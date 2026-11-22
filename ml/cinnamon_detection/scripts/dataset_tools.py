"""Read-only inventory, pending annotation templates, and reviewed grouped splits.

Never downloads data, infers ground truth, or edits source photographs.
"""
import argparse
from collections import Counter, defaultdict
import hashlib
import json
import math
import os
from pathlib import Path
import random
import shutil
import struct

WORKSPACE = Path(__file__).resolve().parents[3]
IMAGE_EXTENSIONS = {'.jpg', '.jpeg', '.png', '.webp', '.bmp', '.tif', '.tiff', '.heic', '.heif'}
SKIP = {'.git', '.dart_tool', 'build', '.gradle', '.venv', 'Pods', 'ephemeral', '__pycache__'}
LABELS = ['cinnamon_quill_end', 'cinnamon_quill_side', 'non_cinnamon']
NEGATIVES = {'pen', 'pencil', 'plastic_pipe', 'wooden_rod', 'rolled_paper',
             'other_cylinder', 'powder', 'leaves', 'empty_background', 'marker_only', 'other'}


def owned(path):
    path = Path(path).resolve()
    if not path.is_relative_to(WORKSPACE):
        raise ValueError('Dataset operations are limited to the standalone workspace')
    return path


def relative_file(root, name):
    if not isinstance(name, str) or Path(name).is_absolute():
        raise ValueError('Expected a relative dataset image path')
    path = (root / name).resolve()
    if not path.is_relative_to(root) or not path.is_file():
        raise ValueError(f'Missing or escaping dataset file: {name}')
    return path


def image_info(path, require_decode=False):
    try:
        from PIL import Image
    except ImportError:
        if require_decode:
            raise ValueError('Install Pillow in the audit environment before preparing training data')
        with path.open('rb') as stream:
            header = stream.read(24)
        if header[:8] == b'\x89PNG\r\n\x1a\n' and len(header) == 24:
            width, height = struct.unpack('>II', header[16:24])
            return dict(width=width, height=height, decoded=False, orientation=None)
        return dict(width=None, height=None, decoded=False, orientation=None)
    with Image.open(path) as image:
        image.verify()
    with Image.open(path) as image:
        image.load()
        width, height = image.size
        orientation = image.getexif().get(274, 1)
    return dict(width=width, height=height, decoded=True, orientation=orientation)


def inventory(root):
    root = owned(root)
    rows, errors = [], []
    for parent, directories, files in os.walk(root, followlinks=False):
        directories[:] = sorted(d for d in directories if d not in SKIP and not (Path(parent) / d).is_symlink())
        for name in sorted(files):
            path = Path(parent) / name
            if path.suffix.lower() not in IMAGE_EXTENSIONS:
                continue
            if path.is_symlink() or not path.resolve().is_relative_to(root):
                errors.append(f'Skipped external/symbolic image: {path.relative_to(root)}')
                continue
            with path.open('rb') as stream:
                digest = hashlib.file_digest(stream, 'sha256').hexdigest()
            row = dict(image=path.relative_to(root).as_posix(), format=path.suffix.lower()[1:],
                       bytes=path.stat().st_size, sha256=digest)
            try:
                row.update(image_info(path))
            except Exception as error:
                row.update(width=None, height=None, decoded=False)
                errors.append(f'{row["image"]}: {type(error).__name__}')
            rows.append(row)
    duplicate_groups = defaultdict(list)
    for row in rows:
        duplicate_groups[row['sha256']].append(row['image'])
    return dict(root=str(root), image_count=len(rows), formats=dict(Counter(r['format'] for r in rows)),
                resolutions=dict(Counter(f'{r["width"]}x{r["height"]}' for r in rows)),
                exact_duplicates=[v for v in duplicate_groups.values() if len(v) > 1],
                images=rows, errors=errors,
                note='Inventory only. Branding and launcher images are not a cinnamon dataset.')


def load_reviewed(root, manifest):
    root, manifest = owned(root), owned(manifest)
    records = json.loads(manifest.read_text(encoding='utf-8'))
    if not isinstance(records, list) or not records:
        raise ValueError('A nonempty reviewed annotation manifest is required')
    seen = set()
    for row in records:
        path = relative_file(root, row['image'])
        if row['image'] in seen:
            raise ValueError('Duplicate image records')
        seen.add(row['image'])
        for field in ['sample_id', 'session_id', 'background_id', 'background_type', 'phone_id', 'reviewer']:
            if not isinstance(row.get(field), str) or not row[field].strip():
                raise ValueError(f'Missing {field}: {row["image"]}')
        if row.get('annotation_status') != 'reviewed' or row.get('view') not in {'end', 'side', 'negative'}:
            raise ValueError('Annotations and view must be explicitly reviewed')
        info = image_info(path, require_decode=True)
        if info['orientation'] != 1:
            raise ValueError('Annotate an explicitly upright derivative; retain the original separately')
        if row['view'] == 'negative' and row.get('negative_type') not in NEGATIVES:
            raise ValueError('Negative examples require a reviewed negative category')
        boxes = row.get('boxes')
        if not isinstance(boxes, list):
            raise ValueError('Explicit boxes are required, including [] for reviewed empty backgrounds')
        for box in boxes:
            label = box.get('class_id')
            coords = box.get('xyxy')
            if type(label) is not int or label not in range(len(LABELS)) or not isinstance(coords, list) or len(coords) != 4:
                raise ValueError('Invalid annotation label or box')
            if any(type(v) not in (int, float) or not math.isfinite(v) or not 0 <= v <= 1 for v in coords):
                raise ValueError('Boxes must be finite normalized coordinates')
            x1, y1, x2, y2 = coords
            if x2 <= x1 or y2 <= y1:
                raise ValueError('Empty/reversed annotation box')
        positive = [b for b in boxes if b['class_id'] in (0, 1)]
        if row['view'] == 'negative' and positive:
            raise ValueError('A negative image cannot contain annotated cinnamon')
        if row['view'] in {'end', 'side'} and not any(b['class_id'] == (0 if row['view'] == 'end' else 1) for b in positive):
            raise ValueError('Positive images require the corresponding view box')
        with path.open('rb') as stream:
            row['_sha256'] = hashlib.file_digest(stream, 'sha256').hexdigest()
    return records


def grouped_split(records, seed=42):
    # Connected components keep each quill, acquisition session, actual surface
    # identity and exact duplicate in one split, even across transitive links.
    parent = list(range(len(records)))
    def find(index):
        while parent[index] != index:
            parent[index] = parent[parent[index]]
            index = parent[index]
        return index
    owners = {}
    for index, row in enumerate(records):
        for key in ['sample_id', 'session_id', 'background_id', '_sha256']:
            value = (key, row[key])
            if value in owners:
                parent[find(index)] = find(owners[value])
            owners[value] = index
    groups = defaultdict(list)
    for index, row in enumerate(records):
        groups[find(index)].append(row)
    groups = list(groups.values())
    if len(groups) < 3:
        raise ValueError('Need at least three independent identity/session/background groups; collect more data')
    random.Random(seed).shuffle(groups)
    count = len(groups)
    val_count = max(1, round(count * .15))
    test_count = max(1, round(count * .15))
    boundaries = [count - val_count - test_count, count - test_count]
    result = dict(train=[], val=[], test=[])
    for index, group in enumerate(groups):
        split = 'train' if index < boundaries[0] else 'val' if index < boundaries[1] else 'test'
        result[split].extend(group)
    return result


def prepare(root, manifest, output, seed):
    root, output = owned(root), owned(output)
    if output.exists() or output == root or root.is_relative_to(output):
        raise ValueError('Choose a new output directory, never an existing/source directory')
    records = load_reviewed(root, manifest)
    splits = grouped_split(records, seed)
    # These are minimum structural checks, not evidence that dataset size is sufficient.
    for name, rows in splits.items():
        if set(r['view'] for r in rows) != {'end', 'side', 'negative'}:
            raise ValueError(f'{name} lacks End, Side or negative examples; collect/rebalance independent groups')
    output.mkdir(parents=True)
    for name, rows in splits.items():
        image_dir, label_dir = output / 'images' / name, output / 'labels' / name
        image_dir.mkdir(parents=True); label_dir.mkdir(parents=True)
        for index, row in enumerate(rows):
            source = relative_file(root, row['image'])
            stem = f'{index:06d}_{row["_sha256"][:16]}'
            shutil.copyfile(source, image_dir / (stem + source.suffix.lower()))
            lines = []
            for box in row['boxes']:
                x1, y1, x2, y2 = box['xyxy']
                lines.append(f'{box["class_id"]} {(x1+x2)/2:.9f} {(y1+y2)/2:.9f} {x2-x1:.9f} {y2-y1:.9f}')
            (label_dir / (stem + '.txt')).write_text('\n'.join(lines), encoding='utf-8')
    (output / 'split_manifest.json').write_text(json.dumps(splits, indent=2), encoding='utf-8')
    (output / 'data.yaml').write_text(f'path: {json.dumps(str(output))}\ntrain: images/train\nval: images/val\ntest: images/test\nnames: {json.dumps(LABELS)}\n', encoding='utf-8')
    return {name: len(rows) for name, rows in splits.items()}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('action', choices=['inventory', 'template', 'prepare'])
    parser.add_argument('--root', type=Path, required=True)
    parser.add_argument('--manifest', type=Path)
    parser.add_argument('--output', type=Path)
    parser.add_argument('--seed', type=int, default=42)
    args = parser.parse_args()
    if args.action == 'prepare':
        if not args.manifest or not args.output:
            parser.error('prepare requires --manifest and --output')
        result = prepare(args.root, args.manifest, args.output, args.seed)
    else:
        result = inventory(args.root)
        if args.action == 'template':
            result = [dict(image=row['image'], sample_id=None, session_id=None, background_id=None,
                background_type=None, phone_id=None, view=None, negative_type=None,
                annotation_status='pending', reviewer=None, boxes=None) for row in result['images']]
        if args.output:
            output = owned(args.output)
            if output.exists(): raise ValueError('Refusing to overwrite an existing report/template')
            output.parent.mkdir(parents=True, exist_ok=True)
            output.write_text(json.dumps(result, indent=2), encoding='utf-8')
    print(json.dumps(result, indent=2))


if __name__ == '__main__':
    main()

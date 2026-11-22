"""Explicit local training only after reviewed labels and independent splits exist."""
import argparse
import importlib.metadata
import json
from pathlib import Path

from dataset_tools import owned


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--prepared', required=True, type=Path)
    parser.add_argument('--weights', required=True, type=Path)
    parser.add_argument('--review', required=True, type=Path)
    parser.add_argument('--output', required=True, type=Path)
    parser.add_argument('--epochs', required=True, type=int)
    parser.add_argument('--image-size', required=True, type=int)
    parser.add_argument('--batch', required=True, type=int)
    parser.add_argument('--device', default='cpu')
    args = parser.parse_args()
    prepared, weights, review, output = map(owned, [args.prepared, args.weights, args.review, args.output])
    if not weights.is_file() or weights.suffix != '.pt':
        raise ValueError('Supply actual local pretrained/trained weights; no implicit weight download')
    if output.exists(): raise ValueError('Use a fresh experiment output directory')
    if min(args.epochs, args.image_size, args.batch) <= 0: raise ValueError('Positive training parameters required')
    approval = json.loads(review.read_text(encoding='utf-8'))
    if approval.get('approved_for_experiment') is not True or not approval.get('reviewer') or not approval.get('limitations'):
        raise ValueError('Record the human dataset review and limitations before training')
    splits = json.loads((prepared / 'split_manifest.json').read_text(encoding='utf-8'))
    for field in ['sample_id', 'session_id', 'background_id', '_sha256']:
        seen = set()
        for split in ['train', 'val', 'test']:
            identities = {row[field] for row in splits[split]}
            if seen & identities: raise ValueError(f'Leakage across splits: {field}')
            seen.update(identities)
    from ultralytics import YOLO
    model = YOLO(str(weights))
    output.mkdir(parents=True)
    (output / 'environment.json').write_text(json.dumps({name: importlib.metadata.version(name)
        for name in ['ultralytics', 'torch', 'numpy']}, indent=2), encoding='utf-8')
    model.train(data=str(prepared / 'data.yaml'), epochs=args.epochs, imgsz=args.image_size,
        batch=args.batch, device=args.device, project=str(output), name='train', seed=42,
        hsv_h=.015, hsv_s=.5, hsv_v=.4, degrees=15, translate=.1, scale=.4,
        fliplr=.5, mosaic=.5, close_mosaic=10, mixup=0, copy_paste=0)
    # Validation is for tuning. Keep the sealed test set for the frozen export.
    model.val(data=str(prepared / 'data.yaml'), split='val', device=args.device)


if __name__ == '__main__': main()

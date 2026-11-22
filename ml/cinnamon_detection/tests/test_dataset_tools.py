import copy
import json
from pathlib import Path
import shutil
import sys
import tempfile
import unittest

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from dataset_tools import WORKSPACE, grouped_split, inventory, load_reviewed, prepare, relative_file
from evaluate_predictions import evaluate
from PIL import Image


class DatasetToolsTests(unittest.TestCase):
    def setUp(self):
        self.root = Path(tempfile.mkdtemp(prefix='phase4_dataset_test_', dir=WORKSPACE / 'build'))
        self.rows = []
        for group in range(3):
            for index, view in enumerate(['end', 'side', 'negative']):
                name = f'g{group}_{view}.png'
                Image.new('RGB', (32, 24), (30+group*50, 20+index*60, 100)).save(self.root / name)
                self.rows.append(dict(image=name, sample_id=f'{group}-{index}', session_id=f'session-{group}',
                    background_id=f'surface-{group}', background_type=['white','wood','green'][group],
                    phone_id=f'phone-{group}', view=view, negative_type='empty_background' if view=='negative' else None,
                    annotation_status='reviewed', reviewer='ISOLATED-TEST-FIXTURE',
                    boxes=[] if view=='negative' else [dict(class_id=index, xyxy=[.2,.2,.8,.8])]))
        self.manifest = self.root / 'manifest.json'
        self.manifest.write_text(json.dumps(self.rows), encoding='utf-8')

    def tearDown(self):
        target = self.root.resolve()
        if not target.is_relative_to((WORKSPACE / 'build').resolve()) or not target.name.startswith('phase4_dataset_test_'):
            raise RuntimeError('Unsafe test cleanup')
        shutil.rmtree(target)

    def test_inventory_decodes_real_fixture_images_without_guessing_labels(self):
        report = inventory(self.root)
        self.assertEqual(report['image_count'], 9)
        self.assertTrue(all(row['decoded'] for row in report['images']))
        self.assertEqual(report['resolutions'], {'32x24':9})
        self.assertNotIn('view', report['images'][0])

    def test_missing_review_boxes_and_path_escape_are_rejected(self):
        self.rows[0]['annotation_status'] = 'pending'
        self.manifest.write_text(json.dumps(self.rows))
        with self.assertRaises(ValueError): load_reviewed(self.root, self.manifest)
        with self.assertRaises(ValueError): relative_file(self.root, '../outside.png')
        self.rows[0]['annotation_status'] = 'reviewed'
        self.rows[0]['boxes'] = []
        self.manifest.write_text(json.dumps(self.rows))
        with self.assertRaises(ValueError): load_reviewed(self.root, self.manifest)

    def test_transitive_identity_background_and_duplicate_links_never_leak(self):
        rows = load_reviewed(self.root, self.manifest)
        # Add an image with a new identity but identical bytes in another session.
        duplicate = copy.deepcopy(rows[0]); duplicate.update(image='alias.png', sample_id='alias', session_id='alias', background_id='alias')
        rows.append(duplicate)
        splits = grouped_split(rows)
        for field in ['sample_id','session_id','background_id','_sha256']:
            seen = set()
            for items in splits.values():
                identities = {row[field] for row in items}
                self.assertFalse(seen & identities); seen.update(identities)
        self.assertEqual(splits, grouped_split(rows))

    def test_insufficient_independent_groups_are_rejected(self):
        rows = load_reviewed(self.root, self.manifest)
        for row in rows: row['background_id'] = 'one-surface'
        with self.assertRaises(ValueError): grouped_split(rows)

    def test_prepared_yolo_export_preserves_sources_and_refuses_overwrite(self):
        before = (self.root / self.rows[0]['image']).read_bytes()
        output = self.root / 'prepared'
        counts = prepare(self.root, self.manifest, output, 42)
        self.assertEqual(counts, {'train':3,'val':3,'test':3})
        self.assertEqual(len(list((output / 'labels').rglob('*.txt'))), 9)
        self.assertEqual((self.root / self.rows[0]['image']).read_bytes(), before)
        with self.assertRaises(ValueError): prepare(self.root, self.manifest, output, 42)

    def test_evaluation_counts_negative_acceptance_and_positive_rejection(self):
        records = self.rows[:3]
        predictions = [dict(image=row['image'], accepted=index!=1, view='end' if index!=1 else 'none',
            latency_ms=10+index, boxes=[] if index==1 else [dict(class_id=0, confidence=.9, xyxy=[.2,.2,.8,.8])])
            for index,row in enumerate(records)]
        result = evaluate(records,predictions,.8,.5)
        self.assertEqual(result['precision'], .5)
        self.assertEqual(result['recall'], .5)
        self.assertEqual(result['false_acceptance_rate'], 1)
        self.assertEqual(result['false_rejection_rate'], .5)
        self.assertEqual(result['backgrounds']['white']['images'],3)
        with self.assertRaises(ValueError): evaluate(records,predictions[:-1],.8,.5)


if __name__ == '__main__': unittest.main()

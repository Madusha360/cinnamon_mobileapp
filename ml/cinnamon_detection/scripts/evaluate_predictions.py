"""Evaluate recorded predictions on reviewed images. No predictions are generated."""
import argparse
from collections import defaultdict
import json
import math
from pathlib import Path

from dataset_tools import owned, load_reviewed


def iou(a, b):
    intersection = max(0, min(a[2], b[2])-max(a[0], b[0])) * max(0, min(a[3], b[3])-max(a[1], b[1]))
    union = (a[2]-a[0])*(a[3]-a[1]) + (b[2]-b[0])*(b[3]-b[1]) - intersection
    return intersection/union if union else 0


def evaluate(records, predictions, confidence, match_iou):
    if not 0 < confidence < 1 or not 0 < match_iou < 1: raise ValueError('Explicit valid evaluation thresholds required')
    lookup = {row['image']: row for row in predictions}
    if len(lookup) != len(predictions) or set(lookup) != {row['image'] for row in records}:
        raise ValueError('Predictions must cover each evaluation image exactly once')
    counts = dict(tp=0, fp=0, fn=0, negatives=0, false_accepts=0, positives=0, false_rejects=0)
    confusion, backgrounds, latencies = defaultdict(int), defaultdict(list), []
    for row in records:
        prediction = lookup[row['image']]
        if type(prediction.get('accepted')) is not bool or prediction.get('view') not in ['end', 'side', 'none']:
            raise ValueError('Record the actual end-to-end acceptance decision and predicted view')
        if prediction['accepted'] and prediction['view'] == 'none': raise ValueError('Accepted output needs a view')
        latency = prediction.get('latency_ms')
        if not isinstance(latency, (int, float)) or not math.isfinite(latency) or latency < 0:
            raise ValueError('Measured latency required')
        latencies.append(latency)
        boxes = prediction['boxes']
        for box in boxes:
            coords, score, label = box['xyxy'], box['confidence'], box['class_id']
            if type(label) is not int or label not in (0, 1, 2) or len(coords) != 4 or not math.isfinite(score) or not 0 <= score <= 1:
                raise ValueError('Invalid prediction')
            if any(not math.isfinite(v) or not 0 <= v <= 1 for v in coords) or coords[0] >= coords[2] or coords[1] >= coords[3]:
                raise ValueError('Invalid predicted box')
        truth = row['boxes']; matched = set()
        for box in sorted(boxes, key=lambda b: b['confidence'], reverse=True):
            if box['confidence'] < confidence: continue
            options = [(iou(box['xyxy'], ground['xyxy']), index) for index, ground in enumerate(truth)
                       if ground['class_id'] == box['class_id'] and index not in matched]
            score, index = max(options, default=(0, -1))
            if score >= match_iou: counts['tp'] += 1; matched.add(index)
            else: counts['fp'] += 1
        counts['fn'] += len(truth) - len(matched)
        negative = row['view'] == 'negative'
        counts['negatives' if negative else 'positives'] += 1
        counts['false_accepts'] += int(negative and prediction['accepted'])
        counts['false_rejects'] += int(not negative and (not prediction['accepted'] or prediction['view'] != row['view']))
        predicted = prediction['view'] if prediction['accepted'] else 'rejected'
        confusion[f'{row["view"]}->{predicted}'] += 1
        backgrounds[row['background_type']].append((row, prediction))
    ratio = lambda n, d: n/d if d else None
    return dict(counts=counts, precision=ratio(counts['tp'], counts['tp']+counts['fp']),
        recall=ratio(counts['tp'], counts['tp']+counts['fn']),
        false_acceptance_rate=ratio(counts['false_accepts'], counts['negatives']),
        false_rejection_rate=ratio(counts['false_rejects'], counts['positives']),
        confusion_matrix=confusion, latency_mean_ms=sum(latencies)/len(latencies) if latencies else None,
        latency_p95_ms=sorted(latencies)[max(0, math.ceil(len(latencies)*.95)-1)] if latencies else None,
        backgrounds={name: dict(images=len(pairs), negatives=sum(r['view']=='negative' for r,p in pairs),
            false_accepts=sum(r['view']=='negative' and p['accepted'] for r,p in pairs),
            positives=sum(r['view']!='negative' for r,p in pairs),
            false_rejects=sum(r['view']!='negative' and (not p['accepted'] or p['view']!=r['view']) for r,p in pairs))
            for name,pairs in backgrounds.items()}, confidence=confidence, match_iou=match_iou)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    for name in ['root', 'manifest', 'predictions', 'output']:
        parser.add_argument('--'+name, required=True, type=Path)
    parser.add_argument('--confidence', required=True, type=float)
    parser.add_argument('--match-iou', required=True, type=float)
    args = parser.parse_args()
    records = load_reviewed(args.root, args.manifest)
    predictions = json.loads(owned(args.predictions).read_text(encoding='utf-8'))
    output = owned(args.output)
    if output.exists(): raise ValueError('Refusing to overwrite evaluation evidence')
    result = evaluate(records, predictions, args.confidence, args.match_iou)
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(result, indent=2), encoding='utf-8')
    print(json.dumps(result, indent=2))


if __name__ == '__main__': main()

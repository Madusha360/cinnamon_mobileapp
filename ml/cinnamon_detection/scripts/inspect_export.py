"""Inspect a real LiteRT export; never fabricate a deployment manifest/policy."""
import argparse
import hashlib
import json
from pathlib import Path

from dataset_tools import owned


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('model', type=Path)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    model, output = owned(args.model), owned(args.output)
    if not model.is_file() or model.suffix != '.tflite': raise ValueError('A real exported model is required')
    if output.exists(): raise ValueError('Refusing to overwrite a model inspection')
    from ai_edge_litert.interpreter import Interpreter
    interpreter = Interpreter(model_path=str(model), num_threads=1)
    interpreter.allocate_tensors()
    def describe(tensor):
        return dict(name=tensor['name'], shape=tensor['shape'].tolist(),
            dtype=str(tensor['dtype']), quantization=tensor['quantization'],
            shape_signature=tensor['shape_signature'].tolist())
    with model.open('rb') as stream:
        digest = hashlib.file_digest(stream, 'sha256').hexdigest()
    result = dict(sha256=digest, inputs=[describe(t) for t in interpreter.get_input_details()],
        outputs=[describe(t) for t in interpreter.get_output_details()],
        deployment_approved=False, normalization_verified=False, labels_verified=False,
        android_compatibility_verified=False,
        note='Tensor inspection only. Compare real labeled-image predictions, preprocessing and Android output before deployment.')
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(result, indent=2), encoding='utf-8')
    print(json.dumps(result, indent=2))


if __name__ == '__main__': main()

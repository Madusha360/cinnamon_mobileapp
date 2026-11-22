# Phase 4 dataset audit — 22 November 2026

**No cinnamon training dataset was accessible for inspection.** This is an access/inventory finding, not a judgment about the user's dataset quality. No training or real-image model evaluation was performed.

## Sources and scope

The standalone `cinnamon_mobileapp` workspace was searched, including ignored files, while excluding Git internals, dependency caches, build outputs and generated platform directories. No separate MERN project or other personal directories were searched. The user subsequently supplied [this Google Drive folder](https://drive.google.com/drive/folders/105zw35d9XzZA2ZGbmEYPmAwc6wMAQEwb?usp=drive_link), authorizing inspection of that source.

The web tool could not open the folder. A direct read-only HTTPS request succeeded but returned **Google Drive: Sign-in**, with no dataset listing. The response was inspected locally; it did not expose image names or annotations. A Google Drive connection was found available but not connected, and an installation/authorization option was offered. No access controls were bypassed and no remote dataset files were downloaded.

## Observed local inventory

| Finding | Observed result |
| --- | --- |
| Image files outside excluded/generated directories | 24 PNG files |
| Branding | 1 original QuillGrade logo |
| Android launcher resources | 5 icons |
| iOS resources | 15 app icons and 3 launch images |
| Dimensions | 1×1 through 1024×1024; full histogram in the local inventory report |
| Exact duplicate groups | 3 groups, all platform icon/launch resources |
| Cinnamon End/Side photographs | None found in the authorized local scope |
| Detection bounding boxes / segmentation masks | None found; platform PNGs are not masks |
| Trained `.tflite`, `.onnx`, `.pt` or `.pth` model | None found |
| Detection label manifest / calibrated thresholds | None found |
| Study JSON | Educational grade references, not training annotations |

`build/phase4-workspace-inventory.json` records the initial file inventory and PNG header dimensions. The corrected full audit, `build/phase4-final-dataset-audit.json`, decoded all 24 PNGs with Pillow 13.0.0 and reported no decode errors. Files generated during automated tests are isolated fixtures, not cinnamon data and not included as evaluation evidence.

## Unknown about the Drive dataset

Actual image count/formats/resolutions, End/Side proportions, classification names, box/mask availability, negative examples, background diversity, lighting, phone diversity, sample identity, duplicates, image quality, provenance and usage rights are **unknown**. Finishing-quality labels, if present, must not be assumed to be detection boxes or correct-view labels.

Whether this dataset supports cinnamon-only detection cannot be determined until its files and annotations are accessible. Even a large positive-only dataset would not by itself demonstrate rejection of pens, wooden rods, plastic pipes, rolled paper, other cylinders, powder, leaves and empty scenes.

## Required next inputs

Provide an authorized Drive connection with access to the linked folder, or place an authorized dataset copy inside `ml/cinnamon_detection/dataset/`. An accessible read-only folder link is another option. Keep raw data ignored by Git.

Required for audit/training: original images; provenance/usage information; physical quill/object IDs; acquisition-session, actual background-surface and phone IDs; reviewed End/Side/non-target labels; normalized bounding boxes or an original annotation export; known duplicates/derivatives; and hard negatives. Segmentation masks are useful future evidence but are not required by the proposed box-detector pipeline. Unknown IDs must be recovered/reviewed, not randomly invented to satisfy split checks.

See [ANNOTATION_GUIDE.md](ANNOTATION_GUIDE.md) and [the local ML tooling guide](../ml/cinnamon_detection/README.md). Training remains blocked until dataset access, annotation review, identity-separated splits and a sufficiency review are complete. No precision, recall, acceptance rate, background accuracy or device latency is claimed.

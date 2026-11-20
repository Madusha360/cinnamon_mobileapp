# Dataset and model prerequisites

No cinnamon dataset, annotations, validated thresholds, label catalogue or trained weights were provided in this workspace. No model has been trained, packaged or evaluated. The app blocks accepted capture and presents “Detection Model Not Installed”.

Before Phase 4, inspect the supplied dataset and record its license/consent, physical sample identifiers, camera/view metadata and annotation format. Detection must identify cinnamon quills, End versus Side orientation, exactly one target and uncertainty. Include pens, pencils, plastic pipes, paper rolls, wooden rods, other cylinders, empty backgrounds, powder, leaves and marker-only images as negatives. Vary backgrounds, lighting, distances and hand-held conditions. A brown shape or contour is not proof of cinnamon identity.

Split train/validation/test by physical quill and acquisition/background session, not randomly by frame. Keep unseen quills and environments in the test set. Supply bounding boxes, view labels and segmentation boundaries where required. Inspect label quality before choosing a TFLite-compatible detector or segmentation model.

For deployment supply actual `.tflite` weights, hashes, model version, supported operations, input dimensions/type, normalization/color order, output tensor schema, label mappings, provenance and measured validation results. Choose acceptance/confidence/stability and image-quality thresholds from validation data, not arbitrary constants. Validate the final high-resolution image again after stable preview acceptance. Only accepted End and Side images may enter the later save flow; rejected temporary photos must not enter history or sync.

Finishing requires the real dataset's class catalogue and labeled examples. Record confidence calibration, review/manual correction rules and defect classes actually supported by the model. Missing finishing weights must produce `Not Analyzed`, not an invented class. Manual overrides must remain distinguishable from predictions.

Real-world performance claims require unseen physical samples, difficult negatives and documented false-accept/reject rates. This phase makes no detection or accuracy claim.

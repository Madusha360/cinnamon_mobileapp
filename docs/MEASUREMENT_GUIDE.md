# Measurement implementation requirements

Phase 1 provides guidance only. There is no camera profile, native OpenCV bridge, ArUco detection, segmentation or millimeter output. The planned default physical marker size is 20 mm; it is not an active calibration. The illustration's reference square is **not** an ArUco marker and must not be printed for measurement.

The future End View pipeline must load the original image, apply lens correction when calibrated, detect/validate the known-size ArUco marker, check coplanarity and suitable perspective, rectify the measurement plane, segment the independently validated cinnamon target, extract its external contour and carefully remove small artifacts. Reject unsuitable geometry or segmentation; never invent millimeters.

| Output | Definition |
| --- | --- |
| Maximum Feret diameter | Greatest distance between external boundary points |
| Minimum Feret width | Minimum supporting-line separation across orientations |
| Area-equivalent diameter | `sqrt(4 * area / pi)` |
| Outer perimeter | Actual closed external contour length, calibrated to mm |
| Cross-sectional area | Area enclosed by the external contour, calibrated to mm² |

Do not substitute `pi * diameter` for irregular circumference. Do not measure length in either view. Side View serves only finishing analysis. Store calibration status/method, marker ID and size, camera profile, algorithm version, original and annotated images, and reviewed contour provenance.

Future review must allow retake, visible contour inspection, manual boundary adjustment and explicit acceptance. Validation needs physical ground-truth widths, perimeter/area references where obtainable, repeated captures and unseen geometries. Report MAE, maximum absolute error, repeatability and fraction within a stated tolerance only after collecting measurements. Current accuracy is unevaluated.

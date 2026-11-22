import '../../capture/domain/capture_session.dart';
import '../domain/detection_status.dart';

/// Consumes the shared Phase 3 quality analysis; never recognizes an object.
class ImageQualityValidator {
  const ImageQualityValidator();
  DetectionStatus? rejection(ImageQualityReport report) {
    if (report.issues.contains(QualityIssue.invalidFile)) {
      return DetectionStatus.uncertain;
    }
    if (report.issues.contains(QualityIssue.blur)) {
      return DetectionStatus.blurry;
    }
    return report.hasWarnings ? DetectionStatus.uncertain : null;
  }
}

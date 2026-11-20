import 'dart:io';

enum SyncStatus { pending, uploading, synced, failed, conflict }

enum SampleSort { newest, oldest, code }

class SampleQuery {
  const SampleQuery({
    this.search = '',
    this.status,
    this.sort = SampleSort.newest,
    this.limit,
  });
  final String search;
  final SyncStatus? status;
  final SampleSort sort;
  final int? limit;
  @override
  bool operator ==(Object other) =>
      other is SampleQuery &&
      search == other.search &&
      status == other.status &&
      sort == other.sort &&
      limit == other.limit;
  @override
  int get hashCode => Object.hash(search, status, sort, limit);
}

class SampleRecord {
  const SampleRecord({
    required this.id,
    required this.code,
    required this.capturedAt,
    required this.detectionStatus,
    required this.calibrationStatus,
    required this.syncStatus,
    required this.revision,
    this.batchId,
    this.notes,
    this.endImagePath,
    this.sideImagePath,
    this.maximumWidthMm,
    this.minimumWidthMm,
    this.equivalentDiameterMm,
    this.outerCircumferenceMm,
    this.finishingQuality,
    this.finishingConfidence,
  });
  final String id;
  final String code;
  final String? batchId;
  final DateTime capturedAt;
  final String? notes;
  final String? endImagePath;
  final String? sideImagePath;
  final double? maximumWidthMm;
  final double? minimumWidthMm;
  final double? equivalentDiameterMm;
  final double? outerCircumferenceMm;
  final String? finishingQuality;
  final double? finishingConfidence;
  final String detectionStatus;
  final String calibrationStatus;
  final SyncStatus syncStatus;
  final int revision;
}

class LocalStatistics {
  const LocalStatistics({
    required this.total,
    required this.pending,
    required this.synced,
    required this.recent,
    required this.uploading,
    required this.failed,
    required this.conflict,
  });
  final int total;

  /// All records still needing sync, including failed/conflicting/in-flight work.
  final int pending;
  final int synced;

  /// Captured within the last seven days.
  final int recent;
  final int uploading;
  final int failed;
  final int conflict;
}

class NewSample {
  const NewSample({
    required this.code,
    required this.capturedAt,
    required this.endPhoto,
    required this.sidePhoto,
    this.batchId,
    this.notes,
  });
  final String code;
  final DateTime capturedAt;
  final File endPhoto;
  final File sidePhoto;
  final String? batchId;
  final String? notes;
}

class MeasurementInput {
  const MeasurementInput({
    required this.calibrationId,
    required this.algorithmVersion,
    required this.calculatedAt,
    this.maximumWidthMm,
    this.minimumWidthMm,
    this.equivalentDiameterMm,
    this.outerCircumferenceMm,
  });
  final String calibrationId;
  final String algorithmVersion;
  final DateTime calculatedAt;
  final double? maximumWidthMm;
  final double? minimumWidthMm;
  final double? equivalentDiameterMm;
  final double? outerCircumferenceMm;
}

class FinishingInput {
  const FinishingInput({
    required this.modelId,
    required this.analyzedAt,
    this.quality,
    this.confidence,
  });
  final String modelId;
  final DateTime analyzedAt;
  final String? quality;
  final double? confidence;
}

class CaptureValidationEvidence {
  const CaptureValidationEvidence({
    required this.modelId,
    required this.validatedAt,
  });
  final String modelId;
  final DateTime validatedAt;
}

abstract interface class CaptureValidationGate {
  Future<CaptureValidationEvidence> validate(File end, File side);
}

/// The only production implementation in Phase 2. A metadata row cannot unlock
/// capture. A real detector adapter must be supplied in a later phase.
class UnavailableCaptureValidationGate implements CaptureValidationGate {
  const UnavailableCaptureValidationGate();
  @override
  Future<CaptureValidationEvidence> validate(File end, File side) async =>
      throw StateError(
        'Cinnamon Detection model is not installed. Capture is blocked.',
      );
}

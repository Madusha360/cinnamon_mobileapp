import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../capture/domain/capture_session.dart';
import '../../data/detection_coordinator.dart';
import '../../data/model_loader.dart';
import '../../data/tflite_cinnamon_detector.dart';
import '../../domain/cinnamon_detector.dart';
import '../../domain/detection_result.dart';

final detectionModelLoaderProvider = Provider<ModelLoader>(
  (ref) => ModelLoader(),
);
typedef DetectionRunnerFactory = Future<DetectionTensorRunner> Function(
  LoadedDetectionModel,
);

/// No untested native package is installed in the absence of a real export.
final detectionRunnerFactoryProvider = Provider<DetectionRunnerFactory?>(
  (ref) => null,
);
final detectionCoordinatorProvider = FutureProvider<DetectionCoordinator>((
  ref,
) async {
  DetectionCoordinator? engine;
  var disposed = false;
  ref.onDispose(() {
    disposed = true;
    unawaited(engine?.close());
  });
  final factory = ref.read(detectionRunnerFactoryProvider);
  final loaded = await ref.read(detectionModelLoaderProvider).load();
  if (!disposed && loaded.model != null && factory != null) {
    DetectionTensorRunner? runner;
    try {
      runner = await factory(loaded.model!);
      if (disposed) {
        await runner.close();
        runner = null;
      }
      if (runner != null) {
        final model = loaded.model!;
        final detector = await TfliteCinnamonDetector.attach(
          model.specification,
          runner,
        );
        engine = DetectionCoordinator(
          detector: detector,
          specification: model.specification.preprocessing,
          policy: model.specification.policy,
        );
        engine.reset();
      }
    } catch (_) {
      // Attach closes a mismatched runner. No fallback guesses an output schema.
    }
  }
  engine ??= DetectionCoordinator(
    detector: const UnavailableCinnamonDetector(),
  );
  if (disposed) await engine.close();
  return engine;
});

final detectionProvider = StreamProvider<DetectionResult>((ref) async* {
  final engine = await ref.watch(detectionCoordinatorProvider.future);
  yield engine.current;
  yield* engine.updates;
});

// A future validated session can call this API; the current debug sandbox does
// not call it and never changes its permanently unvalidated provenance.
final stillRevalidationProvider =
    Provider<Future<StillImageValidation> Function(String, CaptureView)>(
      (ref) =>
          (path, view) async =>
              (await ref.read(detectionCoordinatorProvider.future))
                  .revalidateFile(path, view),
    );

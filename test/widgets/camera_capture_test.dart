import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quillgrade_mobile/app/router/route_names.dart';
import 'package:quillgrade_mobile/features/capture/domain/capture_session.dart';

import '../support/camera_fixture.dart';
import '../support/test_app.dart';

void main() {
  for (final view in ['end', 'side']) {
    testWidgets(
      '$view sandbox shows native-preview interface and correct framing guidance',
      (tester) async {
        final camera = FakeCameraService();
        await pumpTestApp(
          tester,
          location: RouteNames.cameraSandbox(view),
          camera: camera,
          images: WidgetCaptureStorage(),
          quality: FakeQualityService(),
        );
        expect(
          find.byKey(const ValueKey('mock-camera-preview')),
          findsOneWidget,
        );
        expect(
          find.text(
            view == 'end'
                ? 'Align the Cinnamon Quill End'
                : 'Align the Cinnamon Quill Side',
          ),
          findsOneWidget,
        );
        expect(camera.initializations, 1);
        expect(camera.streamsStarted, 0);
        await tapText(tester, 'Take temporary photo');
        // No output was supplied by the mock: failure must remain recoverable.
        expect(find.text('Camera unavailable'), findsOneWidget);
      },
    );
  }

  testWidgets(
    'temporary capture, review, retake and discard stay outside grading',
    (tester) async {
      final camera = FakeCameraService()
        ..outputs.addAll([File('fixture-1.jpg'), File('fixture-2.jpg')]);
      final storage = WidgetCaptureStorage();
      final router = await pumpTestApp(
        tester,
        location: RouteNames.cameraSandbox('end'),
        camera: camera,
        images: storage,
        quality: FakeQualityService(issues: [QualityIssue.blur]),
      );
      await tapText(tester, 'Take temporary photo');
      expect(find.text('Temporary photo review'), findsOneWidget);
      expect(find.byType(InteractiveViewer), findsOneWidget);
      expect(find.text('Image Too Blurry'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Save sample'), 300);
      await tester.pumpAndSettle();
      expect(find.text('Cinnamon Detection Model Not Installed'), findsWidgets);
      final save = find.widgetWithText(FilledButton, 'Save sample');
      expect(tester.widget<FilledButton>(save).onPressed, isNull);
      expect(camera.isOpen, isFalse);
      await tapText(tester, 'Retake Photo');
      expect(storage.files, isEmpty);
      expect(
        router.routeInformationProvider.value.uri.path,
        RouteNames.cameraSandbox('end'),
      );
      expect(find.byKey(const ValueKey('mock-camera-preview')), findsOneWidget);
      await tapText(tester, 'Take temporary photo');
      await tapText(tester, 'Discard photo');
      expect(storage.files, isEmpty);
      expect(camera.isOpen, isFalse);
      expect(
        router.routeInformationProvider.value.uri.path,
        RouteNames.capture,
      );
    },
  );

  testWidgets('permanent denial offers application settings and camera retry', (
    tester,
  ) async {
    final camera = FakeCameraService()
      ..initializeFailure = CameraFailureKind.permissionPermanent;
    await pumpTestApp(
      tester,
      location: RouteNames.cameraSandbox('side'),
      camera: camera,
      images: WidgetCaptureStorage(),
      quality: FakeQualityService(),
    );
    await tapText(tester, 'Open application settings');
    expect(camera.settingsOpened, 1);
    camera.initializeFailure = null;
    await tapText(tester, 'Try again');
    expect(find.byKey(const ValueKey('mock-camera-preview')), findsOneWidget);
  });

  testWidgets(
    'review deep links do not initialize a camera and missing photos are explicit',
    (tester) async {
      final camera = FakeCameraService();
      await pumpTestApp(
        tester,
        location: RouteNames.imageReview('end'),
        camera: camera,
        images: WidgetCaptureStorage(),
        quality: FakeQualityService(),
      );
      expect(find.text('No temporary photo for this view'), findsOneWidget);
      expect(camera.initializations, 0);
      await tester.tap(find.byType(BackButton).last);
      await tester.pumpAndSettle();
      expect(camera.initializations, 1);
      expect(camera.isOpen, isTrue);
    },
  );

  testWidgets('camera controls fit small and rotated screens with large text', (
    tester,
  ) async {
    final camera = FakeCameraService();
    await pumpTestApp(
      tester,
      location: RouteNames.cameraSandbox('side'),
      camera: camera,
      images: WidgetCaptureStorage(),
      quality: FakeQualityService(),
      size: const Size(320, 740),
      textScale: 2,
    );
    await tapText(tester, 'Flash off');
    expect(find.text('Flash on'), findsOneWidget);
    tester.view.physicalSize = const Size(740, 320);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

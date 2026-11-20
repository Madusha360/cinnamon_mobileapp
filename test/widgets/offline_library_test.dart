import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quillgrade_mobile/app/router/route_names.dart';
import 'package:quillgrade_mobile/features/home/presentation/widgets/stats_card.dart';
import 'package:quillgrade_mobile/features/samples/presentation/widgets/sample_card.dart';

import '../support/storage_fixture.dart';
import '../support/test_app.dart';

Future<StorageFixture> seed(WidgetTester tester) async {
  final f = (await tester.runAsync(() async {
    final f = await StorageFixture.create();
    await f.repository.createSample(
      f.input(code: 'LOCAL-ALPHA', batchId: 'BATCH-42'),
    );
    await f.repository.createSample(
      f.input(
        code: 'LOCAL-BETA',
        capturedAt: StorageFixture.time.subtract(const Duration(days: 10)),
        notes: 'Older record',
      ),
    );
    return f;
  }))!;
  addTearDown(f.dispose);
  return f;
}

void main() {
  testWidgets(
    'History loads SQLite records and applies search, filter and sorting',
    (tester) async {
      final f = await seed(tester);
      await pumpTestApp(
        tester,
        location: RouteNames.history,
        database: f.db,
        images: f.images,
        repository: f.repository,
      );
      expect(
        tester
            .widgetList<SampleCard>(find.byType(SampleCard))
            .map((c) => c.sample.code),
        ['LOCAL-ALPHA', 'LOCAL-BETA'],
      );
      await tester.enterText(find.byType(TextField), 'batch-42');
      await tester.pumpAndSettle();
      expect(
        tester
            .widgetList<SampleCard>(find.byType(SampleCard))
            .map((c) => c.sample.code),
        ['LOCAL-ALPHA'],
      );
      await tester.tap(find.widgetWithText(ChoiceChip, 'Synced'));
      await tester.pumpAndSettle();
      expect(find.byType(SampleCard), findsNothing);
      await tester.tap(find.widgetWithText(ChoiceChip, 'All'));
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      await tapText(tester, 'Newest first');
      await tester.tap(find.text('Oldest first').last);
      await tester.pumpAndSettle();
      expect(
        tester
            .widgetList<SampleCard>(find.byType(SampleCard))
            .map((c) => c.sample.code),
        ['LOCAL-BETA', 'LOCAL-ALPHA'],
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'sample details show null results and deletion requires confirmation',
    (tester) async {
      final f = await seed(tester);
      final id = (await f.repository.getAllSamples()).first.id;
      await pumpTestApp(
        tester,
        location: RouteNames.sampleDetail(id),
        database: f.db,
        images: f.images,
        repository: f.repository,
      );
      expect(find.text('Not Measured'), findsNWidgets(4));
      expect(find.text('Not Analyzed'), findsOneWidget);
      await tapText(tester, 'Delete sample');
      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(await f.repository.readSample(id), isNotNull);
      await tapText(tester, 'Delete sample');
      await tester.tap(find.text('Delete').last);
      await tester.pumpAndSettle();
      expect(await f.repository.readSample(id), isNull);
      expect((await f.repository.getStatistics()).total, 1);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Home statistics and recent cards react to local mutations', (
    tester,
  ) async {
    final f = await seed(tester);
    await pumpTestApp(
      tester,
      location: RouteNames.home,
      database: f.db,
      images: f.images,
      repository: f.repository,
    );
    await tester.scrollUntilVisible(find.text('Total samples'), 200);
    expect(
      tester.widgetList<StatsCard>(find.byType(StatsCard)).map((c) => c.value),
      [2, 2, 0, 1],
    );
    final id = (await f.repository.getAllSamples()).first.id;
    await f.repository.deleteSample(id);
    await tester.pumpAndSettle();
    expect(
      tester.widgetList<StatsCard>(find.byType(StatsCard)).map((c) => c.value),
      [1, 1, 0, 0],
    );
    await tester.scrollUntilVisible(find.text('Recent activity'), 250);
    expect(
      tester
          .widgetList<SampleCard>(find.byType(SampleCard))
          .map((c) => c.sample.code),
      ['LOCAL-BETA'],
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'missing original photo has an accessible fallback and detail edits persist',
    (tester) async {
      final f = await seed(tester);
      final sample = (await f.repository.getAllSamples()).first;
      await tester.runAsync(
        () async => (await f.images.resolve(sample.endImagePath!))!.delete(),
      );
      await pumpTestApp(
        tester,
        location: RouteNames.sampleDetail(sample.id),
        database: f.db,
        images: f.images,
        repository: f.repository,
        size: const Size(320, 740),
      );
      await tapText(tester, 'Edit sample');
      final fields = find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextField),
      );
      await tester.enterText(fields.at(2), 'Edited while offline');
      await tester.tap(find.text('Save changes'));
      await tester.pumpAndSettle();
      expect(
        (await f.repository.readSample(sample.id))!.notes,
        'Edited while offline',
      );
      await tester.scrollUntilVisible(find.text('End View').first, 200);
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 30));
      });
      await tester.pumpAndSettle();
      expect(
        find.byTooltip(
          'The private photo file is missing or cannot be opened.',
        ),
        findsWidgets,
      );
      expect(tester.takeException(), isNull);
    },
  );
}

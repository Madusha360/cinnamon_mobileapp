import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:quillgrade_mobile/core/database/app_database.dart';
import 'package:quillgrade_mobile/core/storage/app_preferences_store.dart';
import 'package:quillgrade_mobile/core/storage/sqlite_preferences_store.dart';

import '../support/storage_fixture.dart';
import '../support/test_app.dart';

void main() {
  test('imports legacy theme/onboarding once and preserves SQLite values after reopening', () async {
    final f = await StorageFixture.create(persistent: true);
    final legacy = MemoryPreferencesStore(
      const AppPreferences(
        onboardingComplete: true,
        theme: ThemePreference.dark,
      ),
    );
    final store = SqlitePreferencesStore(f.db, legacy);
    final reads = await Future.wait([store.read(), store.read()]);
    expect(
      reads.every(
        (p) => p.theme == ThemePreference.dark && p.onboardingComplete,
      ),
      isTrue,
    );
    expect((await f.db.select(f.db.userPreferences).get()).length, 1);
    await store.write(
      const AppPreferences(
        onboardingComplete: true,
        theme: ThemePreference.light,
      ),
    );
    expect(legacy.value.theme, ThemePreference.dark);
    await f.db.close();
    final reopened = AppDatabase(
      NativeDatabase(File(p.join(f.directory.path, 'fixture.sqlite'))),
    );
    try {
      legacy.failRead = true;
      final value = await SqlitePreferencesStore(reopened, legacy).read();
      expect(value.theme, ThemePreference.light);
      expect(value.onboardingComplete, isTrue);
    } finally {
      await reopened.close();
      await f.dispose(databaseClosed: true);
    }
  });
}

import 'dart:convert';

import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'app_preferences_store.dart';

/// Imports Phase 1 preferences once; keeps the legacy key as a recovery copy.
class SqlitePreferencesStore implements AppPreferencesStore {
  SqlitePreferencesStore(this.db, this.legacy);
  final AppDatabase db;
  final AppPreferencesStore legacy;
  static const key = 'ui_preferences.v1';

  @override
  Future<AppPreferences> read() async {
    final row = await (db.select(
      db.userPreferences,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    if (row != null) {
      return AppPreferences.fromJson(
        jsonDecode(row.value) as Map<String, dynamic>,
      );
    }
    final old = await legacy.read();
    return db.transaction(() async {
      // A concurrent reader may have completed the import in the meantime.
      await db
          .into(db.userPreferences)
          .insert(
            UserPreferencesCompanion.insert(
              key: key,
              value: jsonEncode(old.toJson()),
              updatedAt: DateTime.now().toUtc(),
            ),
            mode: InsertMode.insertOrIgnore,
          );
      final saved = await (db.select(
        db.userPreferences,
      )..where((t) => t.key.equals(key))).getSingle();
      return AppPreferences.fromJson(
        jsonDecode(saved.value) as Map<String, dynamic>,
      );
    });
  }

  @override
  Future<void> write(AppPreferences preferences) => db.transaction(() async {
    final row = await (db.select(
      db.userPreferences,
    )..where((t) => t.key.equals(key))).getSingleOrNull();
    if (row == null) {
      await db
          .into(db.userPreferences)
          .insert(
            UserPreferencesCompanion.insert(
              key: key,
              value: jsonEncode(preferences.toJson()),
              updatedAt: DateTime.now().toUtc(),
            ),
          );
    } else {
      await (db.update(
        db.userPreferences,
      )..where((t) => t.id.equals(row.id))).write(
        UserPreferencesCompanion(
          value: Value(jsonEncode(preferences.toJson())),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
    }
  });
}

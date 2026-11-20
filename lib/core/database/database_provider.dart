import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/image_storage_service.dart';
import 'app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => unawaited(database.close()));
  return database;
});

final imageStorageProvider = Provider<ImageStorageService>(
  (ref) => ImageStorageService(),
);

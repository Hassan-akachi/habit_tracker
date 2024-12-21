import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/data/database/database.dart';

/// Provider that gives access to the database instance
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});
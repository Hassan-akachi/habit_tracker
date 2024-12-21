import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/data/database/database.dart';
import 'package:habit_tracker/data/providers/database_provider.dart';

/// Provider that streams habits for a specific date
/// Uses family modifier to accept a DateTime parameter
final habitsForDateProvider = StreamProvider.family<List<HabitWithCompletion>, DateTime>((ref, date) {
  // Get the database instance from the provider
  final database = ref.watch(databaseProvider);
  // Return the stream of habits for the given date
  return database.watchHabitsForDate(date);
});
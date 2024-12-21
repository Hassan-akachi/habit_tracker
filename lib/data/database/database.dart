import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:habit_tracker/data/database/tables.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

part 'database.g.dart';

/// Database class that manages habit tracking data using Drift
/// Includes tables for habits and their completions
@DriftDatabase(tables: [Habits, HabitCompletions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// Retrieves all habits from the database
  Future<List<Habit>> getHabits() async {
    return select(habits).get();
  }

  /// Creates a stream that watches for changes in the habits table
  Stream<List<Habit>> watchHabits() => select(habits).watch();

  /// Creates a new habit in the database
  Future<int> createHabit(HabitsCompanion habit) => into(habits).insert(habit);

  /// Watches habits and their completion status for a specific date
  /// Returns a stream of HabitWithCompletion objects
  Stream<List<HabitWithCompletion>> watchHabitsForDate(DateTime date) {
    // Calculate start and end of the given date
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    // Create a join query between habits and their completions
    final query = select(habits).join([
      leftOuterJoin(
          habitCompletions,
          habitCompletions.completedAt
              .isBetweenValues((startOfDay), (endOfDay)))
    ]);

    // Transform the query results into HabitWithCompletion objects
    return query.watch().map((row) {
      return row.map((row) {
        final habit = row.readTable(habits);
        final completion = row.readTableOrNull(habitCompletions);

        return HabitWithCompletion(
            habit: habit, isCompleted: completion != null);
      }).toList();
    });
  }

  /// Marks a habit as completed for a specific date
  /// Updates streak and total completions if not already completed for that day
  Future<void> completeHabit(int habitId, DateTime selectedDate) async {
    await transaction(() async {
      // Calculate day boundaries for the selected date
      final startOfDay =
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final endOfDay = DateTime(selectedDate.year, selectedDate.month,
          selectedDate.day, 23, 59, 59, 999);

      // Check if habit is already completed for the selected date
      final existingCompletion = await (select(habitCompletions)
        ..where((t) =>
        t.habitId.equals(habitId) &
        t.completedAt
            .isBetween(Variable(startOfDay), Variable(endOfDay))))
          .get();

      // Only insert completion if not already completed
      if (existingCompletion.isEmpty) {
        // Insert completion record
        await into(habitCompletions).insert(HabitCompletionsCompanion(
            habitId: Value(habitId), completedAt: Value(selectedDate)));

        // Update habit streak and total completions
        final habit = await (select(habits)..where((t) => t.id.equals(habitId)))
            .getSingle();
        await update(habits).replace(habit
            .copyWith(
            streak: habit.streak + 1,
            totlaCompletions: habit.totlaCompletions + 1)
            .toCompanion(true));
      }
    });
  }

  /// Watches and returns a stream of daily summary statistics
  /// Returns a tuple of (completed habits, total habits) for a given date
  Stream<(int, int)> watchdailySummary(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

    // Stream of completions for the date
    final completionsStream = (select(habitCompletions)
      ..where((t) => t.completedAt
          .isBetween(Variable(startOfDay), Variable(endOfDay))))
        .watch();

    // Stream of all habits for the date
    final habitsStream = watchHabitsForDate(date);

    // Combine streams to get summary statistics
    return Rx.combineLatest2(
        completionsStream,
        habitsStream,
            (completions, habits) =>
        (completions.length, habits.length));
  }
}

/// Data class that combines a habit with its completion status
class HabitWithCompletion {
  final Habit habit;
  final bool isCompleted;

  HabitWithCompletion({required this.habit, required this.isCompleted});
}

/// Creates a lazy database connection
/// Returns a LazyDatabase that will initialize when first used
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'habits.db'));
    return NativeDatabase.createInBackground(file);
  });
}
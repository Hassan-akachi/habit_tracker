import 'package:drift/drift.dart';

/// Defines the structure for storing habit information
class Habits extends Table {
  // Unique identifier for each habit
  IntColumn get id => integer().autoIncrement()();

  // The name of the habit
  TextColumn get title => text()();

  // Optional description of the habit
  TextColumn get description => text().nullable()();

  // When the habit was created, defaults to current time
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  // Optional reminder time stored as text (e.g., "10:00")
  TextColumn get reminderTime => text().nullable()();

  // Current streak of consecutive completions
  IntColumn get streak => integer().withDefault(const Constant(0))();

  // Total number of times the habit has been completed
  // Note: there's a typo in 'totlaCompletions', should be 'totalCompletions'
  IntColumn get totlaCompletions => integer().withDefault(const Constant(0))();

  // Whether the habit is daily (true) or non-daily (false)
  BoolColumn get isDaily => boolean().withDefault(const Constant(false))();
}

/// Defines the structure for tracking habit completions
class HabitCompletions extends Table {
  // Unique identifier for each completion record
  IntColumn get id => integer().autoIncrement()();

  // References the id of the completed habit
  IntColumn get habitId => integer()();

  // When the habit was marked as completed
  DateTimeColumn get completedAt => dateTime()();
}
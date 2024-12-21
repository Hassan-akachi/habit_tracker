import 'package:flutter/material.dart';
import 'package:habit_tracker/data/providers/habits_for_date_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'habit_card.dart';

/// A widget that displays a list of habits for a selected date
/// Uses HookConsumerWidget to access Riverpod providers and handle state
class HabitListCard extends HookConsumerWidget {
  /// The date for which to display habits
  final DateTime selectedDate;

  /// Constructor requires a selectedDate parameter
  const HabitListCard({super.key, required this.selectedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the habits stream for the selected date
    // This will rebuild the widget when the stream updates
    final habitsAsyncValue = ref.watch(habitsForDateProvider(selectedDate));

    // Use AsyncValue.when to handle the three possible states:
    // data, error, and loading
    return habitsAsyncValue.when(
      // When data is available
      data: (habits) => habits.isEmpty
      // Show a message if there are no habits
          ? const Center(child: Text('No habits for this date'))
      // Otherwise, build a scrollable list of habits
          : ListView.separated(
        // Number of items in the list
          itemCount: habits.length,
          // Builds the separator between items
          separatorBuilder: (context, index) => const SizedBox(
            height: 16, // 16 pixels of vertical spacing between items
          ),
          // Builds each habit card
          itemBuilder: (context, index) {
            // Get the habit and its completion status for this index
            final habitWithCompletion = habits[index];

            // Return a HabitCard with the habit's data
            return HabitCard(
              title: habitWithCompletion.habit.title,
              streak: habitWithCompletion.habit.streak,
              // Set progress to 1 if completed, 0 if not
              progress: habitWithCompletion.isCompleted ? 1 : 0,
              habitId: habitWithCompletion.habit.id,
              isCompleted: habitWithCompletion.isCompleted,
              date: selectedDate,
            );
          }
      ),
      // When an error occurs, display it in the center of the screen
      error: (error, stack) => Center(
        child: Text(error.toString()),
      ),
      // While loading, show a centered progress indicator
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

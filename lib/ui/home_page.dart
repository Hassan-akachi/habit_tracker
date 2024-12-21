import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:habit_tracker/ui/pages/create_habit_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../component/daily_summary_card.dart';
import '../component/habit_list_card.dart';
import '../component/time_line_view.dart';
import '../data/providers/daily_summary_provider.dart';

/// HomePage is the main screen of the Habit Tracker app
/// Uses HookConsumerWidget to manage state with Riverpod and Flutter Hooks
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use useState hook to manage the selected date state
    final selectedDate = useState(DateTime.now());
    // Get the current theme's color scheme
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Habit Tracker'),
        ),
        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline view for date selection
                  TimeLineView(
                      selectedDate: selectedDate.value,
                      onSelectedDateChange: (date) => selectedDate.value = date),
                  const SizedBox(height: 16),

                  // Daily summary section showing completed vs total tasks
                  ref.watch(dailySummaryProvider(selectedDate.value)).when(
                      data: (data) => DailySummaryCard(
                          completedTask: data.$1,
                          totalTasks: data.$2,
                          date: DateFormat('yyyy-MM-dd').format(selectedDate.value)),
                      error: (error, stack) => Text(error.toString()),
                      loading: () => const SizedBox.shrink()),
                  const SizedBox(height: 16),

                  // Habits section header
                  const Text('Habit'),
                  const SizedBox(height: 16),

                  // List of habits for the selected date
                  // Wrapped in Expanded to fill remaining space
                  Expanded(child: HabitListCard(selectedDate: selectedDate.value))
                ],
              ),
            )),
        // Custom gradient floating action button for creating new habits
        floatingActionButton: Container(
          decoration: BoxDecoration(
            // Rounded corners for the button
              borderRadius: BorderRadius.circular(12),
              // Gradient background from primary to secondary colors
              gradient: LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              // Subtle shadow effect
              boxShadow: [
                BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.2),
                    blurRadius: 16,
                    spreadRadius: 4)
              ]),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              // Navigate to CreateHabitPage when tapped
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (builder) => const CreateHabitPage())),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: const Text('Create Habit'),
              ),
            ),
          ),
        ));
  }
}
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:habit_tracker/data/database/database.dart';
import 'package:habit_tracker/data/providers/database_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// A widget that provides a form to create new habits with customizable settings
/// including title, description, frequency, and reminders.
class CreateHabitPage extends HookConsumerWidget {
  const CreateHabitPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access the app's color scheme for consistent styling
    final colorScheme = Theme.of(context).colorScheme;

    // Initialize text controllers for input fields using hooks
    final descriptionController = useTextEditingController();
    final titleController = useTextEditingController();

    // State variables for form settings using useState hook
    final isDaily = useState(true);  // Toggle between daily/non-daily habit
    final hasReminder = useState(false);  // Toggle for reminder setting
    final reminderTime = useState(const TimeOfDay(hour: 10, minute: 0));  // Default reminder time

    /// Handles the form submission and habit creation
    Future<void> onPressed() async {
      final title = titleController.text;
      final description = descriptionController.text;

      // Validate that title is not empty
      if (title.isEmpty) {
        return;
      }

      // Create a new habit entry using HabitsCompanion
      final habit = HabitsCompanion.insert(
          title: title,
          description: Value(description),
          isDaily: Value(isDaily.value),
          createdAt: Value(DateTime.now()),
          reminderTime: Value((reminderTime.value?.format(context)))
      );

      // Save the habit to the database
      await ref.read(databaseProvider).createHabit(habit);

      // Navigate back if context is still valid
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create an Habit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title input field
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: "habit title"),
            ),
            const SizedBox(height: 16),

            // Description input field
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Habit Description"),
            ),
            const SizedBox(height: 16),

            // Goal section
            const Text('Goal'),
            const SizedBox(height: 16),

            // Daily/Non-daily toggle
            Row(
              children: [
                const Text('Daily'),
                Switch(
                    value: isDaily.value,
                    onChanged: (value) => isDaily.value = value
                )
              ],
            ),
            const SizedBox(height: 16),

            // Reminder section
            const Text('Reminder'),
            const SizedBox(height: 16),

            // Reminder settings with time picker
            SwitchListTile(
              value: hasReminder.value,
              onChanged: (value) {
                hasReminder.value = value;
                if (value) {
                  // Show time picker when reminder is enabled
                  showTimePicker(
                      context: context,
                      initialTime: reminderTime.value ?? const TimeOfDay(hour: 10, minute: 0)
                  ).then((time) {
                    if (time != null) {
                      reminderTime.value = time;
                    }
                  });
                }
              },
              title: const Text('Has Reminder'),
              subtitle: hasReminder.value
                  ? Text(reminderTime.value?.toString() ?? "No time selected")
                  : null,
            ),
            const SizedBox(height: 16),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary
                ),
                child: const Text('Create Habit'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
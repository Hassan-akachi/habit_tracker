import 'package:flutter/material.dart';
import 'package:habit_tracker/data/providers/database_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HabitCard extends HookConsumerWidget {
  final String title;
  final int  habitId;
  final int streak;
  final double progress;
  final bool isCompleted;
  final DateTime date;

  const HabitCard(
      {super.key,
      required this.title,
      required this.streak,
      required this.progress,
      required this.habitId,
      required this.isCompleted,
      required this.date});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final colorScheme = Theme.of(context).colorScheme;

    Future<void> onCompleted()async {
      await ref.read(databaseProvider).completeHabit(habitId, date);
      if(context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Habit completed"),
          behavior: SnackBarBehavior.floating,)
        );
      }
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
        gradient: LinearGradient(
            colors: isCompleted
                ? [
                    colorScheme.primaryContainer.withOpacity(.8),
                    colorScheme.secondary.withOpacity(0.1)
                  ]
                : [
                    colorScheme.primaryContainer.withOpacity(0.6),
                    colorScheme.surface.withOpacity(0.05),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        boxShadow: [BoxShadow(color: colorScheme.shadow, blurRadius: 16)],
      ),
      child: Card(
      //  color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (streak > 0) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text('$streak days')
                      ],
                    )
                  ]
                ],
              )),
              const SizedBox(
                width: 16,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: isCompleted
                        ? LinearGradient(
                            colors: [
                                colorScheme.primary,
                                colorScheme.secondary
                              ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight)
                        : null,
                    boxShadow: [
                      BoxShadow(
                          color: colorScheme.shadow.withOpacity(0.2),
                          blurRadius: 16,
                          spreadRadius: 4)
                    ],
                color: isCompleted ? colorScheme.surfaceContainerHigh : null,),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onCompleted,
                        borderRadius: BorderRadius.circular(16),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          isCompleted ? Icons.check : Icons.circle_outlined,
                          color: isCompleted
                              ? colorScheme.onPrimary
                              : colorScheme.onSurfaceVariant,
                          size: 24,
                        ),)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

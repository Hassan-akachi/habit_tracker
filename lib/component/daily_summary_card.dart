import 'package:flutter/material.dart';

class DailySummaryCard extends StatelessWidget {
  final int completedTask, totalTasks;
  final String date;

  const DailySummaryCard(
      {super.key,
      required this.completedTask,
      required this.totalTasks,
      required this.date});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = totalTasks > 0 ? completedTask / totalTasks : 0.0 ;
    return Card(
      elevation: 8,
      shadowColor: colorScheme.shadow.withOpacity(0.2),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Daily Summary',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: colorScheme.primaryContainer,
                        fontWeight: FontWeight.bold)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    date,
                    style: TextStyle(
                        color: colorScheme.primaryContainer,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(21),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: colorScheme.surface.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                ),
              ),
            ]),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  '$completedTask / $totalTasks',
                  style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

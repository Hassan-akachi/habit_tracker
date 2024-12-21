import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database_provider.dart';

final dailySummaryProvider =
    StreamProvider.family<(int completedTasks, int totalTasks), DateTime>(
        (ref, date) {
  final database = ref.watch(databaseProvider);

  return database.watchdailySummary(date);
});

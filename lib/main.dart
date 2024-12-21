import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/data/database/database.dart';
import 'package:habit_tracker/data/providers/database_provider.dart';
import 'package:habit_tracker/ui/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final database =AppDatabase();
  runApp( ProviderScope(
      overrides:[
    databaseProvider.overrideWithValue(database),
  ],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.mallardGreen),
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}


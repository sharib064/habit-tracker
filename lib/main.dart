import 'package:flutter/material.dart';
import 'package:habittracker/models/habit_database.dart';
import 'package:habittracker/pages/home_page.dart';
import 'package:habittracker/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HabitDatabase().initialize();
  await HabitDatabase().saveFirstLaunchDate();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => HabitDatabase(),
    ),
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Provider.of<ThemeProvider>(context).getThemeData(),
      home: const HomePage(),
    );
  }
}

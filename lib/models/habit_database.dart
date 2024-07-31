import 'package:flutter/material.dart';
import 'package:habittracker/models/app_settings.dart';
import 'package:habittracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar =
        await Isar.open([AppSettingsSchema, HabitSchema], directory: dir.path);
  }

  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(
        () => isar.appSettings.put(settings),
      );
    }
  }

  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  final List<Habit> currentHabits = [];

  Future<void> addHabit(String habitName) async {
    final newHabit = Habit()..name = habitName;
    await isar.writeTxn(
      () => isar.habits.put(newHabit),
    );
    readHabits();
  }

  Future<void> readHabits() async {
    final fetchedHabits = await isar.habits.where().findAll();
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);
    notifyListeners();
  }

  Future<void> updateHabitCompletion(Id id, bool isCompleted) async {
    final habit = await isar.habits.get(id);

    if (habit != null) {
      await isar.writeTxn(
        () async {
          if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
            final today = DateTime.now();
            habit.completedDays
                .add(DateTime(today.year, today.month, today.day));
          } else {
            habit.completedDays.removeWhere((date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day);
          }
          await isar.habits.put(habit);
        },
      );
    }
    readHabits();
  }

  Future<void> updateHabit(Id id, String habitName) async {
    final habit = await isar.habits.get(id);
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = habitName;
        await isar.habits.put(habit);
      });
    }
    readHabits();
  }

  Future<void> deleteHabit(Id id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    readHabits();
  }
}

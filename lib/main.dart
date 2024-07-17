import 'package:calendar_scheduler/const/color.dart';
import 'package:calendar_scheduler/database/drift.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = AppDatabase();

  await database.createSchedule(
    ScheduleTableCompanion(
      startTime: Value(12),
      endTime: Value(12),
      content: Value('Flutter Programming'),
      date: Value(DateTime.utc(2024,7,21)),
      color: Value(categoryColors.first),
    ),
  );

  final resp = await database.getSchedules();

  print('------------------------');
  print(resp);

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: HomeScreen()
    ),
  );
}
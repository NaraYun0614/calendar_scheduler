import 'package:calendar_scheduler/component/calendar.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/color.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

  class _HomeScreenState extends State<HomeScreen> {
    DateTime selectedDay = DateTime.utc(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    @override
    Widget build(BuildContext context) {

      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Calendar(
                focusedDay: DateTime(2024, 7, 1),
                onDaySelected: onDaySelected,
                selectedDayPredicate: selectedDayPredicate,
              ),
              TodayBanner(
                  selectedDay: selectedDay,
                  taskCount: 0,)
            ],
          )
        ),
      );
    }

    void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
      setState(() {
        this.selectedDay = selectedDay;
      });
    }

    bool selectedDayPredicate(DateTime date) {
      if(selectedDay == null) {
        return false;
      }
      return date.isAtSameMomentAs(selectedDay!);
    }
  }


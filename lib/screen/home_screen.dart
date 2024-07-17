import 'package:calendar_scheduler/component/calendar.dart';
import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/color.dart';
import 'package:calendar_scheduler/database/drift.dart';
import 'package:calendar_scheduler/model/schedule.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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

    /// {
    ///   2024-11-23:[Schedule, Schedule],
    ///   2024-11-24:[Schedule, Schedule]
    ///  }
    // Map<DateTime, List<ScheduleTable>> schedules = {
    //   DateTime.utc(2024, 7, 8): [
    //     ScheduleTable(
    //         id: 1,
    //         startTime: 11,
    //         endTime: 12,
    //         content: 'Study Flutter',
    //         date: DateTime.utc(2024, 7, 8),
    //         color: categoryColors[0],
    //         createdAt: DateTime.now().toUtc(),
    //     ),
    //     ScheduleTable(
    //         id: 2,
    //         startTime: 14,
    //         endTime: 16,
    //         content: 'Study NestJS',
    //         date: DateTime.utc(2024, 7, 8),
    //         color: categoryColors[3],
    //         createdAt: DateTime.now().toUtc(),
    //     ),
    //   ],
    // };

    @override
    Widget build(BuildContext context) {

      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await showModalBottomSheet<ScheduleTable>(
              context: context,
              builder: (_) {
                return ScheduleBottomSheet(
                  selectedDay: selectedDay,
                );
              },
            );

            setState(() {});

          },
          backgroundColor: primaryColor,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
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
                  taskCount: 0,
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                    child: FutureBuilder<List<ScheduleTableData>>(
                      future: GetIt.I<AppDatabase>().getSchedules(
                        selectedDay,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              snapshot.error.toString(),
                            ),
                          );
                        }

                        if (!snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final schedules = snapshot.data!;

                        return ListView.separated(
                          itemCount: schedules.length,
                          itemBuilder: (BuildContext context, int index) {
                            /// 선택된 날짜에 해당되는 일정 리스트로 저장
                            /// List<Schedule>
                            // final selectedSchedules = schedules[selectedDay]!;
                            // final scheduleModel = selectedSchedules[index];

                            final schedule = schedules[index];
                        
                            return Dismissible(
                              key: ObjectKey(schedule.id),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (DismissDirection direction) async {
                                await GetIt.I<AppDatabase>().removeSchedule(
                                  schedule.id,
                                );

                                setState(() {});

                                return true;
                              },
                              child: ScheduleCard(
                                  startTime: schedule.startTime,
                                  endTime: schedule.endTime,
                                  content: schedule.content,
                                  color: Color(
                                    int.parse(
                                      'FF${schedule.color}',
                                      radix: 16,
                                    ),
                                  ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(height: 8.0);
                          },
                        );
                      }
                    ),
                  ),
              ),
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


import 'dart:io';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:calendar_scheduler/model/schedule.dart';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';

part 'drift.g.dart';

@DriftDatabase(
  tables: [ScheduleTable]
)
class AppDatabase extends _$AppDatabase{
  AppDatabase() : super(_openConnection());

  Future<List<ScheduleTableData>> getSchedules(
      DateTime date,
  ) =>
    (select(scheduleTable)..where((table) => table.date.equals(date))).get();


  Future<int> createSchedule(ScheduleTableCompanion data) => into(scheduleTable).insert(data);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    /// C:\\Users\flutter
    /// /Users/flutter
    /// /Users/flutter + /name/NaraYun
    ///
    /// /Users/NaraYun/calendar_scheduler/db.sqlite
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final cachebase = await getTemporaryDirectory();

    sqlite3.tempDirectory = cachebase.path;

    return NativeDatabase.createInBackground(file);
  },);
}
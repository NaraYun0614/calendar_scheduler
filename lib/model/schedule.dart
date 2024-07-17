import 'package:drift/drift.dart';

class ScheduleTable extends Table{
  /// 1) ID which can be identified
  IntColumn get id => integer().autoIncrement()();

  /// 2) Start Time
  IntColumn get startTime => integer()();

  /// 3) End Time
  IntColumn get endTime => integer()();

  /// 4) Schedule Content
  TextColumn get content => text()();

  /// 5) Date
  DateTimeColumn get date => dateTime()();

  /// 6) Category
  TextColumn get color => text()();

  /// 7) Schedule generate DateTime
  DateTimeColumn get createdAt => dateTime().clientDefault(
          () => DateTime.now().toUtc(),
  )();

}
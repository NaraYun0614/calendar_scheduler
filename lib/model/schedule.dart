class Schedule{
  /// 1) ID which can be identified
  final int id;
  /// 2) Start Time
  final int startTime;
  /// 3) End Time
  final int endTime;
  /// 4) Schedule Content
  final String content;
  /// 5) Date
  final DateTime date;
  /// 6) Category
  final String color;
  /// 7) Schedule generate DateTime
  final DateTime createdAt;

  Schedule({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.content,
    required this.date,
    required this.color,
    required this.createdAt,
});
}
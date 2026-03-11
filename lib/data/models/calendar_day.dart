import 'event.dart';

class CalendarDay {
  final String weekday;      // Thứ trong tuần
  final int solarDay;        // Ngày dương
  final int lunarDay;        // Ngày âm
  final int lunarMonth;      // Tháng âm
  final String canchiYear;   // Năm can chi
  final bool isToday;
  final Event? event;

  CalendarDay({
    required this.weekday,
    required this.solarDay,
    required this.lunarDay,
    required this.lunarMonth,
    required this.canchiYear,
    this.isToday = false,
    this.event,
  });

  bool get hasEvent => event != null;

  String get lunarShortText {
    if (lunarDay == 1 || solarDay == 1) {
      return "$lunarDay/$lunarMonth";
    } else {
      return "$lunarDay";
    }
  }
}
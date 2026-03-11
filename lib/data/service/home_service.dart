import 'package:intl/intl.dart';
import 'package:lunar/lunar.dart';
import '../models/calendar_day.dart';
import '../../core/utils/tet_utils.dart';

class HomeService {
  Map<String, String> calculateCountdown(DateTime now, DateTime targetDate) {
    final difference = targetDate.difference(now);

    if (difference.isNegative) {
      return {"days": "00", "hours": "00", "minutes": "00", "seconds": "00"};
    }

    return {
      "days": difference.inDays.toString().padLeft(2, '0'),
      "hours": (difference.inHours % 24).toString().padLeft(2, '0'),
      // 7 ngày 13 giờ = 7*24 + 13 = 181 giờ => 181 % 24 = 13 giờ
      "minutes": (difference.inMinutes % 60).toString().padLeft(2, '0'),
      "seconds": (difference.inSeconds % 60).toString().padLeft(2, '0'),
    };
  }

  /// Tính toán danh sách ngày trong tháng
  List<CalendarDay?> getCalendarDays(DateTime now) {
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    List<CalendarDay?> daysList = [];

    // 1. Padding các ô trống đầu tháng
    int leadingEmptyDays = firstDayOfMonth.weekday - 1;
    for (int i = 0; i < leadingEmptyDays; i++) {
      daysList.add(null);
    }

    // 2. Tạo danh sách CalendarDay
    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      DateTime date = DateTime(now.year, now.month, i);
      Solar solar = Solar.fromYmd(date.year, date.month, date.day);
      Lunar lunar = solar.getLunar();

      daysList.add(CalendarDay(
        weekday: "",
        solarDay: i,
        lunarDay: lunar.getDay(),
        lunarMonth: lunar.getMonth().abs(),
        canchiYear: "",
        isToday: (i == now.day && now.month == date.month && now.year == date.year),
        event: null,
      ));
    }
    return daysList;
  }

  String formatSolarDate(DateTime now) {
    return DateFormat("EEEE, 'ngày' dd 'tháng' MM 'năm' yyyy", 'vi').format(now);
  }

  String formatTargetDate() {
    return DateFormat('dd/MM/yyyy').format(TetUtils.getNextTetDestination());
  }
}
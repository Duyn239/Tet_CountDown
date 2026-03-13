import 'package:intl/intl.dart';
import 'package:vnlunar/vnlunar.dart'; // Đã đổi sang vnlunar
import '../models/calendar_day.dart';
import '../../core/utils/tet_utils.dart';

class HomeService {
  Map<String, String> calculateCountdown(DateTime now, DateTime targetDate) {
    final difference = targetDate.difference(now);
    // Duration(days: 343, hours: 5, minutes: 11)

    if (difference.isNegative) {
      return {"days": "00", "hours": "00", "minutes": "00", "seconds": "00"};
    }

    return {
      "days": difference.inDays.toString().padLeft(2, '0'),
      "hours": (difference.inHours % 24).toString().padLeft(2, '0'),
      "minutes": (difference.inMinutes % 60).toString().padLeft(2, '0'),
      "seconds": (difference.inSeconds % 60).toString().padLeft(2, '0'),
    };
  }

  /// Tính toán danh sách ngày trong tháng chuẩn lịch Việt Nam
  List<CalendarDay?> getCalendarDays(DateTime displayedMonth) {
    // displayedMonth là tháng đang hiển thị trên lịch, không nhất thiết là "now"
    DateTime firstDayOfMonth = DateTime(displayedMonth.year, displayedMonth.month, 1);
    DateTime lastDayOfMonth = DateTime(displayedMonth.year, displayedMonth.month + 1, 0);
    DateTime today = DateTime.now();

    List<CalendarDay?> daysList = [];

    // 1. Padding các ô trống đầu tháng (Thứ 2 là 1, Chủ nhật là 7)
    // Nếu muốn bắt đầu tuần từ Thứ 2:
    int leadingEmptyDays = firstDayOfMonth.weekday - 1;
    for (int i = 0; i < leadingEmptyDays; i++) {
      daysList.add(null);
    }

    // 2. Tạo danh sách CalendarDay bằng vnlunar
    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      // convertSolar2Lunar trả về [lunarDay, lunarMonth, lunarYear, isLeap]
      List<dynamic> lunarData = convertSolar2Lunar(
          i,
          displayedMonth.month,
          displayedMonth.year,
          7
      );

      daysList.add(CalendarDay(
        weekday: "", // Có thể bổ sung nếu UI cần
        solarDay: i,
        lunarDay: lunarData[0], // lunarDay
        lunarMonth: lunarData[1], // lunarMonth
        canchiYear: TetUtils.getCanChiYear(lunarData[2]), // Lấy can chi từ năm âm lịch
        isToday: (i == today.day &&
            displayedMonth.month == today.month &&
            displayedMonth.year == today.year),
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
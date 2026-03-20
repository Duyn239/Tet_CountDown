import 'package:vnlunar/vnlunar.dart';
import '../../core/utils/tet_utils.dart';
import '../models/calendar_day.dart';
import '../models/event.dart';

class CalendarDetailService {
  /// Danh sách ngày cho bảng lịch dựa trên tháng và năm được chọn
  List<CalendarDay?> getCalendarDays(int year, int month) {
    List<CalendarDay?> daysList = [];
    DateTime firstDay = DateTime(year, month, 1);
    DateTime lastDay = DateTime(year, month + 1, 0);

    // 1. Padding các ô trống đầu tháng
    int leadingEmptyDays = firstDay.weekday - 1;
    for (int i = 0; i < leadingEmptyDays; i++) {
      daysList.add(null);
    }

    // 2. Tạo danh sách CalendarDay
    for (int i = 1; i <= lastDay.day; i++) {
      DateTime currentDate = DateTime(year, month, i);

      // vnlunar trả về [lunarDay, lunarMonth, lunarYear, isLeap]
      List<dynamic> lunarData = convertSolar2Lunar(i, month, year, 7);
      int lDay = lunarData[0];
      int lMonth = lunarData[1];
      int lYear = lunarData[2];

      daysList.add(
        CalendarDay(
          weekday: _getWeekdayName(currentDate.weekday),
          solarDay: i,
          lunarDay: lDay,
          lunarMonth: lMonth,
          canchiYear: TetUtils.getCanChiYear(lYear),
          isToday: _isToday(year, month, i),
          event: _getSpecialEvent(lDay, lMonth, lYear, currentDate),
        ),
      );
    }
    return daysList;
  }

  Event? _getSpecialEvent(
    int lDay,
    int lMonth,
    int lYear,
    DateTime currentDate,
  ) {
    String? eventTitle;

    // 1. Nhóm tháng Giêng (Tết)
    if (lMonth == 1) {
      if (lDay == 1) {
        eventTitle = "Tết Nguyên Đán";
      } else if (lDay == 2) {
        eventTitle = "Mùng 2 Tết";
      } else if (lDay == 3) {
        eventTitle = "Mùng 3 Tết";
      }

    }
    // 2. Nhóm tháng Chạp (Cuối năm)
    else if (lMonth == 12) {
      if (lDay == 23) {
        eventTitle = "Ông Công Ông Táo";
      }
      // Kiểm tra Giao thừa
      else if (lDay >= 29) {
        DateTime tomorrow = currentDate.add(const Duration(days: 1));
        List lunarTomorrow = convertSolar2Lunar(
          tomorrow.day,
          tomorrow.month,
          tomorrow.year,
          7,
        );

        if (lunarTomorrow[0] == 1 && lunarTomorrow[1] == 1) {
          eventTitle = "Đêm Giao Thừa";
        }
      }
    }

    if (eventTitle != null) {
      return Event(
        title: eventTitle,
        solarDay: currentDate.day,
        solarMonth: currentDate.month,
        solarYear: currentDate.year,
        lunarDay: lDay,
        lunarMonth: lMonth,
        lunarYear: lYear,
      );
    }
    return null;
  }

  String _getWeekdayName(int weekday) {
    List<String> weekdays = [
      "Thứ 2",
      "Thứ 3",
      "Thứ 4",
      "Thứ 5",
      "Thứ 6",
      "Thứ 7",
      "Chủ Nhật",
    ];
    return weekdays[weekday - 1];
  }

  bool _isToday(int year, int month, int day) {
    final now = DateTime.now();
    return day == now.day && month == now.month && year == now.year;
  }

  /// Lấy danh sách các sự kiện Tết quan trọng của một năm âm lịch
  List<Event> getLunarNewYearEvents(int year) {
    List<Event> tetEvents = [];

    // Tính ngày Ông Táo (23 tháng Chạp năm trước đó)
    List<int> taoQuanSolarList = convertLunar2Solar(23, 12, year - 1, false, 7);
    DateTime taoQuanDateTime = DateTime(
      taoQuanSolarList[2],
      taoQuanSolarList[1],
      taoQuanSolarList[0],
    );

    // Lấy mốc Mùng 1 Tết
    DateTime mung1DateTime = TetUtils.getLunarNewYearEve(year);

    // Tính ngày Giao Thừa
    DateTime giaoThuaDate = mung1DateTime.subtract(const Duration(days: 1));

    _addEvent(tetEvents, "Ông Công Ông Táo", taoQuanDateTime);
    _addEvent(tetEvents, "Đêm Giao Thừa", giaoThuaDate);
    _addEvent(tetEvents, "Tết Nguyên Đán", mung1DateTime);

    // Mùng 2
    _addEvent(
      tetEvents,
      "Mùng 2 Tết",
      mung1DateTime.add(const Duration(days: 1)),
    );

    // Mùng 3
    _addEvent(
      tetEvents,
      "Mùng 3 Tết",
      mung1DateTime.add(const Duration(days: 2)),
    );

    return tetEvents;
  }

  void _addEvent(List<Event> list, String title, DateTime solarDate) {
    List<dynamic> lunarData = convertSolar2Lunar(
      solarDate.day,
      solarDate.month,
      solarDate.year,
      7,
    );

    list.add(
      Event(
        title: title,
        solarDay: solarDate.day,
        solarMonth: solarDate.month,
        solarYear: solarDate.year,
        lunarDay: lunarData[0],
        lunarMonth: lunarData[1],
        lunarYear: lunarData[2],
      ),
    );
  }
}

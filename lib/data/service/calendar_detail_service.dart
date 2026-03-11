import 'package:lunar/lunar.dart';
import '../../core/utils/tet_utils.dart';
import '../models/calendar_day.dart';
import '../models/event.dart';

class CalendarDetailService {
  ///danh sách ngày cho bảng lịch dựa trên tháng và năm được chọn
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
      Solar solar = Solar.fromYmd(year, month, i);
      Lunar lunar = solar.getLunar();

      daysList.add(
        CalendarDay(
          weekday: _getWeekdayName(currentDate.weekday),
          solarDay: i,
          lunarDay: lunar.getDay(),
          lunarMonth: lunar.getMonth(),
          canchiYear: TetUtils.getCanChiYear(lunar),
          isToday: _isToday(year, month, i),
          event: _getSpecialEvent(lunar, currentDate),
        ),
      );
    }
    return daysList;
  }

  Event? _getSpecialEvent(Lunar lunar, DateTime currentDate) {
    String? eventTitle;

    //Xác định tiêu đề sự kiện
    if (lunar.getDay() == 23 && lunar.getMonth() == 12) {
      eventTitle = "Ông Công Ông Táo";
    }
    else {
      DateTime newYearEve = TetUtils.getLunarNewYearEve(currentDate.year);
      if (currentDate.day == newYearEve.day && currentDate.month == newYearEve.month) {
        eventTitle = "Đêm Giao Thừa";
      }
      else if (lunar.getDay() == 1 && lunar.getMonth() == 1) {
        eventTitle = "Tết Nguyên Đán";
      }
      else if (lunar.getDay() == 2 && lunar.getMonth() == 1) {
        eventTitle = "Mùng 2 Tết";
      }
      else if (lunar.getDay() == 3 && lunar.getMonth() == 1) {
        eventTitle = "Mùng 3 Tết";
      }
    }

    //Nếu tìm thấy sự kiện
    if (eventTitle != null) {
      return Event(
        title: eventTitle,
        solarDay: currentDate.day,
        solarMonth: currentDate.month,
        solarYear: currentDate.year,
        lunarDay: lunar.getDay(),
        lunarMonth: lunar.getMonth().abs(),
        lunarYear: lunar.getYear(),
      );
    }

    return null; // Không có sự kiện
  }

  String _getWeekdayName(int weekday) {
    List<String> weekdays = ["Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "Chủ Nhật"];
    return weekdays[weekday - 1];
  }

  bool _isToday(int year, int month, int day) {
    final now = DateTime.now();
    return day == now.day && month == now.month && year == now.year;
  }

  List<Event> getLunarNewYearEvents(int year) {
    List<Event> tetEvents = [];

    // 1. Tính ngày Ông Táo (23 tháng Chạp năm trước)
    Lunar taoQuanLunar = Lunar.fromYmd(year - 1, 12, 23);
    Solar taoQuanSolar = taoQuanLunar.getSolar();
    DateTime taoQuanDateTime = DateTime(taoQuanSolar.getYear(), taoQuanSolar.getMonth(), taoQuanSolar.getDay());

    // 2. Lấy ngày Giao Thừa từ TetUtils
    DateTime giaoThuaDateTime = TetUtils.getLunarNewYearEve(year);

    // 3. Thêm các sự kiện
    _addEvent(tetEvents, "Ông Công Ông Táo", taoQuanDateTime);
    _addEvent(tetEvents, "Đêm Giao Thừa", giaoThuaDateTime);
    _addEvent(tetEvents, "Tết Nguyên Đán", giaoThuaDateTime.add(const Duration(days: 1)));
    _addEvent(tetEvents, "Mùng 2 Tết", giaoThuaDateTime.add(const Duration(days: 2)));
    _addEvent(tetEvents, "Mùng 3 Tết", giaoThuaDateTime.add(const Duration(days: 3)));

    return tetEvents;
  }

  void _addEvent(List<Event> list, String title, DateTime solarDate) {
    Solar solar = Solar.fromYmd(solarDate.year, solarDate.month, solarDate.day);
    Lunar lunar = solar.getLunar();

    list.add(Event(
      title: title,
      solarDay: solarDate.day,
      solarMonth: solarDate.month,
      solarYear: solarDate.year,
      lunarDay: lunar.getDay(),
      lunarMonth: lunar.getMonth().abs(),
      lunarYear: lunar.getYear(),
    ));
  }



}

import 'package:flutter/material.dart';
import '../data/models/calendar_day.dart';
import '../data/models/event.dart';
import '../data/service/calendar_detail_service.dart';

class CalendarViewModel extends ChangeNotifier {
  final CalendarDetailService _detailService = CalendarDetailService();

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  CalendarDay? _selectedDayObject;
  List<Event> lunarNewYearEvents = [];

  // Getters
  int get selectedMonth => _selectedMonth;
  int get selectedYear => _selectedYear;
  CalendarDay? get selectedDayObject => _selectedDayObject;
  String get monthYearLabel => "Tháng $_selectedMonth, $_selectedYear";
  List<CalendarDay?> calendarDays = [];

  CalendarViewModel() {
    _generateCalendar();
    _setInitialSelectedDay();
    _updateTetEvents();
  }

  void _generateCalendar() {
    calendarDays = _detailService.getCalendarDays(_selectedYear, _selectedMonth);
    notifyListeners();
  }

  void _setInitialSelectedDay() {
    final now = DateTime.now();
    _selectedDayObject = calendarDays.firstWhere(
          (d) => d != null && d.isToday,
      orElse: () => null,
    );
  }

  void selectDay(CalendarDay? day) {
    if (day == null) return;
    _selectedDayObject = day;
    notifyListeners();
  }

  void updateMonth(int offset) {
    DateTime updated = DateTime(_selectedYear, _selectedMonth + offset);
    if (updated.year >= 1900 && updated.year <= 2100) {
      _selectedMonth = updated.month;
      _selectedYear = updated.year;
      _generateCalendar();
      _updateTetEvents();
    }
  }

  void updateYear(int year) {
    _selectedYear = year;
    _generateCalendar();
    _updateTetEvents();
  }

  void _updateTetEvents() {
    lunarNewYearEvents = _detailService.getLunarNewYearEvents(_selectedYear);
    notifyListeners();
  }
}
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart'; // Thêm thư viện này
import 'package:tet_countdown_project/view_models/settings_vm.dart';
import '../data/models/calendar_day.dart';
import '../data/service/home_service.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeService _homeService = HomeService();
  final SettingsViewModel settingsVM;
  final AudioPlayer _audioPlayer = AudioPlayer(); // tiếng HPNY
  final AudioPlayer _fireworkPlayer = AudioPlayer(); // Cho tiếng pháo hoa
  Timer? _timer;

  String days = "00", hours = "00", minutes = "00", seconds = "00";
  String currentSolarDate = "";
  String targetTetDateString = "";
  List<CalendarDay?> currentMonthDays = [];
  String currentMonthYearLabel = "";

  // BIẾN QUAN TRỌNG: Kích hoạt pháo hoa và nhạc
  bool isCelebrationMode = false;

  HomeViewModel({required this.settingsVM}) {
    initializeDateFormatting('vi', '').then((_) {
      refreshAllData();
      _startTimer();
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateCountdown();

      final now = DateTime.now();
      if (now.hour == 0 && now.minute == 0 && now.second == 0) {
        _updateCalendar();
      }
    });
  }

  void _updateCountdown() {
    final now = DateTime.now();
    final target = settingsVM.effectiveTargetDate;

    final data = _homeService.calculateCountdown(now, target);
    days = data["days"]!;
    hours = data["hours"]!;
    minutes = data["minutes"]!;
    seconds = data["seconds"]!;

    // 2. Logic xử lý Ăn mừng (Celebration)
    // Nếu thời gian đã trôi qua (isAfter)
    if (now.isAfter(target)) {
      if (!isCelebrationMode) {
        isCelebrationMode = true;
        _playNewYearMusic(); // Chỉ gọi 1 lần khi bắt đầu chế độ ăn mừng
        notifyListeners();
      }
    } else {
      // Nếu chưa tới hoặc user chỉnh lại ngày demo về tương lai
      if (isCelebrationMode) {
        isCelebrationMode = false;
        _audioPlayer.stop();
        _fireworkPlayer.stop();
      }
    }

    currentSolarDate = _homeService.formatSolarDate(now);
    notifyListeners();
  }

  void _playNewYearMusic() async {
    try {
      await _fireworkPlayer.setVolume(1.0); // Tiếng pháo nhỏ hơn nhạc một chút cho đỡ chói
      await _fireworkPlayer.play(AssetSource('sounds/phao_hoa_sound.mp3'));

      // Phát nhạc Happy New Year
      await _audioPlayer.setVolume(1.0);
      await _audioPlayer.play(AssetSource('sounds/HappyNewYearCut.mp3'));
    } catch (e) {
      debugPrint("Lỗi âm thanh: $e");
    }
  }

  void _updateCalendar() {
    final now = DateTime.now();
    currentMonthYearLabel = "Tháng ${now.month}, ${now.year}";
    currentMonthDays = _homeService.getCalendarDays(now);
    targetTetDateString = DateFormat(
      'dd/MM/yyyy',
    ).format(settingsVM.effectiveTargetDate);
    notifyListeners();
  }

  String getZodiacLinkImg() {
    int index = settingsVM.selectedZodiacIndex;
    switch (index) {
      case 0:
        return 'assets/images/12 con giap/01_ty.png';
      case 1:
        return 'assets/images/12 con giap/02_suu.png';
      case 2:
        return 'assets/images/12 con giap/03_dan.png';
      case 3:
        return 'assets/images/12 con giap/04_meo.png';
      case 4:
        return 'assets/images/12 con giap/05_rong.png';
      case 5:
        return 'assets/images/12 con giap/06_ran.png';
      case 6:
        return 'assets/images/12 con giap/07_ngo.jpg';
      case 7:
        return 'assets/images/12 con giap/08_mui.png';
      case 8:
        return 'assets/images/12 con giap/09_than.png';
      case 9:
        return 'assets/images/12 con giap/10_dau.png';
      case 10:
        return 'assets/images/12 con giap/11_tuat.png';
      case 11:
        return 'assets/images/12 con giap/12_hoi.png';
    }
    return 'assets/images/12 con giap/01_ty.png';
  }

  void refreshAllData() {
    _updateCountdown();
    _updateCalendar();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    _fireworkPlayer.dispose();
    super.dispose();
  }
}

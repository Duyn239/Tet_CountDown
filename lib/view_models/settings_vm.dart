import 'package:flutter/material.dart';
import '../core/utils/tet_utils.dart';
import '../data/service/settings_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsService _settingsService = SettingsService();

  // 1. TRẠNG THÁI UI & CẤU HÌNH BẬT/TẮT
  bool isDemoCountdownOn = false;
  bool isEditingCountdown = false;

  // 12 con giáp
  int selectedZodiacIndex = 0; // Mặc định là Tý (0)

  // 2. DỮ LIỆU DRAFT (Dùng để hiển thị trên Form khi đang sửa)
  DateTime draftDate = DateTime(2026, 3, 08);
  TimeOfDay draftTime = const TimeOfDay(hour: 0, minute: 0);

  // 3. DỮ LIỆU CONFIRMED (Dữ liệu thực tế đã lưu, Home Page sẽ dùng cái này)
  DateTime? _confirmedDateTime;

  SettingsViewModel() {
    _init();
  }

  Future<void> _init() async {
    final data = await _settingsService.loadSettings();

    // 1. Load trạng thái switch trước
    isDemoCountdownOn = data['isDemoCountdownOn'] ?? false;

    // 2. Load dữ liệu thời gian
    if (data['demoDate'] != null && data['demoTime'] != null) {
      final date = DateTime.parse(data['demoDate']);
      final parts = data['demoTime'].split(':');
      final time = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));

      draftDate = date;
      draftTime = time;

      // CHỈ GÁN confirmed nếu switch đang BẬT
      if (isDemoCountdownOn) {
        _confirmedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      } else {
        _confirmedDateTime = null; // Đảm bảo trả về Tết thật
      }
    }

    selectedZodiacIndex = await _settingsService.loadZodiacIndex();
    notifyListeners();
  }

  DateTime get effectiveTargetDate {
    if (isDemoCountdownOn && _confirmedDateTime != null) {
      // Chỉ trả về ngày Demo nếu Switch ĐANG BẬT và ĐÃ ẤN LƯU (có confirmed data)
      return _confirmedDateTime!;
    }
    // Nếu không, mặc định trả về Tết thật
    return TetUtils.getNextTetDestination();
  }

  // Cập nhật Draft (Chưa ảnh hưởng đến Home)
  void updateDemoDate(DateTime date) {
    draftDate = date;
    notifyListeners();
  }

  void updateDemoTime(TimeOfDay time) {
    draftTime = time;
    notifyListeners();
  }

  // Điều khiển trạng thái Form
  void setEditingCountdown(bool val) {
    isEditingCountdown = val;
    notifyListeners();
  }

  void toggleDemoCountdown(bool val) async {
    isDemoCountdownOn = val;

    if (val) {
      isEditingCountdown = true;
    } else {
      _confirmedDateTime = null;
      isEditingCountdown = false;

      await _settingsService.saveSettings(
        isDemoCountdownOn: false,
        demoDate: draftDate,
        demoTime: draftTime,
      );
    }

    notifyListeners();
  }

  // Chuyển dữ liệu từ DRAFT sang CONFIRMED
  Future<void> saveDemoSettings() async {
    _confirmedDateTime = DateTime(
      draftDate.year,
      draftDate.month,
      draftDate.day,
      draftTime.hour,
      draftTime.minute,
    );

    await _settingsService.saveSettings(
      isDemoCountdownOn: isDemoCountdownOn,
      demoDate: draftDate,
      demoTime: draftTime,
    );

    notifyListeners();
    print("SettingsVM: Đã xác nhận và lưu dữ liệu Demo!");
  }

  Future<void> resetToDefault() async {
    await _settingsService.clearSettings();
    isDemoCountdownOn = false;
    isEditingCountdown = false;
    draftDate = DateTime(2026, 3, 08);
    draftTime = const TimeOfDay(hour: 0, minute: 0);
    _confirmedDateTime = null;

    selectedZodiacIndex = 0;
    await _settingsService.saveZodiacIndex(0);
    notifyListeners();
  }

  final List<Map<String, dynamic>> zodiacs = [
    {'name': 'Tý', 'icon': '🐭'},
    {'name': 'Sửu', 'icon': '🐮'},
    {'name': 'Dần', 'icon': '🐯'},
    {'name': 'Mão', 'icon': '🐱'},
    {'name': 'Thìn', 'icon': '🐲'},
    {'name': 'Tỵ', 'icon': '🐍'},
    {'name': 'Ngọ', 'icon': '🐴'},
    {'name': 'Mùi', 'icon': '🐐'},
    {'name': 'Thân', 'icon': '🐵'},
    {'name': 'Dậu', 'icon': '🐔'},
    {'name': 'Tuất', 'icon': '🐶'},
    {'name': 'Hợi', 'icon': '🐷'},
  ];


  String get currentZodiacName => zodiacs[selectedZodiacIndex]['name'];

  // HÀM CẬP NHẬT VÀ LƯU NGAY LẬP TỨC
  void updateZodiac(int index) async {
    selectedZodiacIndex = index;

    await _settingsService.saveZodiacIndex(index);

    notifyListeners();
    print("SettingsVM: Đã lưu con giáp index: $index");
  }
}
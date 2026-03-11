import 'package:flutter/material.dart';
import '../core/utils/tet_utils.dart';
import '../data/service/settings_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsService _settingsService = SettingsService();

  // 1. TRẠNG THÁI UI & CẤU HÌNH BẬT/TẮT
  bool isReminderOn = true;
  bool isDemoCountdownOn = false;
  bool isDemoReminderOn = false;
  bool isEditingCountdown = false;
  bool isEditingReminder = false;

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
    isReminderOn = data['isReminderOn'] ?? true;
    isDemoCountdownOn = data['isDemoCountdownOn'] ?? false;
    isDemoReminderOn = data['isDemoReminderOn'] ?? false;

    // Load dữ liệu đã lưu vào cả Draft và Confirmed để đồng bộ lúc khởi tạo
    if (data['demoDate'] != null && data['demoTime'] != null) {
      final date = DateTime.parse(data['demoDate']);
      final parts = data['demoTime'].split(':');
      final time = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));

      draftDate = date;
      draftTime = time;

      // Xác nhận dữ liệu chính thức
      _confirmedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    }

    // 2. TẢI INDEX CON GIÁP ĐÃ LƯU
    selectedZodiacIndex = await _settingsService.loadZodiacIndex();
    notifyListeners();
  }

  // LOGIC QUAN TRỌNG: Trang Home gọi cái này để lấy ngày đích
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

  void setEditingReminder(bool val) {
    isEditingReminder = val;
    notifyListeners();
  }

  // Chuyển đổi Switch
  void toggleReminder(bool val) {
    isReminderOn = val;
    notifyListeners();
  }

  void toggleDemoCountdown(bool val) {
    isDemoCountdownOn = val;
    if (val) isEditingCountdown = true; // Hiện form khi bật
    notifyListeners();
  }

  void toggleDemoReminder(bool val) {
    isDemoReminderOn = val;
    if (val) isEditingReminder = true;
    notifyListeners();
  }

  // HÀM LƯU: Chuyển dữ liệu từ DRAFT sang CONFIRMED
  Future<void> saveDemoSettings() async {
    // 1. Xác nhận dữ liệu chính thức từ các ô nhập liệu tạm
    _confirmedDateTime = DateTime(
      draftDate.year,
      draftDate.month,
      draftDate.day,
      draftTime.hour,
      draftTime.minute,
    );

    // 2. Gửi dữ liệu xuống Service để lưu vào Database/Prefs
    await _settingsService.saveSettings(
      isReminderOn: isReminderOn,
      isDemoCountdownOn: isDemoCountdownOn,
      isDemoReminderOn: isDemoReminderOn,
      demoDate: draftDate,
      demoTime: draftTime,
    );

    // 3. Thông báo cho tất cả các View (Home, Settings) cập nhật dữ liệu mới
    notifyListeners();
    print("SettingsVM: Đã xác nhận và lưu dữ liệu Demo!");
  }

  Future<void> resetToDefault() async {
    await _settingsService.clearSettings();
    isReminderOn = true;
    isDemoCountdownOn = false;
    isDemoReminderOn = false;
    isEditingCountdown = false;
    isEditingReminder = false;
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

    // Lưu vào SharedPreferences thông qua Service
    await _settingsService.saveZodiacIndex(index);

    // Thông báo cho UI (đặc biệt là trang Home) thay đổi ảnh nền ngay
    notifyListeners();
    print("SettingsVM: Đã lưu con giáp index: $index");
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _keyReminder = 'isReminderOn';
  static const String _keyDemoCountdown = 'isDemoCountdownOn';
  static const String _keyDemoReminder = 'isDemoReminderOn';
  static const String _keyDemoDate = 'demoDate';
  static const String _keyDemoTime = 'demoTime';

  // Lưu toàn bộ cài đặt
  Future<void> saveSettings({
    required bool isReminderOn,
    required bool isDemoCountdownOn,
    required bool isDemoReminderOn,
    required DateTime demoDate,
    required TimeOfDay demoTime,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyReminder, isReminderOn);
    await prefs.setBool(_keyDemoCountdown, isDemoCountdownOn);
    await prefs.setBool(_keyDemoReminder, isDemoReminderOn);
    await prefs.setString(_keyDemoDate, demoDate.toIso8601String());
    await prefs.setString(_keyDemoTime, "${demoTime.hour}:${demoTime.minute}");
  }

  // đọc dữ liệu đã lưu từ SharedPreferences
  Future<Map<String, dynamic>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'isReminderOn': prefs.getBool(_keyReminder) ?? true,
      'isDemoCountdownOn': prefs.getBool(_keyDemoCountdown) ?? false,
      'isDemoReminderOn': prefs.getBool(_keyDemoReminder) ?? false,
      'demoDate': prefs.getString(_keyDemoDate),
      'demoTime': prefs.getString(_keyDemoTime),
    };
  }

  // Hàm xóa sạch cài đặt
  Future<void> clearSettings() async {
    final prefs = await SharedPreferences.getInstance();
    // Chỉ xóa duy nhất một cặp Key-Value mà Duy chỉ định.
    await prefs.remove(_keyReminder);
    await prefs.remove(_keyDemoCountdown);
    await prefs.remove(_keyDemoReminder);
    await prefs.remove(_keyDemoDate);
    await prefs.remove(_keyDemoTime);
  }

  // Hàm lưu Index
  Future<void> saveZodiacIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selectedZodiacIndex', index);
  }

  // LOAD INDEX
  Future<int> loadZodiacIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('selectedZodiacIndex') ?? 0; // Mặc định là 0 (Tý)
  }
}
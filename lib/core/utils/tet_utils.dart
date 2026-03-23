import 'package:vnlunar/vnlunar.dart';

class TetUtils {
  /// Lấy ngày Mùng 1 năm âm lịch (lunarYear)
  static DateTime getLunarNewYearEve(int year) {
    // 1. Tìm mùng 1 Tết
    // solarList = [day, month, year]
    // isLeap -> check tháng nhuận hay k
    List<int> solarList = convertLunar2Solar(1, 1, year, false, 7);

    // 00:00:00 ngày mùng 1 Tết
    return DateTime(
        solarList[2],
        solarList[1],
        solarList[0],
        0, 0, 0
    );
  }

  /// Tự động nhảy sang năm sau nếu đã qua Tết năm nay
  static DateTime getNextTetDestination() {
    DateTime now = DateTime.now();
    List<dynamic> currentLunar = convertSolar2Lunar(now.day, now.month, now.year, 7);
    int currentLunarYear = currentLunar[2];

    DateTime currentYearEve = getLunarNewYearEve(currentLunarYear);

    // Để HomeViewModel giữ isCelebrationMode = true
    // Giữ chế độ ăn mừng đến hết Mùng 3 (tức là bắt đầu ngày Mùng 4 thì dừng)
    DateTime endOfCelebration = currentYearEve.add(const Duration(days: 3));

    if (now.isAfter(endOfCelebration)) {
      return getLunarNewYearEve(currentLunarYear + 1);
    }

    return currentYearEve;
  }

  /// Lấy Can Chi của năm từ năm âm lịch (lunarYear)
  static String getCanChiYear(int lunarYear) {
    const canList = ["Canh", "Tân", "Nhâm", "Quý", "Giáp", "Ất", "Bính", "Đinh", "Mậu", "Kỷ"];
    const chiList = ["Thân", "Dậu", "Tuất", "Hợi", "Tý", "Sửu", "Dần", "Mão", "Thìn", "Tỵ", "Ngọ", "Mùi"];

    // 2020(Canh tý) 2020 % 10 = 0, 2020 % 12 = 4
    final can = canList[lunarYear % 10];
    final chi = chiList[lunarYear % 12];

    return "$can $chi";
  }
}
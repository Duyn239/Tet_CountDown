import 'package:vnlunar/vnlunar.dart';

class TetUtils {
  /// Hàm tìm ngày Dương lịch của đêm Giao thừa (29 hoặc 30 Tết)
  static DateTime getLunarNewYearEve(int year) {
    // 1. Tìm mùng 1 Tết
    List<int> solarList = convertLunar2Solar(1, 1, year, false, 7);

    // 2. Thiết lập mục tiêu là ĐÚNG 0h00 ngày Mùng 1
    // Đây chính là thời điểm kết thúc đêm Giao thừa
    return DateTime(
        solarList[2], // Năm
        solarList[1], // Tháng
        solarList[0], // Ngày
        0, 0, 0       // Giờ, Phút, Giây
    );
  }

  /// Tự động nhảy sang năm sau nếu đã qua Tết năm nay
  static DateTime getNextTetDestination() {
    DateTime now = DateTime.now();

    // Bước 1: Lấy năm âm lịch của ngày hôm nay
    // convertSolar2Lunar trả về List<dynamic> vì phần tử cuối là bool
    List<dynamic> currentLunar = convertSolar2Lunar(now.day, now.month, now.year, 7);
    int currentLunarYear = currentLunar[2];

    // Bước 2: Lấy ngày Giao thừa của năm âm lịch hiện tại
    DateTime currentYearEve = getLunarNewYearEve(currentLunarYear);

    // Bước 3: So sánh
    // Nếu hôm nay đã qua Giao thừa năm nay -> Tìm Giao thừa năm âm lịch kế tiếp
    if (now.isAfter(currentYearEve)) {
      return getLunarNewYearEve(currentLunarYear + 1);
    }

    return currentYearEve;
  }

  /// Lấy Can Chi của năm từ năm âm lịch (lunarYear)
  static String getCanChiYear(int lunarYear) {
    // Thuật toán: Can = (năm - 4) % 10, Chi = (năm - 4) % 12
    // Với mảng bắt đầu từ Canh (0) và Thân (0) như dưới đây thì logic % là chuẩn
    const canList = ["Canh", "Tân", "Nhâm", "Quý", "Giáp", "Ất", "Bính", "Đinh", "Mậu", "Kỷ"];
    const chiList = ["Thân", "Dậu", "Tuất", "Hợi", "Tý", "Sửu", "Dần", "Mão", "Thìn", "Tỵ", "Ngọ", "Mùi"];

    final can = canList[lunarYear % 10];
    final chi = chiList[lunarYear % 12];

    return "$can $chi";
  }
}
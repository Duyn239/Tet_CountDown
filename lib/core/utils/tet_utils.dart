import 'package:vnlunar/vnlunar.dart';

class TetUtils {
  /// Lấy ngày Mùng 1 năm âm lịch (lunarYear)
  // 23:59:59 ngày 30 Tết
  // ↓
  // 00:00:00 mùng 1 Tết
  static DateTime getLunarNewYearEve(int year) {
    // 1. Tìm mùng 1 Tết
    // 1/1/2026 âm = 17/02/2026 dương
    // solarList = [day, month, year] -> vd: [17, 2, 2026]
    // isLeap -> check tháng nhuận hay k
    // thực tế không tồn tại tháng 1 nhuận để mà đối chiếu.
    List<int> solarList = convertLunar2Solar(1, 1, year, false, 7);

    // 2. Thiết lập mục tiêu là ĐÚNG 0h00 ngày Mùng 1
    // Đây chính là thời điểm kết thúc đêm Giao thừa
    // 00:00:00 ngày mùng 1 Tết
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
    List<dynamic> currentLunar = convertSolar2Lunar(now.day, now.month, now.year, 7);
    int currentLunarYear = currentLunar[2];

    DateTime currentYearEve = getLunarNewYearEve(currentLunarYear);

    // THÊM LOGIC NÀY:
    // Nếu đang trong mùng 1, mùng 2, mùng 3 Tết thì VẪN LẤY Giao thừa năm nay làm mốc
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
    // Thuật toán: Can = (năm - 4) % 10, Chi = (năm - 4) % 12
    // Với mảng bắt đầu từ Canh (0) và Thân (0) như dưới đây thì logic % là chuẩn
    const canList = ["Canh", "Tân", "Nhâm", "Quý", "Giáp", "Ất", "Bính", "Đinh", "Mậu", "Kỷ"];
    const chiList = ["Thân", "Dậu", "Tuất", "Hợi", "Tý", "Sửu", "Dần", "Mão", "Thìn", "Tỵ", "Ngọ", "Mùi"];

    final can = canList[lunarYear % 10];
    final chi = chiList[lunarYear % 12];

    return "$can $chi";
  }
}
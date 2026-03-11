import 'package:lunar/lunar.dart';

class TetUtils {
  /// Hàm tìm ngày Dương lịch của đêm Giao thừa (30 Tết)
  static DateTime getLunarNewYearEve(int year) {
    //Tìm ngày mùng 1 Tết của năm đó
    Lunar m1TetLunar = Lunar.fromYmd(year, 1, 1); // lịch âm 1/1/2026

    //Chuyển sang Dương lịch
    Solar m1TetSolar = m1TetLunar.getSolar(); // chuyển sang lịch dương: 17/02/2026

    // m1DateTime đang được khởi tạo mặc định là 00:00:00
    DateTime m1DateTime = DateTime(
    m1TetSolar.getYear(),
    m1TetSolar.getMonth(),
    m1TetSolar.getDay(),
    );

    //Giao thừa là ngày trước mùng 1
    return m1DateTime.subtract(const Duration(days: 1));
  }

  /// Tự động nhảy sang năm sau nếu đã qua Tết năm nay
  static DateTime getNextTetDestination() {
    DateTime now = DateTime.now();
    DateTime currentYearEve = getLunarNewYearEve(now.year);

    /// sẽ xử lí thêm khi làm tới phần demo countdown
    // Nếu bây giờ đã muộn hơn giao thừa năm nay ( so sánh cả ngày + thời gian) --> tính giao thừa năm sau
    if (now.isAfter(currentYearEve)) {
      return getLunarNewYearEve(now.year + 1);
    }
    return currentYearEve;
  }

  static String getCanChiYear(Lunar lunarDay) {
    const canList = [
      "Giáp", "Ất", "Bính", "Đinh", "Mậu",
      "Kỷ", "Canh", "Tân", "Nhâm", "Quý"
    ];

    const chiList = [
      "Tý", "Sửu", "Dần", "Mão", "Thìn", "Tỵ",
      "Ngọ", "Mùi", "Thân", "Dậu", "Tuất", "Hợi"
    ];

    int year = lunarDay.getYear();

    // 1984 (Giap ty)
    final can = canList[(year + 6) % 10];
    final chi = chiList[(year + 8) % 12];

    return "$can $chi";
  }

}
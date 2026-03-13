class Event {
  final String title;
  final int solarDay, solarMonth, solarYear;
  final int lunarDay, lunarMonth, lunarYear;

  Event({
    required this.title,
    required this.solarDay,
    required this.solarMonth,
    required this.solarYear,
    required this.lunarDay,
    required this.lunarMonth,
    required this.lunarYear,
  });

  // Getter tính toán thời gian còn lại
  String get dayLeftDisplay {
    DateTime now = DateTime.now();
    // bỏ phần giờ phút giây -> ta sẽ chỉ so sánh theo ngày/tháng/năm
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime target = DateTime(solarYear, solarMonth, solarDay);

    if (target.isAtSameMomentAs(today)) return "Hôm nay";
    if (target.isBefore(today)) return "Đã qua";

    // Tính tổng số ngày trước
    int totalDays = target.difference(today).inDays;

    // dưới 1 năm
    if (totalDays < 365) {
      return "Còn $totalDays ngày";
    }

    // Nếu trên 1 năm -> Tính toán Năm/Tháng/Ngày
    int years = target.year - today.year;
    int months = target.month - today.month;
    int days = target.day - today.day;

    if (days < 0) {
      months -= 1;
      days += DateTime(target.year, target.month, 0).day;
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }

    List<String> parts = [];
    if (years > 0) parts.add("$years năm");
    if (months > 0) parts.add("$months tháng");
    if (days > 0) parts.add("$days ngày");

    return "Còn ${parts.join(" ")}";
  }

  String get solarDateDisplay => "$solarDay/$solarMonth/$solarYear DL";
  String get lunarDateDisplay => "$lunarDay/$lunarMonth/$lunarYear AL";
}
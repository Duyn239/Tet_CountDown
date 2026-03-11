
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart'; // Import Lottie
import '../../../view_models/home_vm.dart';
import '../settings/setting_view.dart';

class CountdownHeader extends StatelessWidget {
  final HomeViewModel vm;
  const CountdownHeader({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    const orangeRedGradient = LinearGradient(
      colors: [Color(0xFFF48554), Color(0xFFFDCB35)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    const double headerHeight = 520;

    return Stack(
      // Cho phép pháo hoa tràn ra ngoài biên của Header
      clipBehavior: Clip.none,
      children: [
        // 1. Hình nền chính
        Container(
          width: double.infinity,
          height: headerHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(vm.getZodiacLinkImg()),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // 2. Lớp phủ Gradient để làm tối nền
        Container(
          width: double.infinity,
          height: headerHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF8B0000).withOpacity(0.8),
                const Color(0xFF8B0000).withOpacity(0.4),
              ],
            ),
          ),
        ),

        // 3. Hiệu ứng PHÁO HOA NÂNG CẤP (To hơn, Dày hơn)
        if (vm.isCelebrationMode)
          Positioned.fill(
            child: IgnorePointer( // Cho phép tương tác xuyên qua lớp pháo hoa
              child: Stack(
                children: [
                  // LỚP 1: Pháo hoa chính (Phóng to 1.3 lần, phủ kín)
                  Transform.scale(
                    scale: 1.3, // <--- Chỉnh to hơn ở đây (1.0 là gốc)
                    child: Lottie.asset(
                      'assets/animations/FireworksNew.json',
                      fit: BoxFit.cover,
                    ),
                  ),

                  // LỚP 2: Thêm một lớp pháo hoa nữa để tạo độ DÀY
                  // Chỉnh lệch vị trí một chút để không bị trùng khít
                  Positioned(
                    top: -50, left: -50, right: -50, bottom: -50,
                    child: Opacity(
                      opacity: 0.8, // Làm mờ nhẹ lớp thứ 2 để tạo chiều sâu
                      child: Transform.rotate(
                        angle: 0.2, // Xoay nhẹ góc để pháo nổ ở vị trí khác
                        child: Transform.scale(
                          scale: 1.1, // Lớp này nhỏ hơn một chút
                          child: Lottie.asset(
                            'assets/animations/hoadao.json',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // 4. Nội dung UI chính
        Positioned.fill(
          child: SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    padding: const EdgeInsets.only(right: 15),
                    icon: const Icon(Icons.settings, color: Colors.white, size: 25),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsView()),
                      );
                    },
                  ),
                ),
                Text(
                  vm.isCelebrationMode ? "TẾT ĐÃ ĐẾN RỒI!" : "ĐẾM NGƯỢC TỚI GIAO THỪA",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 5),
                ShaderMask(
                  shaderCallback: (bounds) => orangeRedGradient.createShader(bounds),
                  child: Text(
                    vm.targetTetDateString,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                const Spacer(),

                // Khối đồng hồ / Hoặc Lời chúc
                Container(
                  width: 270,
                  height: 270,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // Thêm bóng đổ phát sáng mạnh hơn khi ăn mừng
                    boxShadow: vm.isCelebrationMode
                        ? [BoxShadow(color: Colors.orange.withOpacity(0.7), blurRadius: 40, spreadRadius: 10)]
                        : [],
                  ),
                  child: CustomPaint(
                    painter: GradientCirclePainter(
                      gradient: orangeRedGradient,
                      thickness: 6,
                    ),


                    // khối chúc mừng năm mới
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (vm.isCelebrationMode) ...[
                          // Nội dung khi Đã đến Tết
                          Text(
                            "CHÚC MỪNG\nNĂM MỚI",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.philosopher( // Font chữ nghệ thuật hơn cho lời chúc
                              fontSize: 35,
                              color: const Color(0xFFFDCB35),
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ] else ...[
                          // Nội dung khi Đang đếm ngược
                          _buildVerticalTimeUnit(vm.days, "Ngày", isLarge: true),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildVerticalTimeUnit(vm.hours, "Giờ", isLarge: false),
                              const SizedBox(width: 16),
                              _buildVerticalTimeUnit(vm.minutes, "Phút", isLarge: false),
                              const SizedBox(width: 16),
                              _buildVerticalTimeUnit(vm.seconds, "Giây", isLarge: false),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    vm.currentSolarDate,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalTimeUnit(String value, String unit, {bool isLarge = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: isLarge ? 55 : 30,
            color: const Color(0xFFFDCB35),
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          unit,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: isLarge ? 18 : 16,
            fontWeight: FontWeight.w700,
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

class GradientCirclePainter extends CustomPainter {
  final Gradient gradient;
  final double thickness;
  GradientCirclePainter({required this.gradient, required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset.zero & size;
    Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, 6.28, false, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true; // Đổi thành true để cập nhật khi đổi mode
}
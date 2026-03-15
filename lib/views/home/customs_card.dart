import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomsCard extends StatelessWidget {
  const CustomsCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Định nghĩa một shadow chuẩn để dùng chung cho các Text
    final List<Shadow> textShadows = [
      Shadow(
        color: Colors.black.withOpacity(0.2),
        offset: const Offset(0, 2),
        blurRadius: 3,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/customs'),
        child: Container(
          height: 100, // Nhỏ lại một chút theo ý Duy trước đó
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFB8261D).withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // 1. Ảnh nền
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/h1_new.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // 2. Lớp phủ màu đỏ - Đậm hơn một chút ở phía chữ để tăng độ tương phản
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7), // Thêm chút đen để chữ nổi bật
                        const Color(0xFFB8261D).withOpacity(0.4),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),

              // 3. Nội dung
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "KHÁM PHÁ",
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFFD700),
                              letterSpacing: 1.2,
                              shadows: textShadows, // Đổ bóng đen
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Phong Tục Ngày Tết",
                            style: GoogleFonts.philosopher(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: textShadows, // Đổ bóng đen
                            ),
                          ),
                          Text(
                            "Tìm hiểu nét đẹp văn hóa Việt",
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.9),
                              shadows: textShadows, // Đổ bóng đen
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xFFFFD700),
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
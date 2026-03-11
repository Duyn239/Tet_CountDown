import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// về ứng dụng
class InfoCard extends StatelessWidget {
  const InfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFF9ECDD), borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Về ứng dụng",
              style: GoogleFonts.inter(color: const Color(0xFFB8261D), fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          Text("Trợ lý Tết giúp bạn theo dõi đếm ngược và các mốc quan trọng của Tết Nguyên Đán. Chúc bạn năm mới vui vẻ!",
              style: GoogleFonts.inter(color: const Color(0xFFB8261D), fontSize: 13)),
        ],
      ),
    );
  }
}
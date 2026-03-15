import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/custom_model.dart';

class TetCustomsView extends StatelessWidget {
  const TetCustomsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9E5),
      body: Column(
        children: [
          // Header nền đỏ, chữ trắng
          _buildAppBar(context),

          // Danh sách nội dung bên dưới nền kem
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              physics: const BouncingScrollPhysics(),
              itemCount: tetCustoms.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: _buildFlipCard(tetCustoms[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10, // Chừa khoảng trống cho Status bar
        bottom: 20,
        left: 10,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFB8261D), // Nền đỏ truyền thống
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB8261D).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                "PHONG TỤC TẾT",
                style: GoogleFonts.philosopher(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Chữ trắng
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50), // Căn lề đều với Title
            child: Text(
              "Di sản văn hóa phi vật thể Việt Nam",
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.85), // Chữ trắng mờ nhẹ
                fontSize: 13,
                letterSpacing: 0.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlipCard(CustomModel custom) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      speed: 600,
      front: _buildCardFront(custom),
      back: _buildCardBack(custom),
    );
  }

  Widget _buildCardFront(CustomModel custom) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
        image: DecorationImage(
          image: AssetImage(custom.imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              const Color(0xFFB8261D).withOpacity(0.8),
            ],
          ),
        ),
        padding: const EdgeInsets.all(25),
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                "TRUYỀN THỐNG",
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFB8261D),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              custom.title,
              style: GoogleFonts.philosopher(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [const Shadow(blurRadius: 10, color: Colors.black)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack(CustomModel custom) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFB8261D), width: 1.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            custom.title.toUpperCase(),
            style: GoogleFonts.philosopher(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFB8261D),
            ),
          ),
          const Divider(color: Color(0xFFB8261D), thickness: 1, indent: 40, endIndent: 40),
          const SizedBox(height: 10),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                custom.content,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Icon(Icons.flip_camera_android_rounded, color: Color(0xFFB8261D), size: 20),
        ],
      ),
    );
  }
}
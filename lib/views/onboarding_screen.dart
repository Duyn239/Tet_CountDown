import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tet_countdown_project/views/home/home_view.dart';

class ModernOnboarding extends StatefulWidget {
  const ModernOnboarding({super.key});

  @override
  State<ModernOnboarding> createState() => _ModernOnboardingState();
}

class _ModernOnboardingState extends State<ModernOnboarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "CHÀO MỪNG ĐẾN VỚI\nTẾT COUNTDOWN",
      "subtitle": "Cùng nhau đếm ngược khoảnh khắc thiêng liêng chào đón năm mới.",
      "image": "assets/images/h1_new.png",
      "accentColor": const Color(0xFFC62828), // Đỏ đô
    },
    {
      "title": "MỌI TÍNH NĂNG TẾT\nTRONG TẦM TAY",
      "subtitle": "• Countdown tự động các năm\n• Xem lịch âm dương chuẩn xác\n• Theo dõi các sự kiện ngày Tết",
      "image": "assets/images/hinh2.jpg",
      "accentColor": const Color(0xFFE67E22), // Cam (hợp với rồng vàng)
    },
    {
      "title": "LỜI CHÚC AN KHANG\n& MAY MẮN",
      "subtitle": "Kính chúc bạn một năm mới sức khỏe dồi dào, vạn sự như ý và thật nhiều niềm vui!",
      "image": "assets/images/h4.png",
      "accentColor": const Color(0xFFD4AC0D), // Vàng đồng
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Hình nền và Hiệu ứng chuyển trang
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [


                    Image.asset(
                      _onboardingData[index]["image"]!,
                      fit: BoxFit.cover,
                    ),


                    // Lớp Gradient hiện đại giúp nổi chữ
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.5, 0.9],
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // 2. Nội dung văn bản (Style Hiện Đại)
          Positioned(
            bottom: 140,
            left: 30,
            right: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dots Indicator
                Row(
                  children: List.generate(
                    _onboardingData.length,
                        (index) => _buildDot(index, _onboardingData[_currentPage]["accentColor"]),
                  ),
                ),
                const SizedBox(height: 25),
                // Tiêu đề: Montserrat (Mạnh mẽ, sang trọng)
                Text(
                  _onboardingData[_currentPage]["title"]!,
                  style: GoogleFonts.montserrat(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.1,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 15),
                // Nội dung: Open Sans (Sạch sẽ, dễ đọc)
                Text(
                  _onboardingData[_currentPage]["subtitle"]!,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.85),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),

          // 3. Thanh điều hướng dưới cùng
          Positioned(
            bottom: 40,
            left: 30,
            right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => _navigateToHome(),
                  child: Text(
                    "Bỏ qua",
                    style: GoogleFonts.openSans(
                      color: Colors.white60,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Nút hành động chính
                GestureDetector(
                  onTap: () {
                    if (_currentPage == _onboardingData.length - 1) {
                      _navigateToHome();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOutCubic,
                      );
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _currentPage == _onboardingData.length - 1 ? 140 : 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: _onboardingData[_currentPage]["accentColor"],
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: (_onboardingData[_currentPage]["accentColor"] as Color).withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    child: Center(
                      child: _currentPage == _onboardingData.length - 1
                          ? Text(
                        "BẮT ĐẦU",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                          : const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeView()),
    );
  }

  Widget _buildDot(int index, Color accentColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: _currentPage == index ? 28 : 8,
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        color: _currentPage == index ? accentColor : Colors.white24,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
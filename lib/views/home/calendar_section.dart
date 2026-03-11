
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../view_models/home_vm.dart';
import '../calendar/detail_calendar_view.dart';

class CalendarSection extends StatelessWidget {
  final HomeViewModel vm;
  const CalendarSection({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    final List<String> weekDays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Lịch Âm Dương",
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepRed,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DetailCalendarView()),
                  );
                },
                child: Text(
                  "Xem chi tiết ->",
                  style: GoogleFonts.inter(
                    color: const Color(0xFFD3AF35),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  vm.currentMonthYearLabel,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepRed,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: weekDays.map((day) => Text(
                    day,
                    style: GoogleFonts.inter(
                      color: const Color(0xFFB8261D),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 10),


                GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: vm.currentMonthDays.length,


                  itemBuilder: (context, index) {
                    final dayData = vm.currentMonthDays[index];

                    // Xử lý ô trống (nếu dayData là null)
                    if (dayData == null) return const SizedBox.shrink();

                    return Container(
                      decoration: BoxDecoration(
                        color: dayData.isToday ? const Color(0xFFF2C94C) : const Color(0xFFF7E9E0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${dayData.solarDay}",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: const Color(0xFF171A1F),
                            ),
                          ),
                          Text(
                            dayData.lunarShortText,
                            style: GoogleFonts.inter(
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF171a1f).withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
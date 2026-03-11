import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../view_models/calendar_detail_vm.dart';

class DayDetailSection extends StatelessWidget {
  const DayDetailSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalendarViewModel>(context);
    final day = vm.selectedDayObject;

    // Nếu chưa có ngày nào được chọn (trường hợp khởi tạo)
    if (day == null) {
      return const SizedBox(
        height: 180,
        child: Center(child: Text("Chọn một ngày để xem chi tiết")),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 1),
          bottom: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    Text(
                      day.weekday,
                      style: GoogleFonts.inter(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF323842),
                      ),
                    ),
                    Text(
                      "${day.solarDay}",
                      style: GoogleFonts.inter(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFB8261D),
                      ),
                    ),
                    Text(
                      "Tháng ${vm.selectedMonth}, ${vm.selectedYear}",
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF323842),
                      ),
                    ),
                    Text(
                      "Dương lịch",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: const Color(0xFF323842),
                      ),
                    ),
                  ],
                ),
              ),
            ),


            const VerticalDivider(color: Colors.grey, thickness: 1.2),

            // CỘT PHẢI : ÂM LỊCH
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  children: [
                    // nếu ngày đó có sự kiện
                    if (day.hasEvent)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            size: 16,
                            color: Color(0xFFB8261D),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              day.event!.title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                color: const Color(0xFFB8261D),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )

                    // nếu ngày đó k có sự kiện
                    else
                      const SizedBox(
                        height: 20,
                      ),

                    const SizedBox(height: 28),
                    Text(
                      "${day.lunarDay} Tháng ${day.lunarMonth}",
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF323842),
                      ),
                    ),
                    Text(
                      "Năm ${day.canchiYear}",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: const Color(0xFF323842),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Âm lịch",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: const Color(0xFF323842),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

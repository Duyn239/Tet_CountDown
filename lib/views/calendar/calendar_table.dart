
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../view_models/calendar_detail_vm.dart';

class CalendarTable extends StatelessWidget {
  const CalendarTable({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalendarViewModel>(context);
    final List<String> weekDays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFBEC),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            vm.monthYearLabel,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFB8261D),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays.map((day) => Text(
              day,
              style: GoogleFonts.inter(
                color: const Color(0xFFB8261D),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            )).toList(),
          ),
          const SizedBox(height: 5),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 0.85,
            ),
            itemCount: vm.calendarDays.length,


            itemBuilder: (context, index) {
              final dayData = vm.calendarDays[index];

              // Xử lý ô trống (nếu dayData là null)
              if (dayData == null) return const SizedBox.shrink();

              // Logic xác định ngày được chọn
              // So sánh thuộc tính để xác định xem ô này có phải là ngày đang chọn không
              bool isSelected = vm.selectedDayObject?.solarDay == dayData.solarDay;

              return GestureDetector(
                onTap: () => vm.selectDay(dayData),
                child: Container(
                  decoration: BoxDecoration(
                    // Ưu tiên màu vàng cho ngày hôm nay, nếu không thì màu nền mặc định
                    color: dayData.isToday ? const Color(0xFFF2C94C) : const Color(0xFFF7E9E0),
                    borderRadius: BorderRadius.circular(10),
                    border: isSelected
                        ? Border.all(color: const Color(0xFFB71D1D), width: 1.8)
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${dayData.solarDay}",
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF171A1F),
                        ),
                      ),
                      Text(
                        dayData.lunarShortText,
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF171a1f).withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
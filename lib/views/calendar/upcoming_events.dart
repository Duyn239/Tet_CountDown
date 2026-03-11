import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../data/models/event.dart';
import '../../view_models/calendar_detail_vm.dart';

class UpcomingEvents extends StatelessWidget {
  const UpcomingEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalendarViewModel>(context);
    final events = vm.lunarNewYearEvents;

    return Padding(
      // Giảm padding dọc của toàn bộ widget xuống mức tối thiểu
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              "Sự kiện tết năm ${vm.selectedYear}",
              style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFB8261D)
              )
          ),
          const SizedBox(height: 6), // Cực kỳ nhỏ để Label sát tiêu đề
          Row(
            children: [
              _buildEventLabel("AL: Âm lịch"),
              const SizedBox(width: 20),
              _buildEventLabel("DL: Dương lịch"),
            ],
          ),
          // Không thêm SizedBox ở đây để card sát vào Label
          const SizedBox(height: 10),


          if (events.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("Không có sự kiện nào"),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 8),
              itemCount: events.length,

              itemBuilder: (context, index) {
                final event = events[index];
                return _buildEventCard(event);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEventLabel(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)
        ),
        const SizedBox(width: 6),
        Text(
            text,
            style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF888888))
        ),
      ],
    );
  }

  Widget _buildEventCard(Event event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFBEC),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4)
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: const Color(0xFFBA2725),
                borderRadius: BorderRadius.circular(12)
            ),
            child: const Icon(Icons.celebration, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    event.title,
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFB8261D)
                    )
                ),
                const SizedBox(height: 2),
                Text(
                  "${event.lunarDateDisplay}\n${event.solarDateDisplay}",
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF666666),
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
                color: event.dayLeftDisplay == "Hôm nay"
                    ? const Color(0xFFBA2725)
                    : const Color(0xFFF8EED4),
                borderRadius: BorderRadius.circular(12)
            ),
            child: Text(
                event.dayLeftDisplay,
                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: event.dayLeftDisplay == "Hôm nay" ? Colors.white : const Color(0xFFB8261D)
                )
            ),
          ),
        ],
      ),
    );
  }
}
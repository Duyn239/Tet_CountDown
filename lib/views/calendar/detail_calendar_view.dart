
import 'package:flutter/material.dart';
import 'package:tet_countdown_project/views/calendar/upcoming_events.dart';

import 'calendar_header.dart';
import 'calendar_table.dart';
import 'day_detail_section.dart';


class DetailCalendarView extends StatelessWidget {
  const DetailCalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Header màu đỏ
            const CalendarHeader(),

            // 2. Ép bảng lịch đè lên Header bằng Transform
            Transform.translate(
              offset: const Offset(0, -30), // Kéo lên 50px để đè lên phần đỏ bo góc
              child: const CalendarTable(),
            ),

            // 3. Các thành phần bên dưới (Cần dịch chuyển lên để bù đắp khoảng trống của Table)
            Transform.translate(
              offset: const Offset(0, 2),
              child: const Column(
                children: [
                  DayDetailSection(),
                  SizedBox(height: 30),
                  UpcomingEvents(),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
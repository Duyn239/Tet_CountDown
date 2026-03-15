import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../view_models/home_vm.dart';
import 'customs_card.dart';
import 'calendar_section.dart';
import 'countdown_header.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBEE),
      // Bỏ FAB cũ ở đây để giao diện thoáng đãng hơn
      body: SingleChildScrollView(
        child: Column(
          children: [
            CountdownHeader(vm: vm),
            CalendarSection(vm: vm),
            const CustomsCard(),

          ],
        ),
      ),
    );
  }
}
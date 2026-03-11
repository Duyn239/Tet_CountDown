import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../view_models/home_vm.dart';
import 'calendar_section.dart';
import 'countdown_header.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Lắng nghe dữ liệu từ ViewModel
    final vm = Provider.of<HomeViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBEE),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CountdownHeader(vm: vm),
            CalendarSection(vm: vm),
          ],
        ),
      ),
    );
  }
}
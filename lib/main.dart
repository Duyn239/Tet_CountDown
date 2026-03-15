import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tet_countdown_project/view_models/calendar_detail_vm.dart';
import 'package:tet_countdown_project/view_models/home_vm.dart';
import 'package:tet_countdown_project/view_models/settings_vm.dart';
import 'package:tet_countdown_project/views/home/home_view.dart';
import 'package:tet_countdown_project/views/onboarding/onboarding_screen.dart';
import 'package:tet_countdown_project/views/home/tet_custom_view.dart'; // Duy nhớ tạo thư mục và file này nhé

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),

        ChangeNotifierProxyProvider<SettingsViewModel, HomeViewModel>(
          create: (context) => HomeViewModel(
            settingsVM: Provider.of<SettingsViewModel>(context, listen: false),
          ),
          update: (context, settingsVM, homeVM) {
            homeVM?.refreshAllData();
            return homeVM!;
          },
        ),

        ChangeNotifierProvider(create: (_) => CalendarViewModel()),
      ],
      child: const TetCountdownApp(),
    ),
  );
}

class TetCountdownApp extends StatelessWidget {
  const TetCountdownApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tết Countdown',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        // Cấu hình font chữ Serif cho toàn app để hợp không khí Tết
        fontFamily: 'Roboto',
      ),
      // Điều hướng ban đầu: Vào Onboarding trước
      home: const ModernOnboarding(),

      // Định nghĩa route để từ Onboarding nhảy sang Home dễ dàng
      routes: {
        '/home': (context) => const HomeView(),
        '/customs': (context) => const TetCustomsView(), // Thêm dòng này
      },
    );
  }
}
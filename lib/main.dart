import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tet_countdown_project/view_models/calendar_detail_vm.dart';
import 'package:tet_countdown_project/view_models/home_vm.dart';
import 'package:tet_countdown_project/view_models/settings_vm.dart';
import 'package:tet_countdown_project/views/home/home_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),

        ChangeNotifierProxyProvider<SettingsViewModel, HomeViewModel>(
          // Khởi tạo ban đầu
          create: (context) => HomeViewModel(
            settingsVM: Provider.of<SettingsViewModel>(context, listen: false),
          ),
          // Cập nhật khi SettingsViewModel thay đổi
          update: (context, settingsVM, homeVM) {
            // Mỗi khi SettingsViewModel notifyListeners, hàm này chạy
            // Chúng ta cập nhật lại dữ liệu mới nhất cho Home
            homeVM?.refreshAllData();
            return homeVM!;
          },
        ),

        ChangeNotifierProvider(create: (_) => CalendarViewModel()),
      ],
      child: const MaterialApp(
        home: HomeView(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

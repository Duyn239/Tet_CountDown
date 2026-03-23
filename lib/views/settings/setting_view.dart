import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tet_countdown_project/views/home/customs_card.dart';
import 'package:tet_countdown_project/views/settings/widgets/info_card.dart';
import 'package:tet_countdown_project/views/settings/widgets/zodiac_picker_card.dart';
import '../../view_models/settings_vm.dart';
import 'widgets/setting_card.dart';
import 'widgets/demo_card.dart';
import 'widgets/reset_dialog.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SettingsViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFEFCEF),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            _buildRedHeader(),
            SafeArea(
              child: Column(
                children: [
                  _buildAppBar(context),
                  const SizedBox(height: 20),

                  ZodiacPickerCard(vm: vm, buildCommonCard: _buildCommonCardWrapper),

                  /// Demo Countdown
                  DemoCard(
                    vm: vm,
                    icon: Icons.timer_outlined,
                    title: "Chế độ Demo Countdown",
                    subtitle: "Thay đổi đêm giao thừa để demo",
                    value: vm.isDemoCountdownOn, // state của Switch.
                    isEditing: vm.isEditingCountdown, // state của form (hiện/ko)
                    onChanged: (val) => vm.toggleDemoCountdown(val),
                    onToggleEdit: (val) => vm.setEditingCountdown(val),
                  ),


                  _buildActionCard(context, vm),

                  /// VỀ ỨNG DỤNG
                  const InfoCard(),
                  const SizedBox(height: 10),

                  Center(
                    child: Opacity(
                      opacity: 0.9, // Làm mờ nhẹ để không lấn át các thẻ cài đặt bên trên
                      child: Lottie.asset(
                        'assets/animations/LionNY.json', // Thay bằng file của Duy
                        width: 220,
                        fit: BoxFit.contain,
                        repeat: true,
                      ),
                    ),
                  ),


                  // Thêm dòng Version nhỏ ở dưới cùng cho chuyên nghiệp
                  Text(
                    "Phiên bản 1.0.0",
                    style: GoogleFonts.inter(
                      color: Colors.grey.withOpacity(0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 30),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm wrapper để truyền hàm buildCommonCard vào widget con
  Widget _buildCommonCardWrapper(IconData icon, String title, String subtitle, Widget trailing) {
    return _buildCommonCard(icon: icon, title: title, subtitle: subtitle, trailing: trailing);
  }

  Widget _buildRedHeader() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: const BoxDecoration(
        color: Color(0xFFBB2C28),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Text("Cài Đặt", style: GoogleFonts.inter(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, SettingsViewModel vm) {
    return GestureDetector(
      onTap: () => showDialog(context: context, barrierColor: Colors.black54,
                              builder: (context) => ResetDialog(vm: vm)),
      child: _buildCommonCard(
        icon: Icons.restore,
        title: "Khôi phục cài đặt",
        subtitle: "Thiết lập toàn bộ cài đặt về trạng thái mặc định",
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  Widget _buildCommonCard({required IconData icon, required String title, required String subtitle, required Widget trailing}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFBB2C28), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.inter(color: const Color(0xFFB8261D), fontSize: 16, fontWeight: FontWeight.bold)),
                Text(subtitle, style: GoogleFonts.inter(color: const Color(0xFF9095A0), fontSize: 12)),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }


}
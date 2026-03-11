import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../view_models/settings_vm.dart';

class ResetDialog extends StatelessWidget {
  final SettingsViewModel vm;

  const ResetDialog({super.key, required this.vm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      titlePadding: EdgeInsets.zero,
      title: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              padding: const EdgeInsets.only(top: 10, right: 10),
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.close, color: Colors.grey, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Text("Xác nhận khôi phục cài đặt",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: const Color(0xFFB8261D), fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 15),
          const Divider(height: 1, color: Color(0xFFF2F2F2)),
        ],
      ),
      content: Text("Tất cả cài đặt của bạn sẽ được đưa về mặc định. Bạn có chắc chắn muốn thực hiện không?",
          style: GoogleFonts.inter(color: const Color(0xFF171A1F), fontSize: 14)),
      actionsPadding: const EdgeInsets.only(right: 15, bottom: 15),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
              backgroundColor: Colors.grey[400],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          child: Text("Hủy", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
        TextButton(
          onPressed: () async {
            await vm.resetToDefault();
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đã khôi phục cài đặt mặc định")));
            }
          },
          style: TextButton.styleFrom(
              backgroundColor: const Color(0xFFDE3B40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          child: Text("Xác nhận", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
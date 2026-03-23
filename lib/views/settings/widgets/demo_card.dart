import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../view_models/settings_vm.dart';

class DemoCard extends StatelessWidget {
  final SettingsViewModel vm;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value; // Giá trị Switch
  final bool isEditing; // Lấy từ vm.isEditingCountdown
  final ValueChanged<bool> onChanged;
  final Function(bool) onToggleEdit;

  const DemoCard({
    super.key,
    required this.vm,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.isEditing,
    required this.onChanged,
    required this.onToggleEdit,
  });

  @override
  Widget build(BuildContext context) {
    String dateLabel = "${vm.draftDate.day}/${vm.draftDate.month}/${vm.draftDate.year}";
    String timeLabel = vm.draftTime.format(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLeading(isActive: value),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: GoogleFonts.inter(color: const Color(0xFFB8261D), fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: GoogleFonts.inter(color: const Color(0xFF9095A0), fontSize: 12)),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged, // sau khi bật / tắt switch -> gọi đến hàm onChanged
                activeTrackColor: const Color(0xFFBB2C28),
              ),
            ],
          ),

          // TH: bật switch -> hiển thị form chỉnh sửa
          if (value && isEditing) ...[
            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 15),
            _buildInput(context, label: "Ngày demo:", icon: Icons.calendar_today, value: dateLabel, isDate: true),
            const SizedBox(height: 12),
            _buildInput(context, label: "Thời gian demo:", icon: Icons.access_time, value: timeLabel, isDate: false),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () async {
                  await vm.saveDemoSettings();
                  onToggleEdit(false);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Đã lưu thiết lập demo thành công!", style: GoogleFonts.inter()),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDE3B40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("Lưu", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ]

          else if (value && !isEditing) ...[
            TextButton(
              onPressed: () => onToggleEdit(true), // Mở form thông qua VM
              child: Text(
                "Chỉnh sửa thiết lập demo",
                style: GoogleFonts.inter(color: Colors.grey, fontSize: 12, decoration: TextDecoration.underline),
              ),
            )
          ]
        ],
      ),
    );
  }

  Widget _buildLeading({required bool isActive}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFFBB2C28), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(isActive ? "Đang bật" : "Đang tắt",
            style: GoogleFonts.inter(color: const Color(0xFFDE3B40), fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildInput(BuildContext context, {required String label, required IconData icon, required String value, required bool isDate}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(color: const Color(0xFFB8261D), fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            if (isDate) {
              final picked = await showDatePicker(context: context, initialDate: vm.draftDate, firstDate: DateTime(2026), lastDate: DateTime(2030));
              if (picked != null) {
                vm.updateDemoDate(picked);
              }
            } else {
              final picked = await showTimePicker(context: context, initialTime: vm.draftTime);
              if (picked != null) {
                vm.updateDemoTime(picked);
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFDECEC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFBB2C28).withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(icon, color: const Color(0xFFBB2C28), size: 18),
                const SizedBox(width: 10),
                Text(value, style: GoogleFonts.inter(fontSize: 14)),
                const Spacer(),
                const Icon(Icons.edit_calendar_outlined, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
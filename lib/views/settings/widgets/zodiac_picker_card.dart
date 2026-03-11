import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../view_models/settings_vm.dart';

class ZodiacPickerCard extends StatelessWidget {
  final SettingsViewModel vm;
  final Function(IconData, String, String, Widget) buildCommonCard;

  const ZodiacPickerCard({super.key, required this.vm, required this.buildCommonCard});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (_) => Container(
            height: 450,
            color: const Color(0xFFFDFBEC),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  color: const Color(0xFFBA2725),
                  child: Center(
                    child: Text(
                      "Chọn con giáp",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    backgroundColor: const Color(0xFFFDFBEC),
                    itemExtent: 45,
                    scrollController: FixedExtentScrollController(
                      initialItem: vm.selectedZodiacIndex,
                    ),
                    onSelectedItemChanged: (index) => vm.updateZodiac(index),
                    children: vm.zodiacs.map((zodiac) {
                      return Center(
                        child: Text(
                          "${zodiac['icon']}  ${zodiac['name']}",
                          style: GoogleFonts.inter(
                            color: const Color(0xFFB8261D),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: buildCommonCard(
        Icons.wallpaper,
        "Thay màn hình nền",
        "Thay màn hình nền theo 12 con giáp",
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              vm.currentZodiacName,
              style: GoogleFonts.inter(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 14),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
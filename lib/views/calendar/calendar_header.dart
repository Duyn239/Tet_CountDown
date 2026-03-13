import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../view_models/calendar_detail_vm.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({super.key});

  void _showYearPicker(BuildContext context, CalendarViewModel vm) {
    const int startYear = 1900;
    const int endYear = 2100;

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 400,
        color: const Color(0xFFFDFBEC),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: const Color(0xFFBA2725),
              child: Center(
                child: Text(
                  "Chọn năm",
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
                scrollController: FixedExtentScrollController(
                  //Tính toán vị trí dựa trên năm 1900
                  initialItem: vm.selectedYear - startYear,
                ),
                itemExtent: 40,
                onSelectedItemChanged: (index) {
                  //Cập nhật năm: 1900 + vị trí đang chọn
                  vm.updateYear(startYear + index);
                },
                //Tạo danh sách từ 1900 đến 2100
                children: List<Widget>.generate(endYear - startYear + 1, (index) {
                  return Center(
                    child: Text(
                      "${startYear + index}",
                      style: GoogleFonts.inter(
                        color: const Color(0xFFB8261D),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Chuyển sang lắng nghe CalendarViewModel
    final vm = Provider.of<CalendarViewModel>(context);

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 220,
          decoration: const BoxDecoration(
            color: Color(0xFFBA2725),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),
        SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Lịch Chi Tiết",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          // giảm tháng
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.arrow_left, color: Colors.white, size: 35),
                            onPressed: () => vm.updateMonth(-1), // Gọi hàm giảm tháng
                          ),


                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Tháng ${vm.selectedMonth}", // Hiển thị tháng từ VM
                              style: GoogleFonts.inter(color: Colors.white, fontSize: 20),
                            ),
                          ),

                          // tăng tháng
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(Icons.arrow_right, color: Colors.white, size: 35),
                            onPressed: () => vm.updateMonth(1), // Gọi hàm tăng tháng
                          ),


                        ],
                      ),
                      GestureDetector(
                        onTap: () => _showYearPicker(context, vm),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${vm.selectedYear}", // Hiển thị năm từ VM
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
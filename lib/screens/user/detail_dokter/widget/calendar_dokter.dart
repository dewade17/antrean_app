// ignore_for_file: deprecated_member_use

import 'package:antrean_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // untuk DateFormat.E('id_ID')
import 'package:table_calendar/table_calendar.dart';

class CalendarDokter extends StatefulWidget {
  const CalendarDokter({super.key});

  @override
  State<CalendarDokter> createState() => _CalendarDokterState();
}

class _CalendarDokterState extends State<CalendarDokter> {
  DateTime today = DateTime.now();

  // Simulasi tanggal yang tersedia
  final Set<DateTime> availableDates = {
    DateTime.utc(2025, 6, 2),
    DateTime.utc(2025, 6, 4),
    DateTime.utc(2025, 6, 6),
    DateTime.utc(2025, 6, 10),
    DateTime.utc(2025, 6, 11),
    DateTime.utc(2025, 6, 18),
    DateTime.utc(2025, 6, 25),
  };

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  List<DropdownMenuItem<DateTime>> _generateDropdownItems() {
    final currentYear = DateTime.now().year;

    List<DropdownMenuItem<DateTime>> items = [];
    for (int month = 1; month <= 12; month++) {
      items.add(
        DropdownMenuItem(
          value: DateTime(currentYear, month),
          child: Text("${_getMonthName(month)} $currentYear"),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Jadwal Ketersediaan",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<DateTime>(
                    value: DateTime(today.year, today.month),
                    items: _generateDropdownItems(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          today = newValue;
                        });
                      }
                    },
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                    dropdownColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            color: AppColors.accentColor,
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: TableCalendar(
              locale: 'id_ID',
              rowHeight: 40,
              firstDay: DateTime.utc(2020),
              lastDay: DateTime.utc(2030),
              focusedDay: today,
              selectedDayPredicate: (day) => isSameDay(day, today),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  today = selectedDay;
                });
              },
              calendarStyle: CalendarStyle(
                isTodayHighlighted: false,
                outsideDaysVisible: true,
                // or EdgeInsets.all(1)
              ),
              headerVisible: false,
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  final text =
                      DateFormat.E('id_ID').format(day); // e.g. Min, Sen

                  return Container(
                    height: 50, // Sama persis dengan rowHeight agar sejajar
                    alignment:
                        Alignment.center, // Penting: teks tepat di tengah
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey.shade400, width: 0.5),
                    ),
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize:
                            14, // Lebih kecil dari tanggal agar tidak tabrakan
                      ),
                    ),
                  );
                },
                outsideBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day, false, isOutside: true);
                },
                defaultBuilder: (context, day, focusedDay) {
                  final available =
                      availableDates.any((d) => isSameDay(d, day));
                  return _buildDayCell(day, available);
                },
                selectedBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day, true, isSelected: true);
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(9, (index) {
              final hour = 8 + index;
              final timeText = "${hour.toString().padLeft(2, '0')} - 00";
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  timeText,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, color: AppColors.primaryColor, size: 10),
                  SizedBox(width: 4),
                  Text("Tidak Tersedia"),
                ],
              ),
              SizedBox(width: 20),
              Row(
                children: [
                  Icon(Icons.circle_outlined, size: 10),
                  SizedBox(width: 4),
                  Text("Tersedia"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell(DateTime day, bool available,
      {bool isSelected = false, bool isOutside = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 0.5),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (isSelected)
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blue, width: 2),
                ),
              ),
            Text(
              '${day.day}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isOutside ? Colors.grey.shade400 : Colors.black,
              ),
            ),
            if (available && !isOutside)
              Positioned(
                bottom: 6,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return months[month - 1];
  }
}

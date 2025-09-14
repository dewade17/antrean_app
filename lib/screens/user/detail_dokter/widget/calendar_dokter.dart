// ignore_for_file: deprecated_member_use

import 'package:antrean_app/provider/dokter/detail_dokter_provider.dart';
import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

class CalendarDokter extends StatefulWidget {
  final String idDokter;

  const CalendarDokter({
    super.key,
    required this.idDokter,
  });

  @override
  State<CalendarDokter> createState() => _CalendarDokterState();
}

class _CalendarDokterState extends State<CalendarDokter> {
  DateTime today = DateTime.now();

  bool isSameDayLocal(DateTime a, DateTime b) {
    final al = a.toLocal();
    final bl = b.toLocal();
    return al.year == bl.year && al.month == bl.month && al.day == bl.day;
  }

  DateTime dateOnlyLocal(DateTime d) {
    final dl = d.toLocal();
    return DateTime(dl.year, dl.month, dl.day);
  }

  Future<void> _fetchMonth() async {
    final firstDay = DateTime(today.year, today.month, 1);
    final lastDay = DateTime(today.year, today.month + 1, 0);

    await context.read<DetailDokterProvider>().fetch(
          idDokter: widget.idDokter,
          start: firstDay,
          end: lastDay,
          status: 'all',
        );
  }

  List<DropdownMenuItem<DateTime>> _generateDropdownItems() {
    final currentYear = DateTime.now().year;
    return List.generate(12, (i) {
      final month = i + 1;
      return DropdownMenuItem(
        value: DateTime(currentYear, month),
        child: Text("${_getMonthName(month)} $currentYear"),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchMonth();
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailProv = context.watch<DetailDokterProvider>();

    // Hari yang memiliki minimal satu slot tersedia → titik hijau
    final Set<DateTime> availableDays = detailProv.daysWithAvailable;

    // Semua slot pada hari terpilih (chips jam)
    final slotsOfDay = detailProv.slotsOfDate(today);

    // Hanya slot yang tersedia pada hari terpilih (untuk legend)
    final availableSlots = detailProv.availableSlotsOfDate(today);
    final int availableCount = availableSlots.length;
    final int notAvailableCount = slotsOfDay.length - availableCount;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header + dropdown bulan (tetap)
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
                    onChanged: (newValue) async {
                      if (newValue != null) {
                        setState(() {
                          today = DateTime(newValue.year, newValue.month, 1);
                        });
                        await _fetchMonth();
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

          // kalender (desain tetap), dot = hari yang punya slot tersedia
          Container(
            color: AppColors.accentColor,
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: TableCalendar(
              locale: 'id_ID',
              rowHeight: 40,
              firstDay: DateTime.utc(2020),
              lastDay: DateTime.utc(2030),
              focusedDay: today,
              selectedDayPredicate: (day) => isSameDayLocal(day, today),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  today = selectedDay;
                });
                // fetch tetap per-bulan
              },
              calendarStyle: const CalendarStyle(
                isTodayHighlighted: false,
                outsideDaysVisible: true,
              ),
              headerVisible: false,
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  final text = DateFormat.E('id_ID').format(day);
                  return Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.grey.shade400, width: 0.5),
                    ),
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  );
                },
                outsideBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day, false, isOutside: true);
                },
                defaultBuilder: (context, day, focusedDay) {
                  final avail = availableDays
                      .contains(DateTime(day.year, day.month, day.day));
                  return _buildDayCell(day, avail);
                },
                selectedBuilder: (context, day, focusedDay) {
                  final avail = availableDays
                      .contains(DateTime(day.year, day.month, day.day));
                  return _buildDayCell(day, avail, isSelected: true);
                },
              ),
            ),
          ),

          const SizedBox(height: 12),

          // chips jam (tetap), isi = semua slot hari terpilih
          // chips jam (tetap), isi = semua slot hari terpilih
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: slotsOfDay.map((j) {
              final isAvail =
                  context.read<DetailDokterProvider>().isSlotAvailable(j);
              final double op =
                  isAvail ? 1.0 : 0.4; // <-- opacity kalau TIDAK tersedia
              final timeText = "${j.jamMulaiHhmm} - ${j.jamSelesaiHhmm}";

              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade900.withOpacity(op), // <-- di sini
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  timeText,
                  style: TextStyle(
                    color: Colors.white.withOpacity(op), // <-- dan di sini
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // legend (TIDAK mengubah desain) — teksnya menampilkan jumlah
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(Icons.circle, color: AppColors.primaryColor, size: 10),
                  const SizedBox(width: 4),
                  Text("Tidak Tersedia ($notAvailableCount)"),
                ],
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  const Icon(Icons.circle_outlined, size: 10),
                  const SizedBox(width: 4),
                  Text("Tersedia ($availableCount)"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayCell(
    DateTime day,
    bool available, {
    bool isSelected = false,
    bool isOutside = false,
  }) {
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
              const Positioned(
                bottom: 6,
                child: SizedBox(
                  width: 6,
                  height: 6,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
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

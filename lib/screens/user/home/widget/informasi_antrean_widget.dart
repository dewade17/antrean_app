import 'package:antrean_app/provider/book_antrean/get_booking_antrean.dart';
import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class InformasiAntreanWidget extends StatelessWidget {
  const InformasiAntreanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProv = context.watch<GetBookingProvider>();

    // Ambil 1 booking (paling atas). Jika kosong/masih loading → pakai placeholder.
    final b = bookingProv.items.isNotEmpty ? bookingProv.items.first : null;

    final tanggalLabel = b?.jadwal.tanggalLabel ?? '-';
    final statusWaktu = b?.jadwal.statusWaktu ?? '-';
    final notif = b?.jadwal.notif ?? 'Informasi Jadwal Pemeriksaan';
    final namaDokter = b?.dokter.namaDokter ?? 'nama dokter';
    final noSedangDilayani = b?.antrean.noAntreanSedangDilayani;
    final totalAktif = b?.antrean.totalAntreanAktif;
    final noAntreanAnda = b?.antrean.noAntreanAnda;

    String numOrDash(Object? n) {
      if (n == null) return '-';
      if (n is int) return n.toString();
      if (n is String && n.trim().isEmpty) return '-';
      return n.toString();
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 350,
              height: 50,
              margin:
                  const EdgeInsets.only(top: 43), // jaga posisi seperti desain
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                border: Border.all(color: Colors.grey, width: 1.0),
                borderRadius: BorderRadius.circular(9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_month),
                        const SizedBox(width: 5),
                        Text(
                          tanggalLabel, // ⬅️ dari provider
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textDefaultColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 90,
                      height: 30,
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.av_timer_rounded),
                          const SizedBox(width: 5),
                          Text(statusWaktu), // ⬅️ dari provider
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Card(
              elevation: 5,
              child: Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.primaryColor,
                      AppColors.secondaryColor,
                    ],
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(9)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(Icons.notifications, color: AppColors.accentColor),
                      const SizedBox(width: 10),
                      Text(
                        notif, // ⬅️ dari provider
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.accentColor,
                AppColors.backgroundColor,
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          width: 390,
          height: 200,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                "Informasi Antrian",
                style: GoogleFonts.poppins(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDefaultColor,
                ),
              ),
              Text(
                namaDokter, // ⬅️ dari provider
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textDefaultColor,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // --- Box: No. Antrian Sedang Dilayani ---
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      border: Border.all(color: AppColors.textDefaultColor),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                    width: 100,
                    height: 120,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.primaryColor,
                                AppColors.secondaryColor,
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(
                                5), // perbaikan kecil (bukan desain)
                            child: Text(
                              "No. Antrian Sedang Dilayani",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textColor,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              numOrDash(noSedangDilayani),
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // --- Box: Total Antrian ---
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                    width: 100,
                    height: 120,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.hintColor,
                                AppColors.textColor,
                              ],
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.all(10), // perbaikan kecil
                            child: Text(
                              "Total Antrian",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDefaultColor,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              numOrDash(totalAktif),
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // --- Box: No. Antrian Anda ---
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      border: Border.all(color: AppColors.textDefaultColor),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                    width: 100,
                    height: 120,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.primaryColor,
                                AppColors.secondaryColor,
                              ],
                            ),
                          ),
                          child: Text(
                            "No. Antrian Anda",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              numOrDash(noAntreanAnda),
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

import 'package:antrean_app/provider/dokter/dokter_provider.dart';
import 'package:antrean_app/screens/user/detail_dokter/detail_dokter_screen.dart';
import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:antrean_app/dto/dokter/dokter.dart';

class ContentJadwalDokter extends StatefulWidget {
  const ContentJadwalDokter({super.key});

  @override
  State<ContentJadwalDokter> createState() => _ContentJadwalDokterState();
}

class _ContentJadwalDokterState extends State<ContentJadwalDokter> {
  @override
  void initState() {
    super.initState();
    // fetch data jadwal dokter hari ini
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<DokterProvider>()
          .fetch(date: DateTime.now(), status: 'active');
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<DokterProvider>();
    final now = DateTime.now();
    final dateText = DateFormat('d MMMM y', 'id').format(now);

    // ⬇⬇ PENTING: pakai hasil filter (efek search)
    final List<Dokter> data = prov.filteredItems;

    return Column(
      children: [
        // Header tanggal (tetap gaya lama, hanya isi tanggal realtime)
        Container(
          width: 380,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryColor, AppColors.secondaryColor],
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                Icon(Icons.calendar_month, color: AppColors.accentColor),
                const SizedBox(width: 10),
                Text(
                  'Jadwal Dokter $dateText',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.accentColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // konten: loading / error / list kartu
        if (prov.loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: CircularProgressIndicator(),
          )
        else if (prov.error != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              prov.error!,
              style: const TextStyle(color: Colors.red),
            ),
          )
        else if (data.isEmpty) // ⬅ cek kosong pada hasil filter
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text('Tidak ada jadwal dokter untuk hari ini'),
          )
        else
          // render kartu untuk setiap dokter (pakai hasil filter)
          Column(
            children: data.map((d) => _DoctorCard(dokter: d)).toList(),
          ),
      ],
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final Dokter dokter;
  const _DoctorCard({required this.dokter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SizedBox(
        width: 380,
        child: Card(
          elevation: 2,
          color: AppColors.accentColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              children: [
                // foto: pakai network jika ada, kalau kosong pakai aset lama
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryColor,
                        AppColors.secondaryColor
                      ],
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: (dokter.fotoProfilDokter.isNotEmpty)
                        ? Image.network(
                            dokter.fotoProfilDokter,
                            fit: BoxFit.contain,
                          )
                        : Image.asset(
                            "assets/images/Dokter_1.png",
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // baris nama + tombol forward
                      SizedBox(
                        width: 230,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                dokter.namaDokter,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailDokterScreen(
                                        idDokter: dokter.idDokter),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: AppColors.primaryColor,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('Dokter Spesialis ${dokter.spesialisasi}'),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: AppColors.primaryColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 5),
                          child: Row(
                            children: [
                              Icon(
                                Icons.incomplete_circle_outlined,
                                color: AppColors.accentColor,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Slot Tersedia: ${dokter.totalSisa}/${dokter.totalKapasitas}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.accentColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

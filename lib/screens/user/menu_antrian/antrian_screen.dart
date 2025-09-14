// ignore_for_file: deprecated_member_use
import 'package:antrean_app/provider/book_antrean/book_antrean_provider.dart';
import 'package:antrean_app/provider/layanan/layanan_provider.dart';
import 'package:antrean_app/provider/tanggungan/tanggungan_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:antrean_app/constraints/colors.dart';
import 'package:antrean_app/screens/user/menu_antrian/widget/button_back.dart';
import 'package:antrean_app/screens/user/menu_antrian/widget/button_next.dart';
import 'package:antrean_app/screens/user/menu_antrian/widget/button_popconfirm.dart';
import 'package:antrean_app/screens/user/menu_antrian/widget/steps_widget.dart';

// providers
import 'package:antrean_app/provider/dokter/dokter_provider.dart';
import 'package:antrean_app/provider/dokter/detail_dokter_provider.dart';

// models
import 'package:antrean_app/dto/dokter/detail_dokter.dart' show Jadwal;

class AntrianScreen extends StatefulWidget {
  const AntrianScreen({super.key});

  @override
  State<AntrianScreen> createState() => _AntrianScreenState();
}

class _AntrianScreenState extends State<AntrianScreen> {
  // controllers
  final dateController = TextEditingController();
  final namaPasienController = TextEditingController();
  final jeniskelaminController = TextEditingController(); // "Pria" | "Wanita"
  final noteleponController = TextEditingController();
  final dokterController = TextEditingController();
  final namatanggunganController = TextEditingController();
  final layananController = TextEditingController();
  final alamatController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // state dropdown terpilih
  String? selectedDokterId;
  String? selectedSlotId;
  String? selectedLayananId;
  String? selectedTanggunganId;

  // list slot hasil fetch detail dokter (hanya yg aktif & sisa>0)
  List<Jadwal> slotItems = [];

  @override
  void initState() {
    super.initState();
    // fetch awal (dokter/layanan/tanggungan)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final now = DateTime.now();
      await context.read<DokterProvider>().fetch(date: now, status: 'active');
      await context.read<LayananProvider>().fetch(status: 'active');
      await context.read<TanggunganProvider>().fetch(status: 'active');
    });
  }

  @override
  void dispose() {
    dateController.dispose();
    namaPasienController.dispose();
    jeniskelaminController.dispose();
    alamatController.dispose();
    noteleponController.dispose();
    dokterController.dispose();
    namatanggunganController.dispose();
    layananController.dispose();
    super.dispose();
  }

  Future<void> _fetchSlotsByDokter(String idDokter) async {
    final detailProv = context.read<DetailDokterProvider>();
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);

    final ok = await detailProv.fetch(
      idDokter: idDokter,
      start: start,
      end: end,
      status: 'active',
    );
    if (!ok) {
      setState(() {
        slotItems = [];
        selectedSlotId = null;
      });
      return;
    }

    final all = detailProv.jadwal;
    final available = all.where((j) {
      try {
        return j.slot.isActive == true && j.sisa > 0;
      } catch (_) {
        return false;
      }
    }).toList();

    setState(() {
      slotItems = available;
      selectedSlotId = null; // reset saat ganti dokter
    });
  }

  void _onChangeDokter(String? id) {
    setState(() {
      selectedDokterId = id;
    });
    if (id != null && id.isNotEmpty) {
      _fetchSlotsByDokter(id);
    } else {
      setState(() {
        slotItems = [];
        selectedSlotId = null;
      });
    }
  }

  void _onChangeSlot(String? id) {
    setState(() {
      selectedSlotId = id;
    });
  }

  void _onChangeLayanan(String? id) {
    setState(() {
      selectedLayananId = id;
    });
  }

  void _onChangeTanggungan(String? id) {
    setState(() {
      selectedTanggunganId = id;
    });
  }

  // ===== Helpers submit =====
  DateTime? _parseDob(String s) {
    final t = s.trim();
    if (t.isEmpty) return null;

    // coba ISO (yyyy-MM-dd)
    try {
      final d = DateTime.parse(t);
      return DateTime(d.year, d.month, d.day);
    } catch (_) {}

    // coba dd/MM/yyyy atau dd-MM-yyyy
    final slash = RegExp(r'^(\d{1,2})\/(\d{1,2})\/(\d{4})$');
    final dash = RegExp(r'^(\d{1,2})-(\d{1,2})-(\d{4})$');
    RegExpMatch? m = slash.firstMatch(t) ?? dash.firstMatch(t);
    if (m != null) {
      final d = int.parse(m.group(1)!);
      final mo = int.parse(m.group(2)!);
      final y = int.parse(m.group(3)!);
      return DateTime(y, mo, d);
    }
    return null;
  }

  Future<void> _submitBooking() async {
    final bookProv = context.read<BookAntreanProvider>();

    // Validasi minimal
    if (selectedDokterId == null || selectedDokterId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih dokter')),
      );
      return;
    }
    if (selectedSlotId == null || selectedSlotId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih jam pemeriksaan')),
      );
      return;
    }
    if (selectedLayananId == null || selectedLayananId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih jenis layanan')),
      );
      return;
    }

    final dob = _parseDob(dateController.text);
    if (dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal lahir tidak valid')),
      );
      return;
    }

    // Kirim "Pria"/"Wanita" persis sesuai pilihan user
    final jk = jeniskelaminController.text.trim();

    final booking = await bookProv.createBooking(
      tanggalLahir: dob,
      namaPasien: namaPasienController.text,
      jenisKelamin: jk, // ⬅️ langsung "Pria" / "Wanita"
      telepon: noteleponController.text,
      alamatUser: alamatController.text,
      idDokter: selectedDokterId!, // ID dokter
      idLayanan: selectedLayananId!, // ID layanan
      idTanggungan: selectedTanggunganId, // boleh null
      idSlot: selectedSlotId!, // ID SLOT (penting)
    );

    if (!mounted) return;

    if (booking != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Booking antrean berhasil'),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/home-screen',
          (Route<dynamic> route) => false,
        );
      }
    } else {
      final err = bookProv.error ?? 'Gagal membuat antrean';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(err)),
      );
    }
  }

  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    // watch provider untuk data list
    final dokterProv = context.watch<DokterProvider>();
    final layananProv = context.watch<LayananProvider>();
    final tanggunganProv = context.watch<TanggunganProvider>();
    final bookProv = context.watch<BookAntreanProvider>();

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          // header image
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryColor,
                  AppColors.secondaryColor,
                ],
              ),
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Image.asset(
                  "assets/images/Antrian_Image.png",
                  height: 250,
                  width: 300,
                ),
              ),
            ),
          ),

          // content area
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: ShapeDecoration(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.accentColor,
                    AppColors.backgroundColor,
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      StepsWidget(
                        currentStep: currentStep,
                        formKey: formKey,
                        dateController: dateController,
                        namaPasienController: namaPasienController,
                        alamatController: alamatController,
                        jeniskelaminController: jeniskelaminController,
                        noteleponController: noteleponController,
                        dokterController: dokterController,
                        namatanggunganController: namatanggunganController,
                        layananController: layananController,

                        // ==== pass data dinamis ====
                        dokterItems: dokterProv.filteredItems,
                        selectedDokterId: selectedDokterId,
                        onChangeDokter: _onChangeDokter,

                        slotItems: slotItems,
                        selectedSlotId: selectedSlotId,
                        onChangeSlot: _onChangeSlot,

                        layananItems: layananProv.items,
                        selectedLayananId: selectedLayananId,
                        onChangeLayanan: _onChangeLayanan,

                        tanggunganItems: tanggunganProv.items,
                        selectedTanggunganId: selectedTanggunganId,
                        onChangeTanggungan: _onChangeTanggungan,
                      ),
                      const SizedBox(height: 20),
                      ButtonNext(
                        label: bookProv.saving
                            ? "Mengirim..."
                            : (currentStep == 2 ? "Konfirmasi" : "Lanjutkan"),
                        onTap: () async {
                          if (bookProv.saving) return; // cegah double tap

                          if (currentStep == 0 || currentStep == 1) {
                            if (formKey.currentState?.validate() != true) {
                              return;
                            }
                          }

                          if (currentStep == 2) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                icon: const Icon(
                                  Icons.info_outline_rounded,
                                  size: 70,
                                  color: Colors.amberAccent,
                                ),
                                content: const Text(
                                  "Apakah data diri anda sudah \nbenar?",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textDefaultColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                actions: [
                                  ButtonPopconfirm(
                                    onTapBatal: () => Navigator.pop(context),
                                    onTapKirim: () async {
                                      Navigator.pop(context);
                                      await _submitBooking(); // ⬅️ submit di sini
                                    },
                                  ),
                                ],
                              ),
                            );
                            return;
                          }

                          if (currentStep < 2) {
                            setState(() {
                              currentStep++;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      ButtonBack(
                        onTap: () {
                          if (currentStep > 0) {
                            setState(() {
                              currentStep--;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 70,
            left: 20,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

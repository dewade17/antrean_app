// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_steps/flutter_steps.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:antrean_app/constraints/colors.dart';

// widgets
import 'package:antrean_app/screens/user/menu_antrian/widget/calendar_antrian_field.dart';
import 'package:antrean_app/screens/user/menu_antrian/widget/form_confirm_antrian.dart';
import 'package:antrean_app/screens/user/menu_antrian/widget/form_widget_antrean.dart';

// models
import 'package:antrean_app/dto/dokter/dokter.dart';
import 'package:antrean_app/dto/layanan/layanan.dart';
import 'package:antrean_app/dto/tanggungan/tanggungan.dart';
import 'package:antrean_app/dto/dokter/detail_dokter.dart' show Jadwal;

class StepsWidget extends StatelessWidget {
  final int currentStep;

  // controllers lama
  final TextEditingController dateController;
  final TextEditingController namaPasienController;
  final TextEditingController jeniskelaminController;
  final TextEditingController noteleponController;
  final TextEditingController dokterController;
  final TextEditingController namatanggunganController;
  final TextEditingController alamatController;
  final TextEditingController layananController;
  final GlobalKey<FormState> formKey;

  // === data dropdown dinamis + state terpilih + callbacks ===
  final List<Dokter> dokterItems;
  final String? selectedDokterId;
  final ValueChanged<String?> onChangeDokter;

  final List<Jadwal> slotItems; // dari DetailDokterProvider
  final String? selectedSlotId;
  final ValueChanged<String?> onChangeSlot;

  final List<Layanan> layananItems;
  final String? selectedLayananId;
  final ValueChanged<String?> onChangeLayanan;

  final List<Tanggungan> tanggunganItems;
  final String? selectedTanggunganId;
  final ValueChanged<String?> onChangeTanggungan;

  const StepsWidget({
    super.key,
    required this.currentStep,
    // controllers
    required this.dateController,
    required this.namaPasienController,
    required this.jeniskelaminController,
    required this.noteleponController,
    required this.dokterController,
    required this.namatanggunganController,
    required this.layananController,
    required this.alamatController,
    required this.formKey,
    // dropdown data & handlers
    required this.dokterItems,
    required this.selectedDokterId,
    required this.onChangeDokter,
    required this.slotItems,
    required this.selectedSlotId,
    required this.onChangeSlot,
    required this.layananItems,
    required this.selectedLayananId,
    required this.onChangeLayanan,
    required this.tanggunganItems,
    required this.selectedTanggunganId,
    required this.onChangeTanggungan,
  });

  @override
  Widget build(BuildContext context) {
    // Hitung teks jam pemeriksaan dari pilihan slot saat ini
    final String jamPemeriksaanText = (() {
      if (selectedSlotId == null || selectedSlotId!.isEmpty) return '';
      try {
        final j = slotItems.firstWhere((e) => e.slot.idSlot == selectedSlotId);
        return '${j.jamMulaiHhmm} - ${j.jamSelesaiHhmm}';
      } catch (_) {
        return '';
      }
    })();

    final List<String> titles = [
      "Konfirmasi \nTanggal",
      "Mengisi Data",
      "Konfirmasi \nData",
    ];

    final List<Widget> stepContents = [
      Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Masukkan tanggal lahir untuk melanjutkan pendaftaran",
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDefaultColor,
                ),
              ),
            ),
            CalendarAntrianField(dateController: dateController),
          ],
        ),
      ),
      // ====== STEP 2: Form isian + dropdown dinamis ======
      FormWidgetAntrian(
        formKey: formKey,
        // controllers
        namaPasienController: namaPasienController,
        jeniskelaminController: jeniskelaminController,
        alamatController: alamatController,
        noteleponController: noteleponController,
        dokterController: dokterController,
        namatanggunganController: namatanggunganController,
        layananController: layananController,
        // data dropdown
        dokterItems: dokterItems,
        selectedDokterId: selectedDokterId,
        onChangeDokter: onChangeDokter,
        slotItems: slotItems,
        selectedSlotId: selectedSlotId,
        onChangeSlot: onChangeSlot,
        layananItems: layananItems,
        selectedLayananId: selectedLayananId,
        onChangeLayanan: onChangeLayanan,
        tanggunganItems: tanggunganItems,
        selectedTanggunganId: selectedTanggunganId,
        onChangeTanggungan: onChangeTanggungan,
      ),
      // ====== STEP 3: Konfirmasi ======
      FormConfirmAntrian(
        namaPasienController: namaPasienController,
        alamatController: alamatController,
        jeniskelaminController: jeniskelaminController,
        noteleponController: noteleponController,
        dokterController: dokterController,
        jamPemeriksaanText: jamPemeriksaanText, // <-- ditambahkan
        namatanggunganController: namatanggunganController,
        layananController: layananController,
        dateController: dateController,
      ),
    ];

    final steps = List<Steps>.generate(3, (index) {
      final isDone = index < currentStep;
      final isActive = index == currentStep;

      Color borderColor;
      Color fillColor;
      Widget child;

      if (isDone) {
        borderColor = AppColors.primaryColor;
        fillColor = AppColors.primaryColor;
        child = const Icon(Icons.check, size: 20, color: Colors.white);
      } else if (isActive) {
        borderColor = AppColors.primaryColor;
        fillColor = Colors.white;
        child = Text(
          "${index + 1}",
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        );
      } else {
        borderColor = AppColors.primaryColor.withOpacity(0.3);
        fillColor = Colors.white;
        child = Text(
          "${index + 1}",
          style: TextStyle(
            color: AppColors.primaryColor.withOpacity(0.3),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        );
      }

      return Steps(
        title: titles[index],
        isActive: isActive || isDone,
        leading: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: fillColor,
            border: Border.all(color: borderColor, width: 3),
          ),
          child: child,
        ),
      );
    });

    return Column(
      children: [
        FlutterSteps(
          steps: steps,
          direction: Axis.horizontal,
          showSubtitle: false,
          titleFontSize: 12,
          activeStepLineColor: AppColors.primaryColor,
          titleActiveColor: AppColors.primaryColor,
          activeColor: AppColors.primaryColor,
          inactiveColor: AppColors.backgroundColor,
          leadingSize: 56,
        ),
        const SizedBox(height: 20),
        stepContents[currentStep],
      ],
    );
  }
}

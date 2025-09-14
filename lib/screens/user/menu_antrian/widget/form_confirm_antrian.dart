import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormConfirmAntrian extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController namaPasienController;
  final TextEditingController jeniskelaminController;
  final TextEditingController noteleponController;
  final TextEditingController dokterController;
  final TextEditingController alamatController;
  final TextEditingController namatanggunganController;
  final TextEditingController layananController;

  // Tambahan: tampilkan jam pemeriksaan (teks), id_slot tetap dipakai di parent saat submit
  final String jamPemeriksaanText;

  final void Function()? onEdit;

  const FormConfirmAntrian({
    super.key,
    required this.dateController,
    required this.namaPasienController,
    required this.jeniskelaminController,
    required this.alamatController,
    required this.noteleponController,
    required this.dokterController,
    required this.namatanggunganController,
    required this.layananController,
    required this.jamPemeriksaanText,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _readonlyField(
            ' Tanggal Lahir', dateController.text, Icons.person_outline),
        const SizedBox(height: 20),
        _readonlyField(
            ' Nama Pasien', namaPasienController.text, Icons.person_outline),
        const SizedBox(height: 20),
        _readonlyField(' Jenis Kelamin', jeniskelaminController.text,
            Icons.person_outline),
        const SizedBox(height: 20),
        _readonlyField(' Alamat', alamatController.text, Icons.person_outline),
        const SizedBox(height: 20),
        _readonlyField(
            ' No. Telepon', noteleponController.text, Icons.person_outline),
        const SizedBox(height: 20),
        _readonlyField(' Dokter', dokterController.text, Icons.person_outline),
        const SizedBox(height: 20),
        _readonlyField(
            ' Jam Pemeriksaan', jamPemeriksaanText, Icons.schedule), // ⬅️ BARU
        const SizedBox(height: 20),
        _readonlyField(' Nama Tanggungan', namatanggunganController.text,
            Icons.person_outline),
        const SizedBox(height: 20),
        _readonlyField(
            ' Nama Layanan', layananController.text, Icons.person_outline),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _readonlyField(String label, String value, IconData icon) {
    return SizedBox(
      width: 380,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDefaultColor,
                ),
              )),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextFormField(
                controller: TextEditingController(text: value),
                readOnly: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  prefixIcon: Container(
                    padding: const EdgeInsets.only(right: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          width: 1,
                          height: 24,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:antrean_app/constraints/colors.dart';

// ====== Model yg dipakai di dropdown ======
import 'package:antrean_app/dto/dokter/dokter.dart';
import 'package:antrean_app/dto/layanan/layanan.dart';
import 'package:antrean_app/dto/tanggungan/tanggungan.dart';
import 'package:antrean_app/dto/dokter/detail_dokter.dart' show Jadwal;

class FormWidgetAntrian extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  // Controllers yg sudah ada
  final TextEditingController namaPasienController;
  final TextEditingController jeniskelaminController;
  final TextEditingController noteleponController;
  final TextEditingController alamatController;

  // Controllers display (untuk konfirmasi)
  final TextEditingController dokterController;
  final TextEditingController namatanggunganController;
  final TextEditingController layananController;

  // ====== Data & state untuk dropdown dinamis ======
  // Dokter
  final List<Dokter> dokterItems;
  final String? selectedDokterId;
  final ValueChanged<String?> onChangeDokter;

  // Slot (jam pemeriksaan) — tampil hanya slot yg sisa>0 & aktif;
  // value yg dikirim tetap id_slot
  final List<Jadwal> slotItems; // kirim list mentah dari provider
  final String? selectedSlotId;
  final ValueChanged<String?> onChangeSlot;

  // Layanan
  final List<Layanan> layananItems;
  final String? selectedLayananId;
  final ValueChanged<String?> onChangeLayanan;

  // Tanggungan
  final List<Tanggungan> tanggunganItems;
  final String? selectedTanggunganId;
  final ValueChanged<String?> onChangeTanggungan;

  const FormWidgetAntrian({
    super.key,
    required this.formKey,
    // controllers
    required this.namaPasienController,
    required this.jeniskelaminController,
    required this.noteleponController,
    required this.alamatController,
    required this.dokterController,
    required this.namatanggunganController,
    required this.layananController,
    // data dropdown
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

  bool _isSameDayLocal(DateTime a, DateTime b) {
    final al = a.toLocal();
    final bl = b.toLocal();
    return al.year == bl.year && al.month == bl.month && al.day == bl.day;
  }

  @override
  Widget build(BuildContext context) {
    // --- Hanya slot untuk HARI INI ---
    final now = DateTime.now();
    final todaySlots =
        slotItems.where((j) => _isSameDayLocal(j.tanggal, now)).toList();

    // filter slot yang masih tersedia dan aktif
    final availableSlots = todaySlots.where((j) {
      try {
        return (j.slot.isActive == true) && (j.sisa > 0);
      } catch (_) {
        return false;
      }
    }).toList();

    return Form(
      key: formKey,
      child: Column(
        children: [
          // ===== Nama Pasien =====
          _LabeledCardTextField(
            label: ' Nama Pasien',
            controller: namaPasienController,
            hint: 'Masukkan Nama Lengkap Anda',
            icon: Icons.person_outline,
            validator: (v) => (v == null || v.isEmpty)
                ? 'Nama lengkap tidak boleh kosong'
                : null,
          ),
          const SizedBox(height: 20),

          // ===== Jenis Kelamin =====
          _LabeledCardDropdown(
            label: ' Jenis Kelamin',
            hint: 'Jenis Kelamin',
            value: jeniskelaminController.text.isNotEmpty
                ? jeniskelaminController.text
                : null,
            items: const [
              DropdownMenuItem(value: 'Pria', child: Text('Pria')),
              DropdownMenuItem(value: 'Wanita', child: Text('Wanita')),
            ],
            onChanged: (v) {
              if (v != null) jeniskelaminController.text = v;
            },
            validator: (v) => (v == null || v.isEmpty)
                ? 'Jenis Kelamin tidak boleh kosong'
                : null,
          ),
          const SizedBox(height: 20),

          // ===== Alamat =====
          _LabeledCardTextField(
            label: ' Alamat',
            controller: alamatController,
            hint: 'Masukkan Alamat Anda',
            icon: Icons.location_on_outlined,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Alamat tidak boleh kosong' : null,
          ),
          const SizedBox(height: 20),

          // ===== No. Telepon =====
          _LabeledCardTextField(
            label: ' No. Telepon',
            controller: noteleponController,
            hint: 'Masukkan No Telepon Anda',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.number,
            validator: (v) => (v == null || v.isEmpty)
                ? 'No telepon tidak boleh kosong'
                : null,
          ),
          const SizedBox(height: 20),

          // ===== Dokter (dynamic) =====
          _LabeledCardDropdown(
            label: ' Dokter',
            hint: 'Pilih Dokter',
            value: selectedDokterId,
            items: dokterItems
                .map((d) => DropdownMenuItem<String>(
                    value: d.idDokter, child: Text(d.namaDokter)))
                .toList(),
            onChanged: (v) {
              final nama = dokterItems
                  .firstWhere(
                    (d) => d.idDokter == v,
                    orElse: () => Dokter(
                      idDokter: '',
                      namaDokter: '',
                      spesialisasi: '',
                      fotoProfilDokter: '',
                      isActive: true,
                      totalSlot: 0,
                      totalKapasitas: 0,
                      totalTerisi: 0,
                      totalSisa: 0,
                    ),
                  )
                  .namaDokter;
              dokterController.text = nama;
              onChangeDokter(v);
            },
            validator: (v) => (v == null || v.isEmpty)
                ? 'Pilihan dokter tidak boleh kosong'
                : null,
          ),
          const SizedBox(height: 20),

          // ===== Jam Pemeriksaan (HANYA slot hari ini; kirim id_slot) =====
          _LabeledCardDropdown(
            label: ' Jam Pemeriksaan',
            hint: 'Pilih Jam Pemeriksaan',
            value: selectedSlotId,
            items: availableSlots
                .map((j) => DropdownMenuItem<String>(
                      value: j.slot.idSlot,
                      child: Text(
                        '${j.jamMulaiHhmm} - ${j.jamSelesaiHhmm} (sisa ${j.sisa})',
                      ),
                    ))
                .toList(),
            onChanged: availableSlots.isEmpty ? null : onChangeSlot,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Pilih jam pemeriksaan' : null,
          ),
          const SizedBox(height: 20),

          // ===== Jenis Layanan (dynamic) =====
          _LabeledCardDropdown(
            label: ' Jenis Layanan',
            hint: 'Pilih Layanan',
            value: selectedLayananId,
            items: layananItems
                .map((l) => DropdownMenuItem<String>(
                      value: l.idLayanan,
                      child: Text(l.namaLayanan),
                    ))
                .toList(),
            onChanged: (v) {
              final nama = layananItems
                  .firstWhere(
                    (e) => e.idLayanan == v,
                    orElse: () =>
                        Layanan(idLayanan: '', namaLayanan: '', isActive: true),
                  )
                  .namaLayanan;
              layananController.text = nama; // supaya tampil di confirm
              onChangeLayanan(v);
            },
            validator: (v) => (v == null || v.isEmpty) ? 'Pilih layanan' : null,
          ),
          const SizedBox(height: 20),

          // ===== Jenis Tanggungan (dynamic) =====
          _LabeledCardDropdown(
            label: ' Jenis Tanggungan',
            hint: 'Pilih Tanggungan',
            value: selectedTanggunganId,
            items: tanggunganItems
                .map((t) => DropdownMenuItem<String>(
                      value: t.idTanggungan,
                      child: Text(t.namaTanggungan),
                    ))
                .toList(),
            onChanged: (v) {
              final nama = tanggunganItems
                  .firstWhere(
                    (e) => e.idTanggungan == v,
                    orElse: () => Tanggungan(
                      idTanggungan: '',
                      namaTanggungan: '',
                      isActive: true,
                    ),
                  )
                  .namaTanggungan;
              namatanggunganController.text = nama; // untuk confirm
              onChangeTanggungan(v);
            },
            // validator opsional (boleh kosong)
          ),
        ],
      ),
    );
  }
}

/// ---------- Widgets helper dengan pola referensi ----------

class _LabeledCardTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const _LabeledCardTextField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 8),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic),
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
                validator: validator,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledCardDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  const _LabeledCardDropdown({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
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
          const SizedBox(height: 8),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: value,
                items: items,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: const TextStyle(
                      color: Colors.grey, fontStyle: FontStyle.italic),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                validator: validator,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

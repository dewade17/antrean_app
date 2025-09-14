import 'package:antrean_app/dto/layanan/layanan.dart';
import 'package:antrean_app/dto/tanggungan/tanggungan.dart';
import 'package:antrean_app/screens/user/menu_profile/widget/calendar_field_profile.dart';
import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormSettingProfile extends StatelessWidget {
  final TextEditingController emailprofileController;
  final TextEditingController nameprofileController;
  final TextEditingController dateprofileController;
  final TextEditingController jeniskelaminprofileController;
  final TextEditingController noteleponeprofileController;
  final TextEditingController alamatprofileController;
  final List<Layanan> layananItems;
  final String? selectedLayananId;
  final ValueChanged<String?> onChangeLayanan;

  final List<Tanggungan> tanggunganItems;
  final String? selectedTanggunganId;
  final ValueChanged<String?> onChangeTanggungan;

  const FormSettingProfile({
    super.key,
    required this.emailprofileController,
    required this.nameprofileController,
    required this.dateprofileController,
    required this.jeniskelaminprofileController,
    required this.noteleponeprofileController,
    required this.alamatprofileController,
    required this.layananItems,
    required this.selectedLayananId,
    required this.onChangeLayanan,
    required this.tanggunganItems,
    required this.selectedTanggunganId,
    required this.onChangeTanggungan,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      children: [
        SizedBox(
          width: 380,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' Email',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDefaultColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    controller: emailprofileController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 380,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' Nama Lengkap Pengguna',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDefaultColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    controller: nameprofileController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CalendarFieldProfile(dateProfileController: dateprofileController),
            SizedBox(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ' Jenis Kelamin',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textDefaultColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonFormField<String>(
                          value: jeniskelaminprofileController.text.isNotEmpty
                              ? jeniskelaminprofileController.text
                              : null,
                          items: const [
                            DropdownMenuItem(
                              value: 'Pria',
                              child: Text('Pria'),
                            ),
                            DropdownMenuItem(
                              value: 'Wanita',
                              child: Text('Wanita'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              jeniskelaminprofileController.text = value;
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Jenis Kelamin",
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 380,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' No. Telepon',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDefaultColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    controller: noteleponeprofileController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 380,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' Alamat',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDefaultColor,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: TextFormField(
                    controller: alamatprofileController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 380,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(' Jenis Tanggungan',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDefaultColor,
                    ),
                  )),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonFormField<String>(
                    value: selectedTanggunganId,
                    items: tanggunganItems
                        .map((t) => DropdownMenuItem<String>(
                              value: t.idTanggungan,
                              child: Text(t.namaTanggungan),
                            ))
                        .toList(),
                    onChanged: onChangeTanggungan,
                    decoration: const InputDecoration(
                      hintText: "Pilih Tanggungan",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 380,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(' Jenis Layanan',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDefaultColor,
                    ),
                  )),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: DropdownButtonFormField<String>(
                    value: selectedLayananId,
                    items: layananItems
                        .map((l) => DropdownMenuItem<String>(
                              value: l.idLayanan,
                              child: Text(l.namaLayanan),
                            ))
                        .toList(),
                    onChanged: onChangeLayanan,
                    decoration: const InputDecoration(
                      hintText: "Pilih Layanan",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

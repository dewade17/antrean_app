import 'package:antrean_app/screens/user/menu_profile/widget/button_konfirmasi.dart';
import 'package:antrean_app/screens/user/menu_profile/widget/button_pop__profile_konfirm.dart';
import 'package:antrean_app/screens/user/menu_profile/widget/form_setting_profile.dart';
import 'package:antrean_app/utils/colors.dart';
import 'package:flutter/material.dart';

class ProfileUserScreen extends StatefulWidget {
  const ProfileUserScreen({super.key});

  @override
  State<ProfileUserScreen> createState() => _ProfileUserScreenState();
}

class _ProfileUserScreenState extends State<ProfileUserScreen> {
  final emailprofileController = TextEditingController();
  final nameprofileController = TextEditingController();
  final dateprofileController = TextEditingController();
  final jeniskelaminprofileController = TextEditingController();
  final noteleponeprofileController = TextEditingController();
  final namatanggunganprofileController = TextEditingController();
  final namalayananprofileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Pengaturan Pengguna"),
      ),
      body: Container(
        decoration: BoxDecoration(
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
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    FormSettingProfile(
                      emailprofileController: emailprofileController,
                      nameprofileController: nameprofileController,
                      dateprofileController: dateprofileController,
                      jeniskelaminprofileController:
                          jeniskelaminprofileController,
                      noteleponeprofileController: noteleponeprofileController,
                      namatanggunganprofileController:
                          namatanggunganprofileController,
                      namalayananprofileController:
                          namalayananprofileController,
                    ),
                    const SizedBox(height: 20),
                    ButtonKonfirmasi(onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          icon: const Icon(
                            Icons.info_outline_rounded,
                            size: 70,
                            color: Colors.amberAccent,
                          ),
                          content: const Text(
                            "Apakah yakin ingin memperbarui \ndata anda?",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textDefaultColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            ButtonPopProfileKonfirm(
                              onTapBatal: () => Navigator.pop(context),
                              onTapKirim: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text("Data berhasil dikirim"),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 30), // Tambahan agar tidak mentok
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

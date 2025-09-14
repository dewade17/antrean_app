import 'package:antrean_app/provider/layanan/layanan_provider.dart';
import 'package:antrean_app/provider/tanggungan/tanggungan_provider.dart';
import 'package:antrean_app/screens/user/menu_profile/widget/button_konfirmasi.dart';
import 'package:antrean_app/screens/user/menu_profile/widget/button_pop__profile_konfirm.dart';
import 'package:antrean_app/screens/user/menu_profile/widget/form_setting_profile.dart';
import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:antrean_app/provider/users/user_provider.dart';

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
  final alamatprofileController = TextEditingController();

  // Selected IDs untuk dropdown
  String? _selectedLayananId;
  String? _selectedTanggunganId;

  @override
  void initState() {
    super.initState();
    // Load profil & master data saat halaman muncul
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final users = context.read<UsersProvider>();
      final layananProv = context.read<LayananProvider>();
      final tanggProv = context.read<TanggunganProvider>();
      debugPrint('=== DEBUG ===');
      debugPrint('Layanan items: ${layananProv.items.length}');
      debugPrint('Tanggungan items: ${tanggProv.items.length}');
      debugPrint('Selected layanan: $_selectedLayananId');
      debugPrint('Selected tanggungan: $_selectedTanggunganId');
      if (layananProv.items.isNotEmpty) {
        debugPrint('Sample layanan ID: ${layananProv.items.first.idLayanan}');
      }
      if (tanggProv.items.isNotEmpty) {
        debugPrint(
            'Sample tanggungan ID: ${tanggProv.items.first.idTanggungan}');
      }
      
      await users.loadCurrentIntoControllers(
        emailController: emailprofileController,
        nameController: nameprofileController,
        dateController: dateprofileController,
        jenisKelaminController: jeniskelaminprofileController,
        noTeleponController: noteleponeprofileController,
        namaTanggunganController: TextEditingController(),
        namaLayananController: TextEditingController(),
        alamatController: alamatprofileController,
      );

      // fetch master data
      await Future.wait([
        layananProv.fetch(status: 'active'),
        tanggProv.fetch(status: 'active'),
      ]);

      // preselect dari profil user sekarang (kalau tersedia)
      final u = users.user;
      setState(() {
        _selectedLayananId = (u?.idLayanan)?.toString();
        _selectedTanggunganId = (u?.idTanggungan)?.toString();
      });
    });
  }

  @override
  void dispose() {
    emailprofileController.dispose();
    nameprofileController.dispose();
    dateprofileController.dispose();
    jeniskelaminprofileController.dispose();
    noteleponeprofileController.dispose();
    alamatprofileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final users = context.watch<UsersProvider>();
    final layananProv = context.watch<LayananProvider>();
    final tanggProv = context.watch<TanggunganProvider>();

    final isLoading = users.loading || layananProv.loading || tanggProv.loading;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Pengaturan Pengguna"),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.accentColor, AppColors.backgroundColor],
          ),
        ),
        child: SafeArea(
          child: users.loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          if (users.errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                users.errorMessage!,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          FormSettingProfile(
                            emailprofileController: emailprofileController,
                            nameprofileController: nameprofileController,
                            dateprofileController: dateprofileController,
                            jeniskelaminprofileController:
                                jeniskelaminprofileController,
                            noteleponeprofileController:
                                noteleponeprofileController,
                            alamatprofileController: alamatprofileController,

                            // Integrasi dropdown layanan
                            layananItems: layananProv.items,
                            selectedLayananId: _selectedLayananId,
                            onChangeLayanan: (val) {
                              setState(() => _selectedLayananId = val);
                            },

                            // Integrasi dropdown tanggungan
                            tanggunganItems: tanggProv.items,
                            selectedTanggunganId: _selectedTanggunganId,
                            onChangeTanggungan: (val) {
                              setState(() => _selectedTanggunganId = val);
                            },
                          ),
                          const SizedBox(height: 20),
                          ButtonKonfirmasi(
                            onTap: () {
                              // simpan context layar (bukan context milik dialog)
                              final pageCtx = context;

                              showDialog(
                                context: pageCtx,
                                builder: (dialogCtx) => AlertDialog(
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
                                      onTapBatal: () => Navigator.pop(
                                          dialogCtx), // <- pakai dialogCtx
                                      onTapKirim: () async {
                                        // tutup dialog dulu dengan dialogCtx
                                        Navigator.pop(dialogCtx);

                                        // lalu panggil provider pakai pageCtx (konteks layar yg masih aktif)
                                        final ok = await pageCtx
                                            .read<UsersProvider>()
                                            .updateCurrentFromControllers(
                                              emailController:
                                                  emailprofileController,
                                              nameController:
                                                  nameprofileController,
                                              dateController:
                                                  dateprofileController,
                                              jenisKelaminController:
                                                  jeniskelaminprofileController,
                                              noTeleponController:
                                                  noteleponeprofileController,
                                              alamat:
                                                  alamatprofileController.text,
                                              idLayanan: _selectedLayananId,
                                              idTanggungan:
                                                  _selectedTanggunganId,
                                              // controller nama layanan/tanggungan sudah tidak dipakai
                                              namaTanggunganController:
                                                  TextEditingController(),
                                              namaLayananController:
                                                  TextEditingController(),
                                              alamatController:
                                                  alamatprofileController,
                                            );

                                        if (!mounted) return;
                                        ScaffoldMessenger.of(pageCtx)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor:
                                                ok ? Colors.green : Colors.red,
                                            content: Text(
                                              ok
                                                  ? "Profil berhasil diperbarui"
                                                  : (pageCtx
                                                          .read<UsersProvider>()
                                                          .errorMessage ??
                                                      "Gagal memperbarui profil"),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 30),
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

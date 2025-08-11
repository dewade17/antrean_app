import 'package:antrean_app/screens/user/menu_antrian/widget/button_back.dart';
import 'package:antrean_app/screens/user/menu_antrian/widget/button_next.dart';
import 'package:antrean_app/screens/user/menu_antrian/widget/button_popconfirm.dart';
import 'package:antrean_app/screens/user/menu_antrian/widget/steps_widget.dart';
import 'package:antrean_app/utils/colors.dart';
import 'package:flutter/material.dart';

class AntrianScreen extends StatefulWidget {
  const AntrianScreen({super.key});

  @override
  State<AntrianScreen> createState() => _AntrianScreenState();
}

class _AntrianScreenState extends State<AntrianScreen> {
  final dateController = TextEditingController();
  final namaPasienController = TextEditingController();
  final jeniskelaminController = TextEditingController();
  final noteleponController = TextEditingController();
  final dokterController = TextEditingController();
  final namatanggunganController = TextEditingController();
  final layananController = TextEditingController();
  final alamatController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  int currentStep = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          // Layer background gambar atas
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

          // Layer form di bawah gambar
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
                      ),
                      const SizedBox(height: 20),
                      ButtonNext(
                        label: currentStep == 2 ? "Konfirmasi" : "Lanjutkan",
                        onTap: () {
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
                                    onTapKirim: () {
                                      Navigator.pop(context);
                                      // TODO: Submit logic
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            backgroundColor: Colors.green,
                                            content:
                                                Text("Data berhasil dikirim")),
                                      );
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
                Navigator.pop(
                    context); // Atau arahkan ke halaman spesifik dengan Navigator.pushReplacement
              },
            ),
          ),
        ],
      ),
    );
  }
}

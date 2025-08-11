import 'package:antrean_app/screens/auth_screen/register/widget/form_header.dart';
import 'package:antrean_app/screens/auth_screen/register/widget/form_register.dart';
import 'package:antrean_app/screens/auth_screen/register/widget/login_text.dart';
import 'package:antrean_app/screens/auth_screen/register/widget/register_button.dart';
import 'package:antrean_app/utils/colors.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final jeniskelaminController = TextEditingController();
  final noteleponeController = TextEditingController();
  final passwordController = TextEditingController();
  final konfirmasiPasswordController = TextEditingController();

  bool _obscureText = true;
  bool _obscureTextConfirm = true;

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
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
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
                  "assets/images/Register_Screen.png",
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
                      const FormHeader(),
                      FormRegister(
                        emailController: emailController,
                        nameController: nameController,
                        dateController: dateController,
                        jeniskelaminController: jeniskelaminController,
                        noteleponeController: noteleponeController,
                        passwordController: passwordController,
                        obscureText: _obscureText,
                        onToggle: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        konfirmasiPasswordController:
                            konfirmasiPasswordController,
                        obscureTextConfirm: _obscureTextConfirm,
                        onToggleConfirm: () {
                          setState(() {
                            _obscureTextConfirm = !_obscureTextConfirm;
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      const RegisterButton(),
                      const SizedBox(height: 20),
                      const Center(child: LoginText()),
                    ],
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

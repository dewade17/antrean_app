import 'package:antrean_app/provider/Auth/register_provider.dart';
import 'package:antrean_app/screens/auth_screen/register/widget/form_header.dart';
import 'package:antrean_app/screens/auth_screen/register/widget/form_register.dart';
import 'package:antrean_app/screens/auth_screen/register/widget/login_text.dart';
import 'package:antrean_app/screens/auth_screen/register/widget/register_button.dart';
import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterProvider(),
      child: Builder(
        builder: (context) {
          final p = context.watch<RegisterProvider>();

          return Scaffold(
            backgroundColor: AppColors.primaryColor,
            body: Stack(
              children: [
                // Background
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

                // Form
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 24),
                        child: Column(
                          children: [
                            const FormHeader(),
                            FormRegister(
                              formKey: p.formKey, // <-- pakai formKey provider
                              emailController: p.emailController,
                              nameController: p.nameController,
                              dateController: p.dateController,
                              jeniskelaminController: p.jeniskelaminController,
                              noteleponeController: p.noteleponeController,
                              passwordController: p.passwordController,
                              obscureText:
                                  true, // visibilitas diatur lokal screen
                              onToggle:
                                  () {}, // (opsional) kamu bisa ikuti pola awalmu
                              konfirmasiPasswordController:
                                  p.konfirmasiPasswordController,
                              obscureTextConfirm: true,
                              onToggleConfirm: () {},
                            ),
                            const SizedBox(height: 30),
                            RegisterButton(
                              onTap: () => p.submit(context),
                              loading: p.loading,
                            ),
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
        },
      ),
    );
  }
}

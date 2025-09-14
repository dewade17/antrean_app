import 'package:antrean_app/dto/auth/login.dart';
import 'package:antrean_app/provider/Auth/auth_provider.dart';

import 'package:antrean_app/screens/auth_screen/login/widget/form_login.dart';
import 'package:antrean_app/screens/auth_screen/login/widget/login_button.dart';
import 'package:antrean_app/screens/auth_screen/login/widget/login_header.dart';
import 'package:antrean_app/screens/auth_screen/login/widget/register_text.dart';
import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;

  void _toggle() => setState(() => _obscureText = !_obscureText);

  Future<void> _onSubmit() async {
    final auth = context.read<AuthProvider>();
    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) return;

    FocusScope.of(context).unfocus();
    await auth.login(
      context,
      Login(
        email: emailController.text.trim(),
        password: passwordController.text,
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 60),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.primaryColor, AppColors.secondaryColor],
                  ),
                ),
                child: Column(
                  children: [
                    Image.asset("assets/images/Login_Screen.png"),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
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
                  colors: [AppColors.accentColor, AppColors.backgroundColor],
                ),
              ),
              child: SafeArea(
                top: false,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      const LoginHeader(),
                      const SizedBox(height: 40),
                      FormLogin(
                        formKey: formKey,
                        emailcontroller: emailController,
                        passwordcontroller: passwordController,
                        obscureText: _obscureText,
                        onToggle: _toggle,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 200),
                        child: GestureDetector(
                          child: Text(
                            "Lupa Password ?",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textDefaultColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      LoginButton(
                        onTap: _onSubmit,
                        loading: auth.loading, // <- disable saat proses
                      ),
                      const SizedBox(height: 20),
                      const Center(child: RegisterText()),
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

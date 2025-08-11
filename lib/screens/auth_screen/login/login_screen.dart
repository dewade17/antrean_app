import 'package:antrean_app/screens/auth_screen/login/widget/email_field.dart';
import 'package:antrean_app/screens/auth_screen/login/widget/login_button.dart';
import 'package:antrean_app/screens/auth_screen/login/widget/login_header.dart';
import 'package:antrean_app/screens/auth_screen/login/widget/password_field.dart';
import 'package:antrean_app/screens/auth_screen/login/widget/register_text.dart';
import 'package:antrean_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                Container(
                  //containerimage
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryColor, //warna atas (putih)
                        AppColors.secondaryColor // Warna bawah (biru muda)
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Image.asset("assets/images/Login_Screen.png"),
                      SizedBox(
                        height: 100,
                      ),
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
                  //containerform
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35))),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.accentColor, // Warna atas (putih)
                        AppColors.backgroundColor, // Warna bawah (biru muda)
                      ],
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 50,
                          ),
                          LoginHeader(),
                          SizedBox(height: 40),
                          Form(
                            child: Column(
                              children: [
                                Center(
                                    child: EmailField(
                                        controller: emailController)),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                    child: PasswordField(
                                  controller: passwordController,
                                  obscureText: _obscureText,
                                  onToggle: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 200),
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
                          SizedBox(height: 30),
                          LoginButton(),
                          SizedBox(
                            height: 20,
                          ),
                          Center(child: RegisterText()),
                        ],
                      ),
                    ),
                  )),
            )
          ],
        ));
  }
}

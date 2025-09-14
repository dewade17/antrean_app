import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormLogin extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailcontroller;
  final TextEditingController passwordcontroller;
  final bool obscureText;
  final VoidCallback onToggle;

  const FormLogin({
    super.key,
    required this.formKey,
    required this.emailcontroller,
    required this.passwordcontroller,
    required this.obscureText,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey, // <- perbaikan
      child: Column(
        children: [
          SizedBox(
            width: 350,
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
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextFormField(
                      controller: emailcontroller,
                      keyboardType: TextInputType.emailAddress, // <- perbaikan
                      decoration: InputDecoration(
                        hintText: "Masukkan email",
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        prefixIcon: Container(
                          padding: const EdgeInsets.only(right: 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.alternate_email_rounded),
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                width: 1,
                                height: 24,
                                color: Colors.grey.shade300,
                              ),
                            ],
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        const emailPattern =
                            r'^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$';
                        if (!RegExp(emailPattern).hasMatch(value)) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 350,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ' Password',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDefaultColor,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextFormField(
                      controller: passwordcontroller,
                      obscureText: obscureText,
                      decoration: InputDecoration(
                        hintText: "Masukkan password",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 16),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: onToggle,
                        ),
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.lock_outline_rounded),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: 1,
                              height: 24,
                              color: Colors.grey.shade300,
                            ),
                          ],
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

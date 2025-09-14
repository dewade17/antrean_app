import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool loading;

  const LoginButton({
    super.key,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Opacity(
        opacity: loading ? 0.7 : 1,
        child: Card(
          color: AppColors.primaryColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 15),
            child: Text(
              loading ? "Memproses..." : "Masuk",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.accentColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

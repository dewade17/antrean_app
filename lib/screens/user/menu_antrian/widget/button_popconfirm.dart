// ignore_for_file: deprecated_member_use

import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';

class ButtonPopconfirm extends StatelessWidget {
  final VoidCallback onTapBatal;
  final VoidCallback onTapKirim;
  const ButtonPopconfirm({
    super.key,
    required this.onTapBatal,
    required this.onTapKirim,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTapBatal,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.errorColor
                  .withOpacity(0.1), // background merah muda
              border: Border.all(
                  color: AppColors.errorColor, width: 2), // border merah
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            child: Text(
              "Batal",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.errorColor, // teks merah
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: onTapKirim,
          child: Card(
              elevation: 2,
              color: AppColors.primaryColor,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                child: Text(
                  "Ya",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: AppColors.accentColor),
                ),
              )),
        ),
      ],
    );
  }
}

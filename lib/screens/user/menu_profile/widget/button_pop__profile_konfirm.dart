import 'package:antrean_app/utils/colors.dart';
import 'package:flutter/material.dart';

class ButtonPopProfileKonfirm extends StatelessWidget {
  final VoidCallback onTapBatal;
  final VoidCallback onTapKirim;
  const ButtonPopProfileKonfirm(
      {super.key, required this.onTapBatal, required this.onTapKirim});

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
                fontSize: 16,
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
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                child: Text(
                  "Perbarui",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.accentColor),
                ),
              )),
        ),
      ],
    );
  }
}

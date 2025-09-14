import 'package:antrean_app/constraints/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarFieldProfile extends StatefulWidget {
  final TextEditingController dateProfileController;

  const CalendarFieldProfile({super.key, required this.dateProfileController});

  @override
  State<CalendarFieldProfile> createState() => _CalendarFieldProfileState();
}

class _CalendarFieldProfileState extends State<CalendarFieldProfile> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ' Tanggal Lahir',
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
              child: GestureDetector(
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          textTheme: const TextTheme(
                            headlineLarge: TextStyle(fontSize: 20),
                            titleLarge: TextStyle(fontSize: 16),
                            bodyLarge: TextStyle(fontSize: 14),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null && picked != selectedDate) {
                    setState(() {
                      selectedDate = picked;
                      widget.dateProfileController.text =
                          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: widget.dateProfileController,
                    decoration: InputDecoration(
                      hintText: 'dd/mm/yyyy',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tanggal belum dipilih';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

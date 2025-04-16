import 'package:crispychikis/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final ValueChanged<String>? onChanged;

  CustomTextField({
    required this.controller,
    required this.labelText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
            color: colorsPalete['white']
        )),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
              color: colorsPalete['pink'],
            borderRadius: BorderRadius.circular(12)
          ),
          child: TextField(
            controller: controller,
            style: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: colorsPalete['dark brown']
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14)
            ),
            onChanged: onChanged
          )
        )
      ]
    );
  }
}

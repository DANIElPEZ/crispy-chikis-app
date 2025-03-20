import 'package:chispy_chikis/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    required this.text,
    required this.onPressed
  });
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          backgroundColor: colorsPalete['dark brown']
        ),
        onPressed: onPressed,
        child: Text(text,
        style: GoogleFonts.nunito(
          color: colorsPalete['pink'],
          fontSize: 22,
          fontWeight: FontWeight.w700
        ),)
      ),
    );
  }
}
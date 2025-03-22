import 'package:flutter/material.dart';
import 'package:chispy_chikis/color/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterOption extends StatelessWidget {
  FilterOption(
      {required this.title, required this.onPressed, required this.isSelected});

  final String title;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          margin: EdgeInsets.only(right: 10),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1),
          decoration: BoxDecoration(
              color:
                  isSelected ? colorsPalete['dark brown'] : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  width: 2,
                  color: isSelected
                      ? colorsPalete['dark brown']!
                      : colorsPalete['orange']!)),
          child: Text(title,
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: colorsPalete['white']
          ))
        ));
  }
}

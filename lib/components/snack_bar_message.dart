import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crispychikis/theme/color/colors.dart';

void snackBarMessage(ScaffoldMessengerState messenger, String message){
  messenger.showSnackBar(SnackBar(
      content: Text(message,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: colorsPalete['white'])),
      backgroundColor: colorsPalete['light brown']));
}
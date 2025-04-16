import 'package:flutter/material.dart';
import 'package:crispychikis/color/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class Review extends StatelessWidget{
  Review({required this.name, required this.stars, required this.comment});
  String name, comment;
  double stars;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(name,
                style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w800,
                    fontSize: 21,
                    color: colorsPalete['white'])),
            SizedBox(width: 13),
            buildStars(stars)
          ]
        ),
        Text(comment,
            style: GoogleFonts.nunito(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: colorsPalete['white'])),
        Container(height: 2,
        color: colorsPalete['white']),
        SizedBox(height: 15)
      ],
    );
  }

  Widget buildStars(double stars){
    int fullStars = stars.floor();
    bool hasHalfStar = (stars - fullStars) >= 0.5;
    int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < fullStars; i++)
          Icon(Icons.star, color: Colors.yellow),

        if (hasHalfStar)
          Icon(Icons.star_half, color: Colors.yellow),

        for (int i = 0; i < emptyStars; i++)
          Icon(Icons.star_border, color: Colors.yellow),
      ],
    );
  }
}
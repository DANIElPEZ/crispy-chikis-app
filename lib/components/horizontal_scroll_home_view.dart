import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crispychikis/components/card_home_view.dart';
import 'package:crispychikis/color/colors.dart';

class HorizontalScrollHome extends StatelessWidget {
  HorizontalScrollHome({required this.title, required this.elements});

  final String title;
  final List elements;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Text(title,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: colorsPalete['white'])),
      ),
      SizedBox(
          height: 190,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: elements.length,
              itemBuilder: (context, index) {
                return CardHome(
                    id: elements[index][0],
                    title: elements[index][1],
                    description: elements[index][2],
                    price: elements[index][3],
                    image: elements[index][4]
                );
              }))
    ]);
  }
}

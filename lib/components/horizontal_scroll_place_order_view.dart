import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chispy_chikis/components/card_place_order_view.dart';
import 'package:chispy_chikis/color/colors.dart';

class HorizontalScrollPlaceOrder extends StatelessWidget {
  HorizontalScrollPlaceOrder({required this.title, required this.elements});

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
                return CardPlaceOrder(
                    image: elements[index][0],
                    title: elements[index][1],
                    price: elements[index][2]
                );
              }))
    ]);
  }
}

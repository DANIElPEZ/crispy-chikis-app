import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chispy_chikis/color/colors.dart';

class CardSeeOrder extends StatefulWidget {
  CardSeeOrder({required this.quantity, required this.product});

  int quantity;
  String product;

  @override
  State<StatefulWidget> createState() => CardSeeOrderState();
}

class CardSeeOrderState extends State<CardSeeOrder> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        margin: EdgeInsets.only(top: 20),
        color: colorsPalete['dark blue'],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 30),
          height: 70,
          child: Row(children: [
            Text(widget.quantity.toString(),
                style: GoogleFonts.nunito(
                    color: colorsPalete['white'],
                    fontSize: 22,
                    fontWeight: FontWeight.w700)),
            SizedBox(width: 60),
            Text(widget.product,
                style: GoogleFonts.nunito(
                    color: colorsPalete['white'],
                    fontSize: 22,
                    fontWeight: FontWeight.w600)),
            Expanded(child: Container()),
            IconButton(
                onPressed: () {},
                icon:
                    Icon(Icons.delete_forever_outlined, color: colorsPalete['white'], size: 30))
          ]),
        ));
  }
}

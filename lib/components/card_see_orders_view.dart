import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crispychikis/color/colors.dart';
import 'package:crispychikis/provider/provider.dart';
import 'package:provider/provider.dart';

class CardSeeOrder extends StatefulWidget {
  CardSeeOrder({required this.id, required this.product});

  int id;
  String product;

  @override
  State<StatefulWidget> createState() => CardSeeOrderState();
}

class CardSeeOrderState extends State<CardSeeOrder> {

  Future<void> deleteProduct(int id) async{
    final provider=Provider.of<crispyProvider>(context, listen: false);
    await provider.deleteProduct(id);
  }

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
            Text(widget.product,
                style: GoogleFonts.nunito(
                    color: colorsPalete['white'],
                    fontSize: 22,
                    fontWeight: FontWeight.w600)),
            Expanded(child: Container()),
            IconButton(
                onPressed: () {
                  deleteProduct(widget.id);
                },
                icon:
                    Icon(Icons.delete_forever_outlined, color: colorsPalete['white'], size: 30))
          ])
        ));
  }
}

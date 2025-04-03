import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chispy_chikis/color/colors.dart';

class CardOrder extends StatefulWidget {
  CardOrder({required this.date, required this.order, required this.cancel});

  String date;
  List order;
  int cancel;

  @override
  State<CardOrder> createState() => CardOrderState();
}

class CardOrderState extends State<CardOrder> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          lookDetailorder(context);
        },
        child: Card(
            elevation: 10,
            margin: EdgeInsets.only(bottom: 20),
            color: colorsPalete['orange'],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: MediaQuery.of(context).size.width,
              height: 83,
              child: Row(children: [
                SizedBox(width: 15),
                Icon(
                  widget.cancel == 1 ? Icons.check : Icons.schedule,
                  size: 50,
                  weight: 5,
                  color: widget.cancel == 1
                      ? colorsPalete['light green']
                      : colorsPalete['dark brown'],
                ),
                Expanded(child: Container()),
                Column(children: [
                  Text('Pedido el ${widget.date}',
                      softWrap: true,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          color: colorsPalete['white'],
                          fontSize: 18,
                          fontWeight: FontWeight.w900)),
                  Expanded(child: Container()),
                  Text('Toca para ver el detalle',
                      style: GoogleFonts.poppins(
                          color: colorsPalete['white'],
                          fontSize: 15,
                          fontWeight: FontWeight.w800))
                ]),
                Expanded(child: Container())
              ]),
            )));
  }

  Future<void> lookDetailorder(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
                title: Text('Detalle',
                    style: GoogleFonts.nunito(
                        color: colorsPalete['white'],
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                backgroundColor: colorsPalete['dark brown'],
                content: Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Cantidad',
                                style: GoogleFonts.nunito(
                                    color: colorsPalete['white'],
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                            Text('Producto',
                                style: GoogleFonts.nunito(
                                    color: colorsPalete['white'],
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600)),
                            Text('Precio',
                                style: GoogleFonts.nunito(
                                    color: colorsPalete['white'],
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600))
                          ]),
                      Container(height: 2, color: colorsPalete['white']),
                      Expanded(
                          child: ListView.builder(
                              itemCount: widget.order.length,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(width: 30),
                                        Text(widget.order[index][0].toString(),
                                            style: GoogleFonts.nunito(
                                                color: colorsPalete['white'],
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600)),
                                        SizedBox(width: 40),
                                        Container(
                                            constraints:
                                                BoxConstraints(maxWidth: 120),
                                            child: Text(widget.order[index][1],
                                                softWrap: true,
                                                maxLines: 3,
                                                style: GoogleFonts.nunito(
                                                    color: colorsPalete['white'],
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600))),
                                        Expanded(child: Container()),
                                        Text('\$ ${widget.order[index][2]}',
                                            style: GoogleFonts.nunito(
                                                color: colorsPalete['white'],
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600))
                                      ]),
                                );
                              }))
                    ])),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cerrar',
                          style: GoogleFonts.nunito(
                              color: colorsPalete['white'],
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: colorsPalete['dark blue']))
                ]));
  }
}

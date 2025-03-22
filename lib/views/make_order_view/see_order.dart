import 'package:flutter/material.dart';
import 'package:chispy_chikis/components/appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chispy_chikis/components/main_button.dart';
import 'package:chispy_chikis/color/colors.dart';
import 'package:chispy_chikis/components/card_see_orders_view.dart';
import 'package:chispy_chikis/views/make_order_view/confirm_order.dart';

class SeeOrder extends StatelessWidget {
  List productos = [
    [2, 'Presa de pollo'],
    [1, 'Cocacola'],
    [1, 'Jugo de mora']
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: CustomAppBar(
                bg_color: colorsPalete['orange']!,
                shape_color: colorsPalete['dark blue']!)),
        body: Stack(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: colorsPalete['orange'],
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Column(children: [
                  Row(children: [
                    Text('Cantidad',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            color: colorsPalete['white'])),
                    SizedBox(width: 40),
                    Text('Producto',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            color: colorsPalete['white']))
                  ]),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: colorsPalete['white'],
                    height: 2
                  ),
                  Expanded(child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: productos.length,
                      itemBuilder: (context, index) {
                        return CardSeeOrder(
                            quantity: productos[index][0],
                            product: productos[index][1]);
                      }))
                ])),
            Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: CustomButton(
                        text: 'CONFIRMAR PEDIDO',
                        onPressed: () {
                         Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => ConfirmOrder()));
                        })))
          ],
        ));
  }
}

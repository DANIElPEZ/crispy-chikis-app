import 'package:flutter/material.dart';
import 'package:crispychikis/components/appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crispychikis/components/main_button.dart';
import 'package:crispychikis/color/colors.dart';
import 'package:crispychikis/components/card_see_orders_view.dart';
import 'package:crispychikis/views/make_order_view/confirm_order.dart';
import 'package:provider/provider.dart';
import 'package:crispychikis/provider/provider.dart';

class SeeOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: CustomAppBar(
                bg_color: colorsPalete['orange']!,
                shape_color: colorsPalete['dark blue']!)),
        body: Stack(children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: colorsPalete['orange'],
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Column(children: [
                Row(children: [
                  SizedBox(width: 30),
                  Text('Productos en tu pedido',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: colorsPalete['white']))
                ]),
                Container(
                    width: MediaQuery.of(context).size.width,
                    color: colorsPalete['white'],
                    height: 2),
                Expanded(child: Consumer<crispyProvider>(
                    builder: (context, provider, child) {
                  if (provider.getConnection) {
                    final myProducts = provider.myProducts;
                    if (myProducts.isEmpty) {
                      return Stack(alignment: Alignment.center, children: [
                        Center(
                            child: Text('No tienes productos en tu pedido',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                    color: colorsPalete['white'])))
                      ]);
                    } else {
                      return Stack(children: [
                        ListView.builder(
                            padding: EdgeInsets.only(bottom: 150),
                            physics: BouncingScrollPhysics(),
                            itemCount: myProducts.length,
                            itemBuilder: (context, index) {
                              return CardSeeOrder(
                                  id: myProducts[index][0],
                                  product: myProducts[index][1]);
                            }),
                        Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: CustomButton(
                                text: 'CONFIRMAR PEDIDO',
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ConfirmOrder()));
                                })),
                        Positioned(
                            bottom: 85,
                            left: 0,
                            child: FloatingActionButton.extended(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                backgroundColor: colorsPalete['dark brown'],
                                icon: Icon(Icons.arrow_back, color: colorsPalete['pink']),
                                label: Text('Regresar',
                                    style: GoogleFonts.nunito(
                                        color: colorsPalete['pink'],
                                        fontSize: 22,
                                        fontWeight: FontWeight.w700))))
                      ]);
                    }
                  } else {
                    return Column(
                        children: [
                          Expanded(child: Container()),
                          Center(
                              child: Text('Revisa tu conexion a internet',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17,
                                      color: colorsPalete['white']))
                          ),
                          Expanded(child: Container()),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FloatingActionButton.extended(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        backgroundColor: colorsPalete['dark brown'],
                                        icon:
                                        Icon(Icons.arrow_back, color: colorsPalete['pink']),
                                        label: Text('Regresar',
                                            style: GoogleFonts.nunito(
                                                color: colorsPalete['pink'],
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700))),
                                    SizedBox(height: 12),
                                    CustomButton(
                                        text: 'Intertar conectarse',
                                        onPressed: () {
                                          provider.checkConnection();
                                        })
                                  ]
                              ))
                        ]
                    );
                  }
                }))
              ]))
        ]));
  }
}

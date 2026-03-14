import 'package:flutter/material.dart';
import 'package:crispychikis/components/appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crispychikis/components/main_button.dart';
import 'package:crispychikis/theme/color/colors.dart';
import 'package:crispychikis/components/card_see_orders_view.dart';
import 'package:crispychikis/views/make_order_view/confirm_order.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crispychikis/blocs/make_order/make_order_bloc.dart';
import 'package:crispychikis/blocs/make_order/make_order_state.dart';

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
                  SizedBox(width: 20),
                  Text('Cantidad',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: colorsPalete['white'])),
                  Expanded(child: Container()),
                  Text('Su pedido',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: colorsPalete['white'])),
                  Expanded(child: Container()),
                ]),
                Container(
                    width: MediaQuery.of(context).size.width,
                    color: colorsPalete['white'],
                    height: 2),
                Expanded(child: BlocBuilder<MakeOrderBloc, MakeOrderState>(
                    builder: (context, state) {
                  if (state.productsOrder.isNotEmpty) {
                    Map<int, List<dynamic>> groupedProducts = {};

                    for (var item in state.productsOrder) {
                      int id = item[0];
                      if (groupedProducts.containsKey(id)) {
                        groupedProducts[id]![3] = groupedProducts[id]![3] + 1;
                      } else {
                        groupedProducts[id] = [item[0], item[1], item[2], 1];
                      }
                    }
                    List productsToDisplay = groupedProducts.values.toList();

                    return Stack(children: [
                      ListView.builder(
                          padding: EdgeInsets.only(bottom: 150),
                          physics: BouncingScrollPhysics(),
                          itemCount: productsToDisplay.length,
                          itemBuilder: (context, index) {
                            final product = productsToDisplay[index];
                            return CardSeeOrder(
                                id: product[0],
                                quantity: product[3],
                                product: product[1]);
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
                              icon: Icon(Icons.arrow_back,
                                  color: colorsPalete['pink']),
                              label: Text('Regresar',
                                  style: GoogleFonts.nunito(
                                      color: colorsPalete['pink'],
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700))))
                    ]);
                  }

                  return Stack(alignment: Alignment.center, children: [
                    Center(
                        child: Text('No hay productos en su pedido',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                color: colorsPalete['white']))),
                    Positioned(
                        bottom: 20,
                        left: 0,
                        child: FloatingActionButton.extended(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            backgroundColor: colorsPalete['dark brown'],
                            icon: Icon(Icons.arrow_back,
                                color: colorsPalete['pink']),
                            label: Text('Regresar',
                                style: GoogleFonts.nunito(
                                    color: colorsPalete['pink'],
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700))))
                  ]);
                }))
              ]))
        ]));
  }
}

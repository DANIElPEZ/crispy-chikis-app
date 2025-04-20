import 'package:flutter/material.dart';
import 'package:crispychikis/color/colors.dart';
import 'package:crispychikis/components/card_orders_view.dart';
import 'package:crispychikis/components/filter_option_orders_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:crispychikis/components/main_button.dart';
import 'package:crispychikis/provider/provider.dart';

class Orders extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OrdersState();
}

class OrdersState extends State<Orders> {
  String selectedFilter = 'Todos';
  final List<String> filters = ['Todos', 'Pendientes', 'Cancelados'];

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        color: colorsPalete['dark blue'],
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
              children: filters
                  .map((filter) => FilterOption(
                      title: filter,
                      onPressed: () {
                        setState(() => selectedFilter = filter);
                      },
                      isSelected: selectedFilter == filter))
                  .toList()),
          SizedBox(height: 13),
          Expanded(child:
              Consumer<crispyProvider>(builder: (context, provider, child) {
            provider.checkConnection();
            if (provider.getConnection) {
              final orders = provider.orders;

              List filteredOrders = [];
              if (selectedFilter == 'Todos') {
                filteredOrders = orders;
              } else if (selectedFilter == 'Pendientes') {
                filteredOrders = orders
                    .where((order) => order.estado == 1)
                    .toList();
              } else if (selectedFilter == 'Cancelados') {
                filteredOrders = orders
                    .where((order) => order.estado == 2)
                    .toList();
              }
              if (filteredOrders.isNotEmpty) {
                return Stack(children: [
                  ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: 80),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        return CardOrder(
                            date: filteredOrders[index].fecha_creacion_pedido,
                            order: filteredOrders[index].Productos,
                            cancel: filteredOrders[index].estado);
                      }),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: CustomButton(
                        text: 'Actualizar',
                        onPressed: () {
                          provider.fetchOrders();
                        }),
                  )
                ]);
              } else {
                return Column(children: [
                  Expanded(child: Container()),
                  Center(
                      child: Text('No hay pedidos',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: colorsPalete['white']))),
                  Expanded(child: Container()),
                  CustomButton(
                      text: 'Actualizar',
                      onPressed: () {
                        provider.fetchOrders();
                      }),
                  SizedBox(height: 20)
                ]);
              }
            } else {
              return Column(children: [
                Expanded(child: Container()),
                Center(
                    child: Text('Revisa tu conexion a internet',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            color: colorsPalete['white']))),
                Expanded(child: Container()),
                CustomButton(
                    text: 'Intertar conectarse',
                    onPressed: () {
                      provider.checkConnection();
                    }),
                SizedBox(height: 20)
              ]);
            }
          })),
        ]));
  }
}

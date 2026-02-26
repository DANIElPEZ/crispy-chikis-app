import 'package:flutter/material.dart';
import 'package:crispychikis/theme/color/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crispychikis/blocs/orders/orders_bloc.dart';
import 'package:crispychikis/blocs/orders/orders_state.dart';
import 'package:crispychikis/blocs/orders/orders_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crispychikis/components/snack_bar_message.dart';

class Orders extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OrderState();
}

class OrderState extends State<Orders> {
  @override
  void initState() {
    super.initState();
    context.read<OrdersBloc>().add(loadProducts());
    context.read<OrdersBloc>().add(StreamGetLatestOrder());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(children: [
        Container(
            color: colorsPalete['dark blue'],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.19),
        Flexible(
            child: Container(
                color: colorsPalete['orange'],
                width: MediaQuery.of(context).size.width)),
      ]),
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child:
              BlocBuilder<OrdersBloc, OrdersState>(builder: (context, state) {
            if (state.loading) {
              return Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 6, color: colorsPalete['dark blue']));
            }

            if (state.data.isEmpty) {
              return Center(
                child: Text(
                  'No hay pedidos pendientes',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 17),
                ),
              );
            }

            final order = state.data.first;
            return Column(children: [
              SizedBox(height: 40),
              Text(
                order['fecha_creacion_pedido'].toString(),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      order['estado'] == 1
                          ? Icons.access_time_filled
                          : Icons.check,
                      color: order['estado'] == 1
                          ? colorsPalete['dark brown']
                          : colorsPalete['light green'],
                      size: 45),
                  SizedBox(width: 15),
                  Text(
                    order['estado'] == 1 ? "Pendiente" : "Completado",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    SizedBox(height: 20),
                    Text(
                      "Destino: ${order['direccion']}",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(children: [
                      iconButton(Icons.phone),
                      SizedBox(width: 15),
                      iconButton(Icons.location_on),
                    ]),
                    SizedBox(height: 25),
                    Row(children: [
                      Text('Cantidad',
                          style: GoogleFonts.nunito(
                              color: colorsPalete['white'],
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                      SizedBox(width: 20),
                      Text('Producto',
                          style: GoogleFonts.nunito(
                              color: colorsPalete['white'],
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                      Expanded(child: Container()),
                      Text('Precio',
                          style: GoogleFonts.nunito(
                              color: colorsPalete['white'],
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                    ]),
                    Container(height: 2, color: colorsPalete['white']),
                    Expanded(
                        child: ListView.builder(
                            itemCount: state.resume.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(width: 10),
                                        Text(state.resume[index][0].toString(),
                                            style: GoogleFonts.nunito(
                                                color: colorsPalete['white'],
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600)),
                                        SizedBox(width: 25),
                                        Container(
                                            constraints:
                                                BoxConstraints(maxWidth: 120),
                                            child: Text(
                                                state.resume[index][1]
                                                    .toString(),
                                                softWrap: true,
                                                maxLines: 3,
                                                style: GoogleFonts.nunito(
                                                    color:
                                                        colorsPalete['white'],
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600))),
                                        Expanded(child: Container()),
                                        Text(
                                            '\$ ${state.resume[index][2].toString()}',
                                            style: GoogleFonts.nunito(
                                                color: colorsPalete['white'],
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600))
                                      ]));
                            }))
                  ])),
              SizedBox(height: 40)
            ]);
          })),
      Positioned(
          right: 30,
          bottom: 20,
          child:
              BlocBuilder<OrdersBloc, OrdersState>(builder: (context, state) {
            if (state.loading) {
              return Container();
            }
            final order = state.data.first;
            return Text(
              'Total: \$ ${order['precio_total'].toString()}',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            );
          }))
    ]);
  }

  Widget iconButton(IconData icon) {
    return Expanded(
      child: GestureDetector(
        onTap: (){
          snackBarMessage(ScaffoldMessenger.of(context), 'En desarrollo');
        },
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            color: colorsPalete['dark brown'],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: colorsPalete['pink'], size: 30),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:crispychikis/components/appbar.dart';
import 'package:crispychikis/components/text_field.dart';
import 'package:crispychikis/components/horizontal_scroll_place_order_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crispychikis/components/main_button.dart';
import 'package:crispychikis/theme/color/colors.dart';
import 'package:crispychikis/views/make_order_view/see_order.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crispychikis/blocs/make_order/make_order_bloc.dart';
import 'package:crispychikis/blocs/make_order/make_order_event.dart';
import 'package:crispychikis/blocs/make_order/make_order_state.dart';

class PlaceOrder extends StatefulWidget {
  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(filterProducts);
    context.read<MakeOrderBloc>().add(loadProducts());
  }

  void filterProducts() {
    String query = searchController.text.toLowerCase();
    context.read<MakeOrderBloc>().add(searchProduct(query));
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: CustomAppBar(
                bg_color: colorsPalete['orange']!,
                shape_color: colorsPalete['dark blue']!)),
        body: Stack(children: [
          Container(color: colorsPalete['orange']),
          Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomTextField(
                              controller: searchController, labelText: '',
                          placeHolder: 'Buscar producto'),
                          SizedBox(height: 25),
                          Text('Menu del restaurante (desliza)',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: colorsPalete['white']))
                        ])),
                Expanded(child: BlocBuilder<MakeOrderBloc, MakeOrderState>(
                    builder: (context, state) {
                      if (state.loading) {
                        return Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 6, color: colorsPalete['dark blue']));
                      }

                      if (state.products.isEmpty) {
                        return Column(children: [
                          Expanded(child: Container()),
                          Center(
                              child: Text('Sin conexion a internet',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17,
                                      color: colorsPalete['white']))),
                          Expanded(child: Container()),
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: CustomButton(
                                  text: 'Intertar nuevamente',
                                  onPressed: () {
                                    context.read<MakeOrderBloc>().add(loadProducts());
                                  })),
                          SizedBox(height: 20)
                        ]);
                      }

                        return Stack(
                          children: [
                            ListView.builder(
                                padding: EdgeInsets.only(bottom: 80),
                                physics: BouncingScrollPhysics(),
                                itemCount: state.filteredProducts.length,
                                itemBuilder: (context, index) {
                                  return HorizontalScrollPlaceOrder(
                                      title: state.filteredProducts[index][0],
                                      elements: state.filteredProducts[index][1]);
                                }),
                            Positioned(
                                bottom: 20,
                                left: 0,
                                right: 0,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 30),
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
                                        SizedBox(height: 9),
                                        CustomButton(
                                            text: 'VER PEDIDO',
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext context) => SeeOrder()));
                                            }),
                                      ],
                                    )))
                          ]
                        );
                }))
              ]))
        ]));
  }
}

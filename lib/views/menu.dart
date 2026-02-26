import 'package:flutter/material.dart';
import 'package:crispychikis/theme/color/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crispychikis/components/text_field.dart';
import 'package:crispychikis/components/main_button.dart';
import 'package:crispychikis/views/make_order_view/place_order.dart';
import 'package:crispychikis/components/horizontal_scroll_home_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crispychikis/blocs/products/products_event.dart';
import 'package:crispychikis/blocs/products/products_state.dart';
import 'package:crispychikis/blocs/products/products_bloc.dart';

class Menu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MenuState();
}

class MenuState extends State<Menu> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(filterProducts);
    context.read<ProductsBloc>().add(loadProducts());
    context.read<ProductsBloc>().add(canOrder());
  }

  void filterProducts() {
    String query = searchController.text.toLowerCase();
    context.read<ProductsBloc>().add(searchProduct(query));
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        width: 3,
                                        color: colorsPalete['dark brown']!)),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset('assets/logo.jpeg',
                                        width: 120))),
                            FloatingActionButton.extended(
                                onPressed: () {
                                  showVisitLinks(context);
                                },
                                backgroundColor: colorsPalete['dark brown'],
                                icon: Icon(Icons.open_in_new,
                                    color: colorsPalete['pink'], size: 21),
                                label: Text('Visitanos en',
                                    style: GoogleFonts.nunito(
                                        color: colorsPalete['pink'],
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700)))
                          ]),
                      CustomTextField(
                          controller: searchController,
                          labelText: '',
                          placeHolder: 'Buscar producto'),
                      SizedBox(height: 25),
                      Text('Menu del restaurante (desliza)',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: colorsPalete['white']))
                    ])),
            Expanded(
                child: BlocBuilder<ProductsBloc, ProductsState>(
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
                                context.read<ProductsBloc>().add(loadProducts());
                              })),
                      SizedBox(height: 20)
                    ]);
                  }

                  return Stack(children: [
                    ListView.builder(
                        padding: EdgeInsets.only(bottom: 80),
                        physics: BouncingScrollPhysics(),
                        itemCount: state.filteredProducts.length,
                        itemBuilder: (context, index) {
                          return HorizontalScrollHome(
                              title: state.filteredProducts[index][0],
                              elements: state.filteredProducts[index][1]);
                        }),
                    state.userExist
                        ? Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 30),
                                child: CustomButton(
                                    text: 'HACER PEDIDO',
                                    onPressed: () {
                                      context
                                          .read<ProductsBloc>()
                                          .add(canOrder());
                                      final currentState =
                                          context.read<ProductsBloc>().state;
                                      if (!currentState.canOrder) {
                                        restaurantMessage(context);
                                        return;
                                      }
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  PlaceOrder()));
                                    })))
                        : Container()
                  ]);
                }))
          ]))
    ]);
  }

  void showVisitLinks(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
                title: Text('Redes sociales',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: colorsPalete['white'])),
                content: Container(
                    height: 165,
                    width: MediaQuery.of(context).size.width,
                    child: Column(children: [
                      visitButton(
                          context,
                          'https://www.instagram.com/dani.g.dev',
                          FontAwesomeIcons.instagram,
                          'crispy chikis'),
                      SizedBox(height: 12),
                      visitButton(context, 'https://www.tiktok.com/@midudev',
                          FontAwesomeIcons.tiktok, 'crispy.chikis')
                    ])),
                backgroundColor: colorsPalete['dark brown'],
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

  Widget visitButton(
      BuildContext context, String url, IconData icon, String name) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        FaIcon(icon, color: colorsPalete['white'], size: 30),
        Text(name,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: colorsPalete['white']))
      ]),
    );
  }

  void restaurantMessage(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
                title: Text('Horario',
                    style: GoogleFonts.nunito(
                        color: colorsPalete['white'],
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                content: Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Text('Martes a domingo:\n   10:00 a.m. - 10:00 p.m.',
                        style: GoogleFonts.nunito(
                            color: colorsPalete['white'],
                            fontSize: 18,
                            fontWeight: FontWeight.w600))),
                backgroundColor: colorsPalete['dark brown'],
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

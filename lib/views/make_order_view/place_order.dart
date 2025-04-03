import 'package:flutter/material.dart';
import 'package:chispy_chikis/components/appbar.dart';
import 'package:chispy_chikis/components/text_field.dart';
import 'package:chispy_chikis/components/horizontal_scroll_place_order_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chispy_chikis/components/main_button.dart';
import 'package:chispy_chikis/color/colors.dart';
import 'package:chispy_chikis/views/make_order_view/see_order.dart';
import 'package:provider/provider.dart';
import 'package:chispy_chikis/provider/provider.dart';

class PlaceOrder extends StatefulWidget {
  @override
  State<PlaceOrder> createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  TextEditingController searchController = TextEditingController();
  List<List<dynamic>> filteredGroupedProducts = [];
  crispyProvider? provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<crispyProvider>(context, listen: false);
    searchController.addListener(filterProducts);
    setState(()=>filteredGroupedProducts=provider!.clasifiedProducts);
  }

  void filterProducts() {
    String query = searchController.text.toLowerCase();

    setState(() {
      filteredGroupedProducts = provider!.clasifiedProducts
          .map((category) {
        String categoryName = category[0];
        List<List<dynamic>> products = category[1];

        List<List<dynamic>> filteredProducts = products
            .where((product) => product[1].toLowerCase().contains(query))
            .toList();

        if (filteredProducts.isNotEmpty) {
          return [categoryName, filteredProducts];
        } else {
          return null;
        }
      })
          .where((category) => category != null)
          .toList()
          .cast<List<dynamic>>();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              controller: searchController, labelText: ''),
                          SizedBox(height: 25),
                          Text('Menu de productos',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  color: colorsPalete['white']))
                        ])),
                Expanded(child: Consumer<crispyProvider>(
                    builder: (context, provider, child) {
                      if(provider.isLoading){
                        return Center(
                            child: CircularProgressIndicator(
                                strokeWidth: 6,
                                color: colorsPalete['dark blue']
                            )
                        );
                      } else if(provider.getConnection && provider.clasifiedProducts.isNotEmpty){
                        final products=provider.clasifiedProducts;
                        return Stack(
                          children: [
                            filteredGroupedProducts.isEmpty?
                            ListView.builder(
                                padding: EdgeInsets.only(bottom: 80),
                                physics: BouncingScrollPhysics(),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  return HorizontalScrollPlaceOrder(
                                      title: products[index][0],
                                      elements: products[index][1]);
                                }):ListView.builder(
                                padding: EdgeInsets.only(bottom: 80),
                                physics: BouncingScrollPhysics(),
                                itemCount: filteredGroupedProducts.length,
                                itemBuilder: (context, index) {
                                  return HorizontalScrollPlaceOrder(
                                      title: filteredGroupedProducts[index][0],
                                      elements: filteredGroupedProducts[index][1]);
                                }),
                            Positioned(
                                bottom: 20,
                                left: 0,
                                right: 0,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 30),
                                    child: CustomButton(
                                        text: 'VER PEDIDO',
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (BuildContext context) => SeeOrder()));
                                        })))
                          ]
                        );
                  }else{
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
                            Expanded(child: Container())
                          ]
                        );
                      }
                }))
              ]))
        ]));
  }
}

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

class PlaceOrder extends StatelessWidget {
  TextEditingController searchController = TextEditingController();

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
                            ListView.builder(
                                padding: EdgeInsets.only(bottom: 70),
                                physics: BouncingScrollPhysics(),
                                itemCount: products.length,
                                itemBuilder: (context, index) {
                                  return HorizontalScrollPlaceOrder(
                                      title: products[index][0],
                                      elements: products[index][1]);
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

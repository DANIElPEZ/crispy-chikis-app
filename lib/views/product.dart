import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chispy_chikis/components/main_button.dart';
import 'package:chispy_chikis/color/colors.dart';
import 'package:chispy_chikis/components/appbar.dart';
import 'package:chispy_chikis/components/review_product.dart';

class Product extends StatelessWidget {
  Product(
      {required this.id,
      required this.image,
      required this.title,
      required this.description,
      required this.price});

  String image, title, description, price;
  int id;

  List reviews = [
    ['Juan Torres', 3.5, 'Pollo muy delicioso'],
    ['Juan Torres', 4.0, 'Pollo muy delicioso'],
    ['Juan Torres', 3.0, 'Pollo muy delicioso'],
    ['Juan Torres', 1.5, 'Pollo muy delicioso'],
    ['Juan Torres', 2.5, 'Pollo muy delicioso'],
    ['Juan Torres', 4.5, 'Pollo muy delicioso']
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: CustomAppBar(
              bg_color: colorsPalete['dark blue']!,
              shape_color: colorsPalete['orange']!)),
      body: Stack(children: [
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
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 10),
              Center(
                  child: Column(children: [
                Image.network(image, height: 200),
                SizedBox(height: 12),
                Text('Detalle del producto',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 28,
                        color: colorsPalete['white'])),
              ])),
              SizedBox(height: 10),
              Text(title,
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700,
                      fontSize: 21,
                      color: colorsPalete['white'])),
              Text('Que incluye: $description',
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700,
                      fontSize: 21,
                      color: colorsPalete['white'])),
              Text('Precio: \$$price',
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w700,
                      fontSize: 21,
                      color: colorsPalete['white'])),
              SizedBox(height: 15),
              Text('Reseñas',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 28,
                      color: colorsPalete['white'])),
              Expanded(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      return Review(
                          name: reviews[index][0],
                          stars: reviews[index][1],
                          comment: reviews[index][2]);
                    }),
              ),SizedBox(height: 70)
            ])),
        Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: CustomButton(
                    text: 'VOLVER',
                    onPressed: () {
                      Navigator.pop(context);
                    })))
      ]),
    );
  }
}

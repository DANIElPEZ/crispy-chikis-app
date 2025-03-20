import 'package:flutter/material.dart';
import 'package:chispy_chikis/color/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chispy_chikis/components/text_field.dart';
import 'package:chispy_chikis/components/main_button.dart';
import 'package:chispy_chikis/components/card_home_view.dart';
import 'package:chispy_chikis/components/horizontal_scroll_home_view.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();

  List elements = [
    [
      'https://icons.iconarchive.com/icons/michael/coke-pepsi/256/Coca-Cola-Can-icon.png',
      'Cocacola',
      '9.000',
      'Es para tomar y morir.'
    ],
    [
      'https://static.vecteezy.com/system/resources/thumbnails/049/161/664/small/crispy-fried-chicken-leg-with-transparent-background-delicious-golden-brown-isolated-food-image-png.png',
      'Presa de pierna',
      '9.500',
      'Es para comer y morir.'
    ],
    [
      'https://tomatelavida.com.co/wp-content/uploads/2023/03/Agua-Cristal-2023-G.png',
      'Agua',
      '4.567',
      'Es para tomar y sanar.'
    ]
  ];

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
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 3, color: colorsPalete['dark brown']!)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset('assets/logo.jpeg', width: 120))),
              Column(children: [
                Text('Siguenos en',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                        color: colorsPalete['white'])),
                SizedBox(height: 3),
                Row(children: [
                  FaIcon(FontAwesomeIcons.facebook,
                      color: colorsPalete['white'], size: 35),
                  SizedBox(width: 7),
                  FaIcon(FontAwesomeIcons.instagram,
                      color: colorsPalete['white'], size: 35),
                  SizedBox(width: 7),
                  FaIcon(FontAwesomeIcons.tiktok,
                      color: colorsPalete['white'], size: 35)
                ]),
                SizedBox(height: 2),
                Text('@crispy chikis',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: colorsPalete['white']))
              ])
            ]),
            CustomTextField(controller: searchController, labelText: ''),
            SizedBox(height: 25),
            Text('Menu de productos',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: colorsPalete['white']))
          ])),
      Positioned(
          top: 280,
          left: 30,
          child: Container(
              width: 380,
              height: 395,
              child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HorizontalScrollHome(
                            title: 'Presas', elements: elements),
                        HorizontalScrollHome(
                            title: 'bebidas', elements: elements),
                        HorizontalScrollHome(
                            title: 'Combos', elements: elements),
                        SizedBox(height: 70)
                      ])))),
      Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: CustomButton(text: 'HACER PEDIDO', onPressed: () {})))
    ]);
  }
}

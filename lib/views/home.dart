import 'package:flutter/material.dart';
import 'package:chispy_chikis/color/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chispy_chikis/components/text_field.dart';
import 'package:chispy_chikis/components/main_button.dart';
import 'package:chispy_chikis/views/make_order_view/place_order.dart';
import 'package:chispy_chikis/components/horizontal_scroll_home_view.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();

  List products = [
    [
      'Presas',
      [
        [
          'https://static.vecteezy.com/system/resources/thumbnails/049/161/664/small/crispy-fried-chicken-leg-with-transparent-background-delicious-golden-brown-isolated-food-image-png.png',
          'Presa de pierna',
          '9.500',
          'Es para comer y morir.'
        ],
        [
          'https://static.vecteezy.com/system/resources/thumbnails/049/161/664/small/crispy-fried-chicken-leg-with-transparent-background-delicious-golden-brown-isolated-food-image-png.png',
          'Presa de pierna',
          '9.500',
          'Es para comer y morir.'
        ],
        [
          'https://static.vecteezy.com/system/resources/thumbnails/049/161/664/small/crispy-fried-chicken-leg-with-transparent-background-delicious-golden-brown-isolated-food-image-png.png',
          'Presa de pierna',
          '9.500',
          'Es para comer y morir.'
        ]
      ]
    ],
    [
      'Bebidas',
      [
        [
          'https://static.vecteezy.com/system/resources/thumbnails/049/161/664/small/crispy-fried-chicken-leg-with-transparent-background-delicious-golden-brown-isolated-food-image-png.png',
          'Presa de pierna',
          '9.500',
          'Es para comer y morir.'
        ],
        [
          'https://static.vecteezy.com/system/resources/thumbnails/049/161/664/small/crispy-fried-chicken-leg-with-transparent-background-delicious-golden-brown-isolated-food-image-png.png',
          'Presa de pierna',
          '9.500',
          'Es para comer y morir.'
        ],
        [
          'https://static.vecteezy.com/system/resources/thumbnails/049/161/664/small/crispy-fried-chicken-leg-with-transparent-background-delicious-golden-brown-isolated-food-image-png.png',
          'Presa de pierna',
          '9.500',
          'Es para comer y morir.'
        ]
      ]
    ],
    [
      'Combos',
      [
        [
          'https://static.vecteezy.com/system/resources/thumbnails/049/161/664/small/crispy-fried-chicken-leg-with-transparent-background-delicious-golden-brown-isolated-food-image-png.png',
          'Presa de pierna',
          '9.500',
          'Es para comer y morir.'
        ],
        [
          'https://static.vecteezy.com/system/resources/thumbnails/049/161/664/small/crispy-fried-chicken-leg-with-transparent-background-delicious-golden-brown-isolated-food-image-png.png',
          'Presa de pierna',
          '9.500',
          'Es para comer y morir.'
        ],
        [
          'https://static.vecteezy.com/system/resources/thumbnails/049/161/664/small/crispy-fried-chicken-leg-with-transparent-background-delicious-golden-brown-isolated-food-image-png.png',
          'Presa de pierna',
          '9.500',
          'Es para comer y morir.'
        ]
      ]
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
                      CustomTextField(
                          controller: searchController, labelText: ''),
                      SizedBox(height: 25),
                      Text('Menu de productos',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: colorsPalete['white']))
                    ])),
            Expanded(
                child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                return HorizontalScrollHome(
                                    title: products[index][0],
                                    elements: products[index][1]);
                              }),
                          SizedBox(height: 70)
                        ])))
          ])),
      Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: CustomButton(
                  text: 'HACER PEDIDO',
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => PlaceOrder()));
                  })))
    ]);
  }
}

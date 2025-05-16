import 'package:flutter/material.dart';
import 'package:crispychikis/color/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crispychikis/components/text_field.dart';
import 'package:crispychikis/components/main_button.dart';
import 'package:crispychikis/views/make_order_view/place_order.dart';
import 'package:crispychikis/components/horizontal_scroll_home_view.dart';
import 'package:provider/provider.dart';
import 'package:crispychikis/provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  List<List<dynamic>> filteredGroupedProducts = [];
  crispyProvider? provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<crispyProvider>(context, listen: false);
    searchController.addListener(filterProducts);
    setState(() => filteredGroupedProducts = provider!.clasifiedProducts);
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
                                    color: colorsPalete['pink'],
                                size: 21),
                                label: Text('Visitanos en',
                                    style: GoogleFonts.nunito(
                                        color: colorsPalete['pink'],
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700)))
                          ]),
                      CustomTextField(
                          controller: searchController, labelText: '',
                      placeHolder: 'Buscar producto'),
                      SizedBox(height: 25),
                      Text('Menu de productos (desliza)',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                              color: colorsPalete['white']))
                    ])),
            Expanded(child:
                Consumer<crispyProvider>(builder: (context, provider, child) {
              provider.checkConnection();
              if (provider.getConnection) {
                if (provider.isLoading) {
                  return Center(
                      child: CircularProgressIndicator(
                          strokeWidth: 6, color: colorsPalete['dark blue']));
                } else if (provider.clasifiedProducts.isNotEmpty) {
                  final products = provider.clasifiedProducts;
                  return Stack(children: [
                    filteredGroupedProducts.isEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.only(bottom: 80),
                            physics: BouncingScrollPhysics(),
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              return HorizontalScrollHome(
                                  title: products[index][0],
                                  elements: products[index][1]);
                            })
                        : ListView.builder(
                            padding: EdgeInsets.only(bottom: 80),
                            physics: BouncingScrollPhysics(),
                            itemCount: filteredGroupedProducts.length,
                            itemBuilder: (context, index) {
                              return HorizontalScrollHome(
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
                                text: 'HACER PEDIDO',
                                onPressed: () async {
                                  final isBetween =
                                      await provider.getCurrentTime();

                                  print(isBetween);

                                  if (isBetween == null) {
                                    errorGetHour(context);
                                    return;
                                  }

                                  if (!isBetween) {
                                    restaurantTime(context);
                                    return;
                                  }

                                  if (provider.user.isNotEmpty) {
                                    if (provider.user[0]['acepto'] == 1) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  PlaceOrder()));
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Acepta el tratamiento de datos.',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                                color: colorsPalete['white'])),
                                        backgroundColor:
                                            colorsPalete['light brown'],
                                      ));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          'Coloca los datos del perfil.',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                              color: colorsPalete['white'])),
                                      backgroundColor:
                                          colorsPalete['light brown'],
                                    ));
                                  }
                                })))
                  ]);
                } else {
                  return Column(children: [
                    Expanded(child: Container()),
                    Center(
                        child: Text('No hay productos',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700, fontSize: 17))),
                    Expanded(child: Container())
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
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: CustomButton(
                          text: 'Intertar conectarse',
                          onPressed: () {
                            provider.checkConnection();
                          })),
                  SizedBox(height: 20)
                ]);
              }
            }))
          ]))
    ]);
  }

  Future<void> showVisitLinks(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
      builder: (context) =>AlertDialog(
            title: Text('Links para visitar',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: colorsPalete['white'])),
            content: Container(
              height: 165,
              width: MediaQuery.of(context).size.width,
              child: Column(children: [
                GestureDetector(
                  onTap: ()async{
                    const profileUrl = 'https://www.facebook.com/danielsantiagoangel.gonzalezubaque';
                    final fbAppUri = Uri.parse('fb://facewebmodal/f?href=$profileUrl');
                    final fbWebUri = Uri.parse(profileUrl);

                    if (await canLaunchUrl(fbAppUri)) {
                      await launchUrl(fbAppUri, mode: LaunchMode.externalApplication);
                    } else {
                      await launchUrl(fbWebUri, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    FaIcon(FontAwesomeIcons.facebook,
                        color: colorsPalete['white'], size: 30),
                    Text('crispy barrancabermeja',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: colorsPalete['white']))
                  ])
                ),
                SizedBox(height: 12),
                GestureDetector(
                  onTap: ()async{
                    const username = 'dani.g.dev';
                    final instaUri = Uri.parse('instagram://user?username=$username');
                    final fallbackUri = Uri.parse('https://www.instagram.com/$username/');

                    if (await canLaunchUrl(instaUri)) {
                      await launchUrl(instaUri, mode: LaunchMode.externalApplication);
                    } else {
                      await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    FaIcon(FontAwesomeIcons.instagram,
                        color: colorsPalete['white'], size: 30),
                    Text('crispy.chikis',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: colorsPalete['white']))
                  ])
                ),
                SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    const username = 'midudev';
                    final tiktokAppUri = Uri.parse('tiktok://user/@$username');
                    final tiktokWebUri = Uri.parse('https://www.tiktok.com/@$username');

                    if (await canLaunchUrl(tiktokAppUri)) {
                      await launchUrl(tiktokAppUri, mode: LaunchMode.externalApplication);
                    } else {
                      await launchUrl(tiktokWebUri, mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    FaIcon(FontAwesomeIcons.tiktok,
                        color: colorsPalete['white'], size: 30),
                    Text('crispy_videos',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: colorsPalete['white']))
                  ])
                )
              ])
            ),
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
          ])
    );
  }

  Future<void> errorGetHour(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
                title: Text('Error',
                    style: GoogleFonts.nunito(
                        color: colorsPalete['white'],
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                content: Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                        'No se pudo obtener la hora actual. Intenta nuevamente.',
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

  Future<void> restaurantTime(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
                title: Text('Horarios',
                    style: GoogleFonts.nunito(
                        color: colorsPalete['white'],
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                content: Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                        'Martes a domingo:\n' + '   10:00 a.m. - 10:00 p.m.',
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

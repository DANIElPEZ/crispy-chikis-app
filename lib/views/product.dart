import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crispychikis/components/main_button.dart';
import 'package:crispychikis/color/colors.dart';
import 'package:crispychikis/components/appbar.dart';
import 'package:crispychikis/components/review_product.dart';
import 'package:provider/provider.dart';
import 'package:crispychikis/provider/provider.dart';

class Product extends StatefulWidget {
  Product(
      {required this.id,
      required this.image,
      required this.title,
      required this.description,
      required this.price});

  String image, title, description, price;
  int id;

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<crispyProvider>(context, listen: false);
      provider.checkConnection();
      provider.fecthCommentsByProduct(widget.id);
    });
  }

  Future<void> lookInformation(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
            title: Text('¿Como dejar la reseña?',
                style: GoogleFonts.nunito(
                    color: colorsPalete['white'],
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            content: Container(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: Text('Para dejar tu reseña puedes dejarla en el restaurante o enviarnos un correo a admincrispychikis@gmail.com',
              style: GoogleFonts.nunito(
                color: colorsPalete['white'],
                  fontSize: 18,
                  fontWeight: FontWeight.w600
              ))
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
            ]
        )
    );
  }

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
        Consumer<crispyProvider>(
            builder: (context, provider, child) {
              if(provider.getConnection) {
                final reviews=provider.comments;
                return Stack(
                  children: [
                    Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height,
                        padding: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        child:
                        Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Center(
                                  child: Column(children: [
                                    Image.network(widget.image, height: 200),
                                    SizedBox(height: 12),
                                    Text('Detalle del producto',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 28,
                                            color: colorsPalete['white'])),
                                  ])),
                              SizedBox(height: 10),
                              Text(widget.title,
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 21,
                                      color: colorsPalete['white'])),
                              Text('Descripcion: ${widget.description}',
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 21,
                                      color: colorsPalete['white'])),
                              Text('Precio: \$${widget.price}',
                                  style: GoogleFonts.nunito(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 21,
                                      color: colorsPalete['white'])),
                              SizedBox(height: 15),
                              Row(
                                  children: [
                                    Text('Reseñas',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 28,
                                            color: colorsPalete['white'])),
                                    IconButton(onPressed: () {
                                      lookInformation(context);
                                    },
                                        icon: Icon(Icons.info,
                                            color: colorsPalete['white'],
                                            size: 28))
                                  ]
                              ),
                              reviews.isNotEmpty?
                              Expanded(
                                child: ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: reviews.length,
                                    itemBuilder: (context, index) {
                                      return Review(
                                          name: reviews[index].nombre,
                                          stars: reviews[index].puntuacion,
                                          comment: reviews[index].descripcion);
                                    }),
                              ):Center(
                                  child: Text('No hay reseñas',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
                                          color: colorsPalete['white']))
                              ), SizedBox(height: 80)
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
          }
        )
      ])
    );
  }
}

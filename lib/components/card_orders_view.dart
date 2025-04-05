import 'package:chispy_chikis/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chispy_chikis/color/colors.dart';
import 'package:provider/provider.dart';
import 'package:chispy_chikis/provider/provider.dart';

class CardOrder extends StatefulWidget {
  CardOrder({
    required this.date, required this.order, required this.cancel});

  String date;
  List order;
  int cancel;

  @override
  State<CardOrder> createState() => CardOrderState();
}

class CardOrderState extends State<CardOrder> {
  List? resume;

  @override
  void initState() {
    super.initState();
    loadMyorders();
  }

  Future<void> loadMyorders()async{
    final products=Provider.of<crispyProvider>(context,listen: false).products;
    final resumen=await shortProducts(widget.order, products);
    setState(() =>resume=resumen);
  }

  List<List<dynamic>> shortProducts(List ids, List products){
    Map<int, int> conteo = {};

    for (var id in ids) {
      conteo[id] = (conteo[id] ?? 0) + 1;
    }

    List<List<dynamic>> resumen = [];

    conteo.forEach((id, cantidad) {
      final producto = products.firstWhere(
            (p) => p.id == id,
        orElse: () => ProductModel(
          id: 0,
          nombre: 'Desconocido',
          descripcion: '',
          precio: 0,
          imagen: '',
          tipo_producto: 0,
        )
      );

      resumen.add([cantidad, producto.nombre, producto.precio*cantidad]);
    });

    return resumen;
  }

  Future<void> lookDetailorder(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
            title: Text('Detalle',
                style: GoogleFonts.nunito(
                    color: colorsPalete['white'],
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            backgroundColor: colorsPalete['dark brown'],
            content: Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: Column(children: [
                  Row(
                      children: [
                        Icon(Icons.functions, size: 29, color: colorsPalete['white']),
                        SizedBox(width: 20),
                        Icon(Icons.brunch_dining, size: 29, color: colorsPalete['white']),
                        Expanded(child: Container()),
                        Icon(Icons.money, size: 29, color: colorsPalete['white'])
                      ]),
                  Container(height: 2, color: colorsPalete['white']),
                  Expanded(
                      child: ListView.builder(
                          itemCount: resume?.length??0,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(width: 10),
                                    Text(resume![index][0].toString(),
                                        style: GoogleFonts.nunito(
                                            color: colorsPalete['white'],
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(width: 25),
                                    Container(
                                        constraints:
                                        BoxConstraints(maxWidth: 120),
                                        child: Text(resume![index][1].toString(),
                                            softWrap: true,
                                            maxLines: 3,
                                            style: GoogleFonts.nunito(
                                                color: colorsPalete['white'],
                                                fontSize: 18,
                                                fontWeight:
                                                FontWeight.w600))),
                                    Expanded(child: Container()),
                                    Text('\$ ${resume![index][2].toString()}',
                                        style: GoogleFonts.nunito(
                                            color: colorsPalete['white'],
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600))
                                  ])
                            );
                          }))
                ])),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          lookDetailorder(context);
        },
        child: Card(
            elevation: 10,
            margin: EdgeInsets.only(bottom: 20),
            color: colorsPalete['orange'],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              width: MediaQuery.of(context).size.width,
              height: 83,
              child: Row(children: [
                SizedBox(width: 15),
                Icon(
                  widget.cancel == 2 ? Icons.check : Icons.schedule,
                  size: 50,
                  weight: 5,
                  color: widget.cancel == 2
                      ? colorsPalete['light green']
                      : colorsPalete['dark brown'],
                ),
                Expanded(child: Container()),
                Column(children: [
                  Text('Pedido el ${widget.date}',
                      softWrap: true,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          color: colorsPalete['white'],
                          fontSize: 18,
                          fontWeight: FontWeight.w900)),
                  Expanded(child: Container()),
                  Text('Toca para ver el detalle',
                      style: GoogleFonts.poppins(
                          color: colorsPalete['white'],
                          fontSize: 15,
                          fontWeight: FontWeight.w800))
                ]),
                Expanded(child: Container())
              ])
            )));
  }
}

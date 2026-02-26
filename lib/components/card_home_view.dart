import 'package:crispychikis/theme/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crispychikis/views/product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crispychikis/blocs/products/products_event.dart';
import 'package:crispychikis/blocs/products/products_bloc.dart';

class CardHome extends StatelessWidget{
  CardHome({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.price
});
  int id;
  String image,title, description;
  double price;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          context.read<ProductsBloc>().add(loadCommentsByProduct(id));
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Product(image: image, title: title, description: description, price: price.toString())));
        },
        child: Card(
          elevation: 10,
          color: colorsPalete['light brown'],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            width: 185,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(image, height: 90,
                fit: BoxFit.cover),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title,
                            maxLines: 2,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: colorsPalete['white'])),
                        Text('\$ $price',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: colorsPalete['white']))
                      ]),
                ),
                Text('Toca para ver mas',
                    style: GoogleFonts.nunito(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: colorsPalete['white']))
              ]
            )
          ),
        ));
  }
}
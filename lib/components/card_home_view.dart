import 'package:chispy_chikis/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chispy_chikis/views/product.dart';

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
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=>Product(id: 1, image: image, title: title, description: description, price: price.toString())));
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
              children: [
                Image.network(image, height: 90,
                fit: BoxFit.cover),
                Expanded(child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        constraints: BoxConstraints(maxWidth: 70),
                        child: Text(title,
                            softWrap: true,
                            maxLines: 2,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                                color: colorsPalete['white'])),
                      ),
                      Text('\$ $price',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: colorsPalete['white']))
                    ]),
                Expanded(child: Container()),
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
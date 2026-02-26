import 'package:crispychikis/theme/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crispychikis/blocs/make_order/make_order_bloc.dart';
import 'package:crispychikis/blocs/make_order/make_order_event.dart';

class CardPlaceOrder extends StatefulWidget {
  CardPlaceOrder(
      {required this.id, required this.image, required this.title, required this.price});

  int id;
  final String image, title;
  double price;

  @override
  State<CardPlaceOrder> createState() => _CardPlaceOrderState();
}

class _CardPlaceOrderState extends State<CardPlaceOrder>
    with SingleTickerProviderStateMixin {
  bool isAdded = false;
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.bounceInOut);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void toggleAdded() async {
    setState(() => isAdded = true);
    controller.forward(from: 0.5);
    await Future.delayed(Duration(milliseconds: 400));
    setState(() => isAdded = false);
  }

  Future<void> addProducts(int id, String title, double price) async{
    context.read<MakeOrderBloc>().add(AddProduct(id: id, price: price, title: title));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          toggleAdded();
          addProducts(widget.id, widget.title, widget.price);
        },
        child: Card(
            elevation: 5,
            color: colorsPalete['light brown'],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
                width: 185,
                height: 200,
                child: Stack(alignment: AlignmentDirectional.center, children: [
                  Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                        Image.network(widget.image,
                            height: 90, fit: BoxFit.cover),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.title,
                                    softWrap: true,
                                    maxLines: 2,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        color: colorsPalete['white'])),
                                Text('\$ ${widget.price}',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                        color: colorsPalete['white']))
                              ]),
                        )
                      ])),
                  Container(
                      decoration: BoxDecoration(
                          color: Color(0x55000000),
                          borderRadius: BorderRadius.circular(16))),
                  TweenAnimationBuilder(
                      tween:
                          Tween<double>(begin: 1.0, end: isAdded ? 1.2 : 1.0),
                      duration: Duration(seconds: 1),
                      curve: Curves.bounceOut,
                      builder: (context, value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: Icon(
                          isAdded
                              ? Icons.check_circle_outline
                              : Icons.add_circle_outline,
                          color: isAdded
                              ? colorsPalete['light green']
                              : colorsPalete['dark brown'],
                          size: 80))
                ]))));
  }
}

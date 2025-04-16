import 'package:flutter/material.dart';
import 'package:crispychikis/shape/app_bar_shape.dart';

class CustomAppBar extends StatelessWidget{
  CustomAppBar({required this.bg_color, required this.shape_color});
  final Color bg_color;
  final Color shape_color;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
          Positioned.fill(child: Container(color: bg_color)),
          Positioned.fill(child: CustomPaint(
            painter: appBarShape(bgColor: shape_color)
          )),
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0
          )
        ]);
  }
}
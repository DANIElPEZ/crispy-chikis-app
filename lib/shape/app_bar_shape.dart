import 'package:flutter/material.dart';

class appBarShape extends CustomPainter {
  appBarShape({required this.bgColor});
  final Color bgColor;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = bgColor;
    final Path path = Path();
    path.lineTo(0, size.height*0.6);
    double radius = 12;
    double diameter = radius * 2;
    double startY = size.height * 0.6;

    for (double i = 0; i < size.width; i += diameter) {
      path.arcToPoint(
        Offset(i + radius, startY + radius),
        radius: Radius.circular(radius),
        clockwise: false,
      );
      path.arcToPoint(
        Offset(i + diameter, startY),
        radius: Radius.circular(radius),
        clockwise: false,
      );
    }

    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }
}
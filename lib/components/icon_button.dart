import 'package:flutter/material.dart';
import 'package:crispychikis/theme/color/colors.dart';

class OrderButton extends StatelessWidget{
  OrderButton({
    required this.icon,
    required this.onPressed
  });
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            color: colorsPalete['dark brown'],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: colorsPalete['pink'], size: 30),
        ),
      ),
    );
  }
}
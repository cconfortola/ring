import 'package:flutter/material.dart';
import 'package:ring/colors.dart';

class RingButton extends StatelessWidget {
  final String label;
  final Function onPressed;

  RingButton(
    this.label, {
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                RingColors.of(context).primary,
                RingColors.of(context).primary.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(100),
          ),
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Text(
            label,
            style: TextStyle(
              color: RingColors.of(context).textContrast,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(100),
              splashColor: Colors.white10,
              highlightColor: Colors.white10,
              onTap: onPressed,
            ),
          ),
        ),
      ],
    );
  }
}

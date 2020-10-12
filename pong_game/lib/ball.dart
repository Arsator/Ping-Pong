import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double diameter = 50.0;
    return Container(
      width: diameter,
      height: diameter,
      decoration: new BoxDecoration(
        color: Colors.amber[400],
        shape: BoxShape.circle,
      ),
    );
  }
}

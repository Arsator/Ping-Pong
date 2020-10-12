import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Bat extends StatelessWidget {
  final double width, height;
  Bat({@required this.width, @required this.height});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.brown[900],
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}

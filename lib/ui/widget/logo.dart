import 'package:flutter/material.dart';

class MyLogo extends StatelessWidget {
  final double height, width;

  MyLogo({this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: Image.asset(
        "assets/icon/logo.png",
        fit: BoxFit.fill,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MyCustomClipperForAppBar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 45);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 45);
    //path.quadraticBezierTo(1, 0.1, 2, 1);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
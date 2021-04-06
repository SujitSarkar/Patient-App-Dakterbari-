import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NoData extends StatelessWidget {
  String message;
  NoData({this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(message,style: TextStyle(fontSize: 18,color: Color(0xffF0A732)),),
      ),
    );
  }
}

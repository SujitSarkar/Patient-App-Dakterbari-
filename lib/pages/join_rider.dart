import 'package:flutter/material.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';

class JoinRider extends StatefulWidget {
  @override
  _JoinRiderState createState() => _JoinRiderState();
}

class _JoinRiderState extends State<JoinRider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      backgroundColor: Color(0xffF4F7F5),
      appBar: customAppBarDesign(context, 'Join Rider'),
      body: _bodyUI(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: Theme.of(context).primaryColor,
      //   elevation: 2,
      //   tooltip: "Join Rider",
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //     size: 35,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }
  Widget _bodyUI() {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      //padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Center(
        child: Text("Don't Have Any Rider Now"),
      ),
    );
  }

}

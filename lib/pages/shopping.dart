import 'package:flutter/material.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';

class Shopping extends StatefulWidget {
  @override
  _ShoppingState createState() => _ShoppingState();
}

class _ShoppingState extends State<Shopping> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //backgroundColor: Color(0xffF4F7F5),
      appBar: customAppBarDesign(context, 'Happy Shopping'),
      body: _bodyUI(),
    );
  }

}
Widget _bodyUI() {
  return Center(
    child: Text("Shopping feature is coming soon !" ),
  );
}



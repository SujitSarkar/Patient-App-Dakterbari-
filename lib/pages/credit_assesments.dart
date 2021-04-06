import 'package:flutter/material.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';class CreditAssesment extends StatefulWidget {
  @override
  _CreditAssesmentState createState() => _CreditAssesmentState();
}

class _CreditAssesmentState extends State<CreditAssesment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      backgroundColor: Color(0xffF4F7F5),
      appBar: customAppBarDesign(context, 'Credit Assesment'),
      body: _bodyUI(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: Theme.of(context).primaryColor,
      //   elevation: 2,
      //   tooltip: "Credit Assesment",
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
        child: Text("Don't Have Any Credit Assesment Now"),
      ),
    );
  }

}


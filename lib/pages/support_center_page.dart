import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:user_panel/utils/custom_clipper.dart';
import 'package:user_panel/shared/form_decoration.dart';
class SupportCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _customAppBar(context),
      body: _bodyUI(context),
    );
  }

  Widget _customAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(90),
      child: AppBar(
        title: Text(
          'Support Center',
          //style: TextStyle(color: Colors.black,fontSize: 15),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        flexibleSpace: ClipPath(
          clipper: MyCustomClipperForAppBar(),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Color(0xffAB5581),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  tileMode: TileMode.clamp,
                )),
          ),
        ),
      ),
    );
  }

  Widget _bodyUI(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      color: Colors.white,
      child: Column(
        children: [
          //Header...
          Container(
            height: size.height * .25,
            width: size.width,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey[400],
                      offset: Offset(0, 2),
                      blurRadius: 2)
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Dakterbari Logo
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Image.asset('assets/banner2.png'),
                  ),
                ),
                SizedBox(height: 8),
                //Dakterbari Details
                //Text("Dakterbari",style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.w900),),
                Text(
                  "Chottogram, Bangladesh",
                  style: TextStyle(
                      fontSize: size.width*.05,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  "www.dakterbari.com",
                  style: TextStyle(
                      fontSize: size.width*.05,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),

          //Body
          Expanded(
            child: ListView(
              children: [
                SizedBox(height: 20),
                _contentBuilder(
                    context,
                    "Address 1",
                    "Chottogram Office",
                    "K.N. Tower(8th floor), Badamtali More, Agrabad C/A, Chattogram",
                    "Chottogram, Bangladesh"),
                SizedBox(height: 10),
                _contentBuilder(
                    context,
                    "Address 2",
                    "Dhaka Office",
                    "House-16(A3), Sonargaon Janapath Road, Uttara, Dhaka",
                    "Dhaka, Bangladesh"),
                SizedBox(height: 10),

                _contentBuilder(
                    context,
                    "Contact Us",
                    "Customer Care :+8801919253366",
                    "Support Email :dialmexyz@gmail.com",'',),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _contentBuilder(
      BuildContext context,
      String header,
      String sub1,
      String sub2,
      String sub3,
      ) {
    Size size=MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.all(8),
      decoration: cardDecoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            header,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: size.width*.055,
                color: Theme.of(context).primaryColorDark,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 5),
          Text(
            sub1,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: size.width*.038,
                color: Colors.grey[800],
                fontWeight: FontWeight.w400),
          ),
          Text(
            sub2,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: size.width*.038,
                color: Colors.grey[800],
                fontWeight: FontWeight.w300),
          ),
          Text(
            sub3,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: size.width*.038,
                color: Colors.grey[800],
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
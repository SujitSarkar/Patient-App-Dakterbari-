import 'package:flutter/material.dart';

Widget button(BuildContext context, String buttonName) {
  Size size = MediaQuery.of(context).size;
  return Material(
    elevation: 2,
    borderRadius: BorderRadius.all(Radius.circular(10)),
    child: Container(
      alignment: Alignment.center,
      height: size.width*.12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Theme.of(context).primaryColor,
      ),
      child: Text(
        buttonName,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: size.width / 20),
      ),
    ),
  );
}
Widget disableButton(BuildContext context, String buttonName) {
  Size size = MediaQuery.of(context).size;
  return Material(
    elevation: 2,
    borderRadius: BorderRadius.all(Radius.circular(10)),
    child: Container(
      alignment: Alignment.center,
      height: size.width*.12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.grey,
      ),
      child: Text(
        buttonName,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: size.width / 20),
      ),
    ),
  );
}

Widget outlineIconButton(
    BuildContext context, IconData iconData, String buttonName, Color color) {
  Size size = MediaQuery.of(context).size;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
        border: Border.all(width: 2, color: color),
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          size: size.width*.05,
          color: color,
        ),
        SizedBox(width: 5),
        Text(
          buttonName,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: size.width*.035, color: color),
        )
      ],
    ),
  );
}

Widget bigOutlineIconButton(
    BuildContext context, IconData iconData, String buttonName, Color color) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
        border: Border.all(width: 2, color: color),
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          iconData,
          size: 22,
          color: color,
        ),
        SizedBox(width: 5),
        Text(
          buttonName,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 17, color: color),
        )
      ],
    ),
  );
}

Widget miniOutlineButton(
    BuildContext context, String buttonName, Color color) {
  Size size = MediaQuery.of(context).size;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
        border: Border.all(width: 1, color: color),
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: Text(
      buttonName,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: size.width*.03, color: color),
    ),
  );
}

Widget miniOutlineIconButton(
    BuildContext context, String buttonName,  IconData iconData, Color color) {
  Size size = MediaQuery.of(context).size;
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
        border: Border.all(width: 1, color: color),
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(iconData,color: color,size: size.width*.04),
        SizedBox(width: 5),
        Text(
          buttonName,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: size.width*.03, color: color),
        ),
      ],
    ),
  );
}

Widget bigFillButton(BuildContext context, String buttonName, IconData iconData){
  return Material(
    elevation: 2,
    borderRadius: BorderRadius.all(Radius.circular(10)),
    child: Container(
      // width: size.width,
      // height: size.width / 8,
      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData,color: Colors.white,),
          SizedBox(width: 10),
          Text(
            buttonName,
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500),
          )
        ],
      ),
    ),
  );
}

Widget socialButton(
    BuildContext context, String iconUrl, String buttonName, Color color) {
  Size size=MediaQuery.of(context).size;
  return Container(
    width: size.width*.45,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
        border: Border.all(width: 2, color: color),
        borderRadius: BorderRadius.all(Radius.circular(5))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(iconUrl,height: size.width*.032,),
        SizedBox(width: 8),
        Text(
          buttonName,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: size.width*.033, color: color),
        )
      ],
    ),
  );
}

whiteButton(BuildContext context, String buttonName) {
  Size size = MediaQuery.of(context).size;
  return Material(
    elevation: 2,
    borderRadius: BorderRadius.all(Radius.circular(10)),
    child: Container(
      alignment: Alignment.center,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: Text(
        buttonName,
        style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: size.width / 20),
      ),
    ),
  );
}
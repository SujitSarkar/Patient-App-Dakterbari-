import 'package:flutter/material.dart';

colonTextStyle(BuildContext context){
  return TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).primaryColor,
  );
}
boldTextStyle(){
  return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: Colors.grey[800]
  );
}

headingDecorationUnsized(context,headingText,Color backColor,Color textColor){
  Size size=MediaQuery.of(context).size;
  return Container(
  padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
  width: size.width,
  child: Text(headingText,style: TextStyle(fontSize: size.width * .040,fontWeight: FontWeight.w500,color: textColor),textAlign: TextAlign.start,),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
  color: backColor,
  )
  );
}



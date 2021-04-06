import 'package:flutter/material.dart';

void showLoadingDialog(BuildContext context, var regAuth) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder:(context){
          return AlertDialog(
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Expanded(child: Text(regAuth.loadingMgs,style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey[700]))),
              ],
            ),
          );
        }
    );
}
void showAlertDialog(BuildContext context, String message){
  showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: Text('Status'),
          content: Text(message),
        );
      }
  );
}

void showSnackBar(GlobalKey<ScaffoldState> scaffoldKey,message,Color color) {
  scaffoldKey.currentState.showSnackBar(
    SnackBar(
      content: Text(message,
          style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
      backgroundColor: color,
      elevation: 0,
    ),
  );
}
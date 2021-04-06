import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_panel/provider/patient_provider.dart';
import 'package:user_panel/shared/form_decoration.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Notifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF4F7F5),
      resizeToAvoidBottomInset: false,
      //backgroundColor: Colors.white,
      appBar: customAppBarDesign(context, 'Notifications For You'),
      body: _bodyUI()
    );
  }

  Widget _bodyUI(){
    return Consumer<PatientProvider>(
      builder: (context,pProvider, child){
        return RefreshIndicator(
          backgroundColor: Colors.white,
          onRefresh: ()=>pProvider.getNotification(),
          child:AnimationLimiter(
            child: ListView.builder(
              physics:  const AlwaysScrollableScrollPhysics(),
              itemCount: pProvider.notificationList.length,
              itemBuilder: (context, index){
                return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 500),
                    child: SlideAnimation(
                      verticalOffset: 400,
                      child: FadeInAnimation(
                        child: NotificationTile(
                          pProvider: pProvider,
                          index: index,
                        ),),
                    )
                );
                },
            ),
          )
        );
      },
    );
  }
}

// ignore: must_be_immutable
class NotificationTile extends StatelessWidget {
  int index;
  PatientProvider pProvider;
  NotificationTile({this.pProvider,this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> _showFullNotification(context,pProvider.notificationList[index].title,
          pProvider.notificationList[index].message, pProvider.notificationList[index].date),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        width: MediaQuery.of(context).size.width,
        decoration: simpleCardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pProvider.notificationList[index].title??'',
                maxLines: 2,
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.grey[900])),
            SizedBox(height: 5),
            Text(pProvider.notificationList[index].message??'',
                maxLines: 4,
                style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.grey[800])),
            Text(pProvider.notificationList[index].date??'',
                maxLines: 1,
                style: TextStyle(fontSize: 10,fontWeight: FontWeight.w400,color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  void _showFullNotification(BuildContext context,String title, String message, String date){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return AlertDialog(
          scrollable: true,
          title: Text(title,textAlign: TextAlign.justify,),
          content: Text(message,textAlign: TextAlign.justify,),
          actions: [
            IconButton(icon: Icon(Icons.cancel_presentation_sharp), onPressed: ()=>Navigator.pop(context))
          ],
        );
      }
    );
  }
}


import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_panel/pages/login_page.dart';
import 'package:user_panel/pages/subpage/update_user_profile.dart';
import 'package:user_panel/provider/patient_provider.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:user_panel/pages/subpage/contact_us_page.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:user_panel/pages/terms_and_condition.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  bool isLoading = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //backgroundColor: Color(0xffAAF1E8),
      appBar: customAppBarDesign(context, "My Account"),
      body: _bodyUI(),
    );
  }
  Widget _bodyUI() {
    Size size = MediaQuery.of(context).size;
    final PatientProvider patientProvider = Provider.of<PatientProvider>(context);
    return Column(
      children: [
        ///Account Section...
        Container(
          padding: EdgeInsets.all(10),
          color: Colors.white,
          height: size.height * .25,
          width: size.width,
          child: Row(
            children: [
              Container(
                width: size.width * .46,
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: patientProvider.patientList[0].imageUrl==null?
                Image.asset("assets/male.png", width: 150):ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: CachedNetworkImage(
                    imageUrl: patientProvider.patientList[0].imageUrl,
                    placeholder: (context, url) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:Image.asset('assets/loadingimage.gif',fit: BoxFit.cover, height: size.height * .28),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: size.width * .46,
                    height: size.height * .28,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: size.width * .42,
                margin: EdgeInsets.only(left: 10, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(patientProvider.patientList[0].fullName ?? 'Your name',
                      maxLines: 3,
                      style:
                      TextStyle(fontSize: size.width*.06, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: size.width / 15),
                    Text(patientProvider.patientList[0].id ?? 'Your phone number',
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: size.width*.05,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

        ///Account Options Section...
        Expanded(
          child: Container(
            width: size.width,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            color: Color(0xffF4F7F5),
            child: AnimationLimiter(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: size.width / 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.7),
                itemCount: 4,
                itemBuilder: (context, index){
                  return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        verticalOffset: 400,
                        child: FadeInAnimation(
                          child: FunctionBuilder(index: index),),
                      )
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
// ignore: must_be_immutable
class FunctionBuilder extends StatelessWidget {
  int index;

  FunctionBuilder({this.index});

  @override
  Widget build(BuildContext context) {
    final PatientProvider operation=Provider.of<PatientProvider>(context);
    Size size=MediaQuery.of(context).size;
    return InkWell(
          onTap: ()async {
            if (index==0){
              operation.loadingMgs='Please wait...';
              showLoadingDialog(context,operation);
              Future.delayed(Duration(milliseconds: 500)).then((value){
                Navigator.pop(context);
                  Navigator.push(context,MaterialPageRoute(builder: (context) => UpdateUserProfile()));
              });
            }

            else if(index==1){
              PermissionStatus locationStatus = await Permission.location.status;
              if (!locationStatus.isGranted) await Permission.location.request();
              if(await Permission.location.isGranted) {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ContactUs()));
              }else {
                showAlertDialog(context, 'Allow location access to contact with us');
              }
            }

            else if (index==2)
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TermsAndCondition(
                        tc: "tc",
                      )));

            else if (index==3) {
              operation.loadingMgs = 'Logging out...';
              showLoadingDialog(context, operation);

              SharedPreferences preferences = await SharedPreferences.getInstance();
              await preferences.setString('id', null).then((value){

                operation.patientDetails=null;
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LogIn()),
                        (route) => false);
                //await FirebaseAuth.instance.signOut().then((value) {});
              });

            }
          },
          child: Container(
            padding: EdgeInsets.only(left: 20),
            margin: EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, offset: Offset(.2, .5), blurRadius: 2)
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  index==0?Icons.account_box_outlined
                      :index==1?Icons.email_outlined
                      :index==2?Icons.article_outlined
                      :Icons.logout,
                  color: Theme.of(context).primaryColor,
                  size: size.width*.075,
                ),
                Text(
                  index==0?'My Profile'
                      :index==1?'Contact Us'
                      :index==2?'T&C'
                      :'Logout',
                  style: TextStyle(
                      fontSize: size.width*.045,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800]),
                ),
                SizedBox(height: 10),
                Text(
                  index==0?'Setup profile'
                      :index==1?'Let us help you'
                      :index==2?'Company polies'
                      :'See you again',
                  style: TextStyle(color: Colors.grey[600],fontSize: size.width*.036,),
                )
              ],
            ),
          ),
        );
  }
}
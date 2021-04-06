import 'dart:collection';
import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:user_panel/widgets/button_widgets.dart';
import 'package:provider/provider.dart';
import 'package:user_panel/provider/patient_provider.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  bool _isSend = true;
  double sendHeight = 70;
  double locationHeight = 50;
  String name, email, mgs = '';
  bool isMgsFieldTap=false;
  final _formKey=GlobalKey<FormState>();
  final _scaffoldKey=GlobalKey<ScaffoldState>();

  Set<Marker> _marker = HashSet<Marker>();
  GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController controller){
    _mapController = controller;
    setState(() {
      _marker.add(
        Marker(
          markerId: MarkerId('0'),
          position: LatLng(22.328135271666877, 91.81221409739933),
          infoWindow: InfoWindow(
            title: "Daktarbari Headquarter",
            snippet: "Chottogram, Bangladesh"
          ),
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final PatientProvider drProvider = Provider.of<PatientProvider>(context);

    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffF4F7F5),
      appBar: customAppBarDesign(context, "Contact Us"),
      body: _bodyUI(size,drProvider),
      bottomNavigationBar: _bottomNavigationBar(size),
    );
  }

  Widget _bodyUI(Size size,PatientProvider pProvider) {
    return Container(
      //color: Colors.red,
      height: size.height,
      width: size.width,
      child: Stack(
        children: [
          _isSend
              ?
              //Send Section...
              Positioned(
                  top: 55,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[300],
                              blurRadius: 4,
                              offset: Offset(0, 2))
                        ]),
                    height: size.height * .62,
                    width: size.width * .95,
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 30),
                            //Header message
                            Text(
                              "Send us a message!",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800]),
                            ),
                            Text(
                              "How can we help you today?",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800]),
                            ),
                            SizedBox(height: 10),

                            //Input field
                            TextFormField(
                              decoration: InputDecoration(labelText: 'Name'),
                              onChanged: (val) {
                                setState(() => name = val);
                              },
                              validator:(val)=> val.isEmpty?'Enter your name':null,
                            ),
                            SizedBox(height: 20),

                            TextFormField(
                              decoration:
                              InputDecoration(labelText: 'Email'),
                              onChanged: (val) {
                                setState(() => email = val);
                              },
                              onTap: ()=>setState(()=>isMgsFieldTap=true),
                              validator:(val)=> val.isEmpty?'Enter your email':null,
                            ),
                            SizedBox(height: 20),

                            TextFormField(
                              keyboardType: TextInputType.text,
                              maxLines: mgs.length >= 80
                                  ? 3
                                  : mgs.length >= 40
                                  ? 2
                                  : 1,
                              onChanged: (val) {
                                setState(() => mgs = val);
                              },
                              onTap: ()=>setState(()=>isMgsFieldTap=true),
                              validator:(val)=> val.isEmpty?'Enter your message':null,
                              decoration:
                              InputDecoration(labelText: 'Message'),
                            ),
                            //Submit button
                            SizedBox(height: 30),
                            GestureDetector(
                                onTap: ()async{
                                  if(_formKey.currentState.validate()){
                                    pProvider.loadingMgs='Sending your message...';
                                    showLoadingDialog(context, pProvider);
                                    await pProvider.sendMessageToAdmin(context, _scaffoldKey, name, email, mgs);
                                  }
                                },
                                child: button(context, 'Submit')
                            ),
                            SizedBox(height: 35),
                            isMgsFieldTap? SizedBox(height: 200):Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                )

              //Location Section...
              :Positioned(
                  top: 55,
                  right: 0,
                  child: Container(
                    alignment: Alignment.topCenter,
                    //padding: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[300],
                              blurRadius: 4,
                              offset: Offset(0, 2))
                        ]),
                    height: size.height * .62,
                    width: size.width * .95,
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.only(
                            top: 30,
                          ),
                          child: Text(
                            "Meet us at our workplace!",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800]),
                          ),
                        ),
                        Container(
                          height: size.height * .53,
                             margin: EdgeInsets.only(top: 70, left: 5,right: 5,bottom: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: GoogleMap(
                              compassEnabled: true,
                              onMapCreated: _onMapCreated,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(22.328135271666877, 91.81221409739933),
                                zoom: 15,
                              ),
                              markers: _marker,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

          //Send and Location Button...
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSend = true;
                    sendHeight = 70;
                    locationHeight = 50;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  height: sendHeight,
                  width: sendHeight,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 4,
                            offset: Offset(0, 2))
                      ]),
                  child: Image.asset(
                    'assets/icons/email-send100.png',
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isSend = false;
                    sendHeight = 50;
                    locationHeight = 70;
                  });
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  height: locationHeight,
                  width: locationHeight,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[300],
                            blurRadius: 4,
                            offset: Offset(0, 2))
                      ]),
                  child: Image.asset(
                    'assets/icons/marker100.png',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomNavigationBar(Size size) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 8),
        height: size.width * .2,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[300], blurRadius: 4, offset: Offset(0, 2))
            ]),
        child: AnimationLimiter(
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index){
              return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    horizontalOffset: 400,
                    child: FadeInAnimation(
                      child: SocialButtonTile(index: index),),
                  )
              );
            },
          ),
        ));
  }


}


// ignore: must_be_immutable
class SocialButtonTile extends StatelessWidget {
  int index;
  SocialButtonTile({this.index});

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(right: 10),
      child: Padding(
        padding: const EdgeInsets.only(top: 7, bottom: 7),
        child: GestureDetector(
          onTap: ()=> _launchInWebViewWithJavaScript(context,
              index==0? 'https://www.facebook.com/groups/dakterbari'
                  :index==1? 'https://twitter.com/DakterBari'
                  :index==2? 'https://www.youtube.com/channel/UCJdNGzAYLBFlYKpzVnxE6cg/featured'
                  :index==3? 'https://www.linkedin.com/company/dakterbaribd'
                  :'https://www.pinterest.com/dakterbari/_created'),
          child: Image.asset(
            index==0?
            "assets/icons/facebook128.png"
                :index==1?  "assets/icons/twitter128.png"
                :index==2? "assets/icons/youtube128.png"
                :index==3? "assets/icons/linkedin128.png"
                :"assets/icons/pinterest128.png",
            height: 40,
          ),
        ),
      ),
    );
  }

  Future<void> _launchInWebViewWithJavaScript(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      showAlertDialog(context, 'Something went wrong. Try again later');
    }
  }
}

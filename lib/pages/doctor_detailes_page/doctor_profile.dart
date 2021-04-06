import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_panel/shared/widget.dart';
class DoctorProfile extends StatefulWidget {
  String id;
  String fullName;
  String phone;
  String email;
  String about;
  String country;
  String state;
  String city;
  String gender;
  String specification;
  List<dynamic> optionalSpecification;
  String degree;
  String bmdcNumber;
  String appFee;
  String teleFee;
  String experience;
  String photoUrl;
  //String totalPrescribe;
  String countryCode;
  String currency;
  bool provideTeleService;

  DoctorProfile(
      {this.id,
        this.fullName,
        this.phone,
        this.email,
        this.about,
        this.gender,
        this.country,
        this.state,
        this.city,
        this.specification,
        this.optionalSpecification,
        this.degree,
        this.bmdcNumber,
        this.appFee,
        this.teleFee,
        this.experience,
        this.photoUrl,
        //this.totalPrescribe,
        this.provideTeleService,
        this.countryCode,
        this.currency,
      });
  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: _bodyUI(),
    );
  }
  simpleTextStyle(){
    Size size=MediaQuery.of(context).size;
    return TextStyle(
      color: Colors.grey[900],
      fontSize: size.width*.04,
    );
  }
  Widget _bodyUI(){
    Size size=MediaQuery.of(context).size;
    return  ListView(
        children: [
          ///Top Section
          Container(
              padding: EdgeInsets.only(top: 20),
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: size.width*.45,
                        width: size.width*.45,
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).accentColor,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: widget.photoUrl==null?
                        Image.asset(widget.gender=='Male'?
                        "assets/male.png":'assets/female.png', width: size.width*.40,height: size.width*.45 ,fit: BoxFit.cover):ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: CachedNetworkImage(
                            imageUrl: widget.photoUrl,
                            placeholder: (context, url) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset('assets/loadingimage.gif',fit: BoxFit.cover, height: 160),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                            width: size.width * .20,
                            height: 75,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * .01,),
                      Container(
                        height: size.width*.45,
                        width: size.width*.45,
                        //color: Colors.red,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(widget.fullName??'',
                                maxLines: 3,
                                style: TextStyle(fontSize: size.width*.07,fontWeight: FontWeight.w500)),
                            Text('${widget.degree==null?'':widget.degree}',
                                maxLines: 2,
                                style: TextStyle(fontSize: size.width*.04,color: Colors.grey[900])),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.width * .01,
                  ),

                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        widget.bmdcNumber==null?Container():Text('BMDC Number : ${widget.bmdcNumber}',style: TextStyle(fontSize: size.width * .036),),
                        if(widget.country==null||widget.state==null||widget.city==null)Container()
                        else Text('Address: ${widget.country==null?' ':widget.country}, '
                            '${widget.state==null?' ':widget.state}, ${widget.city==null?' ':widget.city}',
                          style: TextStyle(fontSize: size.width * .033),),
                        Text('Phone : ${widget.countryCode}${widget.phone}',style: TextStyle(fontSize: size.width * .036),),
                        widget.email==null?Container():Text('Email : ${widget.email}',style: TextStyle(fontSize: size.width * .034),),
                       ],
                    ),
                  ),

                  SizedBox(
                    height: 8.0,
                  ),
                ],
              )
          ),
          SizedBox(
            height: 8.0,
          ),
          //headingDecoration(context,"Experienced & Fee",Colors.white, Color(0xff00C5A4)),
          ///Experience & Fee Section
          Container(
              margin: EdgeInsets.only(left: 10),
              child: Text("Experienced & Fee",
                style: TextStyle(color:  Theme.of(context).primaryColor,
                    fontSize: size.width * .040,fontWeight: FontWeight.bold),)),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            margin:EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Color(0xffF4F7F5),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                _buildExperinceAndFees(context,'Experienced : ${widget.experience==null?'0':widget.experience} years'),
                SizedBox(height: 8.0,),
                _buildExperinceAndFees(context,'Appointment Fees : ${widget.appFee==null?'not provided yet':widget.appFee} ${widget.currency==null?'':widget.currency}'),
                SizedBox(height: 8.0,),
               widget.provideTeleService==true? _buildExperinceAndFees(context,'Telemedicine Fees : '
                   '${widget.teleFee==null?'not provided yet':widget.teleFee} ${widget.currency==null?' ':widget.currency}'):Container(),
              ],
            ),//child: CategoryContainerUI(),
          ),
          SizedBox(height: 10,),
          ///About Section
          widget.about==null?Container():Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headingDecorationUnsized(context,"About Doctor",Colors.white, Theme.of(context).primaryColor),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                color: Color(0xffF4F7F5),
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text('${widget.about}',style: simpleTextStyle(),textAlign: TextAlign.justify),
              ),
            ],
          ),
          SizedBox(height: size.width / 20),

          ///Specifications...
          //headingDecoration(context, "Specifications", Colors.white, Color(0xff00C5A4)),
          Container(
            margin: EdgeInsets.only(left: 10,bottom: 5),
            child: Text("Specifications",
             style: TextStyle(color:  Theme.of(context).primaryColor,
             fontSize: size.width * .040,fontWeight: FontWeight.bold)),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            width: size.width,
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: Color(0xffF4F7F5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.width / 20),
                Text(
                  '- ${widget.specification}',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: size.width * .038,
                      fontWeight: FontWeight.w500),
                ),
                widget.optionalSpecification==null?Container():Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0,),
                  width: size.width,
                    child: ListView.builder(
                      shrinkWrap: true,
                        itemCount: widget.optionalSpecification.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child:Text('- ${widget.optionalSpecification[index]}',style: TextStyle(color: Colors.black,
                              fontSize: size.width * .034,
                              fontWeight: FontWeight.w500,))

                          );
                        }
                        ),
                ),
                SizedBox(
                  height: size.width / 20,
                ),
              ],
            ),
          ),

        ],
    );
  }

  _buildExperinceAndFees(BuildContext context,String buildText){
    Size size=MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Text(buildText,style: TextStyle(fontSize: size.width * .036),),
    );
  }

}


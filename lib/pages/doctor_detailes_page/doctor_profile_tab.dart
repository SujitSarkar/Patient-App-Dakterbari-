import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_panel/pages/doctor_detailes_page/doctor_availability.dart';
import 'package:user_panel/pages/doctor_detailes_page/doctor_feedback.dart';
import 'package:user_panel/pages/doctor_detailes_page/doctor_profile.dart';
import 'package:user_panel/pages/doctor_detailes_page/faq_page.dart';
import 'package:user_panel/pages/subpage/appointment_page.dart';
import 'package:user_panel/provider/patient_provider.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:user_panel/provider/appointment_provider.dart';

// ignore: must_be_immutable
class DoctorDetailsTab extends StatefulWidget {
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
  String totalPrescribe;
  String countryCode;
  String currency;
  bool provideTeleService;
  List<dynamic> sat;
  List<dynamic> sun;
  List<dynamic> mon;
  List<dynamic> tue;
  List<dynamic> wed;
  List<dynamic> thu;
  List<dynamic> fri;

  DoctorDetailsTab(
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
        this.totalPrescribe,
        this.provideTeleService,
        this.currency,
        this.countryCode,
        this.sat,
        this.fri,
        this.mon,
        this.sun,
        this.thu,
        this.tue,
        this.wed});
  @override
  _DoctorDetailsTabState createState() => _DoctorDetailsTabState();
}

class _DoctorDetailsTabState extends State<DoctorDetailsTab> {
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    final PatientProvider patientProvider = Provider.of<PatientProvider>(context);
    final AppointmentProvider appointmentProvider = Provider.of<AppointmentProvider>(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.white,
        //backgroundColor: Color(0xffF4F7F5),
        appBar: AppBar(
          title: Text("Doctor Profile",style: TextStyle(fontSize: size.width*.05),),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.blue,
              unselectedLabelColor: Colors.white,
              labelStyle: TextStyle(
                fontSize: size.width * .03,
              ),
              tabs: [
                Tab(
                  icon: Icon(Icons.account_box,),
                  text: 'Profile',
                ),
                Tab(
                  icon: Icon(Icons.alarm,),
                  text: 'Availability',
                ),
                Tab(
                  icon: Icon(Icons.star),
                  text: 'Feedback',
                ),
                Tab(
                  icon: Icon(Icons.announcement_outlined),
                  text: 'FAQs',
                ),

              ]),
        ),
        body: Container(
          color: Colors.white,
          child: TabBarView(
              children: [
                DoctorProfile(
                  photoUrl:widget.photoUrl,
                  fullName:widget.fullName,
                  degree:widget.degree,
                  bmdcNumber:widget.bmdcNumber,
                  teleFee:widget.teleFee,
                  appFee:widget.appFee,
                  experience:widget.experience,
                  currency:widget.currency,
                  about:widget.about,
                  country:widget.country,
                  state:widget.state,
                  city:widget.city,
                  email:widget.email,
                  phone:widget.phone,
                  provideTeleService:widget.provideTeleService,
                  countryCode:widget.countryCode,
                  specification:widget.specification,
                  optionalSpecification:widget.optionalSpecification,

                ),
                DoctorAvailability(
                    sat:widget.sat,
                    sun:widget.sun,
                    mon:widget.mon,
                    tue:widget.tue,
                    wed:widget.wed,
                    thu:widget.thu,
                    fri:widget.fri,
                    provideTeleService:widget.provideTeleService,
                ),
                DoctorFeedback(
                  photoUrl:widget.photoUrl,
                  fullName:widget.fullName,
                  degree:widget.degree,
                  bmdcNumber:widget.bmdcNumber,
                  teleFee:widget.teleFee,
                  appFee:widget.appFee,
                  gender: widget.gender,
                  experience:widget.experience,
                  currency:widget.currency,
                  about:widget.about,
                  country:widget.country,
                  state:widget.state,
                  city:widget.city,
                  email:widget.email,
                  phone:widget.phone,
                  provideTeleService:widget.provideTeleService,
                  totalPrescribe:widget.totalPrescribe,
                  countryCode:widget.countryCode,
                  specification:widget.specification,
                  optionalSpecification:widget.optionalSpecification,
                ),
                FAQPage(),
              ]
          ),
        ),
        bottomNavigationBar: Container(
         // color: Colors.white,
          child: GestureDetector(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 8),
                height: size.width * .14,
                decoration: BoxDecoration(color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[300], blurRadius: 4, offset: Offset(2, 2))
                    ]),
              child: Center(child: Text("Book Your Appointment",style:TextStyle(color: Colors.white,fontSize: size.width * .040,fontWeight: FontWeight.bold),textAlign: TextAlign.center,))
            ),
            onTap: ()async{
              if(patientProvider.patientList.isEmpty){
                patientProvider.loadingMgs='Please wait...';
                showLoadingDialog(context,patientProvider);

                await patientProvider.getPatient().then((value){
                  appointmentProvider.appointmentDetailsModel=null;
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Appointment(
                      id: widget.id,
                      fullName:widget.fullName,
                      photoUrl: widget.photoUrl,
                      email: widget.email,
                      specification: widget.specification,
                      appFee: widget.appFee,
                      teleFee: widget.teleFee,
                      currency: widget.currency,
                      provideTeleService: widget.provideTeleService,
                      address: '${widget.country==null?'': '${widget.country},'}, ${widget.country==null?'': '${widget.state},'}, ${widget.country==null?'': '${widget.city},'}',
                      degree: widget.degree,
                      sat: widget.sat,
                      sun: widget.sun,
                      mon: widget.mon,
                      tue: widget.tue,
                      wed: widget.wed,
                      thu: widget.thu,
                      fri: widget.fri
                  )));
                });
              }
              else{
                appointmentProvider.appointmentDetailsModel=null;
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Appointment(
                    id: widget.id,
                    fullName:widget.fullName,
                    photoUrl: widget.photoUrl,
                    email: widget.email,
                    specification: widget.specification,
                    appFee: widget.appFee,
                    teleFee: widget.teleFee,
                    currency: widget.currency,
                    provideTeleService: widget.provideTeleService,
                    address: '${widget.country==null?'': '${widget.country},'}, ${widget.country==null?'': '${widget.state},'}, ${widget.country==null?'': '${widget.city},'}',
                    degree: widget.degree,
                    sat: widget.sat,
                    sun: widget.sun,
                    mon: widget.mon,
                    tue: widget.tue,
                    wed: widget.wed,
                    thu: widget.thu,
                    fri: widget.fri
                )));
              }

            },
          ),
        ),
      ),
    );
  }
}

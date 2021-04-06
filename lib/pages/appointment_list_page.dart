import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:user_panel/pages/all_doctors_category.dart';
import 'package:user_panel/pages/subpage/prescription_page.dart';
import 'package:user_panel/provider/appointment_provider.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:user_panel/widgets/button_widgets.dart';
import 'package:user_panel/shared/form_decoration.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AppointmentList extends StatefulWidget {
  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    AppointmentProvider appointmentProvider = Provider.of<AppointmentProvider>(context);

    return Scaffold(
      //backgroundColor: Color(0xffF4F7F5),
      backgroundColor: Color(0xffF4F7F5),
      appBar: customAppBarDesign(context,"Appointment List"),
      body: _bodyUI(appointmentProvider),
      bottomNavigationBar: GestureDetector(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 8),
          height: size.width * .13,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300], blurRadius: 4, offset: Offset(2, 2))
              ]),
          //padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Center(child: Text("Book Your Appointment",style:TextStyle(color: Colors.white,fontSize: size.width * .040,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),

        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MedicalDepartment()));
        },
      ),
    );
  }

  Widget _bodyUI(AppointmentProvider appointmentProvider) {
    return RefreshIndicator(
      backgroundColor: Colors.white,
      onRefresh: ()=> appointmentProvider.getAppointmentList(),
      child: AnimationLimiter(
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: appointmentProvider.appointmentList.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    verticalOffset: 400,
                    child: FadeInAnimation(
                      child: DoctorBuildersTile(
                        id: appointmentProvider.appointmentList[index].id,
                        drId: appointmentProvider.appointmentList[index].drId,
                        drName: appointmentProvider.appointmentList[index].drName,
                        drPhotoUrl: appointmentProvider.appointmentList[index].drPhotoUrl,
                        drDegree: appointmentProvider.appointmentList[index].drDegree,
                        drEmail: appointmentProvider.appointmentList[index].drEmail,
                        drAddress: appointmentProvider.appointmentList[index].drAddress,
                        specification: appointmentProvider.appointmentList[index].specification,
                        appFee: appointmentProvider.appointmentList[index].appFee,
                        teleFee: appointmentProvider.appointmentList[index].teleFee,
                        currency: appointmentProvider.appointmentList[index].currency,
                        pId:  appointmentProvider.appointmentList[index].pId,
                        pName: appointmentProvider.appointmentList[index].pName,
                        pPhotoUrl: appointmentProvider.appointmentList[index].pPhotoUrl,
                        pAddress: appointmentProvider.appointmentList[index].pAddress,
                        pAge: appointmentProvider.appointmentList[index].pAge,
                        pGender: appointmentProvider.appointmentList[index].pGender,
                        pProblem: appointmentProvider.appointmentList[index].pProblem,
                        bookingDate: appointmentProvider.appointmentList[index].bookingDate,
                        appointDate: appointmentProvider.appointmentList[index].appointDate,
                        chamberName: appointmentProvider.appointmentList[index].chamberName,
                        chamberAddress: appointmentProvider.appointmentList[index].chamberAddress,
                        bookingSchedule: appointmentProvider.appointmentList[index].bookingSchedule,
                        appointState: appointmentProvider.appointmentList[index].appointState,
                        actualProblem: appointmentProvider.appointmentList[index].actualProblem,
                        advice: appointmentProvider.appointmentList[index].advice,
                        rx: appointmentProvider.appointmentList[index].rx,
                        nextVisit: appointmentProvider.appointmentList[index].nextVisit,
                        prescribeDate: appointmentProvider.appointmentList[index].prescribeDate,
                        prescribeState: appointmentProvider.appointmentList[index].prescribeState,
                        prescribeNo:  appointmentProvider.appointmentList[index].prescribeNo,
                        medicines: appointmentProvider.appointmentList[index].medicines,
                      ),),
                  )
              );
            }
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class DoctorBuildersTile extends StatelessWidget {
  String id;
  String drId;
  String drName;
  String drPhotoUrl;
  String drDegree;
  String drEmail;
  String drAddress;
  String specification;
  String appFee;
  String teleFee;
  String currency;
  String prescribeDate;
  String prescribeState;
  String pId;
  String pName;
  String pPhotoUrl;
  String pAddress;
  String pAge;
  String pGender;
  String pProblem;
  String bookingDate;
  String appointDate;
  String chamberName;
  String chamberAddress;
  String bookingSchedule;
  String actualProblem;
  String rx;
  String advice;
  String nextVisit;
  String prescribeNo;
  String appointState; //telemedicine/chamber
  List<dynamic> medicines;

  DoctorBuildersTile({this.id,
    this.drId,
    this.drName,
    this.drPhotoUrl,
    this.drDegree,
    this.drEmail,
    this.drAddress,
    this.prescribeDate,
    this.pName,
    this.pId,
    this.pPhotoUrl,
    this.pAddress,
    this.pAge,
    this.pGender,
    this.pProblem,
    this.bookingDate,
    this.bookingSchedule,
    this.rx,
    this.advice,
    this.nextVisit,
    this.appointDate,
    this.appointState,
    this.medicines,
    this.chamberName,
    this.chamberAddress,
    this.specification,
    this.appFee,
    this.teleFee,
    this.currency,
    this.actualProblem,
    this.prescribeState,
    this.prescribeNo,
  });

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.only(bottom: 10,left: 3,right: 3 ),
        padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 10.0),
      width: size.width,
      height: size.width*.27,
        decoration: simpleCardDecoration,
        child: Row(
          children: [
            ///leading section
            Container(
              width: size.width * .20,
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: drPhotoUrl==null?
              Image.asset(
              "assets/home_icon/doctor.png", width: size.width*.19,height: size.width*.26 ,fit: BoxFit.cover):ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: drPhotoUrl,
                  placeholder: (context, url) => Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.asset('assets/loadingimage.gif',fit: BoxFit.cover,height: 100,),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: size.width * .20,
                  height: size.width*26,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 5,),
            ///middle section
            Container(
              width: size.width * .57,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text("With ", maxLines: 1,style: TextStyle(fontSize: size.width*.020,color: Colors.blueGrey),),
                      Expanded(
                        child: Text('$drName',
                          maxLines: 1,
                          style: TextStyle(fontSize: size.width*.038,color: Colors.black),),
                      ),
                    ],
                  ),
                  Text('${pProblem!=null? '$pProblem':'your problem'}',
                    maxLines: 1,
                    style: TextStyle(fontSize: size.width*.028,color: Colors.black),),

                  Text('${chamberName!=null? '$chamberName':'Chamber name'}',
                    maxLines: 1,
                    style: TextStyle(fontSize: size.width*.026,color: Colors.blueGrey),),

                  Text( 'Schedule: $bookingSchedule' ?? 'Time schudule',
                    maxLines: 1,
                    style: TextStyle(fontSize: size.width*.026,color: Colors.blueGrey),),


                  Text('ApointDate: $appointDate',
                    maxLines: 1,
                    style: TextStyle(fontSize: size.width*.026,color: Colors.blueGrey),),



                  Text('Booking on: $bookingDate',
                    maxLines: 1,
                    style: TextStyle(fontSize: size.width*.026,color: Colors.black),)
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: size.width*.14,
              //height: size.height,
              //color: Colors.red,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                      splashColor: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      onTap: (){Navigator.push(context,
                          MaterialPageRoute(builder: (context) => PrescriptionPage(
                            id: id,
                            drId:drId,
                            drName:drName,
                            drPhotoUrl:drPhotoUrl,
                            drDegree:drDegree,
                            drEmail:drEmail,
                            drAddress:drAddress,
                            prescribeDate:prescribeDate,
                            pName:pName,
                            pId:pId,
                            pPhotoUrl:pPhotoUrl,
                            pAddress:pAddress,
                            pAge:pAge,
                            pGender:pGender,
                            pProblem:pProblem,
                            bookingDate:bookingDate,
                            bookingSchedule:bookingSchedule,
                            rx:rx,
                            advice:advice,
                            nextVisit:nextVisit,
                            appointDate:appointDate,
                            appointState:appointState,
                            medicines:medicines,
                            chamberName:chamberName,
                            chamberAddress:chamberAddress,
                            specification:specification,
                            appFee:appFee,
                            teleFee:teleFee,
                            currency:currency,
                            actualProblem:actualProblem,
                            prescribeState:prescribeState,
                            prescribeNo:prescribeNo,

                          )));},
                      child: miniOutlineButton(context, 'View', Theme.of(context).primaryColor)
                  ),
                  prescribeState=='yes'?Text('Prescribed',
                    style: TextStyle(color: Theme.of(context).primaryColor,fontSize: size.width*.03,fontStyle: FontStyle.italic),)
                      :Text('Not prescribed',
                      style: TextStyle(color: Color(0xffFFBA00),fontSize: size.width*.03,fontStyle: FontStyle.italic))
                ],
              ),
            ),
          ],
        ),
      );
  }
}
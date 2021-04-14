import 'package:flutter/material.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:user_panel/shared/static_variable_page.dart';
import 'package:user_panel/shared/widget.dart';
import 'package:user_panel/provider/patient_provider.dart';
import 'package:user_panel/provider/appointment_provider.dart';
import 'package:provider/provider.dart';
import 'package:user_panel/provider/doctor_provider.dart';
import 'package:user_panel/widgets/no_data_widget.dart';
import 'package:user_panel/shared/form_decoration.dart';
import 'package:user_panel/widgets/button_widgets.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:user_panel/pages/subpage/make_appointment_payment_page.dart';

// ignore: must_be_immutable
class Appointment extends StatefulWidget {
  String id;String fullName;String email;String specification; String degree;String address;
  String appFee;String teleFee;String photoUrl;String currency;bool provideTeleService;
  List<dynamic> sat;List<dynamic> sun;List<dynamic> mon;List<dynamic> tue;
  List<dynamic> wed;List<dynamic> thu;List<dynamic> fri;

  Appointment({this.id, this.fullName, this.email, this.specification,this.degree,this.address,
    this.appFee, this.teleFee, this.photoUrl, this.provideTeleService,
    this.currency, this.sat, this.fri, this.mon, this.sun, this.thu, this.tue, this.wed});

  @override
  _AppointmentState createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  int _counter=0;
  String _email = '';
  String _checkingEmail = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _initializeData(AppointmentProvider appointmentProvider,PatientProvider patientProvider){
    setState(()=>_counter++);
    appointmentProvider.appointmentDetailsModel.pProblem='';
    appointmentProvider.appointmentDetailsModel.appointDate='';

    appointmentProvider.appointmentDetailsModel.drId=widget.id;
    appointmentProvider.appointmentDetailsModel.drName=widget.fullName;
    appointmentProvider.appointmentDetailsModel.drPhotoUrl=widget.photoUrl;
    appointmentProvider.appointmentDetailsModel.specification=widget.specification;
    appointmentProvider.appointmentDetailsModel.drDegree=widget.degree;
    appointmentProvider.appointmentDetailsModel.drEmail=widget.email;
    appointmentProvider.appointmentDetailsModel.drAddress=widget.address;
    appointmentProvider.appointmentDetailsModel.appFee=widget.appFee;
    appointmentProvider.appointmentDetailsModel.teleFee=widget.teleFee;
    appointmentProvider.appointmentDetailsModel.currency=widget.currency;
    print(appointmentProvider.appointmentDetailsModel.drDegree=widget.degree);
    _checkingEmail = patientProvider.patientList[0].email ??'';
    _email = patientProvider.patientList[0].email ??'';
  }

  @override
  Widget build(BuildContext context) {
    final AppointmentProvider appointmentProvider= Provider.of<AppointmentProvider>(context);
    final PatientProvider patientProvider= Provider.of<PatientProvider>(context);
    final DoctorProvider drProvider= Provider.of<DoctorProvider>(context);

    if(_counter==0) _initializeData(appointmentProvider,patientProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar:customAppBarDesign(context, "Book Your Appointment"),
      body: _bodyUI(appointmentProvider,patientProvider,drProvider),
    );
  }
  Widget _bodyUI(AppointmentProvider appointmentProvider,PatientProvider patientProvider,DoctorProvider drProvider){
    return Container(
      child: ListView(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
            margin: EdgeInsets.symmetric(horizontal: 10.0,),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Color(0xffF4F7F5),
            ),
            child:  Text('Patient:  ${patientProvider.patientList[0].fullName}',style: colonTextStyle(context),)
          ),
          SizedBox(height: 20.0),

          Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
              margin: EdgeInsets.symmetric(horizontal: 10.0,),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xffF4F7F5),
              ),
              child:  Text('Doctor:  ${widget.fullName}',style: colonTextStyle(context),)
          ),
          SizedBox(height: 20.0),

          _dropDownBuilder('Select Chamber',appointmentProvider),
          SizedBox(height: 10.0),

          ///Chamber List Builder
          appointmentProvider.appointmentDetailsModel.appointState=='Chamber or Hospital'
              && drProvider.hospitalList.isNotEmpty? _chamberBuilder(drProvider,appointmentProvider)
          :appointmentProvider.appointmentDetailsModel.appointState=='Online Video Consultation'?Container()
              :Container(),

          appointmentProvider.appointmentDetailsModel.appointState=='Chamber or Hospital'
              && drProvider.hospitalList.isEmpty?
          NoData(message:'No Chamber Available \u{1f614}'):Container(),
          SizedBox(height: 10.0),

          ///Chamber Schedule Builder
          appointmentProvider.appointmentDetailsModel.appointState=='Chamber or Hospital'
              && appointmentProvider.isHosClicked? _chamberScheduleBuilder(drProvider,appointmentProvider):Container(),

          ///TeleSchedule Builder
          appointmentProvider.appointmentDetailsModel.appointState=='Online Video Consultation' && widget.provideTeleService?
          _teleScheduleBuilder(appointmentProvider):Container(),

          appointmentProvider.appointmentDetailsModel.appointState=='Online Video Consultation' && !widget.provideTeleService?
          NoData(message:'Do not provide teleMedicine service \u{1f614}'):Container(),
          SizedBox(height: 10.0),

          ///Show Appointment Fee
          appointmentProvider.isHosClicked && appointmentProvider.appointmentDetailsModel.bookingSchedule!=null
            && appointmentProvider.appointmentDetailsModel.bookingSchedule!='Unavailable'?
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
              margin: EdgeInsets.only(left: 10,right: 10,bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xffF4F7F5),
              ),
              child:  Text('Appointment fee:  ${widget.appFee} ${widget.currency}',style: colonTextStyle(context),)
          ):Container(),

          ///Show tele Fee
          appointmentProvider.appointmentDetailsModel.appointState=='Online Video Consultation' &&
              appointmentProvider.appointmentDetailsModel.bookingSchedule!=null
              && appointmentProvider.appointmentDetailsModel.bookingSchedule!='Unavailable' && widget.provideTeleService?
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 15.0),
              margin: EdgeInsets.only(left: 10,right: 10,bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xffF4F7F5),
              ),
              child:  Text('Telemedicine service fee:  ${widget.teleFee} ${widget.currency}',style: colonTextStyle(context),)
          ):Container(),

          ///Appoint date
          appointmentProvider.appointmentDetailsModel.bookingSchedule!=null &&
              appointmentProvider.appointmentDetailsModel.bookingSchedule!='Unavailable'?
              Container(
                margin: EdgeInsets.only(bottom: 20),
                  child: _textFormBuilder('Appointment date', appointmentProvider)):Container(),

          ///Problem Container
          _textFormBuilder('Problems', appointmentProvider),
          SizedBox(height: 20),
          _checkingEmail.isEmpty || !_checkingEmail.contains('@') || !_checkingEmail.contains('.com')? _textFormBuilder('Enter your email address', appointmentProvider):Container(),
          SizedBox(height: 30),

          ///Get Appointment button
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              child: GestureDetector(
                onTap: ()=> _checkValidity(appointmentProvider, patientProvider,drProvider),
                  child: button(context,'Book Appointment')
              )
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }

  Widget _textFormBuilder(String hint, AppointmentProvider appointmentProvider){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child:TextFormField(
        keyboardType: TextInputType.text,
        decoration: FormDecorationWithoutPrefix.copyWith(
          alignLabelWithHint: true,
          labelText: hint,
          fillColor: Color(0xffF4F7F5)
        ),
        maxLines: hint=='Problems'? 5:1,
        onChanged: (val){
          hint=='Problems'? appointmentProvider.appointmentDetailsModel.pProblem=val
          :hint=='Appointment date'?appointmentProvider.appointmentDetailsModel.appointDate=val
              :_email=val;
        },
      ),
    );
  }

  Widget _dropDownBuilder(String hint, AppointmentProvider appointmentProvider){
    Size size=MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
      decoration: BoxDecoration(
          color: Color(0xffF4F7F5),
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      width: MediaQuery.of(context).size.width,
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: appointmentProvider.appointmentDetailsModel.appointState,
          hint: Container(
            width:size.width*.75,
            child: Text(hint,style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16)),
          ),
          items:
          StaticVariables.chamberCategory.map((chamber){
            return DropdownMenuItem(
              child: Container(
                width:size.width*.75,
                child: Text(chamber,style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 16,)),
              ),
              value: chamber,
            );
          }).toList(),
          onChanged: (newValue){
            setState(()=>appointmentProvider.appointmentDetailsModel.appointState = newValue);


            //Remove previous Chamber name and booking schedule...
            appointmentProvider.isHosClicked=false;
            appointmentProvider.chamberIndex=null;
            appointmentProvider.chamberScheduleIndex=null;
            appointmentProvider.teleScheduleIndex=null;
            appointmentProvider.appointmentDetailsModel.chamberName=null;
            appointmentProvider.appointmentDetailsModel.chamberAddress=null;
            appointmentProvider.appointmentDetailsModel.bookingSchedule=null;
            },
          dropdownColor: Colors.white,
        ),
      ),
    );
  }

  Widget _chamberBuilder(DoctorProvider drProvider,AppointmentProvider appointmentProvider){
    return Container(
      color: Colors.white,
      height: 70,
      margin: EdgeInsets.only(left: 10.0,right: 10,bottom: 10),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: drProvider.hospitalList.length,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: (){
              appointmentProvider.chamberIndex=index;
              appointmentProvider.isHosClicked=true;
              appointmentProvider.appointmentDetailsModel.chamberName = drProvider.hospitalList[index].hospitalName;
              appointmentProvider.appointmentDetailsModel.chamberAddress = drProvider.hospitalList[index].hospitalAddress;

              //Remove previous booking schedule...
              appointmentProvider.appointmentDetailsModel.bookingSchedule=null;
              appointmentProvider.isScheduleClicked=false;

            },
            child: Container(
              alignment: Alignment.center,
              width: 200,
                margin: EdgeInsets.only(right: 20),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: appointmentProvider.isHosClicked && appointmentProvider.chamberIndex==index? Theme.of(context).primaryColor: Color(0xffF4F7F5),
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        '${drProvider.hospitalList[index].hospitalName}',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                          color: appointmentProvider.isHosClicked && appointmentProvider.chamberIndex==index? Colors.white: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                    Text(
                        '${drProvider.hospitalList[index].hospitalAddress}',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                          color: appointmentProvider.isHosClicked && appointmentProvider.chamberIndex==index? Colors.white: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                          fontSize: 10),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }

  Widget _chamberScheduleBuilder(DoctorProvider drProvider,AppointmentProvider appointmentProvider){
    return Container(
      color: Colors.white,
      height: 45,
      margin: EdgeInsets.only(left: 10.0,right: 10,bottom: 10),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: (){
              appointmentProvider.isScheduleClicked=true;
              appointmentProvider.chamberScheduleIndex=index;

              appointmentProvider.appointmentDetailsModel.bookingSchedule =
                  index==0? '${drProvider.hospitalList[appointmentProvider.chamberIndex].sat==null? 'Unavailable'
                  :'Sat: ''${drProvider.hospitalList[appointmentProvider.chamberIndex].sat[0]} - ${drProvider.hospitalList[appointmentProvider.chamberIndex].sat[1]}'}'
                  :index==1?'${drProvider.hospitalList[appointmentProvider.chamberIndex].sun==null? 'Unavailable'
                  :'Sun: ''${drProvider.hospitalList[appointmentProvider.chamberIndex].sun[0]} - ${drProvider.hospitalList[appointmentProvider.chamberIndex].sun[1]}'}'
                  :index==2?'${drProvider.hospitalList[appointmentProvider.chamberIndex].mon==null? 'Unavailable'
                  :'Mon: ''${drProvider.hospitalList[appointmentProvider.chamberIndex].mon[0]} - ${drProvider.hospitalList[appointmentProvider.chamberIndex].mon[1]}'}'
                  :index==3?'${drProvider.hospitalList[appointmentProvider.chamberIndex].tue==null? 'Unavailable'
                  :'Tue: ''${drProvider.hospitalList[appointmentProvider.chamberIndex].tue[0]} - ${drProvider.hospitalList[appointmentProvider.chamberIndex].tue[1]}'}'
                  :index==4?'${drProvider.hospitalList[appointmentProvider.chamberIndex].wed==null? 'Unavailable'
                  :'Wed: ''${drProvider.hospitalList[appointmentProvider.chamberIndex].wed[0]} - ${drProvider.hospitalList[appointmentProvider.chamberIndex].wed[1]}'}'
                  :index==5?'${drProvider.hospitalList[appointmentProvider.chamberIndex].thu==null? 'Unavailable'
                  :'Thu: ''${drProvider.hospitalList[appointmentProvider.chamberIndex].thu[0]} - ${drProvider.hospitalList[appointmentProvider.chamberIndex].thu[1]}'}'
                  :'${drProvider.hospitalList[appointmentProvider.chamberIndex].fri==null? 'Unavailable'
                  :'Fri: ''${drProvider.hospitalList[appointmentProvider.chamberIndex].fri[0]} - ${drProvider.hospitalList[appointmentProvider.chamberIndex].fri[1]}'}';

              // print(appointmentProvider.appointmentDetailsModel.appointState);
              // print(appointmentProvider.appointmentDetailsModel.chamberName);
              // print(appointmentProvider.appointmentDetailsModel.bookingSchedule);

            },
            child: Container(
                alignment: Alignment.center,
                width: 100,
                margin: EdgeInsets.only(right: 20),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color:appointmentProvider.isScheduleClicked && appointmentProvider.chamberScheduleIndex==index
                      && appointmentProvider.appointmentDetailsModel.bookingSchedule!='Unavailable'? Theme.of(context).primaryColor: Color(0xffF4F7F5),
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    Text(
                      index==0?'Sat':index==1?'Sun':index==2?'Mon'
                          :index==3?'Tue':index==4?'Wed':index==5?'Thu':'Fri',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: appointmentProvider.isScheduleClicked && appointmentProvider.chamberScheduleIndex==index
                          && appointmentProvider.appointmentDetailsModel.bookingSchedule!='Unavailable'? Colors.white :Colors.grey[800],fontWeight: FontWeight.w500,fontSize: 13),
                    ),
                    Text(
                      index==0? '${drProvider.hospitalList[appointmentProvider.chamberIndex].sat==null? 'Unavailable'
                          :'${drProvider.hospitalList[appointmentProvider.chamberIndex].sat[0]} - ${drProvider.hospitalList[appointmentProvider.chamberIndex].sat[1]}'}'
                          :index==1?'${drProvider.hospitalList[appointmentProvider.chamberIndex].sun==null? 'Unavailable'
                          :'${drProvider.hospitalList[appointmentProvider.chamberIndex].sun[0]} - ${drProvider.hospitalList[appointmentProvider.chamberIndex].sun[1]}'}'
                          :index==2?'${drProvider.hospitalList[appointmentProvider.chamberIndex].mon==null? 'Unavailable'
                          :'${drProvider.hospitalList[appointmentProvider.chamberIndex].mon[0]} - ${drProvider.hospitalList[appointmentProvider.chamberIndex].mon[1]}'}'
                          :index==3?'${drProvider.hospitalList[appointmentProvider.chamberIndex].tue==null? 'Unavailable'
                          :'${drProvider.hospitalList[appointmentProvider.chamberIndex].tue[0]} - ${drProvider.hospitalList[appointmentProvider.chamberIndex].tue[1]}'}'
                          :index==4?'${drProvider.hospitalList[appointmentProvider.chamberIndex].wed==null? 'Unavailable'
                          :'${drProvider.hospitalList[appointmentProvider.chamberIndex].wed[0]} - ${drProvider.hospitalList[appointmentProvider.chamberIndex].wed[1]}'}'
                          :index==5?'${drProvider.hospitalList[appointmentProvider.chamberIndex].thu==null? 'Unavailable'
                          :'${drProvider.hospitalList[appointmentProvider.chamberIndex].thu[0]} - ${drProvider.hospitalList[appointmentProvider.chamberIndex].thu[1]}'}'
                          :'${drProvider.hospitalList[appointmentProvider.chamberIndex].fri==null? 'Unavailable'
                          :'${drProvider.hospitalList[appointmentProvider.chamberIndex].fri[0]} - ${drProvider.hospitalList[appointmentProvider.chamberIndex].fri[1]}'}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: appointmentProvider.isScheduleClicked && appointmentProvider.chamberScheduleIndex==index
                          && appointmentProvider.appointmentDetailsModel.bookingSchedule!='Unavailable'? Colors.white: Colors.grey[800],fontWeight: FontWeight.w500,fontSize: 12),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }

  Widget _teleScheduleBuilder(AppointmentProvider appointmentProvider){
    return Container(
      color: Colors.white,
      height: 45,
      margin: EdgeInsets.only(left: 10.0,right: 10,bottom: 10),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (context, index){
          return GestureDetector(
            onTap: (){
              appointmentProvider.appointmentDetailsModel.chamberName=null;
              appointmentProvider.teleScheduleIndex=index;

              appointmentProvider.appointmentDetailsModel.bookingSchedule =
              index==0? '${widget.sat==null? 'Unavailable'
                  :'Sat: ''${widget.sat[0]} - ${widget.sat[1]}'}'
                  :index==1?'${widget.sun==null? 'Unavailable'
                  :'Sun: ''${widget.sun[0]} - ${widget.sun[1]}'}'
                  :index==2?'${widget.mon==null? 'Unavailable'
                  :'Mon: ''${widget.mon[0]} - ${widget.mon[1]}'}'
                  :index==3?'${widget.tue==null? 'Unavailable'
                  :'Tue: ''${widget.tue[0]} - ${widget.tue[1]}'}'
                  :index==4?'${widget.wed==null? 'Unavailable'
                  :'Wed: ''${widget.wed[0]} - ${widget.wed[1]}'}'
                  :index==5?'${widget.thu==null? 'Unavailable'
                  :'Thu: ''${widget.thu[0]} - ${widget.thu[1]}'}'
                  :'${widget.fri==null? 'Unavailable'
                  :'Fri: ''${widget.fri[0]} - ${widget.fri[1]}'}';
              // print(appointmentProvider.appointmentDetailsModel.chamberName);
              // print(appointmentProvider.appointmentDetailsModel.appointState);
              // print(appointmentProvider.appointmentDetailsModel.bookingSchedule);

            },
            child: Container(
                alignment: Alignment.center,
                width: 110,
                margin: EdgeInsets.only(right: 20),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color:appointmentProvider.teleScheduleIndex==index
                      && appointmentProvider.appointmentDetailsModel.bookingSchedule!='Unavailable'? Theme.of(context).primaryColor: Color(0xffF4F7F5),
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    Text(
                      index==0?'Sat':index==1?'Sun':index==2?'Mon'
                          :index==3?'Tue':index==4?'Wed':index==5?'Thu':'Fri',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: appointmentProvider.teleScheduleIndex==index
                          && appointmentProvider.appointmentDetailsModel.bookingSchedule!='Unavailable'?Colors.white: Colors.grey[800],fontWeight: FontWeight.w500,fontSize: 13),
                    ),
                    Text(
                      index==0? '${widget.sat==null? 'Unavailable'
                          :'${widget.sat[0]} - ${widget.sat[1]}'}'
                          :index==1?'${widget.sun==null? 'Unavailable'
                          :'${widget.sun[0]} - ${widget.sun[1]}'}'
                          :index==2?'${widget.mon==null? 'Unavailable'
                          :'${widget.mon[0]} - ${widget.mon[1]}'}'
                          :index==3?'${widget.tue==null? 'Unavailable'
                          :'${widget.tue[0]} - ${widget.tue[1]}'}'
                          :index==4?'${widget.wed==null? 'Unavailable'
                          :'${widget.wed[0]} - ${widget.wed[1]}'}'
                          :index==5?'${widget.thu==null? 'Unavailable'
                          :'${widget.thu[0]} - ${widget.thu[1]}'}'
                          :'${widget.fri==null? 'Unavailable'
                          :'${widget.fri[0]} - ${widget.fri[1]}'}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: appointmentProvider.teleScheduleIndex==index
                          && appointmentProvider.appointmentDetailsModel.bookingSchedule!='Unavailable'?Colors.white: Colors.grey[800],fontWeight: FontWeight.w500,fontSize: 12),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }

  Future<void> _checkValidity(AppointmentProvider appointmentProvider,PatientProvider patientProvider,DoctorProvider drProvider)async{
    if(appointmentProvider.appointmentDetailsModel.appointState=='Chamber or Hospital'){
      if(appointmentProvider.appointmentDetailsModel.chamberName!=null){
        if(appointmentProvider.appointmentDetailsModel.bookingSchedule!=null &&
            appointmentProvider.appointmentDetailsModel.bookingSchedule!='Unavailable'){
          if(appointmentProvider.appointmentDetailsModel.appointDate!='' &&
              appointmentProvider.appointmentDetailsModel.pProblem!=''){
            if(_email.contains('@') && _email.contains('.com')){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MakeAppointmentPayment(
                appointmentProvider: appointmentProvider,
                patientProvider: patientProvider,
                email: _email,
              )));
            }else showSnackBar(_scaffoldKey,'Invalid email address, update your first',Colors.deepOrange);
          }else showSnackBar(_scaffoldKey,'Define appoint date & your problems',Colors.deepOrange);
        }else showSnackBar(_scaffoldKey,'Select Booking Schedule',Colors.deepOrange);
      }else showSnackBar(_scaffoldKey,'Select Chamber or Hospital',Colors.deepOrange);
    }
    else{
      if(appointmentProvider.appointmentDetailsModel.bookingSchedule!=null &&
          appointmentProvider.appointmentDetailsModel.bookingSchedule!='Unavailable'){
        if(appointmentProvider.appointmentDetailsModel.appointDate!='' &&
            appointmentProvider.appointmentDetailsModel.pProblem!=''){
          if(_email.contains('@') && _email.contains('.com')){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MakeAppointmentPayment(
              appointmentProvider: appointmentProvider,
              patientProvider: patientProvider,
              email: _email,
            )));
          }else showSnackBar(_scaffoldKey,'Invalid email address, update your first',Colors.deepOrange);
        }else showSnackBar(_scaffoldKey,'Define appoint date & your problems',Colors.deepOrange);
      }else showSnackBar(_scaffoldKey,'Select Booking Schedule',Colors.deepOrange);
    }
  }
}


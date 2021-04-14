import 'package:flutter/material.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:aamarpay/aamarpay.dart';
import 'package:user_panel/widgets/button_widgets.dart';
import 'package:user_panel/provider/appointment_provider.dart';
import 'package:user_panel/provider/patient_provider.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:user_panel/provider/doctor_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_panel/shared/form_decoration.dart';

// ignore: must_be_immutable
class MakeAppointmentPayment extends StatefulWidget {

  AppointmentProvider appointmentProvider;
  PatientProvider patientProvider;
  String email;

  MakeAppointmentPayment(
      {this.appointmentProvider, this.patientProvider,this.email});

  @override
  _MakeAppointmentPaymentState createState() => _MakeAppointmentPaymentState();
}

class _MakeAppointmentPaymentState extends State<MakeAppointmentPayment> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _payableAmount;
  String _transactionId;
  dynamic _dollarUnit;
  bool loading=true;
  String pId;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAppointChargeAndDollarUnit();
  }

  Future<void> getAppointChargeAndDollarUnit()async{
    pId = await widget.appointmentProvider.getPreferenceId();
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Amount')
        .where('id', isEqualTo: '123456').get();
    final List<QueryDocumentSnapshot> amount = snapshot.docs;

    _dollarUnit = int.parse(amount[0].get('dollarUnit'));

    if(widget.appointmentProvider.appointmentDetailsModel.appointState == 'Chamber or Hospital')
      _payableAmount = amount[0].get('amountCharge');

    else if(widget.appointmentProvider.appointmentDetailsModel.appointState ==
        'Online Video Consultation' && widget.appointmentProvider.appointmentDetailsModel.currency=='US Dollar')
      _payableAmount = (double.parse(widget.appointmentProvider.appointmentDetailsModel.teleFee) * _dollarUnit).toString();

    else if (widget.appointmentProvider.appointmentDetailsModel.appointState ==
        'Online Video Consultation' && widget.appointmentProvider.appointmentDetailsModel.currency=='BD Taka')
      _payableAmount = widget.appointmentProvider.appointmentDetailsModel.teleFee;

    _transactionId = widget.patientProvider.patientList[0].id+DateTime.now().millisecondsSinceEpoch.toString();

    setState(()=>loading=false);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: customAppBarDesign(context, 'Confirm Payment'),
      body: loading? Center(child: CircularProgressIndicator()): _bodyUI(),
    );
  }

  Widget _bodyUI() {
    bool isLoading = false;
    return Consumer<DoctorProvider>(
      builder: (context, drProvider, child){
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                ///Book Appointment information section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    ///heading Section
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      decoration: cardDecoration,
                      child: Text(
                          '${widget.patientProvider.patientList[0].gender == 'Male' ? 'Mr.' : 'Mrs.'} '
                              '${widget.patientProvider.patientList[0].fullName} is making appointment with Dr. ${widget.appointmentProvider.appointmentDetailsModel.drName}',
                      style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 18,fontWeight: FontWeight.w500),textAlign: TextAlign.center,),
                    ),
                    SizedBox(height: 20),

                   ///Middle Section
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      decoration: cardDecoration,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _rowBuilder('Appointment Type: ', widget.appointmentProvider.appointmentDetailsModel.appointState),

                          widget.appointmentProvider.appointmentDetailsModel.appointState=='Chamber or Hospital'?
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: _rowBuilder('Hospital/Chamber: ', widget.appointmentProvider.appointmentDetailsModel.chamberName)
                          ):Container(),

                          widget.appointmentProvider.appointmentDetailsModel.appointState=='Chamber or Hospital'?
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: _rowBuilder('Hospital/Chamber Address: ', widget.appointmentProvider.appointmentDetailsModel.chamberAddress),
                          ):Container(),

                          SizedBox(height: 10),
                          _rowBuilder('Booking Schedule: ', widget.appointmentProvider.appointmentDetailsModel.bookingSchedule),
                          SizedBox(height: 10),

                          _rowBuilder('Appoint Date: ', widget.appointmentProvider.appointmentDetailsModel.appointDate),
                          SizedBox(height: 10),

                          _rowBuilder('Problems: ', widget.appointmentProvider.appointmentDetailsModel.pProblem),

                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                      decoration: cardDecoration,
                      child: Text('Pay $_payableAmount BD Taka to confirm your appointment. \nThank you.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xffF0A732),fontSize: 15)),
                    )

                  ],
                ),
                SizedBox(height: 30),
                AamarpayData(
                    returnUrl: (url) async{
                      // setState(()=> _isLoading = false);
                      if (url == 'https://secure.aamarpay.com/cancel')
                        showSnackBar(
                            _scaffoldKey, 'Payment canceled', Colors.deepOrange);
                      if (url == 'https://secure.aamarpay.com/fail')
                        showSnackBar(
                            _scaffoldKey, 'Payment failed', Colors.deepOrange);
                      if (url == 'https://secure.aamarpay.com/confirm'){
                        widget.appointmentProvider.loadingMgs='Booking appointment...';
                        showLoadingDialog(context, widget.appointmentProvider);
                        await widget.appointmentProvider.savePaymentInfoAndConfirmAppointment(drProvider,widget.appointmentProvider, widget.patientProvider,
                            _payableAmount, _transactionId, context, _scaffoldKey);
                      }
                    },
                    isLoading: (v) {
                      setState(() {
                        isLoading = true;
                      });
                    },
                    paymentStatus: (status) {
                      print(status);
                    },
                    cancelUrl: "/cancel",
                    successUrl: "/confirm",
                    failUrl: "/fail",
                    customerEmail: widget.email,
                    customerMobile: '$pId',
                    customerName: '${widget.patientProvider.patientList[0].fullName}',
                    signature: "44180c54f52b3050884279c17d91bd04",
                    storeID: "dakterbari",
                    transactionAmount: _payableAmount,
                    transactionID: _transactionId,
                    // description: "asgsg",
                    url: "https://secure.aamarpay.com",
                    child: isLoading
                        ? Center(
                      child: CircularProgressIndicator(),
                    )
                        : Container(
                      //color: Colors.orange,
                      margin: EdgeInsets.only(bottom: 10),
                      height: 50,
                      child: button(context,
                          'Pay $_payableAmount BD Tk' ),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _rowBuilder(String title, String content){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title',style: titleStyle),
        Expanded(child: Text('$content',style: contentStyle,))
      ],
    );
  }

  final TextStyle titleStyle = TextStyle(
   color: Colors.grey[900],
   fontWeight: FontWeight.w500,
   fontSize: 14
  );
  final TextStyle contentStyle = TextStyle(
      color: Color(0xff810043),
      fontWeight: FontWeight.w400,
      fontSize: 14
  );
}

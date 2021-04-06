import 'package:user_panel/provider/doctor_provider.dart';
import 'package:user_panel/provider/reg_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:user_panel/model/appointment_model.dart';
import 'package:user_panel/provider/patient_provider.dart';
import 'package:intl/intl.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentProvider extends RegAuth {
  List<AppointmentDetailsModel> _appointmentList = List<AppointmentDetailsModel>();
  AppointmentDetailsModel _appointmentDetailsModel = AppointmentDetailsModel();

  List<bool> _starList = [false,false,false,false,false];
  int _reviewCounter;

  bool _isHosClicked = false;
  bool _isScheduleClicked = false;
  int _chamberIndex;
  int _chamberScheduleIndex;
  int _teleScheduleIndex;

  get chamberIndex => _chamberIndex;
  get chamberScheduleIndex => _chamberScheduleIndex;
  get teleScheduleIndex => _teleScheduleIndex;
  get isHosClicked => _isHosClicked;
  get isScheduleClicked => _isScheduleClicked;
  get starList => _starList;

  get appointmentDetailsModel => _appointmentDetailsModel;
  get appointmentList => _appointmentList;

  set isHosClicked(bool val) {
    _isHosClicked = val;
    notifyListeners();
  }

  set isScheduleClicked(bool val) {
    _isScheduleClicked = val;
    notifyListeners();
  }

  set chamberIndex(int val) {
    _chamberIndex = val;
    notifyListeners();
  }

  set chamberScheduleIndex(int val) {
    _chamberScheduleIndex = val;
    notifyListeners();
  }

  set teleScheduleIndex(int val) {
    _teleScheduleIndex = val;
    notifyListeners();
  }

  set appointmentDetailsModel(AppointmentDetailsModel model) {
    model = AppointmentDetailsModel();
    _appointmentDetailsModel = model;
    notifyListeners();
  }

  void changeStarColor(int index){
    _starList = [false,false,false,false,false];
    _reviewCounter=index+1;
    notifyListeners();
    for(int i=index;i>=0;i--){
      _starList[i]=true;
    }
    notifyListeners();
  }


  Future<void> savePaymentInfoAndConfirmAppointment(
      DoctorProvider drProvider,
      AppointmentProvider appointmentProvider,
      PatientProvider patientProvider,
      String amount,
      String transactionId,
      BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey) async {

    final int timeStamp = DateTime.now().millisecondsSinceEpoch;
    final String bookingDate = DateFormat("dd-MMM-yyyy")
        .format(DateTime.fromMillisecondsSinceEpoch(timeStamp))
        .toString();

    final String patientId = await appointmentProvider.getPreferenceId();
    final String appointId = patientId + timeStamp.toString();

    await FirebaseFirestore.instance
        .collection('AppointmentPaymentDetails').doc(transactionId).set({
     'id': transactionId,
     'pId': patientId,
     'pName': patientProvider.patientList[0].fullName,
     'drId': appointmentProvider.appointmentDetailsModel.drId,
     'drName': appointmentProvider.appointmentDetailsModel.drName,
     'transactionId': transactionId,
     'amount': amount,
      'currency': appointmentProvider.appointmentDetailsModel.currency,
     'takenService': appointmentProvider.appointmentDetailsModel.appointState,
     'paymentDate': bookingDate,
     'timeStamp': timeStamp.toString(),

    }).then((value)async{
      await FirebaseFirestore.instance
          .collection('AppointmentList')
          .doc(appointId)
          .set({
        'id': appointId,
        'drId': appointmentProvider.appointmentDetailsModel.drId,
        'drName': appointmentProvider.appointmentDetailsModel.drName,
        'drPhotoUrl': appointmentProvider.appointmentDetailsModel.drPhotoUrl,
        'drDegree': appointmentProvider.appointmentDetailsModel.drDegree,
        'drEmail': appointmentProvider.appointmentDetailsModel.drEmail,
        'drAddress': appointmentProvider.appointmentDetailsModel.drAddress,
        'specification':
        appointmentProvider.appointmentDetailsModel.specification,
        'appFee': appointmentProvider.appointmentDetailsModel.appointState ==
            'Online Video Consultation'
            ? null
            : appointmentProvider.appointmentDetailsModel.appFee,
        'teleFee': appointmentProvider.appointmentDetailsModel.appointState ==
            'Chamber or Hospital'
            ? null
            : appointmentProvider.appointmentDetailsModel.teleFee,
        'currency': appointmentProvider.appointmentDetailsModel.currency,
        'prescribeDate': null,
        'prescribeState':'no',
        'pId': patientId,
        'pName': patientProvider.patientList[0].fullName,
        'pPhotoUrl': patientProvider.patientList[0].imageUrl,
        'pAddress': patientProvider.patientList[0].country == null
            ? null
            : '${patientProvider.patientList[0].country}, ${patientProvider.patientList[0].state}, ${patientProvider.patientList[0].city}',
        'pAge': patientProvider.patientList[0].age,
        'pGender': patientProvider.patientList[0].gender,
        'pProblem': appointmentProvider.appointmentDetailsModel.pProblem,
        'bookingDate': bookingDate,
        'appointDate': appointmentProvider.appointmentDetailsModel.appointDate,
        'chamberName': appointmentProvider.appointmentDetailsModel.chamberName,
        'chamberAddress':
        appointmentProvider.appointmentDetailsModel.appointState ==
            'Online Video Consultation'
            ? null
            : appointmentProvider.appointmentDetailsModel.chamberAddress,
        'bookingSchedule':
        appointmentProvider.appointmentDetailsModel.bookingSchedule,
        'actualProblem': null,
        'rx': null,
        'advice': null,
        'nextVisit': null,
        'appointState': appointmentProvider.appointmentDetailsModel.appointState,
        'medicines': null,
        'prescribeNo': null,
        'reviewComment': null,
        'reviewStar': null,
        'reviewDate': null,
        'reviewTimeStamp':null,
        'timeStamp': timeStamp.toString(),
      }).then((value) async{
          if(appointmentProvider.appointmentDetailsModel.appointState == 'Online Video Consultation'){
            await drProvider.getDoctor(appointmentProvider.appointmentDetailsModel.drId).then((value)async{
              await FirebaseFirestore.instance.collection('Doctors').doc(appointmentProvider.appointmentDetailsModel.drId).update({
                'totalTeleFee': drProvider.doctorList[0].totalTeleFee==null? appointmentProvider.appointmentDetailsModel.teleFee
                    : (int.parse(drProvider.doctorList[0].totalTeleFee)+int.parse(appointmentProvider.appointmentDetailsModel.teleFee)).toString(),
              }).then((value)async{
                await getAppointmentList();
                Navigator.pop(context);
                Navigator.pop(context);
                showAlertDialog(context, 'Appointment booking successful');
              },onError: (error){
                Navigator.pop(context);
                showSnackBar(scaffoldKey, error.toString(), Colors.deepOrange);
              });
          },onError:(error){
              Navigator.pop(context);
              showSnackBar(scaffoldKey, error.toString(), Colors.deepOrange);
            });
          }else{
            await getAppointmentList();
            Navigator.pop(context);
            Navigator.pop(context);
            showAlertDialog(context, 'Appointment booking successful');
          }
      }, onError: (error) {
        Navigator.pop(context);
        showSnackBar(scaffoldKey, error.toString(), Colors.deepOrange);
      });
    },onError: (error){
      Navigator.pop(context);
      showSnackBar(scaffoldKey, error.toString(), Colors.deepOrange);
    });

  }

  Future<void> getAppointmentList()async{
    try{
      await getPreferenceId().then((pId)async{
        await FirebaseFirestore.instance.collection('AppointmentList').where('pId',isEqualTo: pId).orderBy('timeStamp',descending: true).get().then((snapshot){
          _appointmentList.clear();
          snapshot.docChanges.forEach((element) {
            AppointmentDetailsModel appointmentDetailsModel=AppointmentDetailsModel(
              id: element.doc['id'],
              drId: element.doc['drId'],
              drName: element.doc['drName'],
              drPhotoUrl: element.doc['drPhotoUrl'],
              drDegree: element.doc['drDegree'],
              drEmail: element.doc['drEmail'],
              drAddress: element.doc['drAddress'],
              specification: element.doc['specification'],
              appFee: element.doc['appFee'],
              teleFee: element.doc['teleFee'],
              currency: element.doc['currency'],
              prescribeDate: element.doc['prescribeDate'],
              prescribeState: element.doc['prescribeState'],
              pId: element.doc['pId'],
              pName: element.doc['pName'],
              pPhotoUrl: element.doc['pPhotoUrl'],
              pAddress: element.doc['pAddress'],
              pAge: element.doc['pAge'],
              pGender: element.doc['pGender'],
              pProblem: element.doc['pProblem'],
              actualProblem: element.doc['actualProblem'],
              bookingDate: element.doc['bookingDate'],
              appointDate: element.doc['appointDate'],
              chamberName: element.doc['chamberName'],
              chamberAddress: element.doc['chamberAddress'],
              bookingSchedule: element.doc['bookingSchedule'],
              rx: element.doc['rx'],
              advice: element.doc['advice'],
              nextVisit: element.doc['nextVisit'],
              appointState: element.doc['appointState'],
              medicines: element.doc['medicines'],
              timeStamp: element.doc['timeStamp'],
              prescribeNo: element.doc['prescribeNo'],
            );
            _appointmentList.add(appointmentDetailsModel);
          });
        });
      });
      notifyListeners();
    }catch(error){}
  }


  Future<void> submitReview(String appId, String reviewComment,BuildContext context, GlobalKey<ScaffoldState> scaffoldKey)async{
    final int reviewTimeStamp=DateTime.now().millisecondsSinceEpoch;
    await FirebaseFirestore.instance.collection('AppointmentList').doc(appId).update({
     'reviewStar': _reviewCounter.toString(),
     'reviewComment': reviewComment,
     'reviewDate': DateFormat("dd-MMM-yyyy").format(DateTime.fromMillisecondsSinceEpoch(reviewTimeStamp)).toString(),
     'reviewTimeStamp': reviewTimeStamp.toString(),
    }).then((value){
      Navigator.pop(context);
      Navigator.pop(context);
      showSnackBar(scaffoldKey,'Review submitted successful',Theme.of(context).primaryColor);
    },onError: (error){
      Navigator.pop(context);
      Navigator.pop(context);
      showSnackBar(scaffoldKey,error.toString(),Colors.deepOrange);
    });
  }
}

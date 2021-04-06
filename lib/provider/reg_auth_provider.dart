import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_panel/model/patient_model.dart';

class RegAuth extends ChangeNotifier{
  PatientDetailsModel _patientDetails =PatientDetailsModel();

  bool _agreeChk = false;
  bool _obscure = true;
  bool _isLoading = false;
  String _loadingMgs;
  String _verificationCode;



  get patientDetails=>_patientDetails;
  get agreeChk => _agreeChk;

  get obscure => _obscure;

  get isLoading => _isLoading;

  get loadingMgs => _loadingMgs;

  get verificationCode => _verificationCode;

  set patientDetails(PatientDetailsModel model){
    model=PatientDetailsModel();
    _patientDetails=model;
    notifyListeners();
  }

  set agreeChk(bool val){
    _agreeChk=val;
    notifyListeners();
  }
  set obscure(bool val) {
    _obscure = val;
    notifyListeners();
  }

  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
  set loadingMgs(String val){
    _loadingMgs=val;
    notifyListeners();
  }
  set verificationCode(String val) {
    _verificationCode = val;
    notifyListeners();
  }

  Future <String> getPreferenceId()async{
    SharedPreferences pref=await SharedPreferences.getInstance();
    return pref.getString('id');
  }
  /// is Patient registared
  Future<bool> isPatientRegistered(String id)async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Patients')
        .where('id', isEqualTo: id).get();
    final List<QueryDocumentSnapshot> user = snapshot.docs;
    if(user.isEmpty){
      loadingMgs ="";
      return false;
    }else{
      loadingMgs ="";
      return true;
    }
  }
  ///is doctor registared
  Future<bool> isDoctorRegistered(String id)async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Doctors')
        .where('id', isEqualTo: id).get();
    final List<QueryDocumentSnapshot> user = snapshot.docs;
    if(user.isEmpty){
      loadingMgs ="";
      return false;
    }else{
      loadingMgs ="";
      return true;
    }
  }

  ///patient Registration
   Future<bool>registerUser(PatientDetailsModel patientDetails) async{
    try {
      String date=DateFormat("dd-MMM-yyyy/hh:mm:aa").format(DateTime.
      fromMicrosecondsSinceEpoch(DateTime.now().microsecondsSinceEpoch));

      SharedPreferences preferences = await SharedPreferences.getInstance();

      await preferences.setString("id", patientDetails.countryCode+patientDetails.phone);
      await preferences.setString('pass', patientDetails.password);
      final String id=patientDetails.countryCode+patientDetails.phone.trim();
     await FirebaseFirestore.instance.collection('Patients').doc(id).set({
     'id': id,
     'name': patientDetails.fullName,
     'phone': patientDetails.phone,
     'password': patientDetails.password,
     'email': patientDetails.email,
     'joinDate': date,
     'gender': patientDetails.gender,
     'country': patientDetails.country,
     'state': patientDetails.state,
     'city': patientDetails.city,
     'currency': patientDetails.currency,
     'imageUrl': patientDetails.imageUrl,
     'address': patientDetails.address,
     'bloodGroup': patientDetails.bloodGroup,
     'countryCode': patientDetails.countryCode,
     'age': patientDetails.age,
     'takenTeleService': patientDetails.takenTeleService,
     });
     return true;
      }
    catch(e){
      return false;
    }
   }


}
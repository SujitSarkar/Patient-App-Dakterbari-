import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_panel/model/patient_model.dart';
import 'package:user_panel/provider/reg_auth_provider.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:user_panel/model/notification_model.dart';

class PatientProvider extends RegAuth{

  List<PatientDetailsModel> _patientList=List<PatientDetailsModel>();
  List<NotificationModel> _notificationList = List<NotificationModel>();

  get patientList=>_patientList;
  get notificationList=>_notificationList;

  void clearPatientList(){
    _patientList.clear();
    notifyListeners();
  }

  Future <void> getPatient()async{
    final String id = await getPreferenceId();
    try{
      await FirebaseFirestore.instance.collection('Patients')
          .where('id',isEqualTo: id).get().then((snapShot){
            _patientList.clear();
            snapShot.docChanges.forEach((element) {
              PatientDetailsModel patients=PatientDetailsModel(
                id: element.doc['id'],
                fullName: element.doc['name'],
                phone: element.doc['phone'],
                password: element.doc['password'],
                email: element.doc['email'],
                joinDate: element.doc['joinDate'],
                gender: element.doc['gender'],
                country: element.doc['country'],
                state: element.doc['state'],
                city: element.doc['city'],
                currency: element.doc['currency'],
                imageUrl: element.doc['imageUrl'],
                address: element.doc['address'],
                bloodGroup: element.doc['bloodGroup'],
                countryCode: element.doc['countryCode'],
                age: element.doc['age'],
                takenTeleService: element.doc['takenTeleService'],
              );
              _patientList.add(patients);
            });
      });
      print("Length: "+_patientList.length.toString());
      notifyListeners();
    }
    catch(error){}
  }

  Future<void> updatePatientProfilePhoto(GlobalKey<ScaffoldState> scaffoldKey, BuildContext context, PatientProvider operation, File imageFile)async{
    final id = await getPreferenceId();
    firebase_storage.Reference storageReference =
    firebase_storage.FirebaseStorage.instance.ref().child('Patients Photo').child(id);

    firebase_storage.UploadTask storageUploadTask = storageReference.putFile(imageFile);

    firebase_storage.TaskSnapshot taskSnapshot;
    storageUploadTask.then((value) {
      taskSnapshot = value;
      taskSnapshot.ref.getDownloadURL().then((newImageDownloadUrl){
        final imageUrl = newImageDownloadUrl;
        FirebaseFirestore.instance.collection('Patients').doc(id).update({
          'imageUrl':imageUrl,
        }).then((value)async{
          await operation.getPatient();
          Navigator.pop(context);
          showSnackBar(scaffoldKey, 'Profile photo updated',Theme.of(context).primaryColor);
        });
      },onError: (error){
        Navigator.pop(context);
        showSnackBar(scaffoldKey, error.toString(), Colors.deepOrange);
      });
    },onError: (error){
      Navigator.pop(context);
      showSnackBar(scaffoldKey, error.toString(), Colors.deepOrange);
    });

  }

  Future<void> updatePatientInformation(PatientProvider operation,GlobalKey<ScaffoldState> scaffoldKey,BuildContext context)async{
    await FirebaseFirestore.instance.collection('Patients').doc(operation.patientList[0].id).update({
      'name':operation.patientDetails.fullName.isEmpty? operation.patientList[0].fullName :operation.patientDetails.fullName,
      'email':operation.patientDetails.email.isEmpty? operation.patientList[0].email :operation.patientDetails.email,
      'age':operation.patientDetails.age.isEmpty? operation.patientList[0].age :operation.patientDetails.age,

      'bloodGroup':operation.patientDetails.bloodGroup,
      'country':operation.patientDetails.country.isEmpty? operation.patientList[0].country :operation.patientDetails.country,
      'state':operation.patientDetails.state.isEmpty? operation.patientList[0].state :operation.patientDetails.state,
      'city':operation.patientDetails.city.isEmpty? operation.patientList[0].city :operation.patientDetails.city,
    }).then((value)async{
      operation.patientList[0].fullName= operation.patientDetails.fullName.isEmpty? operation.patientList[0].fullName :operation.patientDetails.fullName;
      operation.patientList[0].email= operation.patientDetails.email.isEmpty? operation.patientList[0].email :operation.patientDetails.email;
      operation.patientList[0].age= operation.patientDetails.age.isEmpty? operation.patientList[0].age :operation.patientDetails.age;
      operation.patientList[0].bloodGroup = operation.patientDetails.bloodGroup;
      operation.patientList[0].country= operation.patientDetails.country.isEmpty? operation.patientList[0].country :operation.patientDetails.country;
      operation.patientList[0].state= operation.patientDetails.state.isEmpty? operation.patientList[0].state :operation.patientDetails.state;
      operation.patientList[0].city= operation.patientDetails.city.isEmpty? operation.patientList[0].city :operation.patientDetails.city;
      notifyListeners();
      Navigator.pop(context);
      showSnackBar(scaffoldKey,'Updated successful',Theme.of(context).primaryColor);

    },onError: (error){
      Navigator.pop(context);
      showSnackBar(scaffoldKey,error.toString(), Colors.deepOrange);
    });
  }


  Future<void> sendMessageToAdmin(BuildContext context,GlobalKey<ScaffoldState> scaffoldKey,String name,String email,String message)async{

    final String pId = await getPreferenceId();
    final int timeStamp = DateTime.now().millisecondsSinceEpoch;
    final String problemId= pId+timeStamp.toString();
    final String submitDate= DateFormat("dd-MMM-yyyy/hh:mm:aa").format(DateTime.fromMillisecondsSinceEpoch(timeStamp));

    await FirebaseFirestore.instance.collection('UserProblems').doc(problemId).set({
      'id':problemId,
      'submitDate': submitDate,
      'messageFrom': 'patient',
      'name': name,
      'email':email,
      'message':message,
      'phone': pId,
      'timeStamp': timeStamp.toString()
    }).then((value){
      Navigator.pop(context);
      showSnackBar(scaffoldKey,'Message successfully sent to Authority',Theme.of(context).primaryColor);
    },onError: (error){
      Navigator.pop(context);
      showSnackBar(scaffoldKey,error.toString(),Colors.deepOrange);
    });
  }



  Future<void> getNotification()async{
    try{
      FirebaseFirestore.instance.collection('Notifications').where('category',isEqualTo: 'Patient').orderBy('id',descending: true).get().then((snapshot){
        _notificationList.clear();
        snapshot.docChanges.forEach((element) {
          NotificationModel model = NotificationModel(
            id: element.doc['id'],
            category: element.doc['category'],
            date: element.doc['date'],
            message: element.doc['message'],
            title: element.doc['title'],
          );
          _notificationList.add(model);
        });
      });
      notifyListeners();
      print('notification');
    }catch(error){}
  }

  Future<String> updatePatientPassword(String id,PatientProvider drProvider,GlobalKey<ScaffoldState> scaffoldKey,BuildContext context)async{
    try{
      await FirebaseFirestore.instance.collection('Patients').doc(id).update({
        'password': drProvider.patientDetails.password,
      });
      return null;
    }catch(error){
      return error.toString();
    }
  }


}
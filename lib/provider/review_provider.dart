import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_panel/model/appointment_model.dart';
import 'dart:math';

import 'package:user_panel/provider/reg_auth_provider.dart';

class ReviewProvider extends RegAuth{

  List<AppointmentDetailsModel> _allReviewList = List();

  int _totalAppointment;
  int _oneStar=0;
  int _twoStar=0;
  int _threeStar=0;
  int _fourStar=0;
  int _fiveStar=0;
  double _avgRating=0.0;

  get totalAppointment=> _totalAppointment;
  get allReviewList=> _allReviewList;
  get oneStar=> _oneStar;
  get twoStar=> _twoStar;
  get threeStar=> _threeStar;
  get fourStar=> _fourStar;
  get fiveStar=> _fiveStar;
  get avgRating=> _avgRating;

  Future<void> getTotalAppointment(String drId)async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('AppointmentList')
        .where('drId',isEqualTo: drId).get();
    final List<QueryDocumentSnapshot> counter = snapshot.docs;
    if(counter.isNotEmpty){
      _totalAppointment = counter.length;
      notifyListeners();
    }else{
      _totalAppointment = 0;
      notifyListeners();
    }
  }
  
  Future<void> getAllReview(String drId)async{
    try{
      await FirebaseFirestore.instance.collection('AppointmentList').where('drId',isEqualTo: drId).orderBy('reviewTimeStamp',descending: true).get().then((snapshot){
        _allReviewList.clear();
        snapshot.docChanges.forEach((element) {
          if(element.doc['reviewStar']!=null){
            AppointmentDetailsModel appointmentDetailsModel = AppointmentDetailsModel(
              pName: element.doc[ 'pName'],
              pPhotoUrl: element.doc['pPhotoUrl'],
              pProblem: element.doc['pProblem'],
              reviewStar: element.doc['reviewStar'],
              reviewComment: element.doc['reviewComment'],
              reviewDate: element.doc['reviewDate'],
            );
            _allReviewList.add(appointmentDetailsModel);
          }
        });
      });
      notifyListeners();
    }catch(error){}
  }

  void getOneStar(){
     _oneStar=0;
     _twoStar=0;
     _threeStar=0;
     _fourStar=0;
     _fiveStar=0;
    _avgRating=0.0;

    for(int i=0; i<_allReviewList.length; i++){
      if(_allReviewList[i].reviewStar=='1') _oneStar++;

      if(_allReviewList[i].reviewStar=='2') _twoStar++;

      if(_allReviewList[i].reviewStar=='3') _threeStar++;

      if(_allReviewList[i].reviewStar=='4') _fourStar++;

      if(_allReviewList[i].reviewStar=='5') _fiveStar++;
    }
     getAvgRating();
  }

  void getAvgRating(){
    if(_allReviewList.length!=0){
      double tempAvgRating = ((1*_oneStar)+(2*_twoStar)+(3*_threeStar)+(4*_fourStar)+(5*_fiveStar))/_allReviewList.length;
      _avgRating = roundDouble(tempAvgRating, 1);
      notifyListeners();
    }else{
      _avgRating=0.0;
      notifyListeners();
    }
  }

  double roundDouble(double value, int places){
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

}
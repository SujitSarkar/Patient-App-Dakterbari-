import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:user_panel/model/forum_model.dart';
import 'package:user_panel/provider/patient_provider.dart';
import 'package:user_panel/provider/reg_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:user_panel/model/forum_ans_model.dart';

class ForumProvider extends RegAuth {

  List<ForumModel> _myQuesList = List();
  List<ForumModel> _allQuesList = List();
  List<ForumAnsModel> _answerList = List();

  get myQuesList=> _myQuesList;
  get allQuesList=> _allQuesList;

  get answerList=> _answerList;

  Future<void> getMyQuestionList()async{
    try{
      final String pId= await getPreferenceId();
      await FirebaseFirestore.instance.collection('ForumQuestions').where('patientId',isEqualTo: pId).orderBy('timeStamp',descending: true).get().then((snapshot){
        _myQuesList.clear();
        snapshot.docChanges.forEach((element) {
          ForumModel forumModel = ForumModel(
            id: element.doc['id'],
            patientId: element.doc['patientId'],
            patientPhotoUrl: element.doc['patientPhotoUrl'],
            quesDate: element.doc['quesDate'],
            question: element.doc['question'],
            totalAns: element.doc['totalAns'],
          );
          _myQuesList.add(forumModel);
        });
      });
      notifyListeners();
      print(_myQuesList.length);

    }catch(error){}
  }

  Future<void> getAllQuestionList()async{
    try{
      await FirebaseFirestore.instance.collection('ForumQuestions').orderBy('timeStamp',descending: true).get().then((snapshot){
        _allQuesList.clear();
        snapshot.docChanges.forEach((element) {
          ForumModel forumModel = ForumModel(
            id: element.doc['id'],
            patientId: element.doc['patientId'],
            patientPhotoUrl: element.doc['patientPhotoUrl'],
            quesDate: element.doc['quesDate'],
            question: element.doc['question'],
            totalAns: element.doc['totalAns'],
          );
          _allQuesList.add(forumModel);
        });
      });
      notifyListeners();
      print(_allQuesList.length);

    }catch(error){}
  }

  Future<void> getForumAnswer(String quesId)async{
    try{
      await FirebaseFirestore.instance.collection('ForumAnswers').where('quesId', isEqualTo: quesId).orderBy('timeStamp',descending: true).get().then((snapshot)async{
        _answerList.clear();
        snapshot.docChanges.forEach((element) {
          ForumAnsModel forumAnsModel = ForumAnsModel(
            id: element.doc['id'],
            quesId: element.doc['quesId'],
            drId: element.doc['drId'],
            drName: element.doc['drName'],
            drPhotoUrl: element.doc['drPhotoUrl'],
            drDegree: element.doc['drDegree'],
            answer: element.doc['answer'],
            ansDate: element.doc['ansDate'],
            timeStamp: element.doc['timeStamp'],
          );
          _answerList.add(forumAnsModel);
        });
      });
      notifyListeners();
    }catch(error){}

  }

  Future<void> submitForumQues(PatientProvider patientProvider,ForumProvider forumProvider,String question, BuildContext context, GlobalKey<ScaffoldState> scaffoldKey)async{
    final String pId= await getPreferenceId();
    final int timeStamp= DateTime.now().millisecondsSinceEpoch;
    final forumId= pId+timeStamp.toString();

    await FirebaseFirestore.instance.collection('ForumQuestions').doc(forumId).set({
     'id':forumId,
     'patientId':pId,
     'patientPhotoUrl': patientProvider.patientList[0].imageUrl,
     'quesDate': DateFormat("dd-MMM-yyyy").format(DateTime.fromMillisecondsSinceEpoch(timeStamp)).toString(),
     'question': question,
     'totalAns':null,
     'timeStamp': timeStamp.toString()
    }).then((value){
      ForumModel forumModel=ForumModel(
        id: forumId,
        patientId: pId,
        patientPhotoUrl: patientProvider.patientList[0].imageUrl,
        quesDate: DateFormat("dd-MMM-yyyy").format(DateTime.fromMillisecondsSinceEpoch(timeStamp)).toString(),
        question: question,
        totalAns: null,
        timeStamp: timeStamp.toString(),
      );
      _myQuesList.add(forumModel);
      _allQuesList.add(forumModel);
      notifyListeners();
      Navigator.pop(context);
      Navigator.pop(context);
      showSnackBar(scaffoldKey, 'Question submitted successful', Theme.of(context).primaryColor);

    },onError: (error){
      Navigator.pop(context);
      Navigator.pop(context);
      showSnackBar(scaffoldKey, error.toString(), Colors.deepOrange);
    });
  }
}
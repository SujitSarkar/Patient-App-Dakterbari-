import 'dart:io';
import 'package:flutter/material.dart';
import'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import 'package:user_panel/model/article_comment_model.dart';
import 'package:user_panel/model/article_model.dart';
import 'package:user_panel/provider/doctor_provider.dart';
import 'package:user_panel/provider/reg_auth_provider.dart';
import 'package:user_panel/widgets/notification_widget.dart';

class ArticleProvider extends RegAuth{

  ArticleModel _articleModel = ArticleModel();

  List<ArticleModel> _allArticleList=List<ArticleModel>();
  List<ArticleModel> _newsArticleList=List<ArticleModel>();
  List<ArticleModel> _diseasesArticleList=List<ArticleModel>();
  List<ArticleModel> _healthArticleList=List<ArticleModel>();
  List<ArticleModel> _foodArticleList=List<ArticleModel>();
  List<ArticleModel> _medicineArticleList=List<ArticleModel>();
  List<ArticleModel> _medicareArticleList=List<ArticleModel>();
  List<ArticleModel> _tourismArticleList=List<ArticleModel>();
  List<ArticleModel> _symptomsArticleList=List<ArticleModel>();
  List<ArticleModel> _visualArticleList=List<ArticleModel>();

  List<ArticleModel> _popularArticleList=List<ArticleModel>();


  List<ArticleCommentModel> _articleCommentList=List<ArticleCommentModel>();

  get articleModel=> _articleModel;

  get allArticleList => _allArticleList;
  get newsArticleList => _newsArticleList;
  get diseasesArticleList => _diseasesArticleList;
  get healthArticleList => _healthArticleList;
  get foodArticleList => _foodArticleList;
  get medicineArticleList => _medicineArticleList;
  get medicareArticleList => _medicareArticleList;
  get tourismArticleList => _tourismArticleList;
  get symptomsArticleList => _symptomsArticleList;
  get visualArticleList => _visualArticleList;

  get popularArticleList => _popularArticleList;


  get articleCommentList => _articleCommentList;

  set articleModel(ArticleModel model){
    model = ArticleModel();
    _articleModel = model;
    notifyListeners();
  }

  void clearAllArticleList(){
    _allArticleList.clear();
    _newsArticleList.clear();
    _diseasesArticleList.clear();
    _healthArticleList.clear();
    _foodArticleList.clear();
    _medicineArticleList.clear();
    _medicareArticleList.clear();
    _tourismArticleList.clear();
    _symptomsArticleList.clear();
    _visualArticleList.clear();
    _popularArticleList.clear();
    notifyListeners();
  }


  Future<void> submitArticle(ArticleProvider provider,DoctorProvider drProvider,File articleImage,BuildContext context, GlobalKey<ScaffoldState> scaffoldKey)async{
    final String id= drProvider.doctorList[0].id+DateTime.now().millisecondsSinceEpoch.toString();
    final String date= DateFormat("dd-MMM-yyyy").format(DateTime.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch));
    firebase_storage.Reference storageReference =
    firebase_storage.FirebaseStorage.instance.ref().child('Article Photo').child(id);

    firebase_storage.UploadTask storageUploadTask = storageReference.putFile(articleImage);

    firebase_storage.TaskSnapshot taskSnapshot;
    storageUploadTask.then((value) {
      taskSnapshot = value;
      taskSnapshot.ref.getDownloadURL().then((newImageDownloadUrl){
        final photoUrl = newImageDownloadUrl;
        FirebaseFirestore.instance.collection('Articles').doc(id).set({
          'id':id,
          'photoUrl':photoUrl,
          'date':date,
          'timeStamp': DateTime.now().millisecondsSinceEpoch.toString(),
          'title':provider.articleModel.title,
          'author':drProvider.doctorList[0].fullName,
          'like':null,
          'share':null,
          'category':provider.articleModel.category,
          'abstract':provider.articleModel.abstract,
          'introduction':provider.articleModel.introduction,
          'methods':provider.articleModel.methods,
          'results':provider.articleModel.results,
          'conclusion':provider.articleModel.conclusion,
          'acknowledgement':provider.articleModel.acknowledgement,
          'reference':provider.articleModel.reference,
          'doctorId':drProvider.doctorList[0].id,
          'authorPhoto':drProvider.doctorList[0].photoUrl,
          'state': 'pending',
        }).then((value)async{
          Navigator.pop(context);
          Navigator.pop(context);
          showAlertDialog(context, 'Article successfully submitted');
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

  Future<void> getAllArticle()async{
    try{
      await FirebaseFirestore.instance.collection('Articles').where('state',isEqualTo: 'approved').orderBy('timeStamp',descending: true).get().then((snapshot){
        _allArticleList.clear();
        _newsArticleList.clear();
        _diseasesArticleList.clear();
        _healthArticleList.clear();
        _foodArticleList.clear();
        _medicineArticleList.clear();
        _medicareArticleList.clear();
        _tourismArticleList.clear();
        _symptomsArticleList.clear();
        _visualArticleList.clear();

        snapshot.docChanges.forEach((element) {
          ArticleModel articleModel = ArticleModel(
            id: element.doc['id'],
            photoUrl: element.doc['photoUrl'],
            date: element.doc['date'],
            title: element.doc['title'],
            author: element.doc['author'],
            authorPhoto: element.doc['authorPhoto'],
            like: element.doc['like'],
            share: element.doc['share'],
            category: element.doc['category'],
            abstract: element.doc['abstract'],
            introduction: element.doc['introduction'],
            methods: element.doc['methods'],
            results: element.doc['results'],
            conclusion: element.doc['conclusion'],
            acknowledgement: element.doc['acknowledgement'],
            reference: element.doc['reference'],
            doctorId: element.doc['doctorId'],
          );
          _allArticleList.add(articleModel);
        });
        notifyListeners();
      }).then((value)async{
        final String doctorId= await getPreferenceId();

        for(int i=0; i<_allArticleList.length;i++){

          ///News Articles
          if(_allArticleList[i].category=='News'){
            ArticleModel articleModel = ArticleModel(
              id: _allArticleList[i].id,
              photoUrl: _allArticleList[i].photoUrl,
              date: _allArticleList[i].date,
              title: _allArticleList[i].title,
              author: _allArticleList[i].author,
              authorPhoto: _allArticleList[i].authorPhoto,
              like: _allArticleList[i].like,
              share: _allArticleList[i].share,
              category: _allArticleList[i].category,
              abstract: _allArticleList[i].abstract,
              introduction: _allArticleList[i].introduction,
              methods: _allArticleList[i].methods,
              results: _allArticleList[i].results,
              conclusion: _allArticleList[i].conclusion,
              acknowledgement: _allArticleList[i].acknowledgement,
              reference: _allArticleList[i].reference,
              doctorId: _allArticleList[i].doctorId,
            );
            _newsArticleList.add(articleModel);
          }

          ///Diseases
          if(_allArticleList[i].category=='Diseases & Cause'){
            ArticleModel articleModel = ArticleModel(
              id: _allArticleList[i].id,
              photoUrl: _allArticleList[i].photoUrl,
              date: _allArticleList[i].date,
              title: _allArticleList[i].title,
              author: _allArticleList[i].author,
              authorPhoto: _allArticleList[i].authorPhoto,
              like: _allArticleList[i].like,
              share: _allArticleList[i].share,
              category: _allArticleList[i].category,
              abstract: _allArticleList[i].abstract,
              introduction: _allArticleList[i].introduction,
              methods: _allArticleList[i].methods,
              results: _allArticleList[i].results,
              conclusion: _allArticleList[i].conclusion,
              acknowledgement: _allArticleList[i].acknowledgement,
              reference: _allArticleList[i].reference,
              doctorId: _allArticleList[i].doctorId,
            );
            _diseasesArticleList.add(articleModel);
          }

          ///Health
          if(_allArticleList[i].category=='Health Tips'){
            ArticleModel articleModel = ArticleModel(
              id: _allArticleList[i].id,
              photoUrl: _allArticleList[i].photoUrl,
              date: _allArticleList[i].date,
              title: _allArticleList[i].title,
              author: _allArticleList[i].author,
              authorPhoto: _allArticleList[i].authorPhoto,
              like: _allArticleList[i].like,
              share: _allArticleList[i].share,
              category: _allArticleList[i].category,
              abstract: _allArticleList[i].abstract,
              introduction: _allArticleList[i].introduction,
              methods: _allArticleList[i].methods,
              results: _allArticleList[i].results,
              conclusion: _allArticleList[i].conclusion,
              acknowledgement: _allArticleList[i].acknowledgement,
              reference: _allArticleList[i].reference,
              doctorId: _allArticleList[i].doctorId,
            );
            _healthArticleList.add(articleModel);
          }

          ///Food
          if(_allArticleList[i].category=='Food & Nutrition'){
            ArticleModel articleModel = ArticleModel(
              id: _allArticleList[i].id,
              photoUrl: _allArticleList[i].photoUrl,
              date: _allArticleList[i].date,
              title: _allArticleList[i].title,
              author: _allArticleList[i].author,
              authorPhoto: _allArticleList[i].authorPhoto,
              like: _allArticleList[i].like,
              share: _allArticleList[i].share,
              category: _allArticleList[i].category,
              abstract: _allArticleList[i].abstract,
              introduction: _allArticleList[i].introduction,
              methods: _allArticleList[i].methods,
              results: _allArticleList[i].results,
              conclusion: _allArticleList[i].conclusion,
              acknowledgement: _allArticleList[i].acknowledgement,
              reference: _allArticleList[i].reference,
              doctorId: _allArticleList[i].doctorId,
            );
            _foodArticleList.add(articleModel);
          }

          ///Medicine
          if(_allArticleList[i].category=='Medicine & Treatment'){
            ArticleModel articleModel = ArticleModel(
              id: _allArticleList[i].id,
              photoUrl: _allArticleList[i].photoUrl,
              date: _allArticleList[i].date,
              title: _allArticleList[i].title,
              author: _allArticleList[i].author,
              authorPhoto: _allArticleList[i].authorPhoto,
              like: _allArticleList[i].like,
              share: _allArticleList[i].share,
              category: _allArticleList[i].category,
              abstract: _allArticleList[i].abstract,
              introduction: _allArticleList[i].introduction,
              methods: _allArticleList[i].methods,
              results: _allArticleList[i].results,
              conclusion: _allArticleList[i].conclusion,
              acknowledgement: _allArticleList[i].acknowledgement,
              reference: _allArticleList[i].reference,
              doctorId: _allArticleList[i].doctorId,
            );
            _medicineArticleList.add(articleModel);
          }

          ///Medicare
          if(_allArticleList[i].category=='Medicare & Hospital'){
            ArticleModel articleModel = ArticleModel(
              id: _allArticleList[i].id,
              photoUrl: _allArticleList[i].photoUrl,
              date: _allArticleList[i].date,
              title: _allArticleList[i].title,
              author: _allArticleList[i].author,
              authorPhoto: _allArticleList[i].authorPhoto,
              like: _allArticleList[i].like,
              share: _allArticleList[i].share,
              category: _allArticleList[i].category,
              abstract: _allArticleList[i].abstract,
              introduction: _allArticleList[i].introduction,
              methods: _allArticleList[i].methods,
              results: _allArticleList[i].results,
              conclusion: _allArticleList[i].conclusion,
              acknowledgement: _allArticleList[i].acknowledgement,
              reference: _allArticleList[i].reference,
              doctorId: _allArticleList[i].doctorId,
            );
            _medicareArticleList.add(articleModel);
          }

          ///Tourism
          if(_allArticleList[i].category=='Tourism & Cost'){
            ArticleModel articleModel = ArticleModel(
              id: _allArticleList[i].id,
              photoUrl: _allArticleList[i].photoUrl,
              date: _allArticleList[i].date,
              title: _allArticleList[i].title,
              author: _allArticleList[i].author,
              authorPhoto: _allArticleList[i].authorPhoto,
              like: _allArticleList[i].like,
              share: _allArticleList[i].share,
              category: _allArticleList[i].category,
              abstract: _allArticleList[i].abstract,
              introduction: _allArticleList[i].introduction,
              methods: _allArticleList[i].methods,
              results: _allArticleList[i].results,
              conclusion: _allArticleList[i].conclusion,
              acknowledgement: _allArticleList[i].acknowledgement,
              reference: _allArticleList[i].reference,
              doctorId: _allArticleList[i].doctorId,
            );
            _tourismArticleList.add(articleModel);
          }

          ///Symptoms
          if(_allArticleList[i].category=='Symptoms'){
            ArticleModel articleModel = ArticleModel(
              id: _allArticleList[i].id,
              photoUrl: _allArticleList[i].photoUrl,
              date: _allArticleList[i].date,
              title: _allArticleList[i].title,
              author: _allArticleList[i].author,
              authorPhoto: _allArticleList[i].authorPhoto,
              like: _allArticleList[i].like,
              share: _allArticleList[i].share,
              category: _allArticleList[i].category,
              abstract: _allArticleList[i].abstract,
              introduction: _allArticleList[i].introduction,
              methods: _allArticleList[i].methods,
              results: _allArticleList[i].results,
              conclusion: _allArticleList[i].conclusion,
              acknowledgement: _allArticleList[i].acknowledgement,
              reference: _allArticleList[i].reference,
              doctorId: _allArticleList[i].doctorId,
            );
            _symptomsArticleList.add(articleModel);
          }

          ///Visual
          if(_allArticleList[i].category=='Visual Story'){
            ArticleModel articleModel = ArticleModel(
              id: _allArticleList[i].id,
              photoUrl: _allArticleList[i].photoUrl,
              date: _allArticleList[i].date,
              title: _allArticleList[i].title,
              author: _allArticleList[i].author,
              authorPhoto: _allArticleList[i].authorPhoto,
              like: _allArticleList[i].like,
              share: _allArticleList[i].share,
              category: _allArticleList[i].category,
              abstract: _allArticleList[i].abstract,
              introduction: _allArticleList[i].introduction,
              methods: _allArticleList[i].methods,
              results: _allArticleList[i].results,
              conclusion: _allArticleList[i].conclusion,
              acknowledgement: _allArticleList[i].acknowledgement,
              reference: _allArticleList[i].reference,
              doctorId: _allArticleList[i].doctorId,
            );
            _visualArticleList.add(articleModel);
          }

        }// end for loop
        notifyListeners();

      });
    }catch(error){}
  }


  Future<void> getPopularArticle() async{
    try{
      await FirebaseFirestore.instance.collection('Articles').where('state',isEqualTo: 'approved').orderBy('like',descending: true).get().then((snapshot){
        _popularArticleList.clear();
        snapshot.docChanges.forEach((element) {
          ArticleModel articleModel = ArticleModel(
            id: element.doc['id'],
            photoUrl: element.doc['photoUrl'],
            date: element.doc['date'],
            title: element.doc['title'],
            author: element.doc['author'],
            authorPhoto: element.doc['authorPhoto'],
            like: element.doc['like'],
            share: element.doc['share'],
            category: element.doc['category'],
            abstract: element.doc['abstract'],
            introduction: element.doc['introduction'],
            methods: element.doc['methods'],
            results: element.doc['results'],
            conclusion: element.doc['conclusion'],
            acknowledgement: element.doc['acknowledgement'],
            reference: element.doc['reference'],
            doctorId: element.doc['doctorId'],
          );
          _popularArticleList.add(articleModel);
        });
      });
      notifyListeners();
    }catch(error){}
  }


  Future<void> getArticleComments(String articleId) async{
    try{
      _articleCommentList.clear();
      await FirebaseFirestore.instance.collection('ArticleComments').where('articleId',isEqualTo: articleId).orderBy('timeStamp',descending: true).get().then((snapshot){
        snapshot.docChanges.forEach((element) {
          ArticleCommentModel articleCommentModel = ArticleCommentModel(
            id: element.doc['id'],
            articleId: element.doc['articleId'],
            commenterName: element.doc['commenterName'],
            commenterPhoto: element.doc['commenterPhoto'],
            commentDate: element.doc['commentDate'],
            comment: element.doc['comment'],
          );
          _articleCommentList.add(articleCommentModel);
        });
      });
      notifyListeners();
    }catch(error){}
  }


  Future<void> writeComment(String articleId, String commenterId, String commenterName,
      String commenterPhoto, String comment, BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) async{
    final int timeStamp = DateTime.now().millisecondsSinceEpoch;
    final String id = commenterId+timeStamp.toString();
    final String commentDate =  DateFormat("dd-MMM-yyyy").format(DateTime.fromMillisecondsSinceEpoch(timeStamp)).toString();
    await FirebaseFirestore.instance.collection('ArticleComments').doc(id).set({
      'id':id,
      'articleId':articleId,
      'commenterName':commenterName,
      'commenterPhoto':commenterPhoto,
      'comment': comment,
      'timeStamp': timeStamp.toString(),
      'commentDate': commentDate
    }).then((value){
      ArticleCommentModel articleCommentModel = ArticleCommentModel(
          id: id,
          articleId: articleId,
          commenterName: commenterName,
          commenterPhoto: commenterPhoto,
          commentDate: commentDate,
          comment: comment,
          timeStamp: timeStamp.toString()
      );
      _articleCommentList.add(articleCommentModel);
      notifyListeners();
      Navigator.pop(context);
      showSnackBar(scaffoldKey,'Commented on this article', Theme.of(context).primaryColor);
    },onError: (error){
      Navigator.pop(context);
      showSnackBar(scaffoldKey,'Something went wrong. Try again', Colors.deepOrange);
    });
  }


  Future<void> likeArticle(String category,String articleId,BuildContext context, GlobalKey<ScaffoldState> scaffoldKey, String like)async{
    await FirebaseFirestore.instance.collection('Articles').doc(articleId).update({
      'like':like,
    }).then((value)async{
      await getAllArticle();
      await getPopularArticle();

      Navigator.pop(context);
      showSnackBar(scaffoldKey, 'You liked this article', Theme.of(context).primaryColor);
    },onError: (error){
      Navigator.pop(context);
      showSnackBar(scaffoldKey, error.toString(), Colors.deepOrange);
    });
  }

  Future<void> shareArticle(String category,String articleId,BuildContext context, GlobalKey<ScaffoldState> scaffoldKey, String share)async{
    await FirebaseFirestore.instance.collection('Articles').doc(articleId).update({
      'share':share,
    }).then((value)async{
      await getAllArticle();
      await getPopularArticle();

      Navigator.pop(context);
      showSnackBar(scaffoldKey, 'Thanks for sharing this article', Theme.of(context).primaryColor);
    },onError: (error){
      Navigator.pop(context);
      showSnackBar(scaffoldKey, error.toString(), Colors.deepOrange);
    });
  }

}
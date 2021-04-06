import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:user_panel/provider/reg_auth_provider.dart';
import 'package:user_panel/model/discount_shop_model.dart';
import 'package:user_panel/model/featured_product_model.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:user_panel/model/discount_shop_review_model.dart';
import 'package:user_panel/model/subscription_discount_shop_model.dart';

class DiscountShopProvider extends RegAuth{

  DiscountShopModel _shopModel = DiscountShopModel();
  FeaturedProductModel _featuredProductModel = FeaturedProductModel();
  DiscountShopReviewModel _discountShopReviewModel=DiscountShopReviewModel();

  List<DiscountShopModel> _shopList= List<DiscountShopModel>();
  List<SubscriptionDiscountShopModel> _subscribedShopList= List<SubscriptionDiscountShopModel>();
  List<DiscountShopModel> _shopIdList= List<DiscountShopModel>();
  List<FeaturedProductModel> _productList = List<FeaturedProductModel>();
  List<DiscountShopReviewModel> _discountShopReviewList=List<DiscountShopReviewModel>();

  ///for discount shop review
  List<bool> _starList = [false,false,false,false,false];
  int _reviewCounter;
  //List<DiscountShopReviewModel> _allDiscountShopReviewList = List();
  int _oneStar=0;
  int _twoStar=0;
  int _threeStar=0;
  int _fourStar=0;
  int _fiveStar=0;
  double _avgRating=0.0;

  //get allDiscountShopReviewList=> _allDiscountShopReviewList;
  get oneStar=> _oneStar;
  get twoStar=> _twoStar;
  get threeStar=> _threeStar;
  get fourStar=> _fourStar;
  get fiveStar=> _fiveStar;
  get avgRating=> _avgRating;

  get shopModel => _shopModel;
  get discountShopReviewModel => _discountShopReviewModel;
  get featuredProductModel => _featuredProductModel;

  get shopList=> _shopList;
  get subscribedShopList=> _subscribedShopList;
  get shopIdList=> _shopIdList;
  get productList => _productList;

  get starList => _starList;
  get discountShopReviewList => _discountShopReviewList;
  set shopModel(DiscountShopModel model){
    model = DiscountShopModel();
    _shopModel = model;
    notifyListeners();
  }
set discountShopReviewModel(DiscountShopReviewModel model){
    model = DiscountShopReviewModel();
    _discountShopReviewModel = model;
    notifyListeners();
  }


  set featuredProductModel(FeaturedProductModel featuredModel){
    featuredModel = FeaturedProductModel();
    _featuredProductModel = featuredModel;
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



  Future<void> getShop(String subCategory)async{
    try{
      await FirebaseFirestore.instance.collection('DiscountShop').where('subCategory',isEqualTo: subCategory).get().then((snapShot){
        _shopList.clear();
        snapShot.docChanges.forEach((element) {
          DiscountShopModel shops=DiscountShopModel(
            id: element.doc['id'],
            shopImage: element.doc['shopImage'],
            shopName: element.doc['shopName'],
            about: element.doc['about'],
            executiveName: element.doc['executiveName'],
            executivePhoneNo: element.doc['executivePhoneNo'],
            shopCategory: element.doc['shopCategory'],
            subCategory: element.doc['subCategory'],
            webAddress: element.doc['webAddress'],
            mailAddress: element.doc['mailAddress'],
            twitterLink: element.doc['twitterLink'],
            facebookLink: element.doc['facebookLink'],
            phoneNo: element.doc['phoneNo'],
            linkedinLink: element.doc['linkedinLink'],
            amenities: element.doc['amenities'],
            avgReviewStar: element.doc['avgReviewStar'],
            sat: element.doc['Sat'],
            sun: element.doc['Sun'],
            mon: element.doc['Mon'],
            tue: element.doc['Tue'],
            wed: element.doc['Wed'],
            thu: element.doc['Thu'],
            fri: element.doc['Fri'],
            shopAddress: element.doc['shopAddress'],
            latitude: element.doc['latitude'],
            longitude: element.doc['longitude'],
            discount: element.doc['discount'],
          );
          _shopList.add(shops);
          //print(_shopList.length);
        });
      });
      notifyListeners();
    }catch(error){
      print(error.toString());
    }
  }

  Future<void> getSubscribedShop()async{
    final pId = await getPreferenceId();
    try{
      await FirebaseFirestore.instance.collection('SubscribedDiscountShop').where('pId',isEqualTo: pId).get().then((snapShot){
        _subscribedShopList.clear();
        snapShot.docChanges.forEach((element) {
          SubscriptionDiscountShopModel shops=SubscriptionDiscountShopModel(
            id: element.doc['id'],
             pId:element.doc['pId'],
              pName: element.doc['pName'],
              year: element.doc['year'],
              month: element.doc['month'],
             day: element.doc['day'],
             shopId: element.doc['shopId'],
            shopImage: element.doc['shopImage'],
            shopName: element.doc['shopName'],
            about: element.doc['about'],
            executiveName: element.doc['executiveName'],
            executivePhoneNo: element.doc['executivePhoneNo'],
            shopCategory: element.doc['shopCategory'],
            subCategory: element.doc['subCategory'],
            webAddress: element.doc['webAddress'],
            mailAddress: element.doc['mailAddress'],
            twitterLink: element.doc['twitterLink'],
            facebookLink: element.doc['facebookLink'],
            phoneNo: element.doc['phoneNo'],
            linkedinLink: element.doc['linkedinLink'],
            amenities: element.doc['amenities'],
            avgReviewStar: element.doc['avgReviewStar'],
            sat: element.doc['sat'],
            sun: element.doc['sun'],
            mon: element.doc['mon'],
            tue: element.doc['tue'],
            wed: element.doc['wed'],
            thu: element.doc['thu'],
            fri: element.doc['fri'],
            shopAddress: element.doc['shopAddress'],
            latitude: element.doc['latitude'],
            longitude: element.doc['longitude'],
            discount: element.doc['discount'],
          );
          _subscribedShopList.add(shops);
        });
      });
      notifyListeners();
    }catch(error){
      print(error.toString());
    }
  }

  Future<void> getFeaturedProduct(String id)async{
    try{
      await FirebaseFirestore.instance.collection('FeaturedProduct').where('shopId',isEqualTo: id).get().then((snapshot) {
        _productList.clear();
        snapshot.docChanges.forEach((element) {
          FeaturedProductModel products = FeaturedProductModel(
            id: element.doc['id'],
            shopId: element.doc['shopId'],
            imageUrl: element.doc['imageUrl'],
            productName: element.doc['name'],
            productPrice: element.doc['price'],
          );
          _productList.add(products);
        });
      });
      notifyListeners();
    }catch(error){
      print(error.toString());
    }
  }

  ///Submit discount Shop review
  Future<void> submitShopReview(DiscountShopReviewModel reviewModel,DiscountShopModel shopModel,  String shopId, BuildContext context, GlobalKey<ScaffoldState> scaffoldKey)async{
    final pId = await getPreferenceId();
    String id=pId+shopId;
    String date = DateFormat("dd-MMM-yyyy/hh:mm:aa").format(DateTime.
    fromMicrosecondsSinceEpoch(DateTime.now().microsecondsSinceEpoch));
    await FirebaseFirestore.instance.collection('DiscountShopReview').doc(id).set({
     'id':id,
     'shopId':shopId,
     'pId': pId,
     'submitDate':date,
     'reviewStar': _reviewCounter.toString(),
    }).then((value)async{
      await getAllShopReview(shopId);
      getOneStar();
      await FirebaseFirestore.instance.collection('DiscountShop').doc(shopId).update({
        'avgReviewStar': _avgRating.toString(),
      }).then((value) async{

        await checkSubscription(shopId).then((subscribed)async{
          if(subscribed){
            await FirebaseFirestore.instance.collection('SubscribedDiscountShop').doc(pId+shopId).update({
              'avgReviewStar': _avgRating.toString(),
            });
            getSubscribedShop();
            Navigator.pop(context);
            Navigator.pop(context);
            showSnackBar(scaffoldKey,'Review submitted successful',Theme.of(context).primaryColor);
          }
          else{
            getSubscribedShop();
            Navigator.pop(context);
            Navigator.pop(context);
            showSnackBar(scaffoldKey,'Review submitted successful',Theme.of(context).primaryColor);
          }
        });
      });
     
    },onError: (error){
      Navigator.pop(context);
      Navigator.pop(context);
      showSnackBar(scaffoldKey,error.toString(),Colors.deepOrange);
    });

  }

  ///get discount shop review
  Future<void> getAllShopReview(String shopId)async{
    try{
      await FirebaseFirestore.instance.collection('DiscountShopReview').where('shopId',isEqualTo: shopId).get().then((snapshot){
        _discountShopReviewList.clear();
        snapshot.docChanges.forEach((element) {
          if(element.doc['reviewStar']!=null){
            DiscountShopReviewModel shopReviewModel = DiscountShopReviewModel(
                id: element.doc['id'],
                pId: element.doc['pId'],
                shopId: element.doc['shopId'],
                reviewStar: element.doc['reviewStar'],
                submitDate: element.doc['submitDate']
            );
            _discountShopReviewList.add(shopReviewModel);
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

    for(int i=0; i<_discountShopReviewList.length; i++){
      if(_discountShopReviewList[i].reviewStar=='1') _oneStar++;

      if(_discountShopReviewList[i].reviewStar=='2') _twoStar++;

      if(_discountShopReviewList[i].reviewStar=='3') _threeStar++;

      if(_discountShopReviewList[i].reviewStar=='4') _fourStar++;

      if(_discountShopReviewList[i].reviewStar=='5') _fiveStar++;
    }
    getAvgRating();
  }


  void getAvgRating(){
    if(_discountShopReviewList.length!=0){
      double tempAvgRating = ((1*_oneStar)+(2*_twoStar)+(3*_threeStar)+(4*_fourStar)+(5*_fiveStar))/_discountShopReviewList.length;
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

  Future<bool> checkSubscription(String shopId)async{
    final pId = await getPreferenceId();
    final id = pId+shopId;
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('SubscribedDiscountShop')
        .where('id', isEqualTo: id).get();
    final List<QueryDocumentSnapshot> user = snapshot.docs;
    if(user.isNotEmpty){
      return true;
    }else{
      return false;
    }
  }

  Future<int> countSubscriptionDay(String shopId)async{
    final pId = await getPreferenceId();
    final id = pId+shopId;

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('SubscribedDiscountShop')
        .where('id', isEqualTo: id).get();
    final List<QueryDocumentSnapshot> shop = snapshot.docs;
    int year = int.parse(shop[0].get('year'));
    int month =int.parse( shop[0].get('month'));
    int day = int.parse(shop[0].get('day'));
    final subscribeDate = DateTime(year, month, day);
    final currentDate = DateTime.now();
    final int  difference = currentDate.difference(subscribeDate).inDays;

    return difference;

    }

 Future<void> savePaymentInfoAndSubscribeDiscountShop(
     String transactionId,
     String amount,
    String pId,
    String pName,
    String shopId,
    String shopName,
    String shopImage,
    String about,
    String executiveName,
    String executivePhoneNo,
    String shopCategory,
    String subCategory,
    String webAddress,
    String mailAddress,
    String twitterLink,
    String facebookLink,
    String phoneNo,
    String linkedinLink,
    List<dynamic> amenities,
    List<dynamic> sat,
    List<dynamic> sun,
    List<dynamic> mon,
    List<dynamic> tue,
    List<dynamic> wed,
    List<dynamic> thu,
    List<dynamic> fri,
    String shopAddress,
    String review,
    String latitude,
    String longitude,
    String avgReviewStar,
     String discount,
     GlobalKey<ScaffoldState> scaffoldKey,
     BuildContext context
  )async{
   final int timeStamp = DateTime.now().millisecondsSinceEpoch;
   final String paymentDate = DateFormat("dd-MMM-yyyy").format(DateTime.fromMillisecondsSinceEpoch(timeStamp)).toString();
    await FirebaseFirestore.instance.collection('DiscountPaymentDetails').doc(pId+shopId).set({
      'id': pId+shopId,
      'pId': pId,
      'pName': pName,
      'shopId': shopId,
      'shopName': shopName,
      'transactionId': transactionId,
      'paymentDate': paymentDate,
      'amount': amount,
      'currency': 'BD Taka',
      'timeStamp': timeStamp.toString(),
    }).then((value)async{
      await FirebaseFirestore.instance.collection('SubscribedDiscountShop').doc(pId+shopId).set({
        'id': pId+shopId,
        'pId': pId,
        'pName': pName,
        'year': DateTime.now().year.toString(),
        'month': DateTime.now().month.toString(),
        'day': DateTime.now().day.toString(),
        'shopId': shopId,
       'shopImage': shopImage,
       'shopName': shopName,
       'about': about,
       'executiveName': executiveName,
       'executivePhoneNo': executivePhoneNo,
       'shopCategory': shopCategory,
       'subCategory': subCategory,
       'webAddress': webAddress,
       'mailAddress': mailAddress,
       'twitterLink': twitterLink,
       'facebookLink': facebookLink,
       'phoneNo': phoneNo,
       'linkedinLink': linkedinLink,
       'amenities': amenities,
       'sat': sat,
      'sun': sun,
       'mon': mon,
      'tue': tue,
      'wed': wed,
      'thu': thu,
      'fri': fri,
      'shopAddress': shopAddress,
      'latitude': latitude,
      'longitude': longitude,
      'avgReviewStar': avgReviewStar,
        'discount' :discount
      }).then((value){
        getSubscribedShop();
        Navigator.pop(context);
        Navigator.pop(context);
        showAlertDialog(context,'Shop subscription successful');
      },onError: (error){
        Navigator.pop(context);
        showSnackBar(scaffoldKey,error.toString(),Colors.deepOrange);
      });
    },onError: (error){
      Navigator.pop(context);
      showSnackBar(scaffoldKey,error.toString(),Colors.deepOrange);
    });
 } 


}
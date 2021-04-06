import 'package:flutter/material.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:aamarpay/aamarpay.dart';
import 'package:user_panel/widgets/button_widgets.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:user_panel/shared/form_decoration.dart';
import 'package:provider/provider.dart';
import 'package:user_panel/provider/discount_shop_provider.dart';

// ignore: must_be_immutable
class MakeDiscountShopPayment extends StatefulWidget {
  String pId;
  String pName;
  String shopId;
  String shopName;
  String shopImage;
  String about;
  String executiveName;
  String executivePhoneNo;
  String shopCategory;
  String subCategory;
  String webAddress;
  String mailAddress;
  String twitterLink;
  String facebookLink;
  String phoneNo;
  String linkedinLink;
  List<dynamic> amenities;
  List<dynamic> sat;
  List<dynamic> sun;
  List<dynamic> mon;
  List<dynamic> tue;
  List<dynamic> wed;
  List<dynamic> thu;
  List<dynamic> fri;
  String shopAddress;
  String review;
  String latitude;
  String longitude;
  String avgReviewStar;
  String discount;
  MakeDiscountShopPayment({
      this.pId,
      this.pName,
      this.shopId,
      this.shopName,
      this.shopImage,
      this.about,
      this.executiveName,
      this.executivePhoneNo,
      this.shopCategory,
      this.subCategory,
      this.webAddress,
      this.mailAddress,
      this.twitterLink,
      this.facebookLink,
      this.phoneNo,
      this.linkedinLink,
      this.amenities,
      this.sat,
      this.sun,
      this.mon,
      this.tue,
      this.wed,
      this.thu,
      this.fri,
      this.shopAddress,
      this.review,
      this.latitude,
      this.longitude,
      this.avgReviewStar,this.discount});

  @override
  _MakeDiscountShopPaymentState createState() => _MakeDiscountShopPaymentState();
}

class _MakeDiscountShopPaymentState extends State<MakeDiscountShopPayment> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  String _payableAmount='0';
  String _transactionId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _transactionId = widget.pId+DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: customAppBarDesign(context, 'Confirm Payment'),
      body: _bodyUI(),
    );
  }

  Widget _bodyUI(){
    bool isLoading = false;
    return Consumer<DiscountShopProvider>(
      builder: (context, disProvider, child){
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      decoration: cardDecoration,
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        child: Text('Pay minimum 50 Tk to Dakterbari charity fund '
                            'to get up to ${widget.discount}% discount of ${widget.shopName} for one year.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18,color: Theme.of(context).primaryColor,fontWeight: FontWeight.w500))),
                    SizedBox(height: 30),

                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: FormDecoration.copyWith(
                          labelText: 'Enter charity amount',
                          prefixIcon: Icon(Icons.monetization_on),
                          fillColor: Color(0xffF4F7F5)
                      ),
                      onChanged: (val)=>setState(()=>_payableAmount=val),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                _payableAmount.isNotEmpty
                    ? int.parse(_payableAmount)>=50
                    ? AamarpayData(
                    returnUrl: (url) async{
                      // setState(()=> _isLoading = false);
                      if (url == 'https://secure.aamarpay.com/cancel')
                        showSnackBar(
                            _scaffoldKey, 'Payment canceled', Colors.deepOrange);

                      if (url == 'https://secure.aamarpay.com/fail')
                        showSnackBar(_scaffoldKey, 'Payment failed', Colors.deepOrange);

                      if (url == 'https://secure.aamarpay.com/confirm'){
                        disProvider.loadingMgs= 'Confirming subscription...';
                        showLoadingDialog(context,disProvider);

                        await disProvider.savePaymentInfoAndSubscribeDiscountShop(_transactionId, _payableAmount, widget.pId, widget.pName, widget.shopId, widget.shopName,
                            widget.shopImage, widget.about, widget.executiveName, widget.executivePhoneNo, widget.shopCategory, widget.subCategory,
                            widget.webAddress, widget.mailAddress, widget.twitterLink,
                            widget.facebookLink, widget.phoneNo, widget.linkedinLink, widget.amenities, widget.sat, widget.sun, widget.mon, widget.tue, widget.wed,
                            widget.thu, widget.fri, widget.shopAddress, widget.review, widget.latitude,
                            widget.longitude, widget.avgReviewStar, widget.discount,_scaffoldKey,context);
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
                    //customerEmail: "masumbillahsanjid@gmail.com",
                    customerMobile: '${widget.pId}',
                    customerName: '${widget.pName}',
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
                      child: button(context, 'Pay $_payableAmount BD TK'),
                    ))
                    :Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: 50,
                  child: disableButton(context, 'Pay min 50 BD TK'),
                )
                    :Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: 50,
                  child: disableButton(context, 'Pay min 50 BD TK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'dart:collection';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_panel/provider/discount_shop_provider.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:user_panel/shared/widget.dart';
import 'package:user_panel/widgets/button_widgets.dart';
import 'package:user_panel/widgets/no_data_widget.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// ignore: must_be_immutable
class DiscountShopDetails extends StatefulWidget {
  String id;
  String shopImage;
  String shopName;
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
  String discount;
  static const Color starColor = Color(0xffFFBA00);

  DiscountShopDetails(
      {this.id,
        this.shopImage,
        this.shopName,
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
        this.discount,
      });
  //int index=0;
  @override
  _DiscountShopDetailsState createState() => _DiscountShopDetailsState();
}

class _DiscountShopDetailsState extends State<DiscountShopDetails> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Set<Marker> _marker = HashSet<Marker>();
  static GoogleMapController _mapController;

  void _onMapCreated(GoogleMapController controller){
    _mapController = controller;
    setState(() {
      _marker.add(
          Marker(
            markerId: MarkerId('0'),
            position: LatLng(double.parse(widget.latitude??'0.0'), double.parse(widget.longitude??'0.0')),
            infoWindow: InfoWindow(
                title: "${widget.shopName??''}",
                snippet: "${widget.shopAddress??''}"
            ),
          )
      );
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onMapCreated(_mapController);
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DiscountShopProvider discountShopProvider=Provider.of<DiscountShopProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: customAppBarDesign(context, "Shop Details"),
      body: _bodyUI(context,discountShopProvider),
    );
  }
  ///Body UI
  Widget _bodyUI(BuildContext context,DiscountShopProvider discountShopProvider) {
    final Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ///Shop Image
          Container(
            height: size.width*.50,
            width: size.width,
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: widget.shopImage==null?Icons.photo_camera_back
                :ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: CachedNetworkImage(
                imageUrl: widget.shopImage,
                placeholder: (context, url) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/loadingimage.gif',fit: BoxFit.cover,height: 220,),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 5.0),

          ///Header Section
          Container(
            width: size.width,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.shopName??"Not Available",
                      style: TextStyle(fontSize: size.width*.042, fontWeight: FontWeight.bold)),
                  Text(widget.shopAddress??'No address available',
                      style: TextStyle(color: Colors.grey[700],fontSize: size.width*.032)),
                ],
              )),
          SizedBox(height: 18),

          ///about
          headingDecorationUnsized(context, 'About', Colors.white, Colors.grey[700]),
          _aboutBuilder(discountShopProvider),
          SizedBox(height: 18),

          ///Ratings
          headingDecorationUnsized(context, 'Ratings', Colors.white, Colors.grey[700]),
          _ratingBuilder('Reviews',discountShopProvider),
          SizedBox(height: 18),

          ///Featured Products
          headingDecorationUnsized(context, 'Featured Products', Colors.white, Colors.grey[700]),
          _featureProductBuilder(discountShopProvider),
          SizedBox(height: 18),

          ///Amenities
          headingDecorationUnsized(context, 'Amenities', Colors.white, Colors.grey[700]),
          _amenitiesBuilder('Amenities',discountShopProvider),
          SizedBox(height: 18),

          headingDecorationUnsized(context, 'Opening Hours', Colors.white, Colors.grey[700]),
          _openingHoursBuilder(discountShopProvider),
          SizedBox(height: 18),

          headingDecorationUnsized(context, 'Contact', Colors.white, Colors.grey[700]),
          _contactBuilder(discountShopProvider),
          SizedBox(height: 18),
        ],
      ),
    );
  }

  ///About Builder
  Widget _aboutBuilder(DiscountShopProvider discountShopProvider) {
    Size size=MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 5,vertical: 8),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Color(0xffF4F7F5),
          borderRadius: BorderRadius.circular(5)
      ),

      child: Text(widget.about??'',style: TextStyle(fontSize: size.width*.029),
        textAlign: TextAlign.justify,
      ),

    );
  }

  ///Contact Builder
  Widget _contactBuilder(DiscountShopProvider discountShopProvider){
    Size size=MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 15),
          widget.mailAddress==null?Container():GestureDetector(
              onTap: ()async =>await canLaunch('mailto:${widget.mailAddress}') ?
              await launch('mailto:${widget.mailAddress}') : showSnackBar(_scaffoldKey,'Could not launch',Theme.of(context).primaryColor) ,
              child: socialButton(context, 'assets/social_icon/email_48.png', 'Email Us', Color(0xffFFA500))),

          SizedBox(height: 10),
          widget.facebookLink==null?Container():GestureDetector(
              onTap: ()async =>await canLaunch(widget.facebookLink) ?
              await launch(widget.facebookLink) : showSnackBar(_scaffoldKey,'Could not launch',Theme.of(context).primaryColor),
              child: socialButton(context, 'assets/social_icon/facebook_48.png', 'Facebook', Color(0xff4068E0))),

          SizedBox(height: 10),
          widget.webAddress==null?Container():GestureDetector(
            onTap: ()async =>await canLaunch(widget.webAddress) ?
            await launch(widget.webAddress) : showSnackBar(_scaffoldKey,'Could not launch',Theme.of(context).primaryColor),
            child:socialButton(context, 'assets/social_icon/globe_48.png', 'Visit Website', Color(0xffA6D785)),),
          SizedBox(height: 10),
          widget.linkedinLink==null?Container():GestureDetector(
            onTap: ()async =>await canLaunch(widget.linkedinLink) ?
            await launch(widget.linkedinLink) : showSnackBar(_scaffoldKey,'Could not launch',Theme.of(context).primaryColor),
            child:socialButton(context, 'assets/social_icon/linkedin_48.png', 'LinkedIn', Color(0xff4069E1)),),

          SizedBox(height: 10),
          widget.phoneNo==null?Container():GestureDetector(
            onTap: ()async =>await canLaunch('tel:${widget.phoneNo}') ?
            await launch('tel:${widget.phoneNo}') : showSnackBar(_scaffoldKey,'Could not launch',Theme.of(context).primaryColor),
            child:socialButton(context, 'assets/social_icon/phone_48.png', 'Call Now', Color(0xffE0218A)),),

          SizedBox(height: 10),
          widget.twitterLink==null?Container():GestureDetector(
            onTap: ()async =>await canLaunch(widget.twitterLink) ?
            await launch(widget.twitterLink) : showSnackBar(_scaffoldKey,'Could not launch',Theme.of(context).primaryColor),
            child:socialButton(context, 'assets/social_icon/twitter_48.png', 'Twitter', Color(0xff42C0FB)),),
          SizedBox(height: 10),

          GestureDetector(
            onTap: ()=> _locationModal(),
              child: socialButton(context, 'assets/icons/marker100.png', 'Shop Location', Color(0xffFF3F00))),

        ],
      ),
    );
  }

  ///Amenities Builder
  Widget _amenitiesBuilder(String amenities,DiscountShopProvider discountShopProvider){
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
          color: Color(0xffF4F7F5),
          borderRadius: BorderRadius.circular(5)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          widget.amenities!=null?
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.amenities.length>3?3
                :widget.amenities.length,
            itemBuilder: (context, index){
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 8),
                decoration: BoxDecoration(
                    color: Color(0xffF4F7F5),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Text(widget.amenities[index].toString(),style: TextStyle(fontSize: size.width*.030),),
              );
            },
          ):NoData(message: 'No amenities yet \u{1f614}'),

          widget.amenities.length>3? Container(
            width: size.width,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: ()=> viewAllAmenities(context,amenities),
              child: Text("View all amenities",textAlign: TextAlign.end,style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),),
            ),
          ):Container(),
        ],
      ),
    );
  }

  /// Opening Hour Builder
  Widget _openingHoursBuilder(DiscountShopProvider discountShopProvider) {
    Size size = MediaQuery.of(context).size;
    final String sat = widget.sat == null
        ? ''
        : '  Saturday: ${widget.sat[0]}-${widget.sat[1]}';
    final String sun = widget.sun == null
        ? ''
        : '  Sunday: ${widget.sun[0]}-${widget.sun[1]}';
    final String mon = widget.mon == null
        ? ''
        : '  Monday: ${widget.mon[0]}-${widget.mon[1]}';
    final String tue = widget.tue == null
        ? ''
        : '  Tuesday: ${widget.tue[0]}-${widget.tue[1]}';
    final String wed = widget.wed == null
        ? ''
        : '  Wednesday: ${widget.wed[0]}-${widget.wed[1]}';
    final String thu = widget.thu == null
        ? ''
        : '  Thursday: ${widget.thu[0]}-${widget.thu[1]}';
    final String fri = widget.fri == null
        ? ''
        : '  Friday: ${widget.fri[0]}-${widget.fri[1]}';
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Color(0xffF4F7F5),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //headingDecorationUnsized(context, "headingText", Colors.grey, Colors.black),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.only(bottom: 10),
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.sat == null?Container():Text(sat, style: TextStyle(fontSize: size.width*.032)),
                SizedBox(height: 5,),
                widget.sun == null?Container():Text(sun, style: TextStyle(fontSize: size.width*.032)),
                SizedBox(height: 5,),
                widget.mon == null?Container():Text(mon, style: TextStyle(fontSize: size.width*.032)),
                SizedBox(height: 5,),
                widget.tue == null?Container():Text(tue, style: TextStyle(fontSize: size.width*.032)),
                SizedBox(height: 5,),
                widget.wed == null?Container():Text(wed, style: TextStyle(fontSize: size.width*.032)),
                SizedBox(height: 5,),
                widget.thu == null?Container():Text(thu, style: TextStyle(fontSize: size.width*.032)),
                SizedBox(height: 5,),
                widget.fri == null?Container():Text(fri, style: TextStyle(fontSize: size.width*.032)),
              ],
            ),
          ),

        ],
      ),
    );
  }

  ///Features Product Builder
  Widget _featureProductBuilder(DiscountShopProvider discountShopProvider) {
    Size size=MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      //padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        children: [
          discountShopProvider.productList.isNotEmpty?
          ListView.builder(
            itemCount: discountShopProvider.productList.length>1?1
                :discountShopProvider.productList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return FeatureProductTile(
                productName: discountShopProvider.productList[index].productName,
                productPrice: discountShopProvider.productList[index].productPrice,
                imageUrl: discountShopProvider.productList[index].imageUrl,
              );
            },
          ):NoData(message: 'No features product of this shop \u{1f614}'),
          SizedBox(height: 5),
          discountShopProvider.productList.length>1?
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: ()=> viewAllFeaturedProducts(context,discountShopProvider),
              child: Text("View all features product",textAlign: TextAlign.end,style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: size.width*.030,
                  fontWeight: FontWeight.w500),),
            ),
          ):Container(),


        ],
      ),
    );
  }

  ///Review Builder
  Widget _ratingBuilder(String heading,DiscountShopProvider discountShopProvider) {
    final Map<String, double> dataMap = {
      "⭐": double.parse(discountShopProvider.oneStar.toString()),
      "⭐⭐": double.parse(discountShopProvider.twoStar.toString()),
      "⭐⭐⭐": double.parse(discountShopProvider.threeStar.toString()),
      "⭐⭐⭐⭐": double.parse(discountShopProvider.fourStar.toString()),
      "⭐⭐⭐⭐⭐": double.parse(discountShopProvider.fiveStar.toString()),
    };
    final List<Color> colorList = [
      Color(0xffFF5C6B),
      Color(0xffDBB049),
      Color(0xff7A5AB5),
      Color(0xff00D099),
      Color(0xff0094D4),
    ];
    final Color starColor= Color(0xffFFBA00);
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Color(0xffF4F7F5),
          borderRadius: BorderRadius.circular(5)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Container(
            width: size.width,
            child: PieChart(
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 1000),
              chartLegendSpacing: 35,
              chartRadius: MediaQuery
                  .of(context)
                  .size
                  .width * .4,
              colorList: colorList,
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: 32,
              centerText: "Ratings",

              legendOptions: LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  fontSize: size.width*.030
                ),
              ),

              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: false,
                showChartValues: true,
                showChartValuesInPercentage: false,
                showChartValuesOutside: false,
                decimalPlaces: 0,
              ),
            ),
          ),

          SizedBox(height: 30),
          Container(
            width: size.width,
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total People Rated",
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: size.width*.030,
                          fontWeight: FontWeight.w500),

                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Avg. Ratings",
                        style: TextStyle(
                            fontSize: size.width*.030,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500),
                      ),
                    ),

                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.assignment_ind,
                          color: Theme
                              .of(context)
                              .primaryColor,
                          size: size.width*.032,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${discountShopProvider.discountShopReviewList.length}',
                          style: TextStyle(
                              fontSize: size.width*.029,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800]),
                        )
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.star,
                          size: size.width*.032,
                          color: starColor,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "${discountShopProvider.avgRating}",
                          style: TextStyle(
                              fontSize: size.width*.029,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800]),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            child:Container(
              margin: EdgeInsets.only(left: 60,right: 60,bottom: 10),
              child:outlineIconButton(context, Icons.star, 'Submit Rating', Color(0xffFFBA00)),
            ),

            onTap: ()=> _submitReviewBuilder(),
          ),
        ],
      ),
    );
  }

  ///submit review
  void _submitReviewBuilder(){
    final Color starColor= Color(0xffFFBA00);
    showDialog(
      context: context,
      builder: (context){
        return Consumer<DiscountShopProvider>(builder: (context,discountShopProvider,child){
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
            title: Text("Review & Rating",textAlign: TextAlign.center,),

            content: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 30,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: discountShopProvider.starList.length,
                      itemBuilder: (context, index){
                        return IconButton(
                          splashRadius: 20,
                          icon: discountShopProvider.starList[index]==true?
                          Icon(Icons.star,color: starColor,size: 26,)
                              :Icon(Icons.star_border,color: starColor,size: 26,),
                          onPressed:()=> discountShopProvider.changeStarColor(index),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RaisedButton(
                          color: Colors.redAccent,
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          )),
                      RaisedButton(
                          onPressed: () async{
                            if(_formKey.currentState.validate()){
                              discountShopProvider.loadingMgs='Submitting review...';
                              showLoadingDialog(context, discountShopProvider);
                              //print(widget.id);
                              discountShopProvider.submitShopReview(discountShopProvider.discountShopReviewModel,discountShopProvider.shopModel, widget.id, context, _scaffoldKey);
                            }
                          },
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          )),
                    ],
                  )

                ],
              ),
            ),
          );
        });
      },
    );
  }

  ///Location Builder
  void _locationModal(){
    showDialog(
      context: context,
      builder: (context){
        Size size=MediaQuery.of(context).size;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Color(0xffF4F7F5),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child:Column(children: [
            // Container(
            //     width: size.width,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.only(
            //           topLeft: Radius.circular(10),
            //           topRight: Radius.circular(10)
            //       ),
            //       color: Theme.of(context).primaryColor,
            //     ),
            //     //Color(0xffF4F7F5),
            //     //padding: const EdgeInsets.only(right: 15),
            //     child: GestureDetector(
            //       onTap: ()=>Navigator.pop(context),
            //       child: Icon(Icons.clear,color: Colors.grey[100],size: 30,),
            //     )
            // ),
            widget.latitude==null?Container():Container(
              height: MediaQuery.of(context).size.height * .50,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: GoogleMap(
                  compassEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(double.parse(widget.latitude??'0.0'),double.parse(widget.longitude??'0.0')),
                    zoom: 15,
                  ),
                  markers: _marker,
                ),
              ),
            ),
          ],)
        );
      },
    );
  }

  ///Featured product Modal
  void viewAllFeaturedProducts(BuildContext context,DiscountShopProvider discountShopProvider) {
    Size size= MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)
                ),
                color: Colors.white
            ),
            child: Column(
              children: [
                Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                    //Color(0xffF4F7F5),
                    padding: const EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: ()=>Navigator.pop(context),
                      child: Icon(Icons.clear,color: Colors.grey[100],size: 30,),
                    )
                ),
                SizedBox(height: 10),

                Expanded(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      itemCount: discountShopProvider.productList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              horizontalOffset: 400,
                              child: FadeInAnimation(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: FeatureProductTile(
                                    imageUrl: discountShopProvider.productList[index].imageUrl,
                                    productName: discountShopProvider.productList[index].productName,
                                    productPrice: discountShopProvider.productList[index].productPrice,
                                  ),
                                ),),
                            )
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  ///Amenities Modal
  void viewAllAmenities(BuildContext context,String amenities) {
    Size size= MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)
                ),
                color: Colors.white
            ),
            child: Column(
              children: [
                Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)
                      ),
                      color: Theme.of(context).primaryColor,
                    ),
                    //Color(0xffF4F7F5),
                    padding: const EdgeInsets.only(right: 15),
                    child: GestureDetector(
                      onTap: ()=>Navigator.pop(context),
                      child: Icon(Icons.clear,color: Colors.grey[100],size: 30,),
                    )
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: widget.amenities.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                      return Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                        decoration: BoxDecoration(
                            color: Color(0xffF4F7F5),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text(widget.amenities[index].toString()),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

}

// ignore: must_be_immutable
class FeatureProductTile extends StatelessWidget {
  String imageUrl,productName,productPrice;
  FeatureProductTile({this.imageUrl,this.productName,this.productPrice});
  //static const url;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              blurRadius: 1,
              offset: Offset(0.3,0.5),
              color: Colors.grey
          )
        ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ///Image container
          imageUrl==null?Icons.photo_camera_back
                :ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (context, url) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset('assets/loadingimage.gif',fit: BoxFit.cover,height: 80),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                height: 80,
                width: size.width * .29,
                fit: BoxFit.fitHeight,
              ),
            ),

          ///Heading builder
          Container(
            width: size.width * .60,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        productName,
                        style: TextStyle(fontSize: size.width*.030,fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      'Price: $productPrice Tk.',
                      style: TextStyle(color: Colors.grey[700],fontSize: size.width*.029),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Divider(color: Colors.black, height: 2),
              ],
            ),
          )
        ],
      ),
    );

  }
}
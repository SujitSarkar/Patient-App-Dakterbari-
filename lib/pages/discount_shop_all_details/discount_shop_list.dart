import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_panel/provider/discount_shop_provider.dart';
import 'package:user_panel/widgets//custom_app_bar.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:user_panel/provider/patient_provider.dart';
import 'package:user_panel/pages/subpage/make_discountshop_payment_page.dart';
import 'package:user_panel/pages/discount_shop_all_details/discount-Shop_details.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';


// ignore: must_be_immutable
class DiscountShopList extends StatefulWidget {

  String subCategory;

  DiscountShopList(this.subCategory,);

  @override
  _DiscountShopListState createState() => _DiscountShopListState();
}

class _DiscountShopListState extends State<DiscountShopList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF4F7F5),
        appBar:  customAppBarDesign(context, widget.subCategory),
        body: _bodyUI()
    );
  }

  Widget _bodyUI() {
    final DiscountShopProvider disShopProvider = Provider.of<DiscountShopProvider>(context);
    return RefreshIndicator(
      backgroundColor: Colors.white,
      onRefresh: ()=>disShopProvider.getShop(widget.subCategory),
      child: AnimationLimiter(
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: disShopProvider.shopList.length,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: 400,
                  child: FadeInAnimation(
                    child: DiscountShopTile(
                      id: disShopProvider.shopList[index].id,
                      shopImage: disShopProvider.shopList[index].shopImage,
                      shopName: disShopProvider.shopList[index].shopName,
                      about: disShopProvider.shopList[index].about,
                      executiveName: disShopProvider.shopList[index].executiveName,
                      executivePhoneNo: disShopProvider.shopList[index].executivePhoneNo,
                      shopCategory: disShopProvider.shopList[index].shopCategory,
                      subCategory: disShopProvider.shopList[index].subCategory,
                      webAddress: disShopProvider.shopList[index].webAddress,
                      mailAddress: disShopProvider.shopList[index].mailAddress,
                      twitterLink: disShopProvider.shopList[index].twitterLink,
                      facebookLink: disShopProvider.shopList[index].facebookLink,
                      phoneNo: disShopProvider.shopList[index].phoneNo,
                      linkedinLink: disShopProvider.shopList[index].linkedinLink,
                      amenities: disShopProvider.shopList[index].amenities,
                      avgReviewStar: disShopProvider.shopList[index].avgReviewStar,
                      sat: disShopProvider.shopList[index].sat,
                      sun: disShopProvider.shopList[index].sun,
                      mon: disShopProvider.shopList[index].mon,
                      tue: disShopProvider.shopList[index].tue,
                      wed: disShopProvider.shopList[index].wed,
                      thu: disShopProvider.shopList[index].thu,
                      fri: disShopProvider.shopList[index].fri,
                      shopAddress: disShopProvider.shopList[index].shopAddress,
                      latitude: disShopProvider.shopList[index].latitude,
                      longitude: disShopProvider.shopList[index].longitude,
                      discount: disShopProvider.shopList[index].discount,
                    ),),
                )
            );
          },
        ),
      ),
    );
  }

}
// ignore: must_be_immutable
class DiscountShopTile extends StatelessWidget {
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
  String avgReviewStar;
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

  DiscountShopTile(
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
        this.avgReviewStar,
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

  @override
  Widget build(BuildContext context) {
    final DiscountShopProvider disShopProvider = Provider.of<DiscountShopProvider>(context);
    final PatientProvider patientProvider = Provider.of<PatientProvider>(context);

    return GestureDetector(
      onTap: ()async{
        disShopProvider.loadingMgs='Please wait...';
        showLoadingDialog(context,disShopProvider);

        final bool isSubscribed = await disShopProvider.checkSubscription(id);

        /// If old user & subscribed
        if(isSubscribed){
         await disShopProvider.countSubscriptionDay(id).then((subsDay)async{
           if(subsDay<=365){
             await disShopProvider.getAllShopReview(id).then((value)async{
               await disShopProvider.getFeaturedProduct(id).then((value){
                 disShopProvider.getOneStar();
                 Navigator.pop(context);
                 Navigator.push(context, MaterialPageRoute(
                     builder: (context) => DiscountShopDetails(
                       id:id,
                       shopImage:shopImage,
                       shopName:shopName,
                       about:about,
                       executiveName:executiveName,
                       executivePhoneNo:executivePhoneNo,
                       shopCategory:shopCategory,
                       subCategory:subCategory,
                       webAddress:webAddress,
                       mailAddress:mailAddress,
                       twitterLink:twitterLink,
                       facebookLink:facebookLink,
                       phoneNo:phoneNo,
                       linkedinLink:linkedinLink,
                       amenities:amenities,
                       sat:sat,
                       sun:sun,
                       mon:mon,
                       tue:tue,
                       wed:wed,
                       thu:thu,
                       fri:fri,
                       shopAddress:shopAddress,
                       review:review,
                       latitude:latitude,
                       longitude:longitude,
                       discount: discount,
                     )));
               });

               showAlertDialog(context, '${subsDay==0? 'First day of your subscription':
               '${subsDay==365? 'Last day of your subscription': '${365-subsDay} days remaining of your subscription'}'}');
             },onError: (error) {
               Navigator.pop(context);
               showAlertDialog(context, error.toString());
             });
           }else{ ///Subscription expire
             Navigator.pop(context);
             Navigator.push(context, MaterialPageRoute(builder: (context)=>MakeDiscountShopPayment(
               pId: patientProvider.patientList[0].id,
               pName: patientProvider.patientList[0].fullName,
               shopId: id,
               shopName: shopName,
               shopImage: shopImage,
               about: about,
               executiveName: executiveName,
               executivePhoneNo: executivePhoneNo,
               shopCategory: shopCategory,
               subCategory: subCategory,
               webAddress: webAddress,
               mailAddress: mailAddress,
               twitterLink: twitterLink,
               facebookLink: facebookLink,
               phoneNo: phoneNo,
               linkedinLink: linkedinLink,
               amenities:amenities,
               sat: sat,
               sun: sun,
               mon: mon,
               tue: tue,
               wed: wed,
               thu: thu,
               fri: fri,
               shopAddress: shopAddress,
               review: review,
               latitude: latitude,
               longitude: longitude,
               avgReviewStar: avgReviewStar,
               discount: discount,
             )));
             showAlertDialog(context, 'Subscription expired !\nSubscribe again to get discount');
           }

         });

        }

        /// If new user & not subscribed yet
        else if(!isSubscribed){
          if(patientProvider.patientList.isEmpty){
            await patientProvider.getPatient().then((value){
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MakeDiscountShopPayment(
                pId: patientProvider.patientList[0].id,
                pName: patientProvider.patientList[0].fullName,
                shopId: id,
                shopName: shopName,
                shopImage: shopImage,
                about: about,
                executiveName: executiveName,
                executivePhoneNo: executivePhoneNo,
                shopCategory: shopCategory,
                subCategory: subCategory,
                webAddress: webAddress,
                mailAddress: mailAddress,
                twitterLink: twitterLink,
                facebookLink: facebookLink,
                phoneNo: phoneNo,
                linkedinLink: linkedinLink,
                amenities:amenities,
                sat: sat,
                sun: sun,
                mon: mon,
                tue: tue,
                wed: wed,
                thu: thu,
                fri: fri,
                shopAddress: shopAddress,
                review: review,
                latitude: latitude,
                longitude: longitude,
                avgReviewStar: avgReviewStar,
                discount: discount,
              )));
            });
          }
          else{
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MakeDiscountShopPayment(
              pId: patientProvider.patientList[0].id,
              pName: patientProvider.patientList[0].fullName,
              shopId: id,
              shopName: shopName,
              shopImage: shopImage,
              about: about,
              executiveName: executiveName,
              executivePhoneNo: executivePhoneNo,
              shopCategory: shopCategory,
              subCategory: subCategory,
              webAddress: webAddress,
              mailAddress: mailAddress,
              twitterLink: twitterLink,
              facebookLink: facebookLink,
              phoneNo: phoneNo,
              linkedinLink: linkedinLink,
              amenities:amenities,
              sat: sat,
              sun: sun,
              mon: mon,
              tue: tue,
              wed: wed,
              thu: thu,
              fri: fri,
              shopAddress: shopAddress,
              review: review,
              latitude: latitude,
              longitude: longitude,
              avgReviewStar: avgReviewStar,
              discount: discount,
            )));
          }
        }


        },
      child: Container(
        margin: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Theme.of(context).primaryColor
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Image Container
            Container(
              //padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
              ),
              width: MediaQuery.of(context).size.width,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: CachedNetworkImage(
                  imageUrl: shopImage,
                  placeholder: (context, url) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/loadingimage.gif',fit: BoxFit.cover,height: 180,),
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error),
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),),
            ///Content Container
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Shop Name
                  shopName==null?'':Text(
                    shopName,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  ///Shop Location
                  shopAddress==null?'':Text(
                    shopAddress,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 10),
                  ///Shop About
                  Text(about,maxLines: 2,
                      style: TextStyle(
                        color: Colors.grey[900],
                        fontSize: 15,)
                  ),
                  SizedBox(height: 10),
              GestureDetector(
                onTap: ()async{
                  //double.parse(widget.latitude),double.parse(widget.longitude)
                  double lat = double.parse(latitude);
                  double long = double.parse(longitude);
                  final String googleMapslocationUrl = "https://www.google.com/maps/search/?api=1&query=$lat,$long";

                  final String encodedURl = Uri.encodeFull(googleMapslocationUrl);

                  if (await canLaunch(encodedURl)) {
                    await launch(encodedURl);
                  } else {
                    print('Could not launch $encodedURl');
                    throw 'Could not launch $encodedURl';
                  }
                },
                child: Row(
                      children: [
                        Icon(CupertinoIcons.compass,size: 20,color: Colors.grey,),
                        SizedBox(width: 5),
                        Text("Show On Map",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),)
                      ],
                    ),
              ),
                  SizedBox(height: 10),

                  Divider(color: Theme.of(context).primaryColor,),
                  //Footer Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                              decoration:BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Text("Open",style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14
                              ),),
                            ),
                            SizedBox(width: 3,),
                            discount==null?Text('No Discount Available',style: TextStyle(fontSize: 11))
                                :Text('discount up to $discount%',style: TextStyle(fontSize: 11,color: starColor,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      ratingStar(disShopProvider),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget ratingStar(DiscountShopProvider disShopProvider){
    //final Color starColor= Color(0xffFFBA00);
    return Row(
      children: [
        Text(
          "Ratings:",
          style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500),
        ),
        SizedBox(width: 5),
        avgReviewStar == '5.0'
            ? Row(
          children: [
            Icon(Icons.star, size: 14, color: starColor),
            Icon(Icons.star, size: 14, color: starColor),
            Icon(Icons.star, size: 14, color: starColor),
            Icon(Icons.star, size: 14, color: starColor),
            Icon(Icons.star, size: 14, color: starColor),
          ],
        )
            : avgReviewStar == '4.0'
            ? Row(
          children: [
            Icon(Icons.star,
                size: 14, color: starColor),
            Icon(Icons.star,
                size: 14, color: starColor),
            Icon(Icons.star,
                size: 14, color: starColor),
            Icon(Icons.star,
                size: 14, color: starColor),
          ],
        )
            : avgReviewStar == '4.5'
            ? Row(
          children: [
            Icon(Icons.star,
                size: 14, color: starColor),
            Icon(Icons.star,
                size: 14, color: starColor),
            Icon(Icons.star,
                size: 14, color: starColor),
            Icon(Icons.star,
                size: 14, color: starColor),
          ],
        )
            : avgReviewStar == '3.0'
            ? Row(
          children: [
            Icon(Icons.star,
                size: 14, color: starColor),
            Icon(Icons.star,
                size: 14, color: starColor),
            Icon(Icons.star,
                size: 14, color: starColor),
          ],
        )
            : avgReviewStar == '3.5'
            ? Row(
          children: [
            Icon(Icons.star,
                size: 14, color: starColor),
            Icon(Icons.star,
                size: 14, color: starColor),
            Icon(Icons.star,
                size: 14, color: starColor),
          ],
        )
            : avgReviewStar == '2.0'
            ? Row(
          children: [
            Icon(Icons.star,
                size: 15, color: starColor),
            Icon(Icons.star,
                size: 15, color: starColor),
          ],
        )
            : avgReviewStar == '2.5'
            ? Row(
          children: [
            Icon(Icons.star,
                size: 15, color: starColor),
            Icon(Icons.star,
                size: 15, color: starColor),
          ],
        )
            : Row(
          children: [
            Icon(Icons.star,
                size: 15, color: starColor),
          ],
        ),
      ],
    );

  }
}


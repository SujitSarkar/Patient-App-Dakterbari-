import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_panel/pages/discount_shop_all_details/discount-Shop_details.dart';
import 'package:user_panel/pages/subpage/make_discountshop_payment_page.dart';
import 'package:user_panel/provider/discount_shop_provider.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';


class SubscribedDiscountShop extends StatefulWidget {
  @override
  _SubscribedDiscountShopState createState() => _SubscribedDiscountShopState();
}

class _SubscribedDiscountShopState extends State<SubscribedDiscountShop> {


  @override
  Widget build(BuildContext context) {
    final DiscountShopProvider disShopProvider=Provider.of<DiscountShopProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xffF4F7F5),
      body: _bodyUI(disShopProvider),
    );
  }

  Widget _bodyUI(DiscountShopProvider disShopProvider){
    return RefreshIndicator(
      backgroundColor: Colors.white,
      onRefresh: ()=> disShopProvider.getSubscribedShop(),
      child: AnimationLimiter(
        child: ListView.builder(
          physics:  const AlwaysScrollableScrollPhysics(),
          itemCount: disShopProvider.subscribedShopList.length,
          itemBuilder: (context, index){
            return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 500),
                child: SlideAnimation(
                  verticalOffset: 400,
                  child: FadeInAnimation(
                    child: DiscountShopTile(
                      id: disShopProvider.subscribedShopList[index].id,
                      pId:disShopProvider.subscribedShopList[index].pId,
                      pName:disShopProvider.subscribedShopList[index].pName,
                      year:disShopProvider.subscribedShopList[index].year,
                      month:disShopProvider.subscribedShopList[index].month,
                      day:disShopProvider.subscribedShopList[index].day,
                      shopId:disShopProvider.subscribedShopList[index].shopId,
                      shopName: disShopProvider.subscribedShopList[index].shopName,
                      shopImage: disShopProvider.subscribedShopList[index].shopImage,
                      about: disShopProvider.subscribedShopList[index].about,
                      executiveName: disShopProvider.subscribedShopList[index].executiveName,
                      executivePhoneNo: disShopProvider.subscribedShopList[index].executivePhoneNo,
                      shopCategory: disShopProvider.subscribedShopList[index].shopCategory,
                      subCategory: disShopProvider.subscribedShopList[index].subCategory,
                      webAddress: disShopProvider.subscribedShopList[index].webAddress,
                      mailAddress: disShopProvider.subscribedShopList[index].mailAddress,
                      twitterLink: disShopProvider.subscribedShopList[index].twitterLink,
                      facebookLink: disShopProvider.subscribedShopList[index].facebookLink,
                      phoneNo: disShopProvider.subscribedShopList[index].phoneNo,
                      linkedinLink: disShopProvider.subscribedShopList[index].linkedinLink,
                      amenities: disShopProvider.subscribedShopList[index].amenities,
                      avgReviewStar: disShopProvider.subscribedShopList[index].avgReviewStar,
                      sat: disShopProvider.subscribedShopList[index].sat,
                      sun: disShopProvider.subscribedShopList[index].sun,
                      mon: disShopProvider.subscribedShopList[index].mon,
                      tue: disShopProvider.subscribedShopList[index].tue,
                      wed: disShopProvider.subscribedShopList[index].wed,
                      thu: disShopProvider.subscribedShopList[index].thu,
                      fri: disShopProvider.subscribedShopList[index].fri,
                      shopAddress: disShopProvider.subscribedShopList[index].shopAddress,
                      latitude: disShopProvider.subscribedShopList[index].latitude,
                      longitude: disShopProvider.subscribedShopList[index].longitude,
                      discount: disShopProvider.subscribedShopList[index].discount,
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
  String pId;
  String pName;
  String year;
  String month;
  String day;
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
  static const Color starColor = Color(0xffFFBA00);


  DiscountShopTile({this.id, this.pId, this.pName, this.year, this.month,
      this.day, this.shopId, this.shopName, this.shopImage, this.about,
      this.executiveName, this.executivePhoneNo, this.shopCategory,
      this.subCategory, this.webAddress, this.mailAddress, this.twitterLink,
      this.facebookLink, this.phoneNo, this.linkedinLink, this.amenities,
      this.sat, this.sun, this.mon, this.tue, this.wed, this.thu, this.fri,
      this.shopAddress, this.review, this.latitude, this.longitude,
      this.avgReviewStar, this.discount});

  @override
  Widget build(BuildContext context) {
    final DiscountShopProvider disShopProvider = Provider.of<DiscountShopProvider>(context);

    return GestureDetector(
      onTap: ()async{
        disShopProvider.loadingMgs='Please wait...';
        showLoadingDialog(context,disShopProvider);

        final subscribeDate = DateTime(int.parse(year), int.parse(month), int.parse(day));
        final currentDate = DateTime.now();
        final int subsDay = currentDate.difference(subscribeDate).inDays;

        /// If remaining subscription
            if(subsDay<=365){
              await disShopProvider.getAllShopReview(shopId).then((value)async{
                await disShopProvider.getFeaturedProduct(shopId).then((value){
                  disShopProvider.getOneStar();
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => DiscountShopDetails(
                        id:shopId,
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
                pId: pId,
                pName: pName,
                shopId: shopId,
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
                // boxShadow: [
                //   BoxShadow(
                //       color: Colors.grey, offset: Offset(0, 1), blurRadius: 2)
                // ]
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
                    child: Image.asset('assets/loadingimage.gif',fit: BoxFit.cover,height: 180),
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
                      ratingStar(),
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

  Widget ratingStar(){
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

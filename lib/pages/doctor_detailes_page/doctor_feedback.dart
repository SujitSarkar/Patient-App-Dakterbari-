import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:user_panel/provider/doctor_provider.dart';
import 'package:user_panel/provider/review_provider.dart';
import 'package:user_panel/widgets/no_data_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:user_panel/shared/form_decoration.dart';
import 'package:expandable_text/expandable_text.dart';

// ignore: must_be_immutable
class DoctorFeedback extends StatefulWidget {
  String id;
  String fullName;
  String phone;
  String email;
  String about;
  String country;
  String state;
  String city;
  String gender;
  String specification;
  List<dynamic> optionalSpecification;
  String degree;
  String bmdcNumber;
  String appFee;
  String teleFee;
  String experience;
  String photoUrl;
  String totalPrescribe;
  String countryCode;
  String currency;
  bool provideTeleService;

  DoctorFeedback(
      {this.id,
        this.fullName,
        this.phone,
        this.email,
        this.about,
        this.gender,
        this.country,
        this.state,
        this.city,
        this.specification,
        this.optionalSpecification,
        this.degree,
        this.bmdcNumber,
        this.appFee,
        this.teleFee,
        this.experience,
        this.photoUrl,
        this.totalPrescribe,
        this.provideTeleService,
        this.countryCode,
        this.currency,
      });
  @override
  _DoctorFeedbackState createState() => _DoctorFeedbackState();
}

class _DoctorFeedbackState extends State<DoctorFeedback> {
  static const Color starColor = Color(0xffFFBA00);
  @override
  Widget build(BuildContext context) {
    final DoctorProvider drProvider = Provider.of<DoctorProvider>(context);
    final ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context);


    return Scaffold(
      backgroundColor: Colors.white,
      //backgroundColor: Color(0xffF4F7F5),
      //appBar: customAppBarDesign(context, "My Review"),
      body: _bodyUI(drProvider, reviewProvider),
    );
  }
  _bodyUI(DoctorProvider drProvider, ReviewProvider reviewProvider) {
    //Size size = MediaQuery.of(context).size;
    return Container(
      color: Color(0xffF4F7F5),
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _profileSection(drProvider),
            _ratingSection(reviewProvider),

            ///Recent Review Header...
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              alignment: Alignment.topLeft,
              child: Text(
                "Recent Reviews",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500],
                ),
              ),
            ),

            ///Review Cart...
            reviewProvider.allReviewList.isNotEmpty?
            AnimationLimiter(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: reviewProvider.allReviewList.length>1? 1 :reviewProvider.allReviewList.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 500),
                      child: SlideAnimation(
                        horizontalOffset: 400,
                        child: FadeInAnimation(
                          child: ReviewTile(index: index,gender: widget.gender,)),
                      )
                  );
                },
              ),
            ): NoData(message: 'No reviews yet'),
            SizedBox(height: 10),

            reviewProvider.allReviewList.length>1? Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: ()=>_reviewModalBuilder(),
                child: Text('View all review',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Theme.of(context).primaryColor,fontSize:16,fontWeight: FontWeight.w500)),
              ),
            ):Container(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  ///Profile Section...
  Widget _profileSection(DoctorProvider drProvider) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider,child){
        return Container(
          padding: EdgeInsets.all(10),
          color: Colors.white,
          height: size.height * .25,
          width: size.width,
          child: Row(
            children: [
              Container(
                width: size.width * .46,
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: widget.photoUrl == null ? Image.asset(
                    widget.gender=='Male'?
                    "assets/male.png":'assets/female.png', width: size.width*.40,height: size.width*.45 ,fit: BoxFit.cover)
                    : ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: CachedNetworkImage(
                    imageUrl: widget.photoUrl,
                    placeholder: (context, url) =>
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/loadingimage.gif', width: size.width * .46,
                            fit: BoxFit.cover,),
                        ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: size.width * .46,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                width: size.width * .42,
                margin: EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.fullName ?? 'Your Name',
                      style: TextStyle(
                          fontSize: size.width * .06, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: size.width / 30),
                    Text(
                      "Avg. Ratings",
                      style: TextStyle(
                          fontSize: size.width * .04,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        Text(
                          "${reviewProvider.avgRating}",
                          style: TextStyle(
                              fontSize: size.width * .07,
                              fontWeight: FontWeight.w500,
                              color: starColor),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.star,
                          size: size.width * .08,
                          color: starColor,
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );

  }

  ///Ratings Section...
  Widget _ratingSection(ReviewProvider reviewProvider) {
    Size size = MediaQuery
        .of(context)
        .size;

    Map<String, double> dataMap = {
      "⭐": double.parse(reviewProvider.oneStar.toString()),
      "⭐⭐": double.parse(reviewProvider.twoStar.toString()),
      "⭐⭐⭐": double.parse(reviewProvider.threeStar.toString()),
      "⭐⭐⭐⭐": double.parse(reviewProvider.fourStar.toString()),
      "⭐⭐⭐⭐⭐": double.parse(reviewProvider.fiveStar.toString()),
    };
    final List<Color> colorList = [
      Color(0xffFF5C6B),
      Color(0xffDBB049),
      Color(0xff7A5AB5),
      Color(0xff00D099),
      Color(0xff0094D4),
    ];

    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.topLeft,
      color: Colors.white,
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Text(
            "Ratings Overview",
            style: TextStyle(
                color: Colors.grey[500],
                fontSize:  size.width * .036,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20),

          Container(
            width: size.width,
            child: PieChart(
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 1000),
              chartLegendSpacing: 35,
              chartRadius: size.width * .4,
              colorList: colorList,
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: size.width*.06,
              centerText: "Ratings",

              legendOptions: LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900]
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Total People Rated",
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize:  size.width * .033,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.assignment_ind,
                          color: Theme
                              .of(context)
                              .primaryColor,
                          size:  size.width * .038,
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${reviewProvider.allReviewList.length}',
                          style: TextStyle(
                              fontSize:  size.width * .032,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800]),
                        )
                      ],
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Appointment Booked",
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontSize:  size.width * .033,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          Icons.playlist_add_check_rounded,
                          color: Theme
                              .of(context)
                              .primaryColor,
                          size:  size.width * .038,
                        ),
                        SizedBox(width: 10),
                        Text(
                          reviewProvider.totalAppointment.toString(),
                          style: TextStyle(
                              fontSize:  size.width * .032,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800]),
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  ///Review modal
  void _reviewModalBuilder(){
    final Size size= MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Consumer<ReviewProvider>(
            builder: (context, reviewProvider, child){
              return Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)
                    ),
                    color: Color(0xffF4F7F5)
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
                        //padding: const EdgeInsets.only(right: 15),
                        child: GestureDetector(
                          onTap: ()=>Navigator.pop(context),
                          child: Icon(Icons.clear,color: Colors.grey[100],size: 30,),
                        )
                    ),

                    Expanded(
                      child: AnimationLimiter(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: reviewProvider.allReviewList.length,
                          itemBuilder: (context, index){
                            return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 500),
                                child: SlideAnimation(
                                  horizontalOffset: 400,
                                  child: FadeInAnimation(
                                    child: ReviewTile(index: index)),
                                )
                            );
                            },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
    );
  }
}

// ignore: must_be_immutable
class ReviewTile extends StatelessWidget {
  static const Color starColor = Color(0xffFFBA00);
  int index;
  String gender;
  ReviewTile({this.index,this.gender});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double starSize= size.width*.035;
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider,child){
        return Container(
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          margin: EdgeInsets.only(bottom: 10),
          decoration: simpleCardDecoration,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///Image Container
                  Container(
                    height: size.width * .18,
                    width: size.width * .18,
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      //color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Theme.of(context).accentColor,
                    ),
                    child: reviewProvider.allReviewList[index].pPhotoUrl==null?
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                        child: Image.asset(gender=='Male'?
                        "assets/male.png":'assets/female.png', width: size.width*.40,height: size.width*.45 ,fit: BoxFit.cover,))
                        :ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      child: CachedNetworkImage(
                        imageUrl: reviewProvider.allReviewList[index].pPhotoUrl,
                        placeholder: (context, url) => Image.asset('assets/loadingimage.gif'),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        height: size.width * .18,
                        width: size.width * .18,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                  ///Name & Problem Container
                  Container(
                    alignment: Alignment.topLeft,
                    padding:
                    const EdgeInsets.only(top: 5, bottom: 5),
                    width: size.width * .47,
                    //height:  size.width * .16,
                    //color: Colors.blue,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          reviewProvider.allReviewList[index].pName??'',
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: size.width*.045,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500),
                        ),
                       // SizedBox(height: 3),
                        Text(
                          reviewProvider.allReviewList[index].pProblem??'',
                          maxLines: 2,
                          style: TextStyle(
                              fontSize:  size.width * .028, color: Colors.grey[500]),
                        )
                      ],
                    ),
                  ),

                  ///Star container
                  Container(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    //color: Colors.green,
                    width: size.width * .25,
                    //height:  size.width * .16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${reviewProvider.allReviewList[index].reviewStar}.0',
                              style: TextStyle(
                                  fontSize: starSize,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 5),
                            int.parse(reviewProvider.allReviewList[index].reviewStar) == 5
                                ? Row(
                              children: [
                                Icon(Icons.star, size: starSize, color: starColor),
                                Icon(Icons.star, size: starSize, color: starColor),
                                Icon(Icons.star, size: starSize, color: starColor),
                                Icon(Icons.star, size: starSize, color: starColor),
                                Icon(Icons.star, size: starSize, color: starColor),
                              ],
                            )
                                : int.parse(reviewProvider.allReviewList[index].reviewStar) == 4
                                ? Row(
                              children: [
                                Icon(Icons.star,
                                    size: starSize, color: starColor),
                                Icon(Icons.star,
                                    size: starSize, color: starColor),
                                Icon(Icons.star,
                                    size: starSize, color: starColor),
                                Icon(Icons.star,
                                    size: starSize, color: starColor),
                              ],
                            )
                                : int.parse(reviewProvider.allReviewList[index].reviewStar) == 3
                                ? Row(
                              children: [
                                Icon(Icons.star,
                                    size: starSize, color: starColor),
                                Icon(Icons.star,
                                    size: starSize, color: starColor),
                                Icon(Icons.star,
                                    size: starSize, color: starColor),
                              ],
                            )
                                : int.parse(reviewProvider.allReviewList[index].reviewStar) == 2
                                ? Row(
                              children: [
                                Icon(Icons.star,
                                    size: starSize, color: starColor),
                                Icon(Icons.star,
                                    size: starSize, color: starColor),
                              ],
                            )
                                : Row(
                              children: [
                                Icon(Icons.star,
                                    size: starSize, color: starColor),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Text(
                          reviewProvider.allReviewList[index].reviewDate??'',
                          style: TextStyle(fontSize: starSize, color: Colors.grey[500]),
                        )
                      ],
                    ),
                  ),
                ],
              ),

              ///Review Text Container
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                width: size.width * .95,
                child: ExpandableText(
                  reviewProvider.allReviewList[index].reviewComment,
                  expandText: 'more',
                  collapseText: 'less',
                  maxLines: 2,
                  linkColor: Theme.of(context).primaryColor,
                  style: TextStyle(color: Colors.grey[800], fontSize: 14),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}



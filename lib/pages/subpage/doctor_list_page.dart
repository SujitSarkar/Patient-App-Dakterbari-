import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:user_panel/model/doctor_model.dart';
import 'package:user_panel/pages/doctor_detailes_page/doctor_profile_tab.dart';
import 'package:provider/provider.dart';
import 'package:user_panel/provider/doctor_provider.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:user_panel/provider/review_provider.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:user_panel/shared/form_decoration.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// ignore: must_be_immutable
class DoctorList extends StatefulWidget {
  String category;

  DoctorList({this.category});

  @override
  _DoctorListState createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  List<DoctorDetailsModel> filteredDoctor = [];
  List<DoctorDetailsModel> doctorList = [];
  int _counter=0;
  bool _folded = true;

  void _customInitState(DoctorProvider drProvider){
    setState(() {
      doctorList = drProvider.doctorCategoryList;
      filteredDoctor = doctorList;
      _counter++;
    });
  }

  void _filterDoctorList(String searchItem){
    setState(() {
      filteredDoctor = doctorList.where((element) =>
      (element.fullName.toLowerCase().contains(searchItem.toLowerCase()))).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    DoctorProvider drProvider = Provider.of<DoctorProvider>(context);
    if(_counter==0) _customInitState(drProvider);

    return Scaffold(
      backgroundColor: Color(0xffF4F7F5),
      appBar: customAppBarDesign(context, widget.category),
      body: _bodyUI(drProvider),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  Widget _bodyUI(DoctorProvider drProvider) {
    DoctorProvider drProvider = Provider.of<DoctorProvider>(context);
    return RefreshIndicator(
      backgroundColor: Colors.white,
      onRefresh: ()async{
        await drProvider.getDoctorByCategory(widget.category);
        _customInitState(drProvider);
        },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _animatedSearchBar(),
          SizedBox(height: 5),

          Expanded(
            child: AnimationLimiter(
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: filteredDoctor.length,
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              verticalOffset: 400,
                              child: FadeInAnimation(
                                child: DoctorBuildersTile(
                                  id: filteredDoctor[index].id,
                                  fullName: filteredDoctor[index].fullName,
                                  phone: filteredDoctor[index].phone,
                                  email: filteredDoctor[index].email,
                                  about: filteredDoctor[index].about,
                                  country: filteredDoctor[index].country,
                                  state: filteredDoctor[index].state,
                                  city: filteredDoctor[index].city,
                                  gender: filteredDoctor[index].gender,
                                  specification:
                                  filteredDoctor[index].specification,
                                  optionalSpecification: filteredDoctor[index].optionalSpecification,
                                  degree: filteredDoctor[index].degree,
                                  bmdcNumber: filteredDoctor[index].bmdcNumber,
                                  teleFee: filteredDoctor[index].teleFee,
                                  appFee: filteredDoctor[index].appFee,
                                  experience: filteredDoctor[index].experience,
                                  photoUrl: filteredDoctor[index].photoUrl,
                                  totalPrescribe: filteredDoctor[index].totalPrescribe,
                                  countryCode: filteredDoctor[index].countryCode,
                                  currency: filteredDoctor[index].currency,
                                  provideTeleService: filteredDoctor[index].provideTeleService,
                                  sat: filteredDoctor[index].sat,
                                  sun: filteredDoctor[index].sun,
                                  mon: filteredDoctor[index].mon,
                                  tue: filteredDoctor[index].tue,
                                  wed: filteredDoctor[index].wed,
                                  thu: filteredDoctor[index].thu,
                                  fri: filteredDoctor[index].fri,
                                ),),
                            )
                        );
                      }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _animatedSearchBar(){
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      width: _folded ? 50 : MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: Colors.white,
        boxShadow: kElevationToShadow[2],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16),
              child: !_folded
                  ? TextField(
                onChanged: _filterDoctorList,
                decoration: InputDecoration(
                    hintText: 'Search by name...',
                    hintStyle: TextStyle(color: Theme.of(context).primaryColor),
                    border: InputBorder.none),
              )
                  : null,
            ),
          ),
          Container(
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_folded ? 32 : 0),
                  topRight: Radius.circular(32),
                  bottomLeft: Radius.circular(_folded ? 32 : 0),
                  bottomRight: Radius.circular(32),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Icon(
                    _folded ? Icons.search : Icons.close,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _folded = !_folded;
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class DoctorBuildersTile extends StatelessWidget {
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
  List<dynamic> sat;
  List<dynamic> sun;
  List<dynamic> mon;
  List<dynamic> tue;
  List<dynamic> wed;
  List<dynamic> thu;
  List<dynamic> fri;

  DoctorBuildersTile(
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
      this.currency,
      this.sat,
      this.countryCode,
      this.fri,
      this.mon,
      this.sun,
      this.thu,
      this.tue,
      this.wed});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    DoctorProvider drProvider = Provider.of<DoctorProvider>(context);
    final ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context);
    return GestureDetector(
      onTap: () async {
        drProvider.loadingMgs = 'Please wait...';
        showLoadingDialog(context, drProvider);
        await drProvider.getFaq(id).then((value) async {
          await drProvider.getHospitals(id).then((value) async {
            await reviewProvider.getTotalAppointment(id).then((value) async {
              await reviewProvider.getAllReview(id).then((value) async {
                reviewProvider.getOneStar();
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DoctorDetailsTab(
                              id: id,
                              fullName: fullName,
                              phone: phone,
                              email: email,
                              about: about,
                              country: country,
                              state: state,
                              city: city,
                              gender: gender,
                              specification: specification,
                              optionalSpecification: optionalSpecification,
                              degree: degree,
                              bmdcNumber: bmdcNumber,
                              teleFee: teleFee,
                              appFee: appFee,
                              experience: experience,
                              photoUrl: photoUrl,
                              totalPrescribe: totalPrescribe,
                              countryCode: countryCode,
                              currency: currency,
                              provideTeleService: provideTeleService,
                              sat: sat,
                              sun: sun,
                              mon: mon,
                              tue: tue,
                              wed: wed,
                              thu: thu,
                              fri: fri,
                            )));
              });
            });
          });
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: simpleCardDecoration,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ///Leading Section(image)
            Container(
              height: size.width * 0.22,
              width: size.width * 0.20,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 1.5),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Theme.of(context).accentColor,
              ),
              child: photoUrl == null
                  ? Image.asset(gender=='Male'?
              "assets/male.png":'assets/female.png', width: size.width*.46,height: size.height * .28,fit: BoxFit.cover,)
                  : ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        imageUrl: photoUrl,
                        placeholder: (context, url) => Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset('assets/loadingimage.gif',
                              fit: BoxFit.cover, height: size.width * 0.23),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: size.width * .20,
                        height: size.width * 0.20,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),

            ///Middle Section
            Container(
                width: size.width * 0.5,
                padding: EdgeInsets.only(left: 5),
                //color: Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fullName?? '',
                        maxLines: 2,
                        style: TextStyle(fontSize: size.width*.045, color: Colors.black),
                        textAlign: TextAlign.left),
                    Text(degree?? '',
                        maxLines: 2,
                        style: TextStyle(fontSize: size.width*.03),
                        textAlign: TextAlign.left),
                  ],
                )),

            ///Trailing Section
            Container(
              width: size.width * 0.23,
              padding: EdgeInsets.only(left: 5),
              //color: Colors.green,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child: Text('Appointment',style: TextStyle(color: Colors.white,fontSize: size.width*.03),),
                  ),
                  SizedBox(height: 5),

                  ///fees
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      teleFee != null
                          ? Text(
                              'Tele fee: $teleFee',
                              style: TextStyle(fontSize: size.width * 0.027),
                              textAlign: TextAlign.center,
                            )
                          : Container(),

                      appFee != null
                          ? Text(
                              'App. fee: $appFee',
                              style: TextStyle(fontSize: size.width * 0.027),
                              textAlign: TextAlign.center,
                            )
                          : Container(),
                      teleFee != null || appFee != null
                          ? Text(
                              '$currency',
                              style: TextStyle(fontSize: size.width * 0.027),
                              textAlign: TextAlign.center,
                            )
                          : Container(),

                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}



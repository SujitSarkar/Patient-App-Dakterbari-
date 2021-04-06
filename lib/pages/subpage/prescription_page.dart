import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_panel/provider/appointment_provider.dart';
import 'package:user_panel/widgets/button_widgets.dart';
import 'package:user_panel/widgets/no_data_widget.dart';
import 'package:user_panel/shared/form_decoration.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';


// ignore: must_be_immutable
class PrescriptionPage extends StatefulWidget {
  String id;
  String drId;
  String drName;
  String drPhotoUrl;
  String drDegree;
  String drEmail;
  String drAddress;
  String specification;
  String appFee;
  String teleFee;
  String currency;
  String prescribeDate;
  String prescribeState;
  String pId;
  String pName;
  String pPhotoUrl;
  String pAddress;
  String pAge;
  String pGender;
  String pProblem;
  String bookingDate;
  String appointDate;
  String chamberName;
  String chamberAddress;
  String bookingSchedule;
  String actualProblem;
  String rx;
  String advice;
  String nextVisit;
  String paymentState;
  String prescribeNo;
  String appointState; //telemedicine/chamber
  List<dynamic> medicines;

  PrescriptionPage({this.id,
    this.drId,
    this.drName,
    this.drPhotoUrl,
    this.drDegree,
    this.drEmail,
    this.drAddress,
    this.prescribeDate,
    this.pName,
    this.pId,
    this.pPhotoUrl,
    this.pAddress,
    this.pAge,
    this.pGender,
    this.pProblem,
    this.bookingDate,
    this.bookingSchedule,
    this.rx,
    this.advice,
    this.nextVisit,
    this.paymentState,
    this.appointDate,
    this.appointState,
    this.medicines,
    this.chamberName,
    this.chamberAddress,
    this.specification,
    this.appFee,
    this.teleFee,
    this.currency,
    this.prescribeNo,
    this.actualProblem,this.prescribeState});
  @override
  _PrescriptionPageState createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {

  TextEditingController _reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      //backgroundColor: Color(0xffF4F7F5),
      appBar: customAppBarDesign(context, "Prescribe to ${widget.pName}"),
      body: _bodyUI(),
    );
  }

  Widget _bodyUI() {
    final Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          _topSectionBuilder(size),
          SizedBox(height: 10),
          _patientInformationSection(size),
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.only(left: 10,bottom: 5),
            alignment: Alignment.topLeft,
              child: Text("Prescribe Medicine",
                style:TextStyle(color:Theme.of(context).primaryColor,fontSize: size.width * .040,fontWeight: FontWeight.bold),
                textAlign: TextAlign.start, )),
          Container(
            margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 10.0),
            padding:EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Color(0xffF4F7F5),
              ),
              //height: 150,

              child: Column(
                children: [
                  widget.medicines!=null?ListView.builder(
                    shrinkWrap: true,
          itemCount: widget.medicines.length>4?4
                   :widget.medicines.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(widget.medicines[index],
                        style: TextStyle(
                            fontSize: size.width * .030,
                           ),),
                    );
                  }
          ):NoData(message: 'No medicine prescribe yet '),

                  widget.medicines==null?Container(): Container(
                    width: size.width,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: GestureDetector(
                      onTap: ()=> ViewAllMedicine(context),
                      child: Text("View all Medicine",textAlign: TextAlign.end,style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: size.width * .03,
                          fontWeight: FontWeight.w500),),
                    ),
                  ),
                ],
              ),
          ),
          Container(

          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                ///Patient problem
                Text("Patient Problems",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: size.width * .040,fontWeight: FontWeight.bold),),
                widget.actualProblem==null?Container():_buildText(widget.actualProblem),
                ///Rx
                Text("Rx.",style: TextStyle(color:Theme.of(context).primaryColor,fontSize: size.width * .040,fontWeight: FontWeight.bold),),

                widget.rx==null?Container():_buildText(widget.rx),
                SizedBox(height: 10),
                ///Advice
                Text("Advice",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: size.width * .040,fontWeight: FontWeight.bold),),

                widget.advice==null?Container():_buildText(widget.advice),
                SizedBox(height: 10),
                ///next visit
                Text("Next Visite",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: size.width * .040,fontWeight: FontWeight.bold),),

                widget.nextVisit==null?Container(): _buildText(widget.nextVisit),

                SizedBox(height: 8),
                ///Review and rating
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(left: 60,right: 60,bottom: 10),
                    child:outlineIconButton(context, Icons.star, 'Submit Rating', Color(0xffFFBA00)),
                  ),
                  onTap:  _reviewBuilder,
                )
              ],
            ),
          ),
         SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildText(String text){
    Size size=MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xffF4F7F5),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child:Text(text,style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600,fontSize: size.width * .033)),
    );
  }
/// Top Section
  Widget _topSectionBuilder(Size size) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      //color: Color(0xffF4F7F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            color: Colors.white,
            child: Image.asset('assets/banner.png', height: size.width*.15),
          ),
          SizedBox(height: size.width / 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 35,
                width: 35,
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: widget.drPhotoUrl==null?ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Image.asset('assets/home_icon/doctor.png'))
                    :ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl: widget.drPhotoUrl,
                    placeholder: (context, url) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    height: 35,
                    width: 35,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 8),
              widget.drName==null?Container(): Text(
                widget.drName,
                maxLines: 1,
                style: TextStyle(
                    fontSize: size.width / 20,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          widget.drDegree==null?Container():Text(
            widget.drDegree,
            maxLines: 2,
            style:
                TextStyle(fontSize: size.width / 32, color: Colors.grey[700]),
          ),
          SizedBox(height: size.width / 40),
          widget.drAddress==null?Container():Text(widget.drAddress,
            maxLines: 2,
            style:
                TextStyle(fontSize: size.width / 30, color: Colors.grey[700]),
          ),
          Text(
            'Phone:${widget.drId}',

            maxLines: 1,
            style:
                TextStyle(fontSize: size.width / 30, color: Colors.grey[700]),
          ),
          widget.drEmail==null?Container():Text(
            'Email: ${widget.drEmail}',
            maxLines: 1,
            style:
                TextStyle(fontSize: size.width / 30, color: Colors.grey[700]),
          ),
          SizedBox(height: size.width / 40),
          Container(
            height: 2,
            width: size.width,
            color: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }

  ///Pastient Information
  Widget _patientInformationSection(Size size) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      //color: Color(0xffF4F7F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Date & S.No
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: size.width * .43,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Date: ",
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: size.width / 30,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.prescribeDate??'',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: size.width / 32,
                              color: Colors.grey[800]),
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey[800],
                          width: size.width * .34,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: size.width * .43,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "P.No: ",
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: size.width / 30,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.prescribeNo??'',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: size.width / 32,
                              color: Colors.grey[800]),
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey[800],
                          width: size.width * .33,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          //Patient Name
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Patient Name: ",
                maxLines: 1,
                style: TextStyle(
                    fontSize: size.width / 30,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.pName??'',
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: size.width / 32, color: Colors.grey[800]),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey[800],
                    width: size.width * .71,
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 5),

          //Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Address: ",
                maxLines: 1,
                style: TextStyle(
                    fontSize: size.width / 30,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.pAddress??'',
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: size.width / 32, color: Colors.grey[800]),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey[800],
                    width: size.width * .79,
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 5),

          ///Age & Gender
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: size.width * .43,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Age: ",
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: size.width / 30,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.pAge??''} year',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: size.width / 32,
                              color: Colors.grey[800]),
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey[800],
                          width: size.width * .35,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                width: size.width * .43,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Gender: ",
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: size.width / 30,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.pGender??'',
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: size.width / 32,
                              color: Colors.grey[800]),
                        ),
                        Container(
                          height: 1,
                          color: Colors.grey[800],
                          width: size.width * .29,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

///review builder
  void _reviewBuilder(){
    final Color starColor= Color(0xffFFBA00);
    showDialog(
      context: context,
      builder: (context){
        return Consumer<AppointmentProvider>(
          builder: (context, appProvider, child){
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
                        itemCount: appProvider.starList.length,
                        itemBuilder: (context, index){
                          return IconButton(
                            splashRadius: 20,
                              icon: appProvider.starList[index]==true?
                              Icon(Icons.star,color: starColor,size: 26,)
                                  :Icon(Icons.star_border,color: starColor,size: 26,),
                              onPressed:()=> appProvider.changeStarColor(index),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _reviewController,
                      keyboardType: TextInputType.text,
                      maxLines: 4,
                      validator: (val)=> val.isEmpty?'Write your review':null,
                      decoration: FormDecorationWithoutPrefix.copyWith(labelText: 'Write your review',
                          alignLabelWithHint: true,fillColor: Color(0xffF4F7F5)),
                    ),
                    SizedBox(height: 10),

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
                                appProvider.loadingMgs='Submitting review...';
                                showLoadingDialog(context, appProvider);
                                print(widget.id);
                                appProvider.submitReview(widget.id, _reviewController.text, context, _scaffoldKey).then((value){
                                  _reviewController.clear();
                                });
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
          },
        );
      }
    );
  }


  ///Medicine Modal
  void ViewAllMedicine(BuildContext context) {
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
              color: Colors.white,
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
                    itemCount: widget.medicines.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                      return Container(
                        margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Color(0xffF4F7F5),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: Text(widget.medicines[index]));
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

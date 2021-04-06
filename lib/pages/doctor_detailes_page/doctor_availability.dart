import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_panel/provider/doctor_provider.dart';
import 'package:user_panel/widgets/no_data_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// ignore: must_be_immutable
class DoctorAvailability extends StatefulWidget {
  bool provideTeleService;
  List<dynamic> sat;
  List<dynamic> sun;
  List<dynamic> mon;
  List<dynamic> tue;
  List<dynamic> wed;
  List<dynamic> thu;
  List<dynamic> fri;
  DoctorAvailability({
  this.provideTeleService,
  this.sat,
  this.fri,
  this.mon,
  this.sun,
  this.thu,
  this.tue,
  this.wed
  });
  @override
  _DoctorAvailabilityState createState() => _DoctorAvailabilityState();
}

class _DoctorAvailabilityState extends State<DoctorAvailability> {

  @override
  Widget build(BuildContext context) {
    DoctorProvider hosProvider=Provider.of<DoctorProvider>(context);
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      body: _bodyUI( hosProvider),
    );
  }
  Widget _bodyUI(DoctorProvider drProvider){
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView(
        children: [
          ///Chamber Schedule
          drProvider.hospitalList.isEmpty?Container():Container(
            margin: EdgeInsets.only(top: 15),
            child: Text("Chamber/Hospital",
              style: TextStyle(fontSize: size.width * .042,fontWeight: FontWeight.bold,color: Colors.blueGrey),
            textAlign: TextAlign.start,),
          ),

          drProvider.hospitalList.isNotEmpty?
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 1),
            decoration: BoxDecoration(
              color: Color(0xffF4F7F5),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: AnimationLimiter(
              child: ListView.builder(
                itemCount: drProvider.hospitalList.length>2? 2
                    : drProvider.hospitalList.length,
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
                            child: HospitalTile(index: index),
                          ),),
                      )
                  );
                  },
              ),
            ),
          )
              :Padding(
                padding: const EdgeInsets.only(top: 50),
                child: NoData(message:'No Chamber/Hospital \u{1f614}'),
              ),

          drProvider.hospitalList.length>2? Container(
            width: size.width,
            // padding: EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: ()=> _viewAllChamberScheduleModal(context,drProvider),
              child: Container(
                child: Text("View all",textAlign: TextAlign.end,style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),),
              ),
            ),
          ):Container(),
          SizedBox(height: 8),


          /// Telemedicine Schedule
          widget.provideTeleService==true?Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text("Telemedicine Schedule",
                    style: TextStyle(color: Colors.blueGrey,fontSize: size.width * .042,fontWeight: FontWeight.bold ),
                    textAlign: TextAlign.start,),
                ),
                SizedBox(height: 3,),
                _openingHoursTelemedicineBuilder(drProvider),
              ],
            ),
          ):Container(),

        ],
      ),
    );
  }


  ///Chamber/Hospital Modal
  void _viewAllChamberScheduleModal(BuildContext context,DoctorProvider drProvider){
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
                child: AnimationLimiter(
                  child: ListView.builder(
                      itemCount: drProvider.hospitalList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 500),
                            child: SlideAnimation(
                              horizontalOffset: 400,
                              child: FadeInAnimation(
                                child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: HospitalTile(index:index),
                                ),),
                            )
                          ),
                        );
                      }
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ///Opening Hour Telemedicine Builder
  Widget _openingHoursTelemedicineBuilder(DoctorProvider drProvider) {
    Size size = MediaQuery.of(context).size;
    final String sat = drProvider.doctorCategoryList[0].sat == null
        ? ''
        : '  Saturday: ${drProvider.doctorCategoryList[0].sat[0]} - ${drProvider.doctorCategoryList[0].sat[1]}';
    final String sun = drProvider.doctorCategoryList[0].sun == null
        ? ''
        : '  Sunday: ${drProvider.doctorCategoryList[0].sun[0]} - ${drProvider.doctorCategoryList[0].sun[1]}';
    final String mon = drProvider.doctorCategoryList[0].mon == null
        ? ''
        : '  Monday: ${drProvider.doctorCategoryList[0].mon[0]} - ${drProvider.doctorCategoryList[0].mon[1]}';
    final String tue = drProvider.doctorCategoryList[0].tue == null
        ? ''
        : '  Tuesday: ${drProvider.doctorCategoryList[0].tue[0]} - ${drProvider.doctorCategoryList[0].tue[1]}';
    final String wed = drProvider.doctorCategoryList[0].wed == null
        ? ''
        : '  Wednesday: ${drProvider.doctorCategoryList[0].wed[0]} - ${drProvider.doctorCategoryList[0].wed[1]}';
    final String thu = drProvider.doctorCategoryList[0].thu == null
        ? ''
        : '  Thursday: ${drProvider.doctorCategoryList[0].thu[0]} - ${drProvider.doctorCategoryList[0].thu[1]}';
    final String fri = drProvider.doctorCategoryList[0].fri == null
        ? ''
        : '  Friday: ${drProvider.doctorCategoryList[0].fri[0]} - ${drProvider.doctorCategoryList[0].fri[1]}';
    return Container(
      //margin: EdgeInsets.symmetric(horizontal: 10.0),
      //margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Color(0xffF4F7F5),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //headingDecorationUnsized(context, "headingText", Colors.grey, Colors.black),
          SizedBox(height: 5),
          Container(

            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                drProvider.doctorCategoryList[0].sat == null?Container():Text(sat, style: TextStyle(fontSize: size.width * .036)),
                SizedBox(height: 5,),
                drProvider.doctorCategoryList[0].sun == null?Container():Text(sun, style: TextStyle(fontSize:  size.width * .036)),
                SizedBox(height: 5,),
                drProvider.doctorCategoryList[0].mon == null?Container():Text(mon, style: TextStyle(fontSize:  size.width * .036)),
                SizedBox(height: 5,),
                drProvider.doctorCategoryList[0].tue == null?Container():Text(tue, style: TextStyle(fontSize:  size.width * .036)),
                SizedBox(height: 5,),
                drProvider.doctorCategoryList[0].wed == null?Container():Text(wed, style: TextStyle(fontSize:  size.width * .036)),
                SizedBox(height: 5,),
                drProvider.doctorCategoryList[0].thu == null?Container():Text(thu, style: TextStyle(fontSize:  size.width * .036)),
                SizedBox(height: 5,),
                drProvider.doctorCategoryList[0].fri == null?Container():Text(fri, style: TextStyle(fontSize:  size.width * .036)),
              ],
            ),
          ),

        ],
      ),
    );
  }

}


// ignore: must_be_immutable
class HospitalTile extends StatelessWidget {
  int index;
  HospitalTile({this.index});
  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    final TextStyle common = TextStyle(fontSize: size.width * .030,fontWeight: FontWeight.w400,color: Theme.of(context).primaryColor);
    return Consumer<DoctorProvider>(
      builder: (context, operation, child){
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),
          title: Text(operation.hospitalList[index].hospitalName,style: TextStyle(fontSize: size.width * .036),),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //address
              Text(operation.hospitalList[index].hospitalAddress,style: TextStyle(fontSize: size.width * .032,fontWeight: FontWeight.w400),),
              Text(
                '${operation.hospitalList[index].sat==null?'':'Sat: ${operation.hospitalList[index].sat[0]}-${operation.hospitalList[index].sat[1]}  ||  '}'
                    '${operation.hospitalList[index].sun==null?'':'Sun: ${operation.hospitalList[index].sun[0]}-${operation.hospitalList[index].sun[1]}  ||  '}'
                    '${operation.hospitalList[index].mon==null?'':'Mon: ${operation.hospitalList[index].mon[0]}-${operation.hospitalList[index].mon[1]}  ||  '}'
                    '${operation.hospitalList[index].tue==null?'':'Tue: ${operation.hospitalList[index].tue[0]}-${operation.hospitalList[index].tue[1]}  ||  '}'
                    '${operation.hospitalList[index].wed==null?'':'Wed: ${operation.hospitalList[index].wed[0]}-${operation.hospitalList[index].wed[1]}  ||  '}'
                    '${operation.hospitalList[index].thu==null?'':'Thu: ${operation.hospitalList[index].thu[0]}-${operation.hospitalList[index].thu[1]}  ||  '}'
                    '${operation.hospitalList[index].fri==null?'':'Fri: ${operation.hospitalList[index].fri[0]}-${operation.hospitalList[index].fri[1]}  ||  '}',
                style: common,
              )
            ],
          ),

        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:user_panel/pages/subpage/doctor_list_page.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:user_panel/shared/static_variable_page.dart';
import 'package:user_panel/provider/doctor_provider.dart';
import 'package:provider/provider.dart';
import'package:user_panel/widgets/notification_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MedicalDepartment extends StatefulWidget {
  @override
  _MedicalDepartmentState createState() => _MedicalDepartmentState();
}

class _MedicalDepartmentState extends State<MedicalDepartment> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //backgroundColor: Color(0xffF4F7F5),
      backgroundColor: Colors.white,
      appBar: customAppBarDesign(context, 'Medical Department'),
      body: _bodyUI(size),
    );
  }
  Widget _bodyUI(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: size.width,
      height: size.height,
      child: Container(
            width: size.width,
            height: size.height * .90,
            child: AnimationLimiter(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    crossAxisCount: 3,
                    //childAspectRatio: .95
                  ),
                  itemCount: StaticVariables.doctorCategory.length,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 500),
                        child: SlideAnimation(
                          verticalOffset: 400,
                          child: FadeInAnimation(
                            child: GridBuilderTile(size, index),),
                        )
                    );
                  }),
            ),
          ),
    );
  }
}
// ignore: must_be_immutable
class GridBuilderTile extends StatelessWidget {
  int index;
  Size size;

  GridBuilderTile(this.size, this.index);

  @override
  Widget build(BuildContext context) {
    DoctorProvider drProvider = Provider.of<DoctorProvider>(context);
    return InkWell(
      onTap: () async{
        drProvider.loadingMgs='Please wait...';
        showLoadingDialog(context,drProvider);
        await drProvider.getDoctorByCategory(StaticVariables.doctorCategory[index]).then((value){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorList(category: StaticVariables.doctorCategory[index],)));
        },onError: (error){
          Navigator.pop(context);
          showAlertDialog(context, error.toString());
        });

      },

      splashColor: Theme.of(context).primaryColor,
      child: Container(
        //color: Color(0xffF4F7F5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(alignment: Alignment.center, children: [
                Container(
                  height: size.width*.16,
                  width: size.width*.16,
                  decoration: BoxDecoration(
                    color: Color(0xffF4F7F5),
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: index == 0
                          ? AssetImage('assets/medical_category/coronavirus.png')
                          : index == 1
                          ? AssetImage('assets/medical_category/pediatrics.png')
                          : index == 2
                          ? AssetImage('assets/medical_category/cardiology.png')
                          : index == 3
                          ? AssetImage('assets/medical_category/chest.png')
                          : index == 4
                          ? AssetImage('assets/medical_category/cancer.png')
                          : index == 5
                          ? AssetImage('assets/medical_category/diabetes.png')
                          : index == 6
                          ? AssetImage('assets/medical_category/dentist.png')
                          : index == 7
                          ? AssetImage('assets/medical_category/nutrition.png')
                          : index == 8
                          ? AssetImage('assets/medical_category/eye.png')
                          : index == 9
                          ? AssetImage('assets/medical_category/ent.png')
                          : index == 10
                          ? AssetImage('assets/medical_category/gastroenterology.png')
                          : index == 11
                          ? AssetImage('assets/medical_category/gynecology.png')
                          : index == 12
                          ? AssetImage('assets/medical_category/hematology.png')
                          : index == 13
                          ? AssetImage('assets/medical_category/homeopathic.png')
                          : index == 14
                          ? AssetImage('assets/medical_category/medicine.png')
                          : index == 15
                          ? AssetImage('assets/medical_category/neuro_medicine.png')
                          : index == 16
                          ? AssetImage('assets/medical_category/neurosurgery.png')
                          : index == 17
                          ? AssetImage('assets/medical_category/oncology.png')
                          : index == 18
                          ? AssetImage('assets/medical_category/orthopaedic.png')
                          : index == 19
                          ? AssetImage('assets/medical_category/physical_medicine.png')
                          : index == 20
                          ? AssetImage('assets/medical_category/pain_medicine.png')
                          : index == 21
                          ? AssetImage('assets/medical_category/plastic_surgery.png')
                          : index == 22
                          ? AssetImage('assets/medical_category/physiotherapy.png')
                          : index == 23
                          ? AssetImage('assets/medical_category/psychiatrist.png')
                          : index == 24
                          ? AssetImage('assets/medical_category/skin.png')
                          : index == 25
                          ? AssetImage('assets/medical_category/thyroid.png')
                          : index == 26
                          ? AssetImage('assets/medical_category/urology_Specialist.png')
                          : index == 27
                          ? AssetImage('assets/medical_category/urology.png')
                          : index == 28
                          ? AssetImage('assets/medical_category/herbal.png')
                          : AssetImage('assets/medical_category/vascular_surgery.png')
                    ),
                  ),
                  height: size.width*.09,
                  width: size.width*.09,
                ),
              ]),
              SizedBox(height: 7),
              Text(
                StaticVariables.doctorCategory[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, //Color(0xff00C5A4),
                    fontSize: size.width*.033,
                    fontWeight: FontWeight.bold),
              )
            ],
          )),
    );
  }
}


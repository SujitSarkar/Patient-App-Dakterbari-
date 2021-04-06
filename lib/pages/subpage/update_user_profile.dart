import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:user_panel/provider/patient_provider.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:user_panel/shared/form_decoration.dart';
import 'package:user_panel/shared/static_variable_page.dart';
import 'package:user_panel/widgets/button_widgets.dart';
import 'package:user_panel/widgets/notification_widget.dart';

class UpdateUserProfile extends StatefulWidget {
  @override
  _UpdateUserProfileState createState() => _UpdateUserProfileState();
}

class _UpdateUserProfileState extends State<UpdateUserProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _counter =0;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  void _initializeTextFormData(PatientProvider operation){
    setState(()=>_counter++);
    nameController.text = operation.patientList[0].fullName ?? '';
    phoneController.text = operation.patientList[0].id ?? '';
    emailController.text = operation.patientList[0].email ?? '';
    ageController.text = operation.patientList[0].age ?? '';

    operation.patientDetails.fullName=operation.patientList[0].fullName ?? '';
    operation.patientDetails.email=operation.patientList[0].email ?? '';
    operation.patientDetails.age=operation.patientList[0].age ??'';
    operation.patientDetails.bloodGroup = operation.patientList[0].bloodGroup;
    operation.patientDetails.country=operation.patientList[0].country ??'';
    operation.patientDetails.state=operation.patientList[0].state ??'';
    operation.patientDetails.city=operation.patientList[0].city ??'';
  }

  @override
  Widget build(BuildContext context) {
    PatientProvider operation = Provider.of<PatientProvider>(context);
    if(_counter==0)_initializeTextFormData(operation);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: customAppBarDesign(context, "My Profile"),
      body:_bodyUI(),
    );
  }
  Widget _bodyUI() {
    Size size = MediaQuery.of(context).size;
    PatientProvider operation = Provider.of<PatientProvider>(context);
    return Container(
      height: size.height,
      width: size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ///Account Section...
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.white,
              height: size.height * .25,
              width: size.width,
              child: Row(
                children: [
                  ///Profile Picture
                  Container(
                    width: size.width * .46,
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: operation.patientList[0].imageUrl==null? Image.asset("assets/male.png", width: 150)
                        :ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: CachedNetworkImage(
                        imageUrl: operation.patientList[0].imageUrl,
                        placeholder: (context, url) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:  Image.asset('assets/loadingimage.gif',fit: BoxFit.cover, height: size.height * .25),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        width: size.width * .46,
                        height: size.height * .25,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  ///Update Profile Image
                  Container(
                    width: size.width * .40,
                    margin: EdgeInsets.only(left: 10, top: 10),
                    child: InkWell(
                      onTap: (){
                        _getImageFromGallery(operation);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 3,
                                  ),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                              child: Icon(
                                Icons.camera,
                                color: Theme.of(context).primaryColor,
                                size: size.width*.05,
                              )),
                          SizedBox(height: size.width / 40),
                          Text(
                            "Change Image",
                            style: TextStyle(
                                fontSize: size.width*.05,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            ///Patient Details
            Container(
              width: size.width,
              padding: EdgeInsets.symmetric(horizontal: 10),
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(height: size.width / 20),
                  _buildTextForm("Full name", Icons.person,operation),
                  SizedBox(height: size.width / 20),
                  _buildTextForm("Phone number", Icons.phone_android_outlined,operation),
                  SizedBox(height: size.width / 20),
                  _buildTextForm("Email address", Icons.mail,operation),
                  SizedBox(height: size.width / 20),
                  _buildTextForm("Age", Icons.error_outlined,operation),
                  SizedBox(height: size.width / 20),
                  _dropDownBuilder(operation),
                  SizedBox(height: size.width / 20),
                  ///Address builder
                  Container(
                      width: size.width,
                      padding: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                      decoration: BoxDecoration(
                          color: Color(0xffF2F8F4),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Address',style: TextStyle(fontSize: 12,color: Colors.grey[700])),
                          SizedBox(height: 5),
                          operation.patientList[0].country==null&&operation.patientList[0].state==null?Text(
                            'Country, State, City',
                            style: TextStyle(fontSize: 16),
                          ):Text('${operation.patientList[0].country}, ${operation.patientList[0].state}, ${operation.patientList[0].city??''}')
                        ],
                      )
                  ),
                  SizedBox(height: size.width / 20),
                ],
              ),
            ),

            ///Country, State, City picker
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Color(0xffF2F8F4),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Change Address',style: TextStyle(fontSize: 12,color: Colors.grey[700])),
                    SelectState(
                      dropdownColor:Colors.white,
                      style: TextStyle(color: Theme.of(context).primaryColor,fontWeight: FontWeight.w500),
                      onCountryChanged: (value) {
                        setState(() {
                          operation.patientDetails.country = value;
                        });
                      },
                      onStateChanged:(value) {
                        setState(() {
                          operation.patientDetails.state = value;
                        });
                      },
                      onCityChanged:(value) {
                        setState(() {
                          operation.patientDetails.city = value;
                        });
                      },
                    ),
                  ],
                )
            ),

            SizedBox(height: size.width / 40),

            ///Update button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: InkWell(
                  onTap: (){
                    operation.loadingMgs = 'Updating information...';
                    showLoadingDialog(context,operation);
                    operation.updatePatientInformation(operation,_scaffoldKey, context);
                  },
                  splashColor: Colors.cyan[200],
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: bigOutlineIconButton(context, Icons.update, 'Update Information', Theme.of(context).primaryColor)),
            ),
            SizedBox(height: size.width / 40),


          ],
        ),
      ),
    );
  }
  Widget _buildTextForm(String hint, IconData prefixIcon, PatientProvider operation) {
    return TextFormField(
      //maxLines: hint=='About'?4:null,
      readOnly: hint=='Phone number'?true
          :false,

      controller: hint=='Full name'? nameController
          :hint=='Phone number'?phoneController
          :hint=='Email address'?emailController
          :ageController,
      initialValue: null,
      decoration: FormDecoration.copyWith(
          alignLabelWithHint: true,
          labelText: hint,
          fillColor: Color(0xffF4F7F5)),
      keyboardType: TextInputType.text,
      onChanged: (value){
        if(hint=='Full name') operation.patientDetails.fullName=nameController.text;
        if(hint=='Email address') operation.patientDetails.email=emailController.text;
        if(hint=='Age') operation.patientDetails.age=ageController.text;
        },

    );
  }

  Widget _dropDownBuilder(PatientProvider operation){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
      decoration: BoxDecoration(
          color: Color(0xffF4F7F5),
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      width: MediaQuery.of(context).size.width,
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value: operation.patientDetails.bloodGroup,
          hint: Text('Blood group',style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16)),
          items: StaticVariables.bloodGroupList.map((bloodGroup){
            return DropdownMenuItem(
              child: Text(bloodGroup,style: TextStyle(
                color: Colors.grey[900],
                fontSize: 16,)),
              value: bloodGroup,
            );
          }).toList(),
          onChanged: (newValue){
            setState(()=> operation.patientDetails.bloodGroup=newValue);
          },

          dropdownColor: Colors.white,
        ),
      ),
    );
  }

  Future<void> _getImageFromGallery(PatientProvider operation)async{
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery,maxWidth: 300,maxHeight: 300);
    if(pickedFile!=null){
      final File _image = File(pickedFile.path);
      operation.loadingMgs='Updating profile photo...';
      showLoadingDialog(context, operation);
      await operation.updatePatientProfilePhoto(_scaffoldKey,context, operation, _image);
    }else {
      showSnackBar(_scaffoldKey, 'No image selected', Colors.deepOrange);
    }

  }

}

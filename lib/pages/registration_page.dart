import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_panel/pages/home_page.dart';
import 'package:user_panel/widgets/button_widgets.dart';
import 'package:user_panel/pages/login_page.dart';
import 'package:user_panel/pages/terms_and_condition.dart';
import 'package:user_panel/provider/patient_provider.dart';
import 'package:user_panel/provider/reg_auth_provider.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:user_panel/shared/form_decoration.dart';
import 'package:user_panel/shared/static_variable_page.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _otpController = TextEditingController();

  void _initializedPatientData(RegAuth regAuth){
    regAuth.patientDetails.phone='';
    regAuth.patientDetails.fullName='';
    regAuth.patientDetails.password='';
    regAuth.patientDetails.countryCode='';
  }

  @override
  Widget build(BuildContext context) {
    final RegAuth regAuth=Provider.of<RegAuth>(context);
   final PatientProvider patientProvider=Provider.of<PatientProvider>(context);
    if(regAuth.patientDetails.phone==null){
      _initializedPatientData(regAuth);}
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:Colors.white,
      appBar: customAppBarDesign(context, "Register Now"),
      body:_BodyUI(context,regAuth,patientProvider),
    );
  }
  Widget _BodyUI(BuildContext context, RegAuth regAuth,PatientProvider patientProvider) {
    Size size = MediaQuery.of(context).size;
    return Container(
      //margin: EdgeInsets.only(left: 20, right: 20),
        height: size.height,
        width: size.width,
        child: ListView(
            children: [
              Column(
                children: [
                  Text(
                    "Your phone number is not recognized yet.",
                    style: TextStyle(
                        color: Colors.grey[700], fontSize: size.width / 21),
                  ),
                  Text(
                    "Let us know basic details for registration.",
                    style: TextStyle(
                        color: Colors.grey[700], fontSize: size.width / 21),
                  ),
                ],
              ),
              SizedBox(height: size.width / 8),

              //Registration Form
              Container(
                padding:EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    //Mobile number with country code
                    Container(
                      width: size.width,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Color(0xffF4F7F5),
                        borderRadius:  BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        children: [
                          Container(
                              width:size.width*.35,
                              child: _countryCodePicker(regAuth)
                          ),
                          Container(
                              width:size.width*.58,
                              child: _textFieldBuilder('Phone Number',regAuth)),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    //Full name
                    _textFieldBuilder('Full Name',regAuth),
                    SizedBox(height: size.width / 20),

                    //Password
                    _textFieldBuilder('Password',regAuth),
                    SizedBox(height: size.width / 20),
                    _textFieldBuilder('Age',regAuth),
                    SizedBox(height: size.width / 20),

                    _dropDownBuilder('Select Gender',regAuth),
                    SizedBox(height: size.width / 20),

                    //T&C row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: regAuth.agreeChk,
                          onChanged: (bool checkedValue)=> regAuth.agreeChk = checkedValue,
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text("I've read & agree to this agreement",
                                      style: TextStyle(color: Colors.grey[700]))),
                              GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TermsAndCondition())),
                                  child: Text(
                                    " read...",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: size.width / 20),

                    //Continue Button
                    GestureDetector(
                      onTap: ()=>_checkValidity(regAuth,patientProvider),
                      child: button(context, "Continue"),
                    ),
                    SizedBox(height: size.width / 15),

                    //Back to sign in button
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>LogIn())),
                      child: Text(
                        "Back to sign in",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: size.width / 20),
                  ],
                ),
              )
            ]
        )
    );
  }

  Widget _dropDownBuilder(String hint,RegAuth regAuth){
    Size size=MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
      decoration: BoxDecoration(
          color: Color(0xffF4F7F5),
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      width: MediaQuery.of(context).size.width,
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          value:  regAuth.patientDetails.gender,

          hint: Container(
            width: size.width*.75,
            child: Text(hint,style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16)),
          ),
          items: StaticVariables.genderItems.map((gender){
            return DropdownMenuItem(
              child: Container(
                width: size.width*.75,
                child: Text(gender,style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 16,)),
              ),
              value: gender,
            );
          }).toList(),
          onChanged: (newValue){
            setState(() {
              regAuth.patientDetails.gender = newValue;
            });
          },

          dropdownColor: Colors.white,
        ),
      ),
    );
  }

  Widget _textFieldBuilder(String hint,RegAuth regAuth){
    return TextFormField(
      obscureText:hint=='Password'? regAuth.obscure:false,
      keyboardType: hint=='Phone Number'? TextInputType.phone
          :hint=='Full Name'?TextInputType.text
          :hint=='Password'?TextInputType.text
          :hint=='Age'?TextInputType.text
          :TextInputType.number,
      onChanged: (val){
        setState(() {
          hint=='Phone Number'? regAuth.patientDetails.phone=val
              :hint=='Full Name'? regAuth.patientDetails.fullName=val
              :hint=='Password'?regAuth.patientDetails.password=val
              :regAuth.patientDetails.age=val;
        });
      },
      decoration: FormDecoration.copyWith(
          labelText: hint,
          hintStyle: TextStyle(fontSize: 14),
          fillColor: Color(0xffF4F7F5),
          prefixIcon:hint=='Full Name'?Icon(Icons.person_outline,size: 28)
              :hint=='Phone Number'?null
              :hint=='Password'?Icon(Icons.security_outlined)
              :hint=='Age'?null
              : null,

          suffixIcon: hint=='Password'? IconButton(
              icon: regAuth.obscure
                  ? Icon(Icons.visibility_off_rounded)
                  : Icon(Icons.remove_red_eye),
              onPressed: () =>
                  setState(() => regAuth.obscure = !regAuth.obscure)):null
      ),
    );
  }

  Widget _countryCodePicker(RegAuth regAuth){
    return CountryCodePicker(
      comparator: (a, b) =>
          b.name.compareTo(a.name),
      onChanged: (val) {
        regAuth.patientDetails.countryCode = val.dialCode;
        //print(countryCode);
      },
      onInit: (code) {
        regAuth.patientDetails.countryCode = code.dialCode;
        //print(countryCode);
      },
      favorite: ['+880', 'BD'],
      initialSelection: 'BD',
      showCountryOnly: false,
      showFlag: true,
      showOnlyCountryWhenClosed: false,
      showDropDownButton: true,
      padding: EdgeInsets.only(left: 10),
    );
  }

  Future<void>_checkValidity(RegAuth regAuth,PatientProvider patientProvider)async{
      if(regAuth.patientDetails.phone.isNotEmpty && regAuth.patientDetails.fullName.isNotEmpty && regAuth.patientDetails.password.isNotEmpty &&
          regAuth.patientDetails.age.isNotEmpty && regAuth.patientDetails.gender!=null ){
        if(regAuth.agreeChk){
          regAuth.loadingMgs = 'Please wait...';
          showLoadingDialog(context, regAuth);
          bool isRegistered= await regAuth.isPatientRegistered(regAuth.patientDetails.countryCode+regAuth.patientDetails.phone);
          bool isDoctorRegistered= await regAuth.isDoctorRegistered(regAuth.patientDetails.countryCode+regAuth.patientDetails.phone);

          if(!isRegistered){
            if(!isDoctorRegistered){
              _OTPVerification(regAuth,patientProvider);
            }else{
              Navigator.pop(context);
              showSnackBar(_scaffoldKey,'A Doctor is registered with this phone number', Colors.deepOrange);
            }

          }else{
            Navigator.pop(context);
            showSnackBar(_scaffoldKey,'A patient is registered with this phone number', Colors.deepOrange);
          }
        }else showSnackBar(_scaffoldKey,'Check agreement', Colors.deepOrange);
      }else showSnackBar(_scaffoldKey,'Complete all the required fields', Colors.deepOrange);
  }


  Future<void> _OTPVerification(RegAuth regAuth,PatientProvider patientProvider)async{
    FirebaseAuth _auth=FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
        phoneNumber: regAuth.patientDetails.countryCode+regAuth.patientDetails.phone,

        verificationCompleted: (PhoneAuthCredential credential)async{
          await _auth.signInWithCredential(credential).then((value) async{
            if(value.user!=null){
              bool result = await regAuth.registerUser(regAuth.patientDetails);
              if(result){
                //Save data to local
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.setString('id', regAuth.patientDetails.countryCode+regAuth.patientDetails.phone);
                pref.setStringList('likeId', []);
                await patientProvider.getPatient().then((value){
                  regAuth.patientDetails =null;
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage()), (route) => false);
                });
              }
              else{
                //Navigator.pop(context);
                Navigator.pop(context);
                showSnackBar(_scaffoldKey,'Error register patient. Try again', Colors.deepOrange);
              }
            }
          });
        },
        verificationFailed: (FirebaseAuthException e){
          if (e.code == 'invalid-phone-number') {
            Navigator.pop(context);
            showSnackBar(_scaffoldKey,'The provided phone number is not valid', Colors.deepOrange);
          }
        },
        codeSent: (String verificationId, int resendToken){
          regAuth.verificationCode = verificationId;
          Navigator.pop(context);
          _OTPDialog(regAuth);
        },
        codeAutoRetrievalTimeout: (String verificationId){
      regAuth.verificationCode = verificationId;
      Navigator.pop(context);
      _OTPDialog(regAuth);
    },
    timeout: Duration(seconds: 120),
    );
  }

  void _OTPDialog(RegAuth regAuth){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            contentPadding: EdgeInsets.all(20),
            title: Text("Phone Verification", textAlign: TextAlign.center),
            content: Container(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    child: Text(
                      "We've sent OTP verification code on your given number.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  SizedBox(height: 25),
                  TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    decoration: FormDecoration.copyWith(
                        labelText: "Enter OTP here",
                        fillColor: Colors.grey[100],
                        prefixIcon: Icon(Icons.security)),
                  ),
                  SizedBox(height: 10),
                  Consumer<PatientProvider>(
                    builder: (context, operation, child){
                      return GestureDetector(
                        onTap: ()async{
                          regAuth.loadingMgs = 'Verifying OTP...';
                          showLoadingDialog(context, regAuth);
                          try{
                            await FirebaseAuth.instance.signInWithCredential(PhoneAuthProvider.credential(
                                verificationId: regAuth.verificationCode, smsCode: _otpController.text)).then((value)async{
                              if(value.user!=null){
                                bool result = await regAuth.registerUser(regAuth.patientDetails);
                                if(result){
                                  //Save data to local
                                  SharedPreferences pref = await SharedPreferences.getInstance();
                                  pref.setString('id', regAuth.patientDetails.countryCode+regAuth.patientDetails.phone);
                                  pref.setStringList('likeId', []);
                                  await operation.getPatient().then((value){
                                    regAuth.patientDetails =null;
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>HomePage()), (route) => false);
                                  });
                                }
                                else{
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  showSnackBar(_scaffoldKey,'Error register patient. Try again', Colors.deepOrange);
                                }
                              }
                            });
                          }catch(e){
                            Navigator.pop(context);
                            Navigator.pop(context);
                            showSnackBar(_scaffoldKey,'Invalid OTP', Colors.deepOrange);
                          }
                        },
                        child: button(context, 'Submit'),
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  Text('OTP will expired after 2 minutes ',style: TextStyle(fontSize: 14,color: Colors.grey[600]))
                ],
              ),
            ),
          );
        });
  }

}

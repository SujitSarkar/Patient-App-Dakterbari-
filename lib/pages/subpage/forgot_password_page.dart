import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_panel/provider/patient_provider.dart';
import 'package:user_panel/shared/form_decoration.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'reset_password.dart';
import 'package:user_panel/widgets/button_widgets.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _otpController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _initializeDoctorData(PatientProvider provider) async {
    provider.patientDetails.phone = '';
  }

  @override
  Widget build(BuildContext context) {
    final PatientProvider provider = Provider.of<PatientProvider>(context);
    if (provider.patientDetails.phone == null) _initializeDoctorData(provider);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffF4F7F5),
      appBar: customAppBarDesign(context, 'Forgot Password'),
      //resizeToAvoidBottomInset: false,
      body: _bodyUI(provider),
    );
  }

  Widget _bodyUI(PatientProvider provider) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Heading Section
            Container(
                height: size.height * .15,
                width: size.width,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Image.asset(
                    "assets/banner.png",
                    //width: 100,
                    fit: BoxFit.fitWidth,
                  ),
                )
            ),
            SizedBox(height: 30),
            Text(
              "Reset Password",
              style: TextStyle(
                  fontSize: size.width*.065,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800]),
            ),
            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              decoration: cardDecoration,
              child: Text(
                "We will send you a password reset OTP to this given phone number",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: size.width*.05,
                    fontWeight: FontWeight.normal,
                    color:Theme.of(context).accentColor)),
              ),

            SizedBox(height: 30),

            //Phone number field
            Container(
              width: size.width * .90,
              child: Material(
                color: Colors.white,
                elevation: 2,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Row(
                  children: [
                    Container(
                        width: size.width * .35,
                        child: _countryCodePicker(provider)),
                    Container(
                      width: size.width * .54,
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        onChanged: (val) =>
                            setState(() => provider.patientDetails.phone = val),
                        decoration: FormDecoration.copyWith(
                          labelText: 'Phone number',
                          prefixIcon: null,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            //Continue Button...
            Consumer<PatientProvider>(
              builder: (context, provider, child) {
                return Container(
                  width: size.width * .90,
                  child: GestureDetector(
                    onTap: () => _checkValidity(provider),
                    child: button(context, "Send OTP"),
                  ),
                );
              },
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _countryCodePicker(PatientProvider provider) {
    return CountryCodePicker(
      comparator: (a, b) => b.name.compareTo(a.name),
      onChanged: (val) {
        provider.patientDetails.countryCode = val.dialCode;
        //print(countryCode);
      },
      onInit: (code) {
        provider.patientDetails.countryCode = code.dialCode;
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

  void _checkValidity(PatientProvider provider) async {
    if (provider.patientDetails.phone.isNotEmpty) {
      provider.loadingMgs = "Verifying...";
      showLoadingDialog(context, provider);
      final bool isRegistered = await provider.isPatientRegistered(
          provider.patientDetails.countryCode + provider.patientDetails.phone);
      if (isRegistered) {
        _OTPVerification(provider);
      } else {
        Navigator.pop(context);
        showSnackBar(_scaffoldKey, "No user found of this phone number",
            Colors.deepOrange);
      }
    } else
      showSnackBar(_scaffoldKey, "Phone can\'t be empty",
          Colors.deepOrange);
  }

  // ignore: non_constant_identifier_names
  void _OTPDialog(PatientProvider provider) {
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
                      "We've sent OTP verification code on your given number",
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
                        fillColor: Color(0xffF4F7F5),
                        prefixIcon: Icon(Icons.security)),
                  ),
                  SizedBox(height: 10),
                  Consumer<PatientProvider>(
                    builder: (context, provider, child) {
                      return GestureDetector(
                        onTap: () async {
                          provider.loadingMgs = 'Verifying OTP...';
                          showLoadingDialog(context, provider);
                          try {
                            await FirebaseAuth.instance
                                .signInWithCredential(
                                    PhoneAuthProvider.credential(
                                        verificationId:
                                            provider.verificationCode,
                                        smsCode: _otpController.text))
                                .then((value) async {
                              if (value.user != null) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ResetPassword()),
                                        (route) => false);
                              } else {
                                Navigator.pop(context);
                                Navigator.pop(context);
                                showSnackBar(
                                    _scaffoldKey,
                                    'Something went wrong. try again',
                                    Colors.deepOrange);
                              }
                            });
                          } catch (e) {
                            Navigator.pop(context);
                            showSnackBar(
                                _scaffoldKey, 'Invalid OTP', Colors.deepOrange);
                          }
                        },
                        child: button(context, 'Submit'),
                      );
                    },
                  ),
                  SizedBox(height: 15),
                  Text('OTP will expired after 2 minutes',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]))
                ],
              ),
            ),
          );
        });
  }

  // ignore: non_constant_identifier_names
  Future<void> _OTPVerification(PatientProvider provider) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
      phoneNumber:
          provider.patientDetails.countryCode+provider.patientDetails.phone,
      //Automatic verify....
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential).then((value) async {
          if (value.user != null) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ResetPassword()),
                    (route) => false);
          } else {
            Navigator.pop(context);
            showSnackBar(
                _scaffoldKey, 'Something went wrong, try again', Colors.deepOrange);
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          Navigator.pop(context);
          showSnackBar(_scaffoldKey, 'The provided phone number is not valid',
              Colors.deepOrange);
        }
      },
      codeSent: (String verificationId, int resendToken) {
        provider.verificationCode = verificationId;
        Navigator.pop(context);
        _OTPDialog(provider);
        //_startTimer();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        provider.verificationCode = verificationId;
        Navigator.pop(context);
        _OTPDialog(provider);
        //_startTimer();
      },
      timeout: Duration(seconds: 120),
    );
  }
}

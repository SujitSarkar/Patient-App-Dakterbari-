import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_panel/pages/home_page.dart';
import 'package:user_panel/pages/registration_page.dart';
import 'package:user_panel/pages/subpage/forgot_password_page.dart';
import 'package:user_panel/provider/patient_provider.dart';
import 'package:user_panel/provider/reg_auth_provider.dart';
import 'package:user_panel/shared/form_decoration.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:user_panel/widgets/button_widgets.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController _otpController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isConnected = true;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  void _checkConnectivity() async {
    var result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.none) {
      setState(() => _isConnected = false);
      showSnackBar(_scaffoldKey, "No internet connection !", Colors.deepOrange);
    } else if (result == ConnectivityResult.mobile) {
      setState(() => _isConnected = true);
    } else if (result == ConnectivityResult.wifi) {
      setState(() => _isConnected = true);
    }
  }

  void _initializedPatientData(RegAuth regAuth) async {
    regAuth.patientDetails.phone = '';
    regAuth.patientDetails.password = '';
  }

  @override
  Widget build(BuildContext context) {
    final RegAuth regAuth = Provider.of<RegAuth>(context);
    final PatientProvider operation = Provider.of<PatientProvider>(context);
    if (regAuth.patientDetails.phone == null ||
        regAuth.patientDetails.password == null)
      _initializedPatientData(regAuth);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xffF4F7F5),
      body: _isConnected ? _bodyUI(regAuth, operation) : _noInternetUI(),
    );
  }

  Widget _bodyUI(RegAuth regAuth, PatientProvider operation) {
    final Size size = MediaQuery.of(context).size;
    final Color colorPrimaryAccent = Color(0xffBCEDF2);
    return Container(
      height: size.height,
      width: size.width,
      child: SingleChildScrollView(
        child: Column(
          children: [
            //Heading Section
            Container(
              height: size.height * .40,
              width: size.width,
              color: colorPrimaryAccent,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ///Logo Icon...
                  Positioned(
                      top: size.height * .09,
                      child: Container(
                        alignment: Alignment.center,
                        width: size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: Image.asset(
                            'assets/banner.png',
                            height: size.width * .18,
                            width: size.width * .9,
                          ),
                        ),
                      )),

                  ///background Image...
                  Positioned(
                    bottom: -(size.height * .04),
                    child: Container(
                        alignment: Alignment.center,
                        width: size.width,
                        child: Image.asset(
                          "assets/doctor_patient.png",
                          height: 200,
                          fit: BoxFit.cover,
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),

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
                        child: _countryCodePicker(regAuth)),
                    Container(
                      width: size.width * .54,
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        onChanged: (val) =>
                            setState(() => regAuth.patientDetails.phone = val),
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

            //password field
            Container(
              width: size.width * .90,
              //height: 50,
              alignment: Alignment.center,
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: TextFormField(
                  obscureText: _obscure,
                  keyboardType: TextInputType.text,
                  onChanged: (val) =>
                      setState(() => regAuth.patientDetails.password = val),
                  decoration: FormDecoration.copyWith(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.security),
                      suffixIcon: IconButton(
                          icon: _obscure
                              ? Icon(Icons.visibility_off_rounded)
                              : Icon(Icons.remove_red_eye),
                          onPressed: () =>
                              setState(() => _obscure = !_obscure))),
                ),
              ),
            ),
            SizedBox(height: 20),

            //Continue Button...
            Consumer<PatientProvider>(
              builder: (context, operation, child) {
                return Container(
                  width: size.width * .90,
                  child: GestureDetector(
                    onTap: () => _checkValidity(regAuth, operation),
                    child: button(context, "Continue"),
                  ),
                );
              },
            ),
            SizedBox(height: 40),

            //Register Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have account? ",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: size.width / 20),
                ),
                Consumer<RegAuth>(
                  builder: (context, regAuth, child) {
                    return GestureDetector(
                      onTap: () {
                        regAuth.patientDetails = null;
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegistrationPage()));
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: size.width / 20,
                            color: Theme.of(context).primaryColor),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 30),

            ///Forgot password
            GestureDetector(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ForgotPassword())),
              child: Text('Forgot Password?',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: size.width / 20,
                      color: Theme.of(context).primaryColor)),
            )
          ],
        ),
      ),
    );
  }

  Widget _noInternetUI() {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white70,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/banner.png',
            height: size.width * .18,
            width: size.width * .9,
          ),
          SizedBox(height: 40),
          Icon(
            CupertinoIcons.wifi_exclamationmark,
            color: Colors.orange[300],
            size: 150,
          ),
          Text(
            'No Internet Connection !',
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
          Text(
            'Connect your device with wifi or cellular data',
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
          SizedBox(height: 20),
          Text(
            "For emergency call 16263",
            style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () => _checkConnectivity(),
            splashColor: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
                width: MediaQuery.of(context).size.width * .25,
                child: miniOutlineIconButton(
                    context, 'Refresh', Icons.refresh, Colors.grey)),
          )
        ],
      ),
    );
  }

  ///Country Code Picker
  Widget _countryCodePicker(RegAuth regAuth) {
    return CountryCodePicker(
      comparator: (a, b) => b.name.compareTo(a.name),
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

  ///check validation
  void _checkValidity(RegAuth regAuth, PatientProvider operation) async {
    if (regAuth.patientDetails.phone.isNotEmpty) {
      if (regAuth.patientDetails.password.isNotEmpty) {
        regAuth.loadingMgs = "Logging in...";
        showLoadingDialog(context, regAuth);

        //Firebase querySnapshot
        QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('Patients')
            .where('phone', isEqualTo: regAuth.patientDetails.phone)
            .get();
        final List<QueryDocumentSnapshot> user = snapshot.docs;
        if (user.isNotEmpty) {
          if (user[0].get('password') == regAuth.patientDetails.password) {
            _OTPVerification(regAuth, operation);
          } else {
            Navigator.pop(context);
            showSnackBar(_scaffoldKey, "Incorrect password", Colors.deepOrange);
          }
        } else {
          Navigator.pop(context);
          showSnackBar(_scaffoldKey, "No user is registered with this phone",
              Colors.deepOrange);
        }
      } else
        showSnackBar(
            _scaffoldKey, "Password can't be empty", Colors.deepOrange);
    } else
      showSnackBar(
          _scaffoldKey, "Phone number can't be empty", Colors.deepOrange);
  }

  // ignore: non_constant_identifier_names
  Future<void> _OTPVerification(
      RegAuth regAuth, PatientProvider operation) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
      phoneNumber:
          regAuth.patientDetails.countryCode + regAuth.patientDetails.phone,
      //Automatic verify....
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential).then((value) async {
          if (value.user != null) {
            //Save data to local
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.setString(
                'id',
                regAuth.patientDetails.countryCode +
                    regAuth.patientDetails.phone);
            // if(pref.getStringList('likeId')==null)
            //   pref.setStringList('likeId', []);
            //clear all list
            operation.clearPatientList();
            await operation.getPatient().then((value) async {
              Navigator.pop(context);
              regAuth.patientDetails = null;
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false);
            });
          } else {
            Navigator.pop(context);
            showSnackBar(_scaffoldKey, 'Something went wrong, try again',
                Colors.deepOrange);
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
        regAuth.verificationCode = verificationId;
        Navigator.pop(context);
        _OTPDialog(regAuth);
        //_startTimer();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        regAuth.verificationCode = verificationId;
        Navigator.pop(context);
        _OTPDialog(regAuth);
        //_startTimer();
      },
      timeout: Duration(seconds: 120),
    );
  }

  void _OTPDialog(RegAuth regAuth) {
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
                        fillColor: Color(0xffF4F7F5),
                        prefixIcon: Icon(Icons.security)),
                  ),
                  SizedBox(height: 10),
                  Consumer<PatientProvider>(
                    builder: (context, operation, child) {
                      return GestureDetector(
                        onTap: () async {
                          regAuth.loadingMgs = 'Verifying OTP...';
                          showLoadingDialog(context, regAuth);
                          try {
                            await FirebaseAuth.instance
                                .signInWithCredential(
                                    PhoneAuthProvider.credential(
                                        verificationId:
                                            regAuth.verificationCode,
                                        smsCode: _otpController.text))
                                .then((value) async {
                              if (value.user != null) {
                                //Save data to local
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                pref.setString(
                                    'id',
                                    regAuth.patientDetails.countryCode +
                                        regAuth.patientDetails.phone);
                                // if(pref.getStringList('likeId').length==0)
                                //   pref.setStringList('likeId', []);
                                //clear all list
                                operation.clearPatientList();
                                await operation
                                    .getPatient()
                                    .then((value) async {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  regAuth.patientDetails = null;
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()),
                                      (route) => false);
                                });
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
                  Text('OTP will expired after 2 minutes ',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]))
                ],
              ),
            ),
          );
        });
  }
}

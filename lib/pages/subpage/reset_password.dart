import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_panel/pages/home_page.dart';
import 'package:user_panel/pages/login_page.dart';
import 'package:user_panel/provider/patient_provider.dart';
import 'package:user_panel/shared/form_decoration.dart';
import 'package:user_panel/widgets/button_widgets.dart';
import 'package:user_panel/widgets/notification_widget.dart';

// ignore: must_be_immutable
class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String new1;
  String new2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Color(0xffF4F7F5),
      body: _bodyUI(),
    );
  }

  Widget _bodyUI() {
    final PatientProvider provider = Provider.of<PatientProvider>(context);
    final Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 60),
          Container(
            alignment: Alignment.center,
            width: size.width,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: Image.asset(
                "assets/banner.png",
                width: size.width * .9,
                //width: 100,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 30),

          Text(
            'New Password',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: size.width,
            child: TextFormField(
              keyboardType: TextInputType.text,
              onChanged: (val) {
                setState(() => new1 = val);
              },
              decoration: FormDecoration.copyWith(
                labelText: 'Enter new Password',
                prefixIcon: null,
              ),
            ),
          ),
          SizedBox(height: 20),

          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: size.width,
            child: TextFormField(
              keyboardType: TextInputType.text,
              onChanged: (val) {
                setState(() {
                  new2 = val;
                  provider.patientDetails.password = val;
                });
              },
              decoration: FormDecoration.copyWith(
                labelText: 'Re-enter new Password',
                prefixIcon: null,
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
                  onTap: () async {
                    if (new1 == new2) {
                      provider.loadingMgs = 'Password updating...';
                      showLoadingDialog(context, provider);
                      provider
                          .updatePatientPassword(
                              provider.patientDetails.countryCode +
                                  provider.patientDetails.phone,
                              provider,
                              _scaffoldKey,
                              context)
                          .then((value) async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        pref.setString(
                            'id',
                            provider.patientDetails.countryCode +
                                provider.patientDetails.phone);
                        await provider.getPatient().then((value) {
                          Navigator.pop(context);
                          provider.patientDetails = null;
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()),
                              (route) => false);
                        }, onError: (error) {
                          Navigator.pop(context);
                          showSnackBar(_scaffoldKey, error, Colors.deepOrange);
                        });
                        showAlertDialog(context, 'Password reset successful');
                      }, onError: (error) {
                        Navigator.pop(context);
                        showSnackBar(_scaffoldKey, error, Colors.deepOrange);
                      });
                    } else {
                      showSnackBar(_scaffoldKey, "Password not matched",
                          Colors.deepOrange);
                    }
                  },
                  child: button(context, "Reset Password"),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

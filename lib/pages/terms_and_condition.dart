import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:user_panel/shared/terms_condition.dart';
import 'package:user_panel/widgets/button_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_panel/provider/reg_auth_provider.dart';

// ignore: must_be_immutable
class TermsAndCondition extends StatefulWidget {
  String tc;
  TermsAndCondition({this.tc});

  @override
  _TermsAndConditionState createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: customAppBarDesign(context, "Terms And Conditions"),
      body: _BodyUI(),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _BodyUI() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
          height: size.height,
          width: size.width,
          child: ListView(
            children: [
              ///Section 1...
              //SizedBox(height: 20),
              _buildContent(
                  heading: "INTRODUCTION",
                  content: TermsCondition.introduction),

              ///Section 2...
              _buildContent(
                  title: "A. YOUR ACCOUNT",
                  content: TermsCondition.conditionOfUseA,
                  heading: "2. CONDITIONS OF USE"),
              _buildContent(
                  title: "B. PRIVACY", content: TermsCondition.conditionOfUseB),
              _buildContent(
                  title: "C. PLATFORM FOR COMMUNICATION",
                  content: TermsCondition.conditionOfUseC),
              _buildContent(
                  title: "D. CONTINUED AVAILABILITY OF THE SITE",
                  content: TermsCondition.conditionOfUseD),
              _buildContent(
                  title: "E. LICENSE TO ACCESS THE SITE",
                  content: TermsCondition.conditionOfUseE),
              _buildContent(
                  title: "F. YOUR CONDUCT",
                  content: TermsCondition.conditionOfUseF),
              _buildContent(
                  title: "G. YOUR SUBMISSION",
                  content: TermsCondition.conditionOfUseG),
              _buildContent(
                  title: "H. CLAIMS AGAINST OBJECTIONABLE CONTENT",
                  content: TermsCondition.conditionOfUseH),
              _buildContent(
                  title: "I. CLAIMS AGAINST INFRINGING CONTENT",
                  content: TermsCondition.conditionOfUseI),
              _buildContent(
                  title: "J. TRADEMARKS AND COPYRIGHTS",
                  content: TermsCondition.conditionOfUseJ),
              _buildContent(
                  title: "K. DISCLAIMER",
                  content: TermsCondition.conditionOfUseK),
              _buildContent(
                  title: "L. INDEMNITY",
                  content: TermsCondition.conditionOfUseL),
              _buildContent(
                  title: "M. THIRD PARTY BUSINESSES",
                  content: TermsCondition.conditionOfUseM),
              _buildContent(
                  title: "N. COMMUNICATING WITH US",
                  content: TermsCondition.conditionOfUseN),
              _buildContent(
                  title: "O. LOSSES", content: TermsCondition.conditionOfUseO),
              _buildContent(
                  title:
                      "P. AMENDMENTS TO CONDITIONS OR ALTERATIONS OF SERVICE AND RELATED PROMISE",
                  content: TermsCondition.conditionOfUseP),
              _buildContent(
                  title: "Q. EVENTS BEYOND OUR CONTROL",
                  content: TermsCondition.conditionOfUseQ),
              _buildContent(
                  title: "R. WAIVER", content: TermsCondition.conditionOfUseR),
              _buildContent(
                  title: "S. TERMINATION",
                  content: TermsCondition.conditionOfUseS),
              _buildContent(
                  title: "T. GOVERNING LAW AND JURISDICTION",
                  content: TermsCondition.conditionOfUseT),
              _buildContent(
                  title: "U. CONTACT US",
                  content: TermsCondition.conditionOfUseU),
              _buildContent(
                  title: "V. OUR SOFTWARE",
                  content: TermsCondition.conditionOfUseV),
              _buildContent(
                  title: "W. PROMOTIONAL VOUCHER OR COUPON",
                  content: TermsCondition.conditionOfUseW),

              ///Section 3...
              _buildContent(
                  heading:
                      "3. CONTRACT FOR SALE (BETWEEN SELLERS AND CUSTOMERS)",
                  content: TermsCondition.contractForSale),
              _buildContent(
                  title:
                      "A. CONDITIONS RELATED TO SALE OF THE PRODUCT OR SERVICE",
                  content: TermsCondition.contractForSaleA),
              _buildContent(
                  title: "B. THE CONTRACT",
                  content: TermsCondition.contractForSaleB),
              _buildContent(
                  title: "C. PRICING, AVAILABILITY AND ORDER PROCESSING",
                  content: TermsCondition.contractForSaleC),
              _buildContent(
                  title: "D. RETURN, REPLACEMENT AND REFUND POLICY",
                  content: TermsCondition.contractForSaleD),
              _buildContent(
                  title: "E. RESELLING PRODUCTS",
                  content: TermsCondition.contractForSaleE),
              _buildContent(
                  title: "F. TAXES", content: TermsCondition.contractForSaleF),
              _buildContent(
                  title: "G. REPRESENTATIONS AND WARRANTIES",
                  content: TermsCondition.contractForSaleG),

              widget.tc == "tc"
                  ? Container()
                  : Consumer<RegAuth>(
                builder: (context, regAuth,child){
                  return GestureDetector(
                    onTap: (){
                      regAuth.agreeChk=true;
                      Navigator.of(context).pop();
                    },
                    child: button(context, "I have read & agree"),
                  );
                },
              ),
              SizedBox(height: 20),
            ],
          )),
    );
  }

  Widget _buildContent({String title, String content, String heading}) {
    return Container(
      child: Column(
        children: [
          heading != null
              ? Container(
                  alignment: Alignment.topCenter,
                  child: Text(
                    heading,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                )
              : Container(),
          heading != null ? SizedBox(height: 5) : Container(),
          title != null
              ? Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 17),
                  ),
                )
              : Container(),
          Container(
            child: Text(
              content,
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

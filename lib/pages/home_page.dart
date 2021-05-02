import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_panel/pages/appointment_list_page.dart';
import 'package:user_panel/pages/blog_page.dart';
import 'package:user_panel/pages/all_doctors_category.dart';
import 'package:user_panel/pages/my_account.dart';
import 'package:user_panel/pages/shopping.dart';
import 'package:user_panel/pages/support_center_page.dart';
import 'package:user_panel/provider/appointment_provider.dart';
import 'package:user_panel/provider/article_provider.dart';
import 'package:user_panel/provider/discount_shop_provider.dart';
import 'package:user_panel/provider/forum_provider.dart';
import 'package:user_panel/provider/patient_provider.dart';
import 'package:user_panel/widgets/custom_app_bar.dart';
import 'package:user_panel/widgets/notification_widget.dart';
import 'package:user_panel/widgets/button_widgets.dart';
import 'package:user_panel/pages/forum_tab_page.dart';
import 'package:user_panel/pages/discount_shop_all_details/discount_shop_tab.dart';
import 'package:user_panel/pages/notifications_page.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isConnected = true;
  int _counter = 0;

  void initState() {
    // TODO: implement initState
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

  Future<void> _initialLists(
      PatientProvider pProvider,
      ArticleProvider articleProvider,
      ForumProvider forumProvider,
      DiscountShopProvider disProvider,
      AppointmentProvider appProvider) async {
    setState(() => _counter++);
    await pProvider.getPatient().then((value) async {
      await articleProvider.getAllArticle();
      await articleProvider.getPopularArticle();
      await forumProvider.getAllQuestionList();
      await forumProvider.getMyQuestionList();
      await disProvider.getSubscribedShop();
      await appProvider.getAppointmentList();
      await pProvider.getNotification();
      pProvider.patientDetails = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final PatientProvider pProvider = Provider.of<PatientProvider>(context);
    final ArticleProvider articleProvider =
        Provider.of<ArticleProvider>(context);
    final ForumProvider forumProvider = Provider.of<ForumProvider>(context);
    final DiscountShopProvider disProvider =
        Provider.of<DiscountShopProvider>(context);
    final AppointmentProvider appProvider =
        Provider.of<AppointmentProvider>(context);

    if (_counter == 0 || pProvider.patientList.isEmpty)
      _initialLists(pProvider, articleProvider, forumProvider,
          disProvider, appProvider);

    return Scaffold(
      key: _scaffoldKey,
      //backgroundColor: Color(0xffF4F7F5),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: customAppBarDesign(context, 'Dakterbari | ডাক্তারবাড়ি'),
      body: _isConnected
          ? _bodyUI(size, pProvider, articleProvider, forumProvider,
              disProvider, appProvider)
          : _noInternetUI(),
    );
  }

  Widget _bodyUI(
      Size size,
      PatientProvider pProvider,
      ArticleProvider articleProvider,
      ForumProvider forumProvider,
      DiscountShopProvider disProvider,
      AppointmentProvider appProvider) {
    return Container(
      width: size.width,
      height: size.height,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: size.width,
            height: size.width * .35,
            decoration: BoxDecoration(
                color: Color(0xffF4F7F5),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Welcome to",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.width * .015),
                Image.asset(
                  'assets/banner.png',
                  height: size.width * .18,
                  width: size.width * .9,
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              backgroundColor: Colors.white,
              onRefresh: () => _initialLists(pProvider,
                  articleProvider, forumProvider, disProvider, appProvider),
              child: AnimationLimiter(
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 3,
                    ),
                    itemCount: 12,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 500),
                          child: SlideAnimation(
                            verticalOffset: 400,
                            child: FadeInAnimation(
                              child: GridBuilderTile(size: size, index: index),
                            ),
                          ));
                    }),
              ),
            ),
          ),
        ],
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
}

// ignore: must_be_immutable
class GridBuilderTile extends StatelessWidget {
  Size size;
  int index;
  GridBuilderTile({this.size, this.index});

  @override
  Widget build(BuildContext context) {
    final PatientProvider patientProvider =
        Provider.of<PatientProvider>(context);
    final ArticleProvider articleProvider =
        Provider.of<ArticleProvider>(context);

    Future<void> _launchInWebViewWithJavaScript(BuildContext context, String url) async {
      if (await canLaunch(url)) {
        await launch(
          url,
          //forceSafariVC: true,
          forceWebView: true,
          enableJavaScript: true,
        );
      } else {
        showAlertDialog(context, 'Something went wrong. Try again later');
      }
    }

    return InkWell(
      onTap: () async {
        ///My Account
        if (index == 0) {
          if (patientProvider.patientList.isEmpty) {
            patientProvider.loadingMgs = "Please Wait...";
            showLoadingDialog(context, patientProvider);
            await patientProvider.getPatient().then((value) async {
              patientProvider.patientDetails = null;
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyAccount()));
            });
          } else {
            patientProvider.patientDetails = null;
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MyAccount()));
          }
        }

        ///Doctor Category
        if (index == 1)
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => MedicalDepartment()));

        ///Appointment
        if (index == 2)
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AppointmentList()));

        ///Discount shop
        if (index == 3)
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DiscountShopTab()));

        ///Notification
        if (index == 4)
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Notifications()));

        ///Shop
        if (index == 5)
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Shopping()));

        ///Forum page
        if (index == 6) {
          if (patientProvider.patientList.isEmpty) {
            patientProvider.loadingMgs = 'Please wait...';
            showLoadingDialog(context, patientProvider);
            await patientProvider.getPatient().then((value) async {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ForumTabPage()));
            });
          } else
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ForumTabPage()));
        }

        ///Blog
        if (index == 7) {
          if (articleProvider.allArticleList.isEmpty) {
            articleProvider.loadingMgs = 'Please wait...';
            showLoadingDialog(context, articleProvider);

            await articleProvider.getAllArticle().then((value) async {
              await articleProvider.getPopularArticle().then((value) {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BlogPage()));
              });
            });
          } else
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => BlogPage()));
        }

        ///eLoan
        if (index == 8)
          _launchInWebViewWithJavaScript(context, 'https://docs.google.com/forms/d/e/1FAIpQLSdZxuA_haPM3cG8QnonMLpeZ_j--Inyfg76bc_LMkzxaU6hIg/viewform');

        ///health Insurence
        if (index == 9)
          _launchInWebViewWithJavaScript(context, 'https://dakterbari.com/health-insurance/');

        ///Join Rider
        if (index == 10)
          _launchInWebViewWithJavaScript(context, 'https://docs.google.com/forms/d/e/1FAIpQLSdgK1nqIb-v5fgkgcFGnkeUXMLoaoHkxQGngw3vM89WLUFBrg/viewform');

        ///Support Center
        if (index == 11)
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SupportCenter()));
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
              height: size.width * .17,
              width: size.width * .17,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: index == 0
                      ? AssetImage('assets/home_icon/account.png')
                      : index == 1
                          ? AssetImage('assets/home_icon/doctor.png')
                          : index == 2
                              ? AssetImage('assets/home_icon/appointment.png')
                              : index == 3
                                  ? AssetImage('assets/home_icon/discount.png')
                                  : index == 4
                                          ? AssetImage(
                                              'assets/home_icon/notifications.png')
                                          : index == 5
                                              ? AssetImage(
                                                  'assets/home_icon/shopping.png')
                                              : index == 6
                                                  ? AssetImage(
                                                      'assets/home_icon/forum.png')
                                                  : index == 7
                                                      ? AssetImage(
                                                          'assets/home_icon/blog.png')
                                                      : index == 8
                                                          ? AssetImage(
                                                              'assets/home_icon/credit_assesment.png')
                                                          : index == 9
                                                              ? AssetImage(
                                                                  'assets/home_icon/health_insurance.png')
                                                              : index == 10
                                                                  ? AssetImage(
                                                                      'assets/home_icon/join_riders.png')
                                                                  : AssetImage(
                                                                      'assets/home_icon/support.png'),
                ),
              ),
              height: size.width * .09,
              width: size.width * .09,

            ),
          ]),
          SizedBox(height: 5),
          Text(
            index == 0
                ? 'My Account'
                : index == 1
                    ? 'Doctors'
                    : index == 2
                        ? 'Appointment'
                        : index == 3
                            ? 'Discount Shop'
                                : index == 4
                                    ? 'Notifications'
                                    : index == 5
                                        ? 'Shopping'
                                        : index == 6
                                            ? 'Forum'
                                            : index == 7
                                                ? 'Blog'
                                                : index == 8
                                                    ? 'eLoan'
                                                    : index == 9
                                                        ? 'Health Insurance'
                                                        : index == 10
                                                            ? 'Join Rider'
                                                            : 'Support Center',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).primaryColor, //Color(0xff00C5A4),
                fontSize: size.width * .04,
                fontWeight: FontWeight.bold),
          )
        ],
      )),
    );
  }
}

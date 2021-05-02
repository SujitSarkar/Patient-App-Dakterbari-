import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_panel/pages/home_page.dart';
import 'package:user_panel/pages/login_page.dart';
import 'package:user_panel/provider/article_provider.dart';
import 'package:user_panel/provider/discount_shop_provider.dart';
import 'package:user_panel/provider/forum_provider.dart';
import 'package:user_panel/provider/patient_provider.dart';
import 'package:user_panel/provider/doctor_provider.dart';
import 'package:user_panel/provider/reg_auth_provider.dart';
import 'package:user_panel/provider/appointment_provider.dart';
import 'package:user_panel/provider/review_provider.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:user_panel/splash_screen_package/animation_screen.dart';

Future <void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await firebase_core.Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<int, Color> color = {//RGB Color Code (0, 194, 162)
    50:Color.fromRGBO(129, 0, 67, .1),
    100:Color.fromRGBO(129, 0, 67, .2),
    200:Color.fromRGBO(129, 0, 67, .3),
    300:Color.fromRGBO(129, 0, 67, .4),
    400:Color.fromRGBO(129, 0, 67, .5),
    500:Color.fromRGBO(129, 0, 67, .6),
    600:Color.fromRGBO(129, 0, 67, .7),
    700:Color.fromRGBO(129, 0, 67, .8),
    800:Color.fromRGBO(129, 0, 67, .9),
    900:Color.fromRGBO(129, 0, 67, 1),
  };
  String id;
  String pass;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkPreferences();
  }

  void _checkPreferences() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id =preferences.get('id');
      pass=preferences.get('pass');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>RegAuth(),),
        ChangeNotifierProvider(create: (context)=>PatientProvider(),),
        ChangeNotifierProvider(create: (context)=>DoctorProvider(),),
        ChangeNotifierProvider(create: (context)=>AppointmentProvider(),),
        ChangeNotifierProvider(create: (context)=>ArticleProvider(),),
        ChangeNotifierProvider(create: (context)=>DiscountShopProvider()),
        ChangeNotifierProvider(create: (context)=>ForumProvider()),
        ChangeNotifierProvider(create: (context) => ReviewProvider(),),
      ],
      child: MaterialApp(
        //for country code picker
        supportedLocales: [
          Locale('en', 'US'),
        ],
        localizationsDelegates: [
          CountryLocalizations.delegate,
        ],

        title: 'DakterBari',
        theme: ThemeData(
            primarySwatch:  MaterialColor(0xff810043, color), //HEX Color Code(0xff00C5A4)
            visualDensity: VisualDensity.adaptivePlatformDensity,
            canvasColor: Colors.transparent,
            cursorColor: Colors.black,
            //BottomNavigationBar Theme...
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.transparent,
              elevation: 50,
              showUnselectedLabels: true,
              unselectedIconTheme: IconThemeData(
                  color: Colors.grey[800]
              ),
            )
        ),
        debugShowCheckedModeBanner: false,
        //home: HomePage(),
         home: Material(
           child: Stack(
             children: [
               id == null ? LogIn() : HomePage(),
               IgnorePointer(
                   child: AnimationScreen(
                     color: Color(0xff810043),
                     appName: 'Patient App',
                   )
               )
             ],
           ),
         )
      ),
    );
  }
}

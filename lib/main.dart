
import 'package:b_w/utils/constants.dart';
import 'package:b_w/view/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view/restaurant/restaurants.dart';
import 'package:b_w/welcomeScreen/signin_secreen/signin_screen.dart';
import 'package:b_w/welcomeScreen/welcomeScreen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var id;
  bool isSigin=false;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getString("id");
    if(id!=null){
      isSigin=true;
    }
    setState(() {});
  }
@override
  void initState() {
    getPref();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'B_W Order',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: kBackgroundColor,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white.withOpacity(.2),
              ),
            ),
          ),
        ),
        home:isSigin?Home():WelcomeScreen(),
        routes:{
          'Home': (context) {
            return Home();
          },
          'SignInScreen': (context) {
            return SignInScreen();
          },
          'Restaurants': (context) {
            return Restaurants();
          },

        }
    );
  }
}

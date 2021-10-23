// @dart=2.9
import 'package:emotionmusicplayer/screens/firstScreen.dart';
import 'package:emotionmusicplayer/screens/homePage.dart';
import 'package:emotionmusicplayer/screens/loginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin=false;
  @override
  void initState() {
    Firebase.initializeApp();
    getLogin();
    // TODO: implement initState
    super.initState();
  }
  void getLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool("isLogin");

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: isLogin?"/":"/login",
      //  home:FirstScreen(),
      routes: {
        '/':(context)=>const FirstScreen(),
        '/login':(context)=> SignIn(),
        '/home':(context)=>const HomePage(),
      },
    );
  }
}


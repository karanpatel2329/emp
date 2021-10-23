import 'dart:io';
import 'package:emotionmusicplayer/Constant.dart';
import 'package:emotionmusicplayer/screens/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
bool isEdit = false;

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {

  int num = 0;
  bool isEdit = false;
  String name="";
  String phone="";
  String email="";
  User? user = FirebaseAuth.instance.currentUser;
  void edit() {
    setState(() {
      isEdit = !isEdit;
    });
  }
  @override
  void dispose() {
    myName.dispose();
    myPhone.dispose();
    myEmail.dispose();
    super.dispose();
  }
  @override
  void initState() {
    if (user?.displayName==null) {
      name = "";
    } else {
      name = user!.displayName!;
    }
    if (user?.email==null) {
      email = "";
    } else {
      email = user!.email!;
    }
    if (user?.phoneNumber==null) {
      phone = "";
    } else {
      phone = user!.phoneNumber!;
    }
    myName = TextEditingController()..text = name;
    myPhone = TextEditingController()..text = phone;
    myEmail = TextEditingController()..text = email;
    // TODO: implement initState
    super.initState();
  }


  TextEditingController myName = TextEditingController();
  TextEditingController myEmail = TextEditingController();
  TextEditingController myPhone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Constant.lightPink,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15,vertical:10 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios)),
                    Text(
                      "My Profile",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          fontFamily: "lora"),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0,bottom: 18.0),
                        child: isEdit
                            ? GestureDetector(
                            onTap: () {

                              edit();
                              setState(() {
                                user!.updateDisplayName(name);
                                user!.updateEmail(email);
                              });
                              // print(widget.docId + " " + name);
                              // Database.updateUser(
                              //     name: name,
                              //     email: email,
                              //     phone: phone,
                              //     docId: widget.docId);
                            },
                            child: Text("Save"))
                            : GestureDetector(
                            onTap: () {
                              edit();
                            },
                            child: Text("Edit")),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Column(
                  children: [
                    TextField(
                      onChanged: (newValue) {
                        name = newValue;
                      },
                      enabled: isEdit,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),
                        enabledBorder: new OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Constant.pink),
                        ),
                        focusedBorder: new OutlineInputBorder(

                          borderSide:
                          BorderSide(color: Constant.pink),
                        ),
                      ),
                      controller: myName,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      onChanged: (newValue) {
                        email = newValue;
                      },
                      enabled: isEdit,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email Id',
                        labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),
                        enabledBorder: new OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Constant.pink),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderRadius:
                          new BorderRadius.circular(20.0),
                          borderSide:
                          BorderSide(color: Constant.pink),
                        ),
                      ),
                      controller: myEmail,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      onChanged: (newValue) {
                        phone = newValue;
                      },
                      enabled: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Phone No.',
                        labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.w700),
                        enabledBorder: new OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Constant.pink),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderRadius:
                          new BorderRadius.circular(20.0),
                          borderSide:
                          BorderSide(color: Constant.pink),
                        ),
                      ),
                      controller: myPhone,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Buttons(
                bgColor: Constant.darkWhite,
                textColor: Constant.pink,
                text: 'Change Your Mood',
                onPress: () async{
                  Navigator.pushReplacementNamed(context, "/");
                },
              ),
              SizedBox(
                height: 10,
              ),
              Buttons(
                text: 'LogOut',
                bgColor: Constant.pink,
                textColor: Constant.darkWhite,
                onPress: () async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setBool("isLogin", false);
                  FirebaseAuth.instance.signOut();
                  print(FirebaseAuth.instance.currentUser);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
class Buttons extends StatelessWidget {
  Buttons({required this.bgColor,required this.textColor,required this.text, required this.onPress});
  final String text;
  final Function() onPress;
  final Color bgColor;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.8,
      height: 45,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor:
            MaterialStateProperty.all<Color>(bgColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ))),
        onPressed: onPress,
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 20.0),
        ),
      ),
    );
  }
}
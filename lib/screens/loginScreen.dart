import 'package:emotionmusicplayer/Constant.dart';
import 'package:emotionmusicplayer/screens/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  late final String title;

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  late User _firebaseUser;
  String _status = "";
  bool otp = false;
  late AuthCredential _phoneAuthCredential;
  late String _verificationId;
  late int _code;
  late bool isAvailable = false;
  bool isLoading = false;
  bool isLogin =false;
  @override
  void initState() {
    getLogin();
    Firebase.initializeApp();
    super.initState();
  }
  void getLogin()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLogin = prefs.getBool("isLogin");
    print(isLogin);
    print("HI IS LOGIN IS");
    if(isLogin==null){
      isLogin=false;
    }
    if(isLogin==true){
      Navigator.pushReplacementNamed(context, '/');
    }
  }
  void _handleError(e) {
    var snackBar = SnackBar(content: Text(e.message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    print(e.message);
    setState(() {
      _status += e.message + '\n';
      isLoading = false;
    });
  }

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance
          .signInWithCredential(this._phoneAuthCredential)
          .then((UserCredential authRes) {
        _firebaseUser = authRes.user!;
        print(_firebaseUser.toString());
        Navigator.pushReplacementNamed(context, '/');
      }).catchError((e) => _handleError(e));
      setState(() {
        _status += 'Signed In\n';
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isLogin", true);
    } catch (e) {
      print("HERE");
      _handleError(e);
    }
  }

  Future<void> _submitPhoneNumber() async {
    setState(() {
      isLoading = true;
    });
    String phoneNumber = "+91 " + _phoneNumberController.text.toString().trim();
    print(phoneNumber);

    void verificationCompleted(AuthCredential phoneAuthCredential) {
      print('verificationCompleted');
      setState(() {
        _status += 'verificationCompleted\n';
      });
      this._phoneAuthCredential = phoneAuthCredential;
      print(phoneAuthCredential);
      print("***");
    }

    void verificationFailed(error) {
      print('verificationFailed');
      _handleError(error);
    }

    void codeSent(String verificationId, [int? code]) {
      print('codeSent');
      this._verificationId = verificationId;
      print(verificationId);
      this._code = code!;
      print(code.toString());
      setState(() {
        _status += 'Code Sent\n';
        otp = true;
        isLoading = false;
      });
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');
      setState(() {
        _status += 'codeAutoRetrievalTimeout\n';
      });
      print(verificationId);
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(milliseconds: 10000),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  }

  void _submitOTP() {
    String smsCode = _otpController.text.toString().trim();

    this._phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: this._verificationId, smsCode: smsCode);
    _login();
    _phoneNumberController.clear();
    _otpController.clear();
    otp = false;
    _status = "";
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Container(
              color: Constant.lightPink,
              child: ListView(
                padding: EdgeInsets.all(16),
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                      child: Text("Welcome",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              fontFamily: "lora"))),
                  Center(
                      child: Text("Experience Modern Music Player",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              fontFamily: "lora"))),
                  Container(child: Lottie.asset("assets/music.json")
                      // Image(
                      //   image: AssetImage('assets/github.png'),
                      // ),
                      ),
                  SizedBox(height: 24),
                  Container(
                    height: MediaQuery.of(context).size.width * 0.30,
                    child: Column(
                      children: <Widget>[
                        TextField(
                          keyboardType: TextInputType.phone,
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            hintText: 'Phone Number',
                            labelText: 'Phone Number',
                            labelStyle: TextStyle(
                                color:  Colors.black
                            ),
                            border: OutlineInputBorder(),
                            enabledBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: Constant.pink),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(20.0),
                              borderSide: BorderSide(color: Constant.pink),
                            ),
                          ),
                        ),
                        Spacer(),
                        !otp
                            ? MaterialButton(
                                minWidth: MediaQuery.of(context).size.width * 1,
                                color: Constant.pink,
                                onPressed: _submitPhoneNumber,
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    'Send Otp',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  !otp ? SizedBox(height: 48) : Container(),
                  otp
                      ? Container(
                          height: MediaQuery.of(context).size.width * 0.35,
                          child: Column(
                            children: <Widget>[
                              TextField(
                                keyboardType: TextInputType.phone,
                                controller: _otpController,
                                decoration: InputDecoration(
                                  hintText: 'OTP',
                                  labelText: 'OTP',
                                  labelStyle: TextStyle(color: Colors.black),
                                  border: OutlineInputBorder(),
                                  enabledBorder: new OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0),
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
                              ),
                              Spacer(),
                              MaterialButton(
                                minWidth:
                                    MediaQuery.of(context).size.width * 70,
                                color: Constant.pink,
                                onPressed: (){
                                  setState(() {
                                    isLoading=true;
                                  });
                                  _submitOTP();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

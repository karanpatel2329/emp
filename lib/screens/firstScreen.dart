import 'package:emotionmusicplayer/Constant.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  String imageP = "";
  String imagePath = "";
  bool isLoading = false;
  var smileProb;
  late ImagePicker imagePicker = ImagePicker();
  Future<int> _imgFromCamera() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    late ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    setState(() {
      isLoading = true;
    });
    var visionImage = GoogleVisionImage.fromFile(File(image!.path));
    var faceDetection = GoogleVision.instance.faceDetector(FaceDetectorOptions(
      enableClassification: true,
      enableLandmarks: true,
      enableContours: true,
    ));
    List<Face> faces = await faceDetection.processImage(visionImage);
    for (Face f in faces) {
      smileProb = f.smilingProbability;
    }
    await faceDetection.close();
    if (smileProb == null) {
      setState(() {
        isLoading = false;
      });
      return -1;
    }
    String mood = detectSmile();
    setState(() {
      isLoading = false;
    });
    prefs.setString("mood", mood);
    Navigator.of(context).pop();
    //Navigator.of(context).pushReplacementNamed('/home');
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
    return 0;
    // Navigator.pushReplacementNamed(context, '/home');
    //Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(mood: mood)));
  }

  String detectSmile() {
    if (smileProb > 0.86) {
      return 'Very Happy';
    } else if (smileProb > 0.8) {
      return 'Happy';
    } else if (smileProb > 0.3) {
      return 'Happy';
    } else
      return 'Sad';
  }

  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Constant.lightPink,
        body: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LottieBuilder.asset("assets/selfie.json"),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: Text(
                    "Take a Selfie. To Play Song.",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Builder(
                  builder: (BuildContext context) {
                    return ElevatedButton(
                      child: Text('Continue'),
                      onPressed: () async {
                        var a = ScaffoldMessenger.of(context);
                        int res = await _imgFromCamera();
                        if (res == -1) {
                          a.showSnackBar(SnackBar(
                            content:
                                Text('No Face Detected. Please Try Again.'),
                          ));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Color(0xFF66AAFF),
                        primary: Color(0xFFFF7F61),
                        elevation: 5,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:emotionmusicplayer/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:share/share.dart';

class PlayerScreen extends StatefulWidget {
  String title;
  String Poster;
  String link;
  String Singer;
  PlayerScreen({required this.title, required this.link, required this.Poster, required this.Singer});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  AudioPlayer audioPlayer = AudioPlayer();
  bool isLiked = false;
  bool isPlayed = true;
  late Duration duration;
  Duration? _duration;
  Duration? _position;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    play();
    _controller =
    AnimationController(vsync: this, duration: Duration(seconds: 5))
      ..repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    audioPlayer.stop();
    _controller.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  play() async {

    final playPosition = (_position != null &&
        _duration != null &&
        _position!.inMilliseconds > 0 &&
        _position!.inMilliseconds < _duration!.inMilliseconds)
        ? _position
        : null;
    int result = await audioPlayer.play(widget.link,
        isLocal: false,position: playPosition);
    //final result = await _audioPlayer.play(url, position: playPosition);

        print(_position);
        print(_duration);
        print("hI");
    audioPlayer.onAudioPositionChanged.listen((Duration  p) {
    //print('Current position: $p');
    setState(() {
      duration=p;
    });
    });
    if (result == 1) {
      setState(() {
        isPlayed=true;
      });
      print("playong song");
    }
    _positionSubscription = audioPlayer.onAudioPositionChanged.listen((event) {setState(() {
      _position=event;
    });});
    _durationSubscription = audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);});
    _playerCompleteSubscription =
        audioPlayer.onPlayerCompletion.listen((event) {
          _controller.stop();
          setState(() {
            isPlayed=false;
          });
        });
    _controller.repeat();
  }

  pause() async {
    _controller.stop();
    int result = await audioPlayer.pause();
    if (result == 1) {
      setState(() {
        isPlayed=false;
      });
      print("playong stop");
    }
  }
  forward() async{
    final Position= _position!.inMilliseconds+10000;
    int result =await audioPlayer
        .seek(Duration(milliseconds: Position.round()));

  }
  reverse() async{
    final Position= _position!.inMilliseconds-10000;
    int result =await audioPlayer
        .seek(Duration(milliseconds: Position.round()));

  }
  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constant.lightPink.withOpacity(0.95),
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(
            left: 5,
            right: 5,
            top: 15,
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios)),
                    Text(
                      "Now Playing",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          fontFamily: "lora"),
                    ),
                    GestureDetector(onTap: () {}, child: PopupMenuButton(
                      icon: Icon(Icons.more_vert),  //don't specify icon if you want 3 dot menu
                      color: Constant.darkWhite,
                      itemBuilder: (context) => [
                        PopupMenuItem<int>(
                          value: 0,
                          child: GestureDetector(onTap: (){Share.share('Download now\nBest Music Player. Play songs according to your mood automatically.\nwww.play.google.com/store/apps/details?id=soonBeThere');},child: Text("Invites",style: TextStyle(color: Colors.black,fontFamily: 'lora'),)),
                        ),
                        PopupMenuItem<int>(
                          value: 1,
                          child: Text("More Info",style: TextStyle(color: Colors.black,fontFamily: 'lora'),),
                        ),
                      ],
                      onSelected: (item) => {print(item)},
                    ),),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height*0.01,
                    ),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (_, child) {
                        return Transform.rotate(
                          angle: _controller.value * 2 * math.pi,
                          child: child,
                        );
                      },
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Constant.orange,
                        child: CircleAvatar(
                          radius: 95,
                          backgroundImage: NetworkImage(widget.Poster),

                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(widget.title, style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w100,
                            fontFamily: "lora"),),
                        Text("By "+widget.Singer, style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w100,
                            fontFamily: "lora"),),
                      ],
                    ),
                    Stack(
                      overflow: Overflow.visible,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          decoration: BoxDecoration(
                              color: Constant.darkWhite,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(30.0),
                                  topLeft: Radius.circular(30.0))),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 40),
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [_position==null?Container():Text(_printDuration(_position!)),_duration==null?Container(): Text(_printDuration(_duration!))],
                                ),
                              ),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  inactiveTrackColor:
                                      Constant.grey.withOpacity(0.1),
                                  activeTrackColor: Constant.grey,
                                  thumbColor: Constant.pink,
                                  overlayColor: Color(0x29EB1555),
                                  thumbShape: RoundSliderThumbShape(
                                      enabledThumbRadius: 10.0),
                                  overlayShape: RoundSliderOverlayShape(
                                      overlayRadius: 30.0),
                                ),
                                child: Slider(
                                  onChanged: (v) {
                                    print("ji");
                                    if (_duration == null) {
                                      return;
                                    }
                                    final Position = v * _duration!.inMilliseconds;
                                    print(Position);
                                    audioPlayer
                                        .seek(Duration(milliseconds: Position.round()));
                                    setState(() {
                                      audioPlayer
                                          .seek(Duration(milliseconds: Position.round()));
                                    });
                                  },
                                  value: (_position != null &&
                                      _duration != null &&
                                      _position!.inMilliseconds > 0 &&
                                      _position!.inMilliseconds <
                                          _duration!.inMilliseconds)
                                      ? _position!.inMilliseconds / _duration!.inMilliseconds
                                      : 0.0,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        reverse();
                                      },
                                      child: Icon(
                                        Icons.replay_10,
                                        size: 35,
                                      ),
                                    ),
                                    !isPlayed
                                        ? GestureDetector(
                                            onTap: () {
                                              play();
                                            },
                                            child: Icon(
                                              Icons
                                                  .play_circle_outline_outlined,
                                              size: 60,
                                            ))
                                        : GestureDetector(
                                            onTap: () {
                                              pause();
                                            },
                                            child: Icon(
                                              Icons.pause_circle_outline,
                                              size: 60,
                                            )),
                                    GestureDetector(
                                      onTap: (){
                                        forward();
                                      },
                                      child: Icon(
                                        Icons.forward_10,
                                        size: 35,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          top: -12,
                          left: 0,
                          right: 0,
                          child: Container(
                            child: isLiked
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isLiked = !isLiked;
                                      });
                                    },
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: Constant.pink,
                                      child: CircleAvatar(
                                        radius: 18,
                                        backgroundColor:
                                            Constant.white.withOpacity(0.9),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 10,
                                                  color: Constant.orange,
                                                  spreadRadius: 8)
                                            ],
                                          ),
                                          child: CircleAvatar(
                                            radius: 12.0,
                                            backgroundColor: Constant.orange,
                                            child: Icon(
                                              Icons.favorite,
                                              color: isLiked
                                                  ? Colors.red
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isLiked = !isLiked;
                                      });
                                    },
                                    child: CircleAvatar(radius: 20,backgroundColor: Constant.grey,child: Icon(Icons.favorite_border,size: 30,)),),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }

}

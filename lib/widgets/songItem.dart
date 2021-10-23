import 'package:emotionmusicplayer/screens/playerScreen.dart';
import 'package:flutter/material.dart';
import 'package:emotionmusicplayer/Constant.dart';
class SongItem extends StatefulWidget {
  String title;
  String Poster;
  String link;
  String Singer;
  String duration;
  SongItem({required this.title, required this.link, required this.Poster, required this.Singer, required this.duration});


  @override
  _SongItemState createState() => _SongItemState();
}

class _SongItemState extends State<SongItem> {
  bool isLiked=false;
  void getLiked(){
    setState(() {
      isLiked=!isLiked;
    });
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>PlayerScreen(title: widget.title,Singer:widget.Singer,Poster: widget.Poster,link: widget.link,)));
      },
      child: Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              color: Constant.darkWhite,
              borderRadius: BorderRadius.all(Radius.circular(30))
          ),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Constant.blue.withOpacity(0.9),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Constant.white.withOpacity(0.9),
                  child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(blurRadius: 8, color: Constant.blue, spreadRadius: 3)],
                      ),
                      child: Icon(Icons.audiotrack,color: Constant.white,)
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width*0.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,style: TextStyle(color: Constant.grey,fontFamily: "lora", fontWeight: FontWeight.w600),),
                    Text(widget.Singer,style: TextStyle(color: Constant.grey.withOpacity(0.7),fontSize: 13,fontFamily: "lora", fontWeight: FontWeight.w400),)
                  ],
                ),
              ),
              Text(widget.duration,style: TextStyle(color: Constant.grey.withOpacity(0.7),fontSize: 13,fontFamily: "lora", fontWeight: FontWeight.w400),),

            ],
          )
      ),
    );
  }
}


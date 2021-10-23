import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

import '../Constant.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constant.lightPink,
        body: Column(
          children: [
            SizedBox(
              height: 10,
            ),
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
                  Center(
                    child: Text("Your Notifications",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w500,fontFamily: "lora"),),
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

            Container(
                height: MediaQuery.of(context).size.height*0.75,
                child:StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('notifications').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            print(index);
                            DocumentSnapshot doc = snapshot.data!.docs[index];
                            return  Container(
                                padding: EdgeInsets.all(18.0),
                                margin: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    color: Constant.blue.withOpacity(0.6),
                                    borderRadius: BorderRadius.all(Radius.circular(30))
                                ),
                                child:Container(
                                  width: MediaQuery.of(context).size.width*0.33,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(doc['heading'],style: TextStyle(color: Constant.grey,fontFamily: "lora", fontWeight: FontWeight.w600),),
                                      Text(doc['sub-heading'],style: TextStyle(color: Constant.grey.withOpacity(0.7),fontSize: 13,fontFamily: "lora", fontWeight: FontWeight.w400),)
                                    ],
                                  ),
                                )
                            );
                          });
                    } else {
                      return Text("No data");
                    }
                  },
                )
              // ListView(
              //   children: [
              //     FoodItem(id: 1,name: "Cheese Pizza",price: 5.3,),
              //     FoodItem(id: 2,name: "Tomato Pizza",price: 9.4,),
              //     FoodItem(id: 3,name: "Onion Pizza",price: 5.4,),
              //     FoodItem(id: 4,name: "Veg Pizza",price: 3.3,),
              //     FoodItem(id: 5,name: "Non Pizza",price: 5.4,),
              //     FoodItem(id: 6,name: "Pineapple Pizza",price: 10.3,),
              //     FoodItem(id: 7,name: "Combo Pizza",price: 15.32,),
              //     FoodItem(id: 8,name: "SeaFood Pizza",price: 15.36,),
              //     FoodItem(id: 9,name: "KFC Pizza",price: 10.8,),
              //   ],
              // ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotionmusicplayer/Constant.dart';
import 'package:emotionmusicplayer/screens/myAccountScreen.dart';
import 'package:emotionmusicplayer/screens/notification.dart';
import 'package:emotionmusicplayer/screens/search.dart';
import 'package:emotionmusicplayer/widgets/songItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String mood = "";
  String searchQuery = "";
  TextEditingController _searchController = TextEditingController();

  late Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];
  var _controller = TextEditingController();
  @override
  void initState() {
    getMood();
    print("Here0");
    getUsersPastTripsStreamSnapshots();
    print("Here1");
    _searchController.addListener(_onSearchChanged);
    // TODO: implement initState
    super.initState();
  }

  void getMood() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mood = prefs.getString("mood")!;
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("djj");
    resultsLoaded = getUsersPastTripsStreamSnapshots();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != "") {
      for (var tripSnapshot in _allResults) {
        var title = tripSnapshot['title'].toString().toLowerCase();

        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(tripSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getUsersPastTripsStreamSnapshots() async {
    print("Here");
    //final uid = await Provider.of(context).auth.getCurrentUID();
    var data = await FirebaseFirestore.instance.collection('songs').get();
    print(data);
    print("889");
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "complete";
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationScreen()));
                      },
                      child: Icon(
                        Icons.notifications,
                        size: 30,
                        color: Constant.pink,
                      )),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.70,
                    decoration: BoxDecoration(
                        color: Constant.white,
                        borderRadius: BorderRadius.all(Radius.circular(25.0))),
                    child: TextField(
                      textInputAction: TextInputAction.go,
                      onSubmitted: (value) async {
                        print(searchQuery);
                      },
                      controller: _searchController,
                      style: TextStyle(
                        color: Constant.grey,
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                        // x = x.where((i) => x.contains(value))
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(15.0),
                        suffixIcon: IconButton(
                          onPressed: () {
                            print(searchQuery);
                          },
                          icon: Icon(
                            Icons.search,
                            color: Constant.grey,
                          ),
                        ),
                        hintText: "  Search",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyProfile()));
                      },
                      child: Image(
                        image: AssetImage('assets/profile.png'),
                        width: 30,
                        height: 30,
                      ),)
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "My Mood",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              fontFamily: "lora"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            MoodIcon(
                              image: "assets/happy.png",
                              color: mood == "Very Happy"
                                  ? Constant.orange
                                  : Constant.lightPink,
                              size: mood == "Very Happy" ? 23 : 20,
                            ),
                            mood == "Very Happy"
                                ? Text(
                                    mood,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "lora"),
                                  )
                                : Container()
                          ],
                        ),
                        Column(
                          children: [
                            MoodIcon(
                              image: "assets/smile.png",
                              color: mood == "Happy"
                                  ? Constant.orange
                                  : Constant.lightPink,
                              size: mood == "Happy" ? 23 : 20,
                            ),
                            mood == "Happy"
                                ? Text(
                                    mood,
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "lora"),
                                  )
                                : Container()
                          ],
                        ),
                        Column(
                          children: [
                            MoodIcon(
                              image: "assets/sad.png",
                              color: mood == "Sad"
                                  ? Constant.orange
                                  : Constant.lightPink,
                              size: mood == "Sad" ? 23 : 20,
                            ),
                            mood == "Sad"
                                ? Text(
                                    mood,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "lora"),
                                  )
                                : Container()
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Constant.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          "Playlist",
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              fontFamily: "lora"),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.669,
                            child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.75,
                                child: ListView.builder(
                                    itemCount: _resultsList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (_resultsList[index]['mood'] == mood) {
                                        print(mood);
                                        return SongItem(
                                          title: _resultsList[index]['title'],
                                          Poster: _resultsList[index]['poster'],
                                          link: _resultsList[index]['link'],
                                          Singer: _resultsList[index]['singer'],
                                          duration: _resultsList[index]['duration'],
                                        );
                                      }
                                      return Container();
                                    })
                                // StreamBuilder<QuerySnapshot>(
                                //   stream: FirebaseFirestore.instance.collection('songs').snapshots(),
                                //   builder: (context, snapshot) {
                                //     if (snapshot.hasData) {
                                //       return ListView.builder(
                                //           itemCount: snapshot.data!.docs.length,
                                //           itemBuilder: (context, index) {
                                //             print(index);
                                //             DocumentSnapshot doc = snapshot.data!.docs[index];
                                //             if(doc['mood']=="happy"){
                                //               return SongItem(title:doc['title'],Poster: doc['poster'],link: doc['link'],Singer: doc['singer'],);
                                //             }
                                //             return Container();
                                //             //                                          return  FoodItem(id: index,name: doc['itemName'],price: doc['itemPrice'],quantity: doc['itemQuantity'],image: doc['itemImage'],docId:doc.id);
                                //           });
                                //     } else {
                                //       return Text("No data");
                                //     }
                                //   },
                                // )
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
                                )
                            // ListView(
                            //   children: [
                            //     SongItem(),
                            //     SongItem(),
                            //     SongItem(),
                            //     SongItem(),
                            //     SongItem(),
                            //     SongItem(),
                            //     SongItem(),
                            //     SongItem(),
                            //     SongItem(),
                            //     SongItem(),
                            //     SongItem(),
                            //     SongItem(),
                            //     SongItem()
                            //   ],
                            // ),
                            ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MoodIcon extends StatelessWidget {
  String image;
  Color color;

  MoodIcon({required this.image, required this.color, required this.size});
  double size;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundColor: Constant.pink,
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Constant.white.withOpacity(0.9),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(blurRadius: 10, color: color, spreadRadius: 8)
            ],
          ),
          child: CircleAvatar(
            radius: 12.0,
            backgroundImage: AssetImage(image),
          ),
        ),
      ),
    );
  }
}

import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Cleint/Models/book.dart';
import 'package:ecommerce/Cleint/config/cleint.dart';
import 'package:ecommerce/Config/config.dart';
import 'package:ecommerce/Widgets/customAppBar.dart';
import 'package:ecommerce/Widgets/loadingWidget.dart';
import 'package:ecommerce/Widgets/myDrawer.dart';
import 'package:ecommerce/chatApp/Chat/chat.dart';
import 'package:ecommerce/chatApp/Config/config.dart';
import 'package:ecommerce/notifiers/BookQuantity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProductPage extends StatefulWidget {
  final BookModel bookModel;

  ProductPage({this.bookModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<NetworkImage> _listOfImages = <NetworkImage>[];

  @override
  Widget build(BuildContext context) {
    _listOfImages = [];
    for (int i = 0;
    i <
        widget.bookModel.urls
            .length;
    i++) {
      _listOfImages.add(NetworkImage(widget.bookModel.urls[i]));
    }
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(
          leading: BackButton(
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ),
        drawer: MyDrawer(),
        body: ListView(children: <Widget>[
          Container(
            width: MediaQuery
                .of(context)
                .size
                .width,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 18.0, left: 18.0),
                  child: Text(widget.bookModel.title,
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)),
                ),

                Container(
                  margin: EdgeInsets.all(10.0),
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Carousel(
                      boxFit: BoxFit.cover,
                      images: _listOfImages,
                      autoplay: false,
                      indicatorBgPadding: 5.0,
                      dotPosition: DotPosition.bottomCenter,
                      animationCurve: Curves.fastOutSlowIn,
                      animationDuration:
                      Duration(milliseconds: 2000)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Description",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    widget.bookModel.description,
                    //"There are several things to consider in order to help your book achieve its greatest potential discoverability. Readers, librarians, and retailers can't purchase a book they can't find, and your book metadata is responsible for whether or not your book pops up when they type in search terms relevant to your book. Book metadata may sound complicated, but it consists of all the information that describes your book, including: your title, subtitle, series name, price, trim size, author name, book description, and more. There are two metadata fields for your book description: the long book description and the short book description. Although both play a role in driving traffic to your book, they have distinct differences.",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: Colors.blueGrey),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 20.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Price: ",
                        style: TextStyle(),
                      ),
                      Text(
                        "P",
                        style: TextStyle(color: Colors.red, fontSize: 20.0),
                      ),
                      Text(
                        widget.bookModel.price.toString(),
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Details of owner'),
                ),
                FutureBuilder<DocumentSnapshot>(
                    future: Firestore.instance.collection(
                        UniversityApp.collectionUser).document(widget.bookModel.uid).get(),
                    builder: (context, snapshot) {
                      return snapshot.hasData?OwnerCard(snapshot.data):LoadingWidget();
                    })
              ],
            ),
          ),
        ]),
      ),
    );
  }
}


class OwnerCard extends StatelessWidget {
  final DocumentSnapshot snapshot;
  OwnerCard(this.snapshot);
  @override
  Widget build(BuildContext context) {
    return
      snapshot.data[EcommerceApp.userUID]==EcommerceApp.sharedPreferences
          .getString(EcommerceApp.userUID)?Container(
        child: Text('This book is owned by you'),
      ):
      Container(
        child: UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Colors.deepPurple),
          accountName:
          Text(snapshot.data[EcommerceApp.userName]),
          accountEmail: Row(
            children: <Widget>[
              Text(snapshot.data[EcommerceApp.userEmail]),
              SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: (){
                  List friendList = EcommerceApp.sharedPreferences
                      .getStringList(EcommerceApp.userFriendList);
                  if(!friendList.contains(snapshot.data[ChatApp.userUID])){
                    friendList.add(snapshot.data[ChatApp.userUID]);

                    EcommerceApp.firestore
                        .collection(EcommerceApp.collectionUser)
                        .document(EcommerceApp.sharedPreferences.getString(ChatApp.userUID)).collection(
                        EcommerceApp.userFriendList).document(snapshot.data[ChatApp.userUID]).setData({
                      'name': snapshot.data[ChatApp.userName],
                      'url' :snapshot.data[EcommerceApp.userAvatarUrl]
                    });
                    EcommerceApp.firestore
                        .collection(EcommerceApp.collectionUser)
                        .document(snapshot.data[ChatApp.userUID]).collection(
                        EcommerceApp.userFriendList).document(EcommerceApp.sharedPreferences.getString(ChatApp.userUID)).setData({
                      'name': EcommerceApp.sharedPreferences.getString(ChatApp.userName),
                      'url': EcommerceApp.sharedPreferences.getString(EcommerceApp.userAvatarUrl),
                    });
                    EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userFriendList, friendList);
                  }
                  Route route = MaterialPageRoute(
                      builder: (builder) => Chat(
                        // TODO Change peerID with admin ID
                        peerId: snapshot.data[ChatApp.userUID],
                        userID: EcommerceApp.sharedPreferences.getString(ChatApp.userUID),
                      ));
                  Navigator.push(context, route);
                },
                child: Container(
                  color: Colors.white,
                  width: 80,
                  height: 30,
                  child: Center(child: Text('Chat',style: TextStyle(color: Colors.blueGrey),)),
                ),
              ),
            ],
          ),
          currentAccountPicture: CircleAvatar(
            backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                ? Colors.blue
                : Colors.white,
            backgroundImage: NetworkImage(snapshot.data[EcommerceApp.userAvatarUrl]),
          ),
        ),
      );
  }
}
//
//class MyApp extends StatefulWidget {
//  @override
//  _MyAppState createState() => _MyAppState();
//}
//
//class _MyAppState extends State<MyApp> {
//  var rating = 0.0;
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: 'Rating bar demo',
//      theme: ThemeData(
//        primarySwatch: Colors.green,
//      ),
//      debugShowCheckedModeBanner: false,
//      home: Scaffold(
//        body: Center(
//            child: SmoothStarRating(
//              rating: rating,
//              size: 45,
//              starCount: 5,
//              onRatingChanged: (value) {
//                setState(() {
//                  rating = value;
//                });
//              },
//            )),
//      ),
//    );
//  }
//}

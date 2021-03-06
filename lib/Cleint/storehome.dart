import 'dart:convert';
import 'dart:io';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Cleint/Models/book.dart';
import 'package:ecommerce/Cleint/SellBooks/addBook.dart';
import 'package:ecommerce/Cleint/config/cleint.dart';
import 'package:ecommerce/Cleint/productPage.dart';
import 'package:ecommerce/chatApp/Config/config.dart';

import 'package:ecommerce/notifiers/cartitemcounter.dart';
import 'package:ecommerce/Config/light_color.dart';
import 'package:ecommerce/Config/theme.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/Config/config.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import '../Widgets/customAppBar.dart';
import '../Widgets/loadingWidget.dart';
import '../Widgets/myDrawer.dart';
import '../Widgets/searchBox.dart';

double width;

class CleintStoreHome extends StatefulWidget {
  @override
  _CleintStoreHomeState createState() => _CleintStoreHomeState();
}

class _CleintStoreHomeState extends State<CleintStoreHome> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    registerNotification();
    configLocalNotification();
  }

  void registerNotification() {
    firebaseMessaging.requestNotificationPermissions();
    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      showNotification(message['notification']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      EcommerceApp.firestore
          .collection(ChatApp.collectionUser)
          .document(
              EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
          .updateData({ChatApp.userToken: token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      // Change package name
      Platform.isAndroid
          ? 'com.example.ecommerce'
          : 'com.duytq.flutterchatdemo',
      'Flutter chat demo',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: json.encode(message));
  }

  @override
  Widget build(BuildContext context) {

//    floatingActionButton: new Stack(
//      alignment: Alignment.topLeft,
//      children: <Widget>[
//        new FloatingActionButton(
//          onPressed: () {
//            Navigator.of(context).push(new CupertinoPageRoute(
//                builder: (BuildContext context) => new SellBook()));
//          },
//          child: new Icon(Icons.shopping_cart),
//        ),
//        new CircleAvatar(
//          radius: 10.0,
//          backgroundColor: Colors.red,
//          child: new Text(
//            "0",
//            style: new TextStyle(color: Colors.white, fontSize: 12.0),
//          ),
//        )
//      ],
//    );

    Widget image_carousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/new/1.jpeg'),
          AssetImage('images/new/2.jpg'),
          AssetImage('images/new/3.jpg'),
          AssetImage('images/new/4.jpg'),
          AssetImage('images/new/5.jpg'),
          AssetImage('images/new/6.jpg'),
        ],
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 2.1,
        dotColor: Colors.amber,
        dotBgColor: Colors.transparent,
      ),
    );

    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: MyAppBar(),
            ),
            SliverPersistentHeader(pinned: true, delegate: SearchBoxDelegate()),
            StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance
                    .collection(UniversityApp.collectionAllBook)
                    .snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? SliverToBoxAdapter(
                          child: Center(child: LoadingWidget()),
                        )
                      : SliverStaggeredGrid.countBuilder(
                          crossAxisCount: 1,
                          staggeredTileBuilder: (_) => StaggeredTile.fit(1),
                          itemBuilder: (context, index) {
                            BookModel model = BookModel.fromJson(
                                snapshot.data.documents[index].data);
                            return sourceInfo(model, context,snapshot.data.documents[index].documentID);
                          },
                          itemCount: snapshot.data.documents.length,
                        );
                }),
          ],
        ),
      ),
    );
  }
}

Widget sourceInfo(BookModel model, BuildContext context, String documentID,
    {Color background, removeCartFunction,bool isProductPage=false}) {
  print('Printing.. update cart ${model.avarageRating} $removeCartFunction');
  return InkWell(
    onTap: () {
      Route route =
          MaterialPageRoute(builder: (_) => ProductPage(bookModel: model,documentID: documentID,));
      Navigator.push(context, route);
    },
    splashColor: LightColor.purple,
    child: Container(
        height: 170,
        width: width - 20,
        child: Row(
          children: <Widget>[
            AspectRatio(
              aspectRatio: .7,
              child: card(primaryColor: background, imgPath: model.urls[0]),
            ),


            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 15),
                Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                        child: Text(model.title,
                            style: TextStyle(
                                color: LightColor.purple,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                      CircleAvatar(
                        radius: 3,
                        backgroundColor: background,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(width: 10)
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 0.0,
                          ),
                          child: Row(
                            // mainAxisSize: MainAxisSize.min,
                            //mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Price: ",
                                  style: AppTheme.h6Style.copyWith(
                                    fontSize: 14,
                                    color: LightColor.grey,
                                  )),
                              Text(
                                "P",
                                style: TextStyle(
                                    color: Colors.red, fontSize: 14.0),
                              ),
                              Text(model.price.toString(),
                                  style: AppTheme.h6Style.copyWith(
                                    fontSize: 14,
                                    color: Colors.red,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child:                 RichText(text: TextSpan(
                      text: 'Number of views: ',
                      style: AppTheme.h6Style.copyWith(
                        fontSize: 14,
                        color: LightColor.grey,
                      ),
                      children: [
                        TextSpan(
                            text: model.views.toString(),
                            style: AppTheme.h6Style.copyWith(
                              fontSize: 14,
                              color: Colors.red,
                            )
                        )
                      ]
                  )),

                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child:                 RichText(text: TextSpan(
                      text: 'Average rating: ',
                      style: AppTheme.h6Style.copyWith(
                        fontSize: 14,
                        color: LightColor.grey,
                      ),
                      children: [
                        TextSpan(
                            text: model.avarageRating==null?'No reviews yet':model.avarageRating.toStringAsFixed(2),
                            style: AppTheme.h6Style.copyWith(
                              fontSize: 14,
                              color: Colors.red,
                            )
                        )
                      ]
                  )),

                ),
//                Text(model.views.toString()),
//                SmoothStarRating(
//                  color: Colors.pink,
//                  rating: model.avarageRating,
//                  allowHalfRating: false,
//                  spacing: 5,
//                  isReadOnly: true,
//                  size: 25,
//                  starCount: 5,
//                ),

//                Text(model.avarageRating.toString()),
                Flexible(
                  child: Container(),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: removeCartFunction == null
                      ? Container()
                      : IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                            color: LightColor.purple,
                          ),
                          onPressed: () {
                            print('StoreHome.dart');
                            removeCartFunction();
                            //checkItemInCart(model.isbn, context);
                          }),
                ),
                Divider(
                  height: 4,
                )
              ],
            ))
          ],
        )),
  );
}

Widget _chip(String text, Color textColor,
    {double height = 0, bool isPrimaryCard = false}) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Chip(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: height),
      label: Text(
        text,
        style: TextStyle(
            color: isPrimaryCard ? Colors.white : textColor, fontSize: 12),
      ),
    ),
  );
}

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container(
      height: 150,
      width: width * .34,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                offset: Offset(0, 5), blurRadius: 10, color: Color(0x12000000))
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Image.network(
          imgPath,
          height: 150,
          width: width * .34,
          fit: BoxFit.fill,
        ),
      ));
}

void checkItemInCart(String productID, BuildContext context) {
  print(productID);

  ///print(cartItems);
  EcommerceApp.sharedPreferences
          .getStringList(
            EcommerceApp.userFriendList,
          )
          .contains(productID)
      ? Fluttertoast.showToast(msg: 'Product is already in cat')
      : addToCart(productID, context);
}

void addToCart(String productID, BuildContext context) {
  List temp = EcommerceApp.sharedPreferences.getStringList(
    EcommerceApp.userFriendList,
  );
  temp.add(productID);
  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .document(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .updateData({EcommerceApp.userFriendList: temp}).then((_) {
    Fluttertoast.showToast(msg: 'Item Added Succesfully');
    EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userFriendList, temp);
    Provider.of<CartItemCounter>(context, listen: false).displayResult();
  });
}

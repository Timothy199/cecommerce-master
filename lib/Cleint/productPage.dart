import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Cleint/Models/book.dart';
import 'package:ecommerce/Cleint/config/cleint.dart';
import 'package:ecommerce/Cleint/storehome.dart';
import 'package:ecommerce/Config/config.dart';
import 'package:ecommerce/Config/light_color.dart';
import 'package:ecommerce/Config/theme.dart';
import 'package:ecommerce/Widgets/customAppBar.dart';
import 'package:ecommerce/Widgets/loadingWidget.dart';
import 'package:ecommerce/Widgets/myDrawer.dart';
import 'package:ecommerce/chatApp/Chat/chat.dart';
import 'package:ecommerce/chatApp/Config/config.dart';
import 'package:ecommerce/modals/reviewreting.dart';
import 'package:ecommerce/notifiers/BookQuantity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'addReview.dart';
//import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProductPage extends StatefulWidget {
  final BookModel bookModel;
  final String documentID;

  ProductPage({this.bookModel, this.documentID});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<NetworkImage> _listOfImages = <NetworkImage>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    updateCount();
  }

  updateCount() async {
    int views = 0;

    DocumentSnapshot snapshot = await EcommerceApp.firestore
        .collection(UniversityApp.collectionAllBook)
        .document(widget.documentID)
        .get();
    views = snapshot.data['views'];
    EcommerceApp.firestore
        .collection(UniversityApp.collectionAllBook)
        .document(widget.documentID)
        .updateData({
      'views': views + 1,
    }).then((value) => print('Update count ${views + 1}'));
  }

  @override
  Widget build(BuildContext context) {
    _listOfImages = [];
    for (int i = 0; i < widget.bookModel.urls.length; i++) {
      _listOfImages.add(NetworkImage(widget.bookModel.urls[i]));
    }
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: MyAppBar(
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          drawer: MyDrawer(),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10.0),
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: Carousel(
                            boxFit: BoxFit.cover,
                            images: _listOfImages,
                            autoplay: false,
                            indicatorBgPadding: 5.0,
                            dotPosition: DotPosition.bottomCenter,
                            animationCurve: Curves.fastOutSlowIn,
                            animationDuration: Duration(milliseconds: 2000)),
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
                              style:
                                  TextStyle(color: Colors.red, fontSize: 20.0),
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
                          future: Firestore.instance
                              .collection(UniversityApp.collectionUser)
                              .document(widget.bookModel.uid)
                              .get(),
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? OwnerCard(snapshot.data)
                                : LoadingWidget();
                          }),
//                      Text('Rate this app'),
//                      InkWell(
//                        onTap: () {
//                          Route route = MaterialPageRoute(
//                              builder: (_) =>
//                                  AddReview(
//                                    documentID: widget.documentID,
//                                  ));
//                          Navigator.push(context, route);
//                        },
//                        child: Row(
//                          children: <Widget>[
//                            Text('Tell others what you think'),
//                            Icon(Icons.edit)
//                          ],
//                        ),
//                      ),
                      Header(
                        title: 'Suggesstions',
                        onPressed: () {},
                      ),
                      Container(
                        height: 180,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance
                                .collection(UniversityApp.collectionAllBook)
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<DocumentSnapshot> list = [];
                              if (snapshot.hasData) {
                                list = snapshot.data.documents;
                                list.shuffle();
                              }
                              return !snapshot.hasData
                                  ? Center(child: LoadingWidget())
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          snapshot.data.documents.length > 10
                                              ? 10
                                              : snapshot.data.documents.length,
                                      itemBuilder: (_, index) {
                                        BookModel model = BookModel.fromJson(
                                            list[index].data);
                                        if(widget.documentID==list[index].documentID){
                                          return Container();
                                        }

                                        return InkWell(
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 0, horizontal: 5),
                                              child: Container(
                                                height: 150,
                                                width: 100,
                                                alignment: Alignment.center,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    AspectRatio(
                                                      aspectRatio: .7,
                                                      child: card(
                                                          primaryColor:
                                                              Colors.white,
                                                          imgPath:
                                                              model.urls[0]),
                                                    ),
                                                    Text(model.title,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            color: LightColor
                                                                .purple,
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              )),
                                          onTap: () {
                                            Route route = MaterialPageRoute(
                                                builder: (_) => ProductPage(
                                                      bookModel: model,
                                                      documentID: widget.documentID,
                                                    ));
                                            Navigator.push(context, route);
                                          },
                                        );
                                      });
                            }),
                      ),
//                      Container(
//                        height: 130,
//                        child: ListView.builder(
//                            scrollDirection: Axis.horizontal,
//                            itemBuilder: (_,index){
//                          return Padding(padding: EdgeInsets.symmetric(vertical: 0,horizontal: 5),child: Container(
//                            height: 100,
//                            //padding: EdgeInsets.all(20),
//                            width: 100,
//                            color:  Colors.primaries[index % Colors.primaries.length],
//                          ),);
//                        }),
//                      ),
                      ListTile(
                        title: Text('Reviews'),
                        trailing: InkWell(
                          onTap: () {
                            Route route = MaterialPageRoute(
                                builder: (_) => AddReview(
                                      documentID: widget.documentID,
                                    ));
                            Navigator.push(context, route);
                          },
                          child: Text('Add a review'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: EcommerceApp.firestore
                      .collection(UniversityApp.collectionAllBook)
                      .document(widget.documentID)
                      .collection(UniversityApp.collectionReview)
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.documents.length == 0) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text('No reviews yet'),
                          ),
                        );
                      }
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          // To convert this infinite list to a list with three items,
                          // uncomment the following line:
                          //if (index > 3) return null;
                          ReviewRating rating = ReviewRating.fromJson(
                              snapshot.data.documents[index].data);
                          return Container(


                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 10,top: 10),
                                        child:                 RichText(text: TextSpan(
                                            text: 'Posted By: ',
                                            style: AppTheme.h6Style.copyWith(
                                              fontSize: 14,
                                              color: LightColor.grey,
                                            ),
                                            children: [
                                              TextSpan(
                                                  text: rating.postedBy,
                                                  style: AppTheme.h6Style.copyWith(
                                                    fontSize: 14,
                                                    color: Colors.red,
                                                  )
                                              )
                                            ]
                                        )),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(right: 10,top: 10),
                                        child:                 RichText(text: TextSpan(
                                            text: 'Posted at: ',
                                            style: AppTheme.h6Style.copyWith(
                                              fontSize: 14,
                                              color: LightColor.grey,
                                            ),
                                            children: [
                                              TextSpan(
                                                  text: DateFormat('dd MMM kk:mm').format(
                                                    DateTime.fromMillisecondsSinceEpoch(
                                                        rating.time)),//DateTime.fromMicrosecondsSinceEpoch(rating.time).toString(),
                                                  style: AppTheme.h6Style.copyWith(
                                                    fontSize: 14,
                                                    color: Colors.red,
                                                  )
                                              )
                                            ]
                                        )),
                                      ),


                                    ],
                                  ),
                                  SmoothStarRating(
                                      allowHalfRating: false,
                                      starCount: 5,
                                      rating: rating.rating,
                                      //rating: 2,
                                      size: 30.0,
                                      isReadOnly: true,
//              fullRatedIconData: Icons.blur_off,
//              halfRatedIconData: Icons.blur_on,
                                      color: Colors.deepPurple,
                                      borderColor: Colors.deepPurple,
                                      spacing: 0.0),
                                  Text(rating.review,style: AppTheme.h6Style.copyWith(
                                    fontSize: 14,
                                    color: LightColor.grey,
                                  ),),

                                ],
                              ),
                              height: 150.0);
                        }, childCount: snapshot.data.documents.length
                            // Or, uncomment the following line:
                            // childCount: 3,
                            ),
                      );
                    } else {
                      return SliverToBoxAdapter(
                        child: LoadingWidget(),
                      );
                    }
                  })
            ],
          )),
    );
  }
}

class Header extends StatelessWidget {
  final String title;
  final onPressed;

  const Header({Key key, this.title, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
    );
  }
}

class OwnerCard extends StatelessWidget {
  final DocumentSnapshot snapshot;

  OwnerCard(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return snapshot.data[EcommerceApp.userUID] ==
            EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID)
        ? Container(
            child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text('This book is owned by you'),
          ))
        : Container(
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              accountName: Text(snapshot.data[EcommerceApp.userName]),
              accountEmail: Row(
                children: <Widget>[
                  Text(snapshot.data[EcommerceApp.userEmail]),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      List friendList = EcommerceApp.sharedPreferences
                          .getStringList(EcommerceApp.userFriendList);
                      if (!friendList
                          .contains(snapshot.data[ChatApp.userUID])) {
                        friendList.add(snapshot.data[ChatApp.userUID]);

                        EcommerceApp.firestore
                            .collection(EcommerceApp.collectionUser)
                            .document(EcommerceApp.sharedPreferences
                                .getString(ChatApp.userUID))
                            .collection(EcommerceApp.userFriendList)
                            .document(snapshot.data[ChatApp.userUID])
                            .setData({
                          'name': snapshot.data[ChatApp.userName],
                          'url': snapshot.data[EcommerceApp.userAvatarUrl]
                        });
                        EcommerceApp.firestore
                            .collection(EcommerceApp.collectionUser)
                            .document(snapshot.data[ChatApp.userUID])
                            .collection(EcommerceApp.userFriendList)
                            .document(EcommerceApp.sharedPreferences
                                .getString(ChatApp.userUID))
                            .setData({
                          'name': EcommerceApp.sharedPreferences
                              .getString(ChatApp.userName),
                          'url': EcommerceApp.sharedPreferences
                              .getString(EcommerceApp.userAvatarUrl),
                        });
                        EcommerceApp.sharedPreferences.setStringList(
                            EcommerceApp.userFriendList, friendList);
                      }
                      Route route = MaterialPageRoute(
                          builder: (builder) => Chat(
                                // TODO Change peerID with admin ID
                                peerId: snapshot.data[ChatApp.userUID],
                                userID: EcommerceApp.sharedPreferences
                                    .getString(ChatApp.userUID),
                              ));
                      Navigator.push(context, route);
                    },
                    child: Container(
                      color: Colors.white,
                      width: 80,
                      height: 30,
                      child: Center(
                          child: Text(
                        'Chat',
                        style: TextStyle(color: Colors.blueGrey),
                      )),
                    ),
                  ),
                ],
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.blue
                        : Colors.white,
                backgroundImage:
                    NetworkImage(snapshot.data[EcommerceApp.userAvatarUrl]),
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

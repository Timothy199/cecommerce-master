import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/Cleint/config/cleint.dart';
import 'package:ecommerce/Config/config.dart';
import 'package:ecommerce/modals/reviewreting.dart';
import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'dart:convert';

class AddReview extends StatefulWidget {
  final String documentID;
  const AddReview({Key key, this.documentID}) : super(key: key);

  @override
  _AddReviewState createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  double value = 5;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write a review'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (reviewController.text.isNotEmpty) {
            uploadReview();
          } else {
            final snackbar = SnackBar(content: Text('Review cannot be empty'));
            scaffoldKey.currentState.showSnackBar(snackbar);
            FocusScope.of(context).requestFocus(FocusNode());
          }
        },
        label: Text('Done'),
        backgroundColor: Colors.deepPurple,
        icon: Icon(Icons.check),
      ),
      key: scaffoldKey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SmoothStarRating(
              allowHalfRating: false,
              onRated: (v) {
                value = v;
                setState(() {});
              },
              starCount: 5,
              rating: value,
              //rating: 2,
              size: 40.0,
              isReadOnly: false,
//              fullRatedIconData: Icons.blur_off,
//              halfRatedIconData: Icons.blur_on,
              color: Colors.deepPurple,
              borderColor: Colors.deepPurple,
              spacing: 0.0),
//          DropdownButton<int>(
//            items: <int>[1,2,3,4,5].map((int value) {
//              return new DropdownMenuItem<int>(
//                value: value,
//                child: new Text(value.toString()),
//              );
//            }).toList(),
//            value: value,
//            onChanged: (_) {
//              value=_;
//              setState(() {
//
//              });
//            },
//          ),
          Form(
              //key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: reviewController,
                  decoration:
                      InputDecoration.collapsed(hintText: 'Enter your review',border: InputBorder.none,
                        ),
                  maxLines: 10,
//                  minLines: 10,
                ),
              )),
          TextField(),
        ],
      ),
    );
  }

  uploadReview() async {
    final snackbar = SnackBar(content: Text('Uploading'));
    scaffoldKey.currentState.showSnackBar(snackbar);
    FocusScope.of(context).requestFocus(FocusNode());
   // formKey.currentState.reset();
    double averageRating = 0;
    int dateTime = DateTime.now().millisecondsSinceEpoch;
    ReviewRating model =
        ReviewRating(rating: value, postedBy: EcommerceApp.sharedPreferences
            .getString(EcommerceApp.userName), review: reviewController.text, time: dateTime);
    print('Review ${reviewController.text}');
    EcommerceApp.firestore
        .collection(UniversityApp.collectionAllBook)
        .document(widget.documentID)
        .collection(UniversityApp.collectionReview)
        .document(dateTime.toString())
        .setData(model.toJson());
    QuerySnapshot snapshot = await EcommerceApp.firestore
        .collection(UniversityApp.collectionAllBook)
        .document(widget.documentID)
        .collection(UniversityApp.collectionReview)
        .getDocuments();
    snapshot.documents.length;
    snapshot.documents.forEach((element) {
      averageRating = element['rating'] + averageRating;
    });
    print('averageRating');
    EcommerceApp.firestore
        .collection(UniversityApp.collectionAllBook)
        .document(widget.documentID)
        .updateData({
      'rating': (averageRating / snapshot.documents.length),
    }).then((value) {
      final snackbar = SnackBar(content: Text('Review added successfully'));
      scaffoldKey.currentState.showSnackBar(snackbar);
      FocusScope.of(context).requestFocus(FocusNode());
      reviewController.clear();

    } );
  }
}

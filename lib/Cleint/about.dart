import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF78909C),
        title: Text("About"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "UB SECONDHAND BOOK-TRADER APP",
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
            ),
            Text("Version 1.0.0"),

            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
            ),
            Divider(
              height: 20.0,
              color: Colors.grey,
            ),
            Container(
              padding: const EdgeInsets.only(left: 8.0),
              alignment: Alignment.topLeft,
              child: Text(
                "About UB SECONDHAND BOOK-TRADER APP",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "UB SECONDHAND BOOK-TRADER APP enables you to trade amongst other students within the safety and convenience of your university campus. We make it safer easier and cheaper to buy and sell stuff within university. Textbooks, for example, are on average 70% less expensive on UB SECONDHAND BOOK-TRADER APP than new. It takes meer seconds to upload a textbook and meer seconds to find the textbook you need on the platform."),
            ),
            Container(
              padding: const EdgeInsets.only(left: 8.0),
              alignment: Alignment.topLeft,
              child: Text(
                "Privacy & Policy",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "UB SECONDHAND BOOK-TRADER APP enables you to trade amongst other students within the safety and convenience of your university campus. We make it safer easier and cheaper to buy and sell stuff within university. Textbooks, for example, are on average 70% less expensive on UB SECONDHAND BOOK-TRADER APP than new. It takes meer seconds to upload a textbook and meer seconds to find the textbook you need on the platform."),
            )
          ],
        ),
      ),
    );
  }
}

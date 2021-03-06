import 'package:ecommerce/Cleint/storehome.dart';
import 'package:ecommerce/Widgets/customTextField.dart';
import 'package:ecommerce/dialogs/errorDialog.dart';
import 'package:ecommerce/dialogs/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:ecommerce/Config/config.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Login to your account',
                style: TextStyle(color: Colors.red),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CustomTextField(
                    data: Icons.person_outline,
                    controller: _emailController,
                    hintText: 'Email',
                    isObsecure: false,
                  ),
                  CustomTextField(
                    data: Icons.lock_outline,
                    controller: _passwordController,
                    hintText: 'Password',
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            RaisedButton(
              onPressed: () {
                 _emailController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty
                        ? _login()
                        : showDialog(
                            context: context,
                            builder: (con) {
                              return ErrorAlertDialog(
                                message: 'Please fill the desired fields',
                              );
                            });
              },
              color: Colors.redAccent,
              child: Text('Log in'),
            ),
            SizedBox(
              height: 20,
            ),

            Container(
              height: 3,
              width: _screenWidth * 0.8,
              color: Colors.red,
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              onPressed: _resetPassword,

              color: Colors.redAccent,
              child: Text('Forget Password'),
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );
  }

  void _resetPassword(){
    final _emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (_){
        return AlertDialog(
          content: TextField(
            controller: _emailController,
            decoration :InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
            Icons.email,
            color: Theme.of(context).primaryColor,
        ),
        focusColor: Theme.of(context).primaryColor,
        hintText: 'Enter your email',
          ),),
          actions: <Widget>[
            RaisedButton(
              child: Text('Cancel'),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            RaisedButton(
              child: Text('Send Email'),
       onPressed: () async{
         if(_emailController.text.isEmpty){
           showDialog(
                    context: context,
                    builder: (con) {
                      return ErrorAlertDialog(
                        message: 'Please fill the desired fields',
                      );
                    });
           return ;
         }
         showDialog(
           context: context,
           builder: (_){
             return LoadingAlertDialog(
               message: 'Please wait',
             );
           }
         );
         await _auth.sendPasswordResetEmail(email: _emailController.text.trim())
             .then((auth) {
           //currentUser = auth.user;
           Navigator.pop(context);
           showDialog(
               context: context,
               builder: (con) {
                 return ErrorAlertDialog(
                   message: 'Email has been sent to ${_emailController.text}',
                   doublePop: true
                 );
               });

         }).catchError((error) {
           Navigator.pop(context);
           showDialog(
               context: context,
               builder: (con) {
                 return ErrorAlertDialog(
                   message: error.message.toString(),
                 );
               });
         });
       },

            ),
          ],

        );
      }
    );
  }

  void _login() async {
    showDialog(
        context: context,
        builder: (con) {
          return LoadingAlertDialog(
            message: 'Please wait',
          );
        });
    FirebaseUser currentUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (con) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });
    if (currentUser != null) {
      readDataToDataBase(currentUser).then((s) {
        Navigator.pop(context);
        // TODO navigate to homescreen

        Route newRoute = MaterialPageRoute(builder: (_) => CleintStoreHome());
        Navigator.pushReplacement(context, newRoute);
      });
    } else {
      //   _success = false;
    }
  }


}

Future readDataToDataBase(FirebaseUser currentUser) async {
   await EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .document(currentUser.uid).get().then((snapshot) async {
        print(snapshot.data);
     await EcommerceApp.sharedPreferences
         .setString(EcommerceApp.userUID, snapshot.data[EcommerceApp.userUID]);
     await EcommerceApp.sharedPreferences
         .setString(EcommerceApp.userEmail, snapshot.data[EcommerceApp.userEmail]);
        await EcommerceApp.sharedPreferences
            .setString(EcommerceApp.userName, snapshot.data[EcommerceApp.userName]);
        await EcommerceApp.sharedPreferences
            .setString(EcommerceApp.userAvatarUrl, snapshot.data[EcommerceApp.userAvatarUrl]);
      //  print(snapshot.data[EcommerceApp.userFriendList]);
        //List<String> cart = snapshot.data[EcommerceApp.userFriendList].cast<String>();
        //await EcommerceApp.sharedPreferences.setStringList(EcommerceApp.userFriendList, cart);
  });
//      .setData({
//    DeliveryApp.userUID: currentUser.uid,
//    DeliveryApp.userEmail: currentUser.email,
//  });

}


final FirebaseAuth _auth = FirebaseAuth.instance;

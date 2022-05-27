import 'package:auth/signInPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  String uid;
  HomePage({this.uid});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<bool> signOutUser() async {
    FirebaseUser user = await auth.currentUser();
    print(user.providerData[1].providerId);

    await auth.signOut();
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
        child: Center(
          child: IconButton(
            icon: Icon(Icons.exit_to_app),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () => signOutUser().then((value) async{
             await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SignPage()));
                 
            }),
          ),
        ),
      ),
    );
  }
}

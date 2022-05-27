import 'package:auth/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class SignPage extends StatefulWidget {
  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FacebookLogin facebookSignIn = new FacebookLogin();
  String _message = 'Log in/out by pressing the buttons below.';

  void _signInFacebook() async {
//    2407536649-ZFNGnaMhK7tCHBYL4rQ2SGT9nkuTbnL8g3aJCxq acc token
//    Niz5D73o0BaUMZU4GHHGCTSpJmIoxmoPIITPeuOH46SMO acc token secret
    FacebookLogin facebookLogin = FacebookLogin();

    final result = await facebookLogin.logIn(['email']);
    final token = result.accessToken.token;
    print(token);

    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name&access_token=${token}');
    print(graphResponse.body);
    if (result.status == FacebookLoginStatus.loggedIn) {
      final credential = FacebookAuthProvider.getCredential(accessToken: token);
      _auth.signInWithCredential(credential);
    }
  }

  Future<void> signUpWithFacebook() async {
    try {
      var facebookLogin = new FacebookLogin();
      var result = await facebookLogin.logIn(['email']);

      if (result.status == FacebookLoginStatus.loggedIn) {
        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        );
        final FirebaseUser user =
            (await FirebaseAuth.instance.signInWithCredential(credential)).user;
        print('signed in ' + user.displayName);
        print(user.uid);
        print(user);
        return user;
      }
    } catch (e) {
      print(" exception bjfdbfjJD ${e.message}");
    }
  }

  // Future<Null> _login() async {
  //   final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

  //   switch (result.status) {
  //     case FacebookLoginStatus.loggedIn:
  //       final FacebookAccessToken accessToken = result.accessToken;
  //       _showMessage('''
  //        Logged in!

  //        Token: ${accessToken.token}
  //        User id: ${accessToken.userId}
  //        Expires: ${accessToken.expires}
  //        Permissions: ${accessToken.permissions}
  //        Declined permissions: ${accessToken.declinedPermissions}
  //        ''');

  //     if (result.status == FacebookLoginStatus.loggedIn) {
  //       final AuthCredential credential = FacebookAuthProvider.getCredential(
  //         accessToken: result.accessToken.token,
  //       );
  //       final FirebaseUser user =
  //           (await FirebaseAuth.instance.signInWithCredential(credential)).user;
  //       print('signed in ' + user.displayName);
  //       print(user.uid);
  //       print(user);
  //       return user;
  //     }

  //       break;
  //     case FacebookLoginStatus.cancelledByUser:
  //       _showMessage('Login cancelled by the user.');
  //       break;
  //     case FacebookLoginStatus.error:
  //       print("facebookerror ${result.errorMessage}' ");
  //       break;
  //   }
  // }

//   void _signInTwitter() async {
//     var twitterLogin = new TwitterLogin(
//       consumerKey: 'azIqko7qrN5E3f6s2xn6WG1sm',
//       consumerSecret: 'sM8O7GFlzZb7hMX7ajg7I0Ti1rkJxZyHnkyqammDzZrJLBIOa6',
//     );

//     final TwitterLoginResult result = await twitterLogin.authorize();

//     switch (result.status) {
//       case TwitterLoginStatus.loggedIn:
//         var session = result.session;
//         print('successful sign in: ${session.username}');
// //        _sendTokenAndSecretToServer(session.token, session.secret);
//         break;
//       case TwitterLoginStatus.cancelledByUser:
// //        _showCancelMessage();
//         print('cancelled by user');
//         break;
//       case TwitterLoginStatus.error:
//         print(result.errorMessage);
//         break;
//     }
//   }

  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text("Auth"),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 30.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset("assets/welcome2.png"),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => signUpWithFacebook().whenComplete(() async {
                  FirebaseUser user = await FirebaseAuth.instance.currentUser();

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => HomePage(uid: user.uid)));
                }),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.facebookF,
                        color: Colors.red,
                        size: 30.0,
                      ),
                      Text(
                        ' |  Sign in with Facebook',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                onTap: () {
                  // _signInTwitter();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        FontAwesomeIcons.twitter,
                        color: Colors.red,
                        size: 30.0,
                      ),
                      Text(
                        ' |  Sign in with Twitter',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                onTap: () {
                  // goToPageCallback(2);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                onTap: () {
                  // goToPageCallback(1);
                },
                child: Text(
                  'ALREADY REGISTERED? SIGN IN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

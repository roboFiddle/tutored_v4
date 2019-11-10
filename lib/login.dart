import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'authentication.dart';
import 'dashboard.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => new LoginState();
}
class LoginState extends State<Login> {
  var auth = new Authentication();

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

  FirebaseUser currentUser;

  @override
  void initState() {
    Dashboard.title = 'TutorED';
    super.initState();
    _initFirestore();
    auth.isSignedIn(context);
  }
  void _initFirestore() async {
    await Firestore.instance.settings(timestampsInSnapshotsEnabled: true);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('images/logo.jpg'),
              height: 300.0,
              width: 300.0,
            ),
            SizedBox(height: 100.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GoogleSignInButton(
                  onPressed: () => auth.signIn(context)
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class User extends StatefulWidget {
  @override
  UserState createState() => new UserState();
}
class UserState extends State<User> {
  var auth = new Authentication();

  int option = -1;

  SharedPreferences prefs;
  String id = '';
  String name = '';

  @override
  void initState() {
    Dashboard.title = 'TutorED';
    super.initState();
    _readLocal();
  }
  void _readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    name = prefs.getString('name') ?? '';
  }

  void addData(int role) {
    if (role != -1) {
      setState(() {
        auth.isLoading.value = true;
      });
      Firestore.instance
          .collection('users')
          .document(id)
          .updateData({
            'role': role,
            'englishState': "NI",
            'mathState': "NI",
            'historyState': "NI",
            'languageState': "NI",
            'scienceState': "NI",
            'selectedLanguage': "NA",
            'monday': true,
            'tuesday': true,
            'wednesday': true,
            'thursday': true,
            'friday': true,
            'saturday': true,
            'sunday': true,
          }).then((data) async {
        await prefs.setInt('role', role);
        await prefs.setString('aboutMe',"");
        await prefs.setString('contact', "");
        await prefs.setInt('grade', 0);
        await prefs.setString('englishState', "NI");
        await prefs.setString('mathState', "NI");
        await prefs.setString('historyState', "NI");
        await prefs.setString('languageState', "NI");
        await prefs.setString('scienceState', "NI");
        await prefs.setString('selectedLanguage', "NA");
        await prefs.setBool("monday", true);
        await prefs.setBool("tuesday", true);
        await prefs.setBool("wednesday", true);
        await prefs.setBool("thursday", true);
        await prefs.setBool("friday", true);
        await prefs.setBool("saturday", true);
        await prefs.setBool("sunday", true);
        setState(() {
          auth.isLoading.value = false;
        });
      }).catchError((err) {
        setState(() {
          auth.isLoading.value = false;
        });
      });
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  }
  int roleValue = -1;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack (
        children: <Widget>[
          Container (
            alignment: Alignment(0.0, -0.8),
            child: Text (
              'Welcome ' + name.split(' ')[0] + '!',
              style: new TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 42.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text (
                'I am a...',
                style: new TextStyle(
//                  color: Theme.of(context).primaryColor,
                  fontSize: 24.0,
                ),
                textAlign: TextAlign.center,
              ),
              RadioListTile<int>(
                  title: new Text (
                    'Student',
                    style: new TextStyle(
                      color: Theme.of(context).textSelectionColor,
                    ),
                  ),
                  value: 0,
                  groupValue: roleValue,
                  activeColor: Theme.of(context).textSelectionColor,
                  onChanged: (int value) {
                    setState(() => roleValue = value);
                  }),
              RadioListTile<int>(
                  title: new Text (
                    'Parent',
                    style: new TextStyle(
                      color: Theme.of(context).textSelectionColor,
                    ),
                  ),
                  value: 1,
                  groupValue: roleValue,
                  activeColor: Theme.of(context).textSelectionColor,
                  onChanged: (int value) {
                    setState(() => roleValue = value);
                  }),
            ],
          ),
          Container (
            alignment: Alignment(0.0, 0.8),
            child: ButtonTheme(
              minWidth: 150,
              child: RaisedButton(
                  onPressed: () => addData(roleValue),
                  child: Text(
                    'Go!',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  color: Theme.of(context).accentColor,
                  splashColor: Colors.transparent,
                  textColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0))
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: auth.isLoading,
            builder: (context, value, child) {
              return Container (
                child: auth.isLoading.value
                    ? Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).errorColor),
                    ),
                  ),
                  color: Colors.white.withOpacity(0.8),
                ): Container(),
              );
            },
          ),
        ],
      ),
    );
  }
}
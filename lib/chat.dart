import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tutor_ed/conversation.dart';
import 'dashboard.dart';
import 'profile.dart';

class Chat extends StatefulWidget {
  @override
  ChatState createState() => new ChatState();
}

class ChatState extends State<Chat> {
  SharedPreferences prefs;
  String id = '';
  int role = -1;
  @override
  void initState() {
    super.initState();
    _readLocal();
  }
  void _readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    role = prefs.getInt('role') ?? -1;
    setState(() {});
  }

  String requests(DocumentSnapshot document) {
    List<String> avail = new List<String>();
    if(document['englishState'] == "TT")
      avail.add("English");
    if(document['mathState'] == "TT")
      avail.add("Math");
    if(document['historyState'] == "TT")
      avail.add("History");
    if(document['languageState'] == "TT") {
      switch(document['selectedLanguage']) {
        case "SP":
          avail.add("Spanish");
          break;
        case "FR":
          avail.add("French");
          break;
        case "CH":
          avail.add("Chinese");
          break;
        case "IT":
          avail.add("Italian");
          break;
        case "LA":
          avail.add("Latin");
          break;
        default:
          avail.add("Foreign Language");
      }
    }
    if(document['scienceState'] == "TT")
      avail.add("Science");
    return avail.join(", ");
  }
  String offers(DocumentSnapshot document) {
    List<String> avail = new List<String>();
    if(document['englishState'] == "WT")
      avail.add("English");
    if(document['mathState'] == "WT")
      avail.add("Math");
    if(document['historyState'] == "WT")
      avail.add("History");
    if(document['languageState'] == "WT") {
      switch(document['selectedLanguage']) {
        case "SP":
          avail.add("Spanish");
          break;
        case "FR":
          avail.add("French");
          break;
        case "CH":
          avail.add("Chinese");
          break;
        case "IT":
          avail.add("Italian");
          break;
        case "LA":
          avail.add("Latin");
          break;
        default:
          avail.add("Foreign Language");
      }
    }
    if(document['scienceState'] == "WT")
      avail.add("Science");
    return avail.join(", ");
  }

  Widget buildUser(BuildContext context, DocumentSnapshot document, int r) {
    if (document['id'] == id || document['role'] == r || r == -1) {
      return Container();
    } else {
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).errorColor),
                    ),
                    width: 50.0,
                    height: 50.0,
                    padding: EdgeInsets.all(15.0),
                  ),
                  imageUrl: document['photoUrl'],
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Name: ${document['name']}',
                          style: TextStyle(color: Theme.of(context).textSelectionColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          'Grade: ${document['grade']}',
                          style: TextStyle(color: Theme.of(context).textSelectionColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                      Container(
                        child: Text(
                          r == 0 ? "Tutoring: " + offers(document) : "Requests: " + requests(document),
                          style: TextStyle(color: Theme.of(context).textSelectionColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            navigateToProfile(context, document);
          },
          color: Theme.of(context).primaryColorLight,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }
  Future navigateToProfile(context, DocumentSnapshot document) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(document: document,)));
  }
  Widget buildChatList(int r) {
    return Container(
      child: StreamBuilder(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).errorColor),
              ),
            );
          } else {
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) => buildUser(context, snapshot.data.documents[index], r),
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      ),
    );
  }



  int value = 0;
  final Map<int, Widget> options = const <int, Widget>{
    0: Text('Students'),
    1: Text('Tutors'),
  };

  Widget buildSegmentedControl() {
    return Column(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8.0),
        ),
        SizedBox (
          width: 500,
          child: CupertinoSegmentedControl<int>(
            borderColor: Theme.of(context).hintColor,
            selectedColor: Theme.of(context).primaryColorDark,
            pressedColor: Theme.of(context).primaryColorLight,
            unselectedColor: Theme.of(context).accentColor,
            children: options,
            onValueChanged: (int val) {
              setState(() {
                value = val;
              });
            },
            groupValue: value,
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
        ),
        Expanded (
          child: Container (
            child: buildChatList(1-value),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Dashboard.title = 'TutorED';
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          Container(
            child: buildSegmentedControl(),
          ),
        ],
      ),
    );
  }
}
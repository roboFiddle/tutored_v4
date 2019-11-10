import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'conversation.dart';
import 'dashboard.dart';

class Profile extends StatefulWidget {
  final DocumentSnapshot document;
  Profile({Key key, this.document}) : super(key: key);
  @override
  ProfileState createState() => new ProfileState();
}

class ProfileState extends State<Profile> {
  SharedPreferences prefs;
  String name = '';
  String photoUrl = '';
  String email = '';
  String aboutMe = '';
  String id = '';
  String contact = '';
  String englishState = 'NI';
  String mathState = 'NI';
  String historyState = 'NI';
  String languageState = 'NI';
  String scienceState = 'NI';
  String selectedLanguage = "NA";
  int role = 0;
  int grade = 0;
  bool monday=false, tuesday=false, wednesday=false, thursday=false, friday=false, saturday=false, sunday=false;

  @override
  void initState() {
    super.initState();
    _readLocal();
  }
  void _readLocal() async {
    prefs = await SharedPreferences.getInstance();
    if (widget.document == null) {
      prefs = await SharedPreferences.getInstance();
      name = prefs.getString('name') ?? '';
      photoUrl = prefs.getString('photoUrl') ?? '';
      email = prefs.getString('email') ?? '';
      id = prefs.getString('id') ?? '';
      role = prefs.getInt('role') ?? 0;
      grade = prefs.getInt('grade') ?? 0;
      aboutMe = prefs.getString('aboutMe') ?? '';
      contact = prefs.getString('contact') ?? '';
      monday = prefs.getBool('monday') ?? true;
      tuesday = prefs.getBool('tuesday') ?? true;
      wednesday = prefs.getBool('wednesday') ?? true;
      thursday = prefs.getBool('thursday') ?? true;
      friday = prefs.getBool('friday') ?? true;
      saturday = prefs.getBool('saturday') ?? true;
      sunday = prefs.getBool('sunday') ?? true;
      englishState = prefs.getString('englishState') ?? 'NI';
      mathState = prefs.getString('mathState') ?? 'NI';
      historyState = prefs.getString('historyState') ?? 'NI';
      languageState = prefs.getString('languageState') ?? 'NI';
      scienceState = prefs.getString('scienceState') ?? 'NI';
      selectedLanguage = prefs.getString('selectedLanguage') ?? 'NA';
    } else {
      name = widget.document['name'] ?? '';
      photoUrl = widget.document['photoUrl'] ?? '';
      email = widget.document['email'] ?? '';
      id = widget.document['id'] ?? '';
      role = widget.document['role'] ?? '';
      grade = widget.document['grade'] ?? 0;
      aboutMe = widget.document['aboutMe'] ?? '';

      name = widget.document['name'] ?? '';
      photoUrl = widget.document['photoUrl'] ?? '';
      email = widget.document['email'] ?? '';
      id = widget.document['id'] ?? '';
      role = widget.document['role'] ?? 0;
      grade = widget.document['grade'] ?? 0;
      aboutMe = widget.document['aboutMe'] ?? '';
      contact = widget.document['contact'] ?? '';
      monday = widget.document['monday'] ?? true;
      tuesday = widget.document['tuesday'] ?? true;
      wednesday = widget.document['wednesday'] ?? true;
      thursday = widget.document['thursday'] ?? true;
      friday = widget.document['friday'] ?? true;
      saturday = widget.document['saturday'] ?? true;
      sunday = widget.document['sunday'] ?? true;
      englishState = widget.document['englishState'] ?? 'NI';
      mathState = widget.document['mathState'] ?? 'NI';
      historyState = widget.document['historyState'] ?? 'NI';
      languageState = widget.document['languageState'] ?? 'NI';
      scienceState = widget.document['scienceState'] ?? 'NI';
      selectedLanguage = widget.document['selectedLanguage'] ?? 'NA';
    }
    Dashboard.title = email.split('@')[0];
    setState(() {});
  }
  Future navigateToConversation(context, DocumentSnapshot document) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Conversation(document: document,)));
  }
  String requests() {
    List<String> avail = new List<String>();
    if(englishState == "TT")
      avail.add("English");
    if(mathState == "TT")
      avail.add("Math");
    if(historyState == "TT")
      avail.add("History");
    if(languageState == "TT") {
      switch(selectedLanguage) {
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
    if(scienceState == "TT")
      avail.add("Science");
    return avail.join(", ");
  }
  String offers() {
    List<String> avail = new List<String>();
    if(englishState == "WT")
      avail.add("English");
    if(mathState == "WT")
      avail.add("Math");
    if(historyState == "WT")
      avail.add("History");
    if(languageState == "WT") {
      switch(selectedLanguage) {
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
    if(scienceState == "WT")
      avail.add("Science");
    return avail.join(", ");
  }
  String days() {
    List<String> avail = new List<String>();
    if(monday)
      avail.add("Monday");
    if(tuesday)
      avail.add("Tuesday");
    if(wednesday)
      avail.add("Wednesday");
    if(thursday)
      avail.add("Thursday");
    if(friday)
      avail.add("Friday");
    if(saturday)
      avail.add("Saturday");
    if(sunday)
      avail.add("Sunday");
    return avail.join(", ");
  }
  @override
  Widget build(BuildContext context) {
    _readLocal();
    Container profile =  new Container (
      decoration: BoxDecoration(color: Colors.transparent),
      child: Align (
        child: Container (
          alignment: Alignment(0,0),
          decoration: new BoxDecoration(color: Colors.white),
          child: ListView(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            children: <Widget>[
              // picture
              photoUrl != '' ? Container(
                alignment: Alignment(0.0,-0.9),
                child: Material(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).errorColor),
                      ),
                      width: 90.0,
                      height: 90.0,
                      padding: EdgeInsets.all(20.0),
                    ),
                    imageUrl: photoUrl,
                    width: 90.0,
                    height: 90.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(45.0)),
                  clipBehavior: Clip.hardEdge,
                ),
                padding: EdgeInsets.fromLTRB(0, 15, 0, 20),
              ) : Container(),

              Center (
                child: Text(
                  name,
                  style: new TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontSize: 32,
                  ),
                ),
              ),
              Padding (
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              ),

              // email
              Center(
                child: Text(
                  email,
                  style: new TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding (
                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              ),

              // grade
              Center(
                child: Text(
                  'Grade ' + grade.toString(),
                  style: new TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontSize: 15,
                  ),
                ),
              ),
              Padding (
                padding: EdgeInsets.fromLTRB(0, 5, 0, 30),
              ),

              // about me
              Center(
                child: Text(
                  aboutMe,
                  style: new TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontSize: 18,
                  ),
                ),
              ),
              Padding (
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              ),
              Row(
                children: <Widget>[
                  Text(
                    "Contact:",
                    style: new TextStyle(
                      color: Theme.of(context).textSelectionColor,
                      fontSize: 18,
                    )
                  ),
                  SizedBox(width: 12.0),
                  SizedBox(
                    width: 250,
                    child: Text(
                      contact,
                      style: new TextStyle(
                        color: Theme.of(context).textSelectionColor,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
              Padding (
                padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
              ),
              Text(
                "Classes Requesting Tutoring: " + requests(),
                style: new TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 18,
                ),
              ),
              Padding (
                padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
              ),
              Text(
                "Classes Offering Tutoring: " + offers(),
                style: new TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 18,
                ),
              ),
              Padding (
                padding: EdgeInsets.fromLTRB(0, 0, 0, 15),
              ),
              Text(
                "Days Available: " + days(),
                style: new TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 18,
                ),
              )
            ],
          ),
        )
      )
    );
    if (widget.document == null) {
      return profile;
    } else {
      return new Scaffold (
        appBar: PreferredSize (
          preferredSize: Size.fromHeight(50),
          child: AppBar (
            title: new Text(
              name,
              style: new TextStyle(
                color: const Color(0xFFFFFFFF),
                fontSize: 30.0,
              ),
            ),

            actions: <Widget>[

            ],
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
        body: profile,
      );
    }
  }
}
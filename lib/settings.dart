import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => new SettingsState();
}

class SettingsState extends State<Settings> {
  final TextEditingController _gradeController = new TextEditingController();
  final TextEditingController _aboutMeController = new TextEditingController();
  final TextEditingController _contactController = new TextEditingController();
  SharedPreferences prefs;
  String name = '';
  String id = '';
  int grade = 0;
  String aboutMe = '';
  String contactText = '';
  String photoUrl = '';
  String englishState = 'NI';
  String mathState = 'NI';
  String historyState = 'NI';
  String languageState = 'NI';
  String scienceState = 'NI';
  String selectedLanguage = "NA";
  bool monday = true;
  bool tuesday = true;
  bool wednesday = true;
  bool thursday = true;
  bool friday = true;
  bool saturday = true;
  bool sunday = true;
  @override
  void initState() {
    super.initState();
    _readLocal();
  }
  void _readLocal() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? '';
    id = prefs.getString('id') ?? '';
    grade = prefs.getInt('grade') ?? 0;
    aboutMe = prefs.getString('aboutMe') ?? '';
    contactText = prefs.getString('contact') ?? '';
    photoUrl = prefs.getString('photoUrl') ?? '';
    englishState = prefs.getString('englishState') ?? 'NI';
    mathState = prefs.getString('mathState') ?? 'NI';
    historyState = prefs.getString('historyState') ?? 'NI';
    languageState = prefs.getString('languageState') ?? 'NI';
    scienceState = prefs.getString('scienceState') ?? 'NI';
    selectedLanguage = prefs.getString('selectedLanguage') ?? 'NA';
    monday = prefs.getBool("monday") ?? true;
    tuesday = prefs.getBool("tuesday") ?? true;
    wednesday = prefs.getBool("wednesday") ?? true;
    thursday = prefs.getBool("thursday") ?? true;
    friday = prefs.getBool("friday") ?? true;
    saturday = prefs.getBool("saturday") ?? true;
    sunday = prefs.getBool("sunday") ?? true;
    _gradeController.text = grade.toString();
    _aboutMeController.text = aboutMe;
    _contactController.text = contactText;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize (
        preferredSize: Size.fromHeight(50),
        child: AppBar (
          title: new Text(
            'Settings',
            style: new TextStyle(
              color: const Color(0xFFFFFFFF),
              fontSize: 30.0,
            ),
          ),
          actions: <Widget>[
            IconButton (
              icon: Icon(Icons.save),
              tooltip: 'Save',
              onPressed: () {
                setState(() {
                  Firestore.instance
                      .collection('users')
                      .document(id)
                      .updateData({
                        'aboutMe': _aboutMeController.text,
                        'contact': _contactController.text,
                        'grade': int.parse(_gradeController.text),
                        'englishState': englishState,
                        'mathState': mathState,
                        'historyState': historyState,
                        'languageState': languageState,
                        'scienceState': scienceState,
                        'selectedLanguage': selectedLanguage,
                        'monday': monday,
                        'tuesday': tuesday,
                        'wednesday': wednesday,
                        'thursday': thursday,
                        'friday': friday,
                        'saturday': saturday,
                        'sunday': sunday,
                      }).then((data) async {
                    await prefs.setString('aboutMe', _aboutMeController.text);
                    await prefs.setString('contact', _contactController.text);
                    await prefs.setInt('grade', int.parse(_gradeController.text));
                    await prefs.setString('englishState', englishState);
                    await prefs.setString('mathState', mathState);
                    await prefs.setString('historyState', historyState);
                    await prefs.setString('languageState', languageState);
                    await prefs.setString('scienceState', scienceState);
                    await prefs.setString('selectedLanguage', selectedLanguage);
                    await prefs.setBool("monday", monday);
                    await prefs.setBool("tuesday", tuesday);
                    await prefs.setBool("wednesday", wednesday);
                    await prefs.setBool("thursday", thursday);
                    await prefs.setBool("friday", friday);
                    await prefs.setBool("saturday", saturday);
                    await prefs.setBool("sunday", sunday);

                  });
                  Navigator.of(context).pushReplacementNamed('/dashboard');
                });
              },
            )
          ],
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
      body: ListView(
        children: <Widget>[
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
                imageUrl: prefs.getString('photoUrl'),
                width: 90.0,
                height: 90.0,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(45.0)),
              clipBehavior: Clip.hardEdge,
            ),
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          ) : Container(),

          Center (
            child: Text(
              name,
              style: new TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 24,
              ),
            ),
          ),

          Padding (
            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
          ),
          // grade
          Container(
            child: Row (
              children: <Widget>[
                Text (
                  'Grade:   ',
                  style: new TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox (
                  width: 30,
                  child: TextFormField(
                    controller: _gradeController,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          ),
          Container(
            child: Row (
              children: <Widget>[
                Text (
                  'About Me:   ',
                  style: new TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox (
                  width: 250,
                  child: TextFormField(
                    controller: _aboutMeController,
                    minLines: 2,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintMaxLines: 2,
                        hintText: 'Use this field to describe the tutoring you are seeking/giving.'
                    ),
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 50),
          ),
          Container(
            child: Row (
              children: <Widget>[
                Text (
                  'Contact Info:   ',
                  style: new TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox (
                  width: 250,
                  child: TextFormField(
                    controller: _contactController,
                    minLines: 2,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintMaxLines: 2,
                        hintText: 'How should a student/tutor contact you?'
                    ),
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 50),
          ),
          Center(
            child: Text(
              "Choose Classes",
              style: new TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 30,
              ),
            ),
          ),
          Container(
              child: Row (
                children: <Widget>[
                  Text (
                    'English:   ',
                    style: new TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  DropdownButton<String>(
                      value: englishState,
                      icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      onChanged: (String newValue) {
                        setState(() {
                          englishState = newValue;
                        });
                      },
                      items: [
                        DropdownMenuItem<String>(value: "NI", child: Text("Not Interested")),
                        DropdownMenuItem<String>(value: "TT", child: Text("Requesting to be Tutored")),
                        DropdownMenuItem<String>(value: "WT", child: Text("Able to Tutor")),
                      ]
                    ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          ),
                    Container(
            child: Row (
              children: <Widget>[
                Text (
                  'Foreign Language:   ',
                  style: new TextStyle(
                    fontSize: 18,
                  ),
                ),
                DropdownButton<String>(
                    value: languageState,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String newValue) {
                      setState(() {
                        languageState = newValue;
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(value: "NI", child: Text("Not Interested")),
                      DropdownMenuItem<String>(value: "TT", child: Text("Requesting to be Tutored")),
                      DropdownMenuItem<String>(value: "WT", child: Text("Able to Tutor")),
                    ]
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          ),
          Container(
            child: Row (
              children: <Widget>[
                Text (
                  'Language:   ',
                  style: new TextStyle(
                    fontSize: 18,
                  ),
                ),
                DropdownButton<String>(
                    value: selectedLanguage,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String newValue) {
                      setState(() {
                        selectedLanguage = newValue;
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(value: "NA", child: Text("Select a Language")),
                      DropdownMenuItem<String>(value: "SP", child: Text("Spanish")),
                      DropdownMenuItem<String>(value: "FR", child: Text("French")),
                      DropdownMenuItem<String>(value: "CH", child: Text("Chinese")),
                      DropdownMenuItem<String>(value: "IT", child: Text("Italian")),
                      DropdownMenuItem<String>(value: "LA", child: Text("Latin")),
                    ]
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(50, 0, 20, 0),
          ),
          Container(
            child: Row (
              children: <Widget>[
                Text (
                  'History:   ',
                  style: new TextStyle(
                    fontSize: 18,
                  ),
                ),
                DropdownButton<String>(
                    value: historyState,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String newValue) {
                      setState(() {
                        historyState = newValue;
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(value: "NI", child: Text("Not Interested")),
                      DropdownMenuItem<String>(value: "TT", child: Text("Requesting to be Tutored")),
                      DropdownMenuItem<String>(value: "WT", child: Text("Able to Tutor")),
                    ]
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          ),

          Container(
            child: Row (
              children: <Widget>[
                Text (
                  'Mathematics:   ',
                  style: new TextStyle(
                    fontSize: 18,
                  ),
                ),
                DropdownButton<String>(
                    value: mathState,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String newValue) {
                      setState(() {
                        mathState = newValue;
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(value: "NI", child: Text("Not Interested")),
                      DropdownMenuItem<String>(value: "TT", child: Text("Requesting to be Tutored")),
                      DropdownMenuItem<String>(value: "WT", child: Text("Able to Tutor")),
                    ]
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          ),
          Container(
            child: Row (
              children: <Widget>[
                Text (
                  'Science:   ',
                  style: new TextStyle(
                    fontSize: 18,
                  ),
                ),
                DropdownButton<String>(
                    value: scienceState,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    onChanged: (String newValue) {
                      setState(() {
                        scienceState = newValue;
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(value: "NI", child: Text("Not Interested")),
                      DropdownMenuItem<String>(value: "TT", child: Text("Requesting to be Tutored")),
                      DropdownMenuItem<String>(value: "WT", child: Text("Able to Tutor")),
                    ]
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          ),
          Center(
            child: Text(
              "Choose Days",
              style: new TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 30,
              ),
            ),
          ),
          Container(
            child: Row (
              children: <Widget>[
                Text (
                  'Monday:   ',
                  style: new TextStyle(
                    fontSize: 18,
                  ),
                ),
                Switch(
                  value: monday,
                  onChanged: (value) {
                    setState(() {
                      monday = value;
                    });
                  },
                  activeTrackColor: Colors.lightBlueAccent,
                  activeColor: Colors.blue,
                ),
              ]
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          ),
          Container(
            child: Row (
                children: <Widget>[
                  Text (
                    'Tuesday:   ',
                    style: new TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Switch(
                    value: tuesday,
                    onChanged: (value) {
                      setState(() {
                        tuesday = value;
                      });
                    },
                    activeTrackColor: Colors.lightBlueAccent,
                    activeColor: Colors.blue,
                  ),
                ]
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          ),
          Container(
            child: Row (
                children: <Widget>[
                  Text (
                    'Wednesday:   ',
                    style: new TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Switch(
                    value: wednesday,
                    onChanged: (value) {
                      setState(() {
                        wednesday = value;
                      });
                    },
                    activeTrackColor: Colors.lightBlueAccent,
                    activeColor: Colors.blue,
                  ),
                ]
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          ),
          Container(
            child: Row (
                children: <Widget>[
                  Text (
                    'Thursday:   ',
                    style: new TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Switch(
                    value: thursday,
                    onChanged: (value) {
                      setState(() {
                        thursday = value;
                      });
                    },
                    activeTrackColor: Colors.lightBlueAccent,
                    activeColor: Colors.blue,
                  ),
                ]
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          ),
          Container(
            child: Row (
                children: <Widget>[
                  Text (
                    'Friday:   ',
                    style: new TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Switch(
                    value: friday,
                    onChanged: (value) {
                      setState(() {
                        friday = value;
                      });
                    },
                    activeTrackColor: Colors.lightBlueAccent,
                    activeColor: Colors.blue,
                  ),
                ]
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          ),
          Container(
            child: Row (
                children: <Widget>[
                  Text (
                    'Saturday:   ',
                    style: new TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Switch(
                    value: saturday,
                    onChanged: (value) {
                      setState(() {
                        saturday = value;
                      });
                    },
                    activeTrackColor: Colors.lightBlueAccent,
                    activeColor: Colors.blue,
                  ),
                ]
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          ),
          Container(
            child: Row (
                children: <Widget>[
                  Text (
                    'Sunday:   ',
                    style: new TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Switch(
                    value: sunday,
                    onChanged: (value) {
                      setState(() {
                        sunday = value;
                      });
                    },
                    activeTrackColor: Colors.lightBlueAccent,
                    activeColor: Colors.blue,
                  ),
                ]
            ),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          ),
        ],
      ),
    );
  }
}

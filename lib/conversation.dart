import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';

class Conversation extends StatefulWidget {
  final DocumentSnapshot document;
  Conversation({Key key, this.document}) : super(key: key);
  @override
  ConversationState createState() => new ConversationState();
}

class ConversationState extends State<Conversation> {
  final TextEditingController textEditingController = new TextEditingController();
  SharedPreferences prefs;
  String name = '';
  @override
  void initState() {
    super.initState();
    _readLocal();
  }
  void _readLocal() async {
    prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ?? '';
    Dashboard.title = 'TutorED';
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize (
        preferredSize: Size.fromHeight(50),
        child: AppBar (
          title: new Text(
            widget.document['name'],
            style: new TextStyle(
              color: const Color(0xFFFFFFFF),
              fontSize: 30.0,
            ),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container (
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      child: TextField(
                        autofocus: true,
                        cursorColor: Theme.of(context).textSelectionColor,
                        style: TextStyle(color: Theme.of(context).textSelectionColor, fontSize: 15.0),
                        controller: textEditingController,
                        decoration: InputDecoration.collapsed (
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(color: Theme.of(context).hintColor),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    child: new Container(
                      margin: new EdgeInsets.symmetric(horizontal: 8),
                      child: new IconButton(
                        icon: new Icon(Icons.send),
                        iconSize: 20,
                        onPressed: () => print(textEditingController.text),
                        color: Theme.of(context).textSelectionColor,
                      ),
                    ),
                    color: Colors.white,
                  ),
                ],
              ),
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(10,0,10,0),
              height: 40.0,
              decoration: new BoxDecoration(
              border: new Border(top: new BorderSide(color: Color(0xffE8E8E8), width: 0.5)), color: Colors.white),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget> [
            new UserAccountsDrawerHeader (
              accountName: new Text(
                widget.document['name'],
                style: new TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 15.0,
                ),
              ),
              accountEmail: new Text(
                widget.document['email'],
                style: new TextStyle(
                  color: Theme.of(context).textSelectionColor,
                  fontSize: 15.0,
                ),
              ),
              currentAccountPicture: Material(
                child: CachedNetworkImage(
                  /* placeholder: Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).errorColor),
                    ),
                    width: 50.0,
                    height: 50.0,
                    padding: EdgeInsets.all(15.0),
                  ), */
                  imageUrl: widget.document['photoUrl'],
                  width: 50.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
                clipBehavior: Clip.hardEdge,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
              ),
            ),
            ListTile(
              title: new Text(
                'tile 1',
                style: new TextStyle(
                  color: Theme.of(context).textSelectionColor,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: new Text(
                'tile 2',
                style: new TextStyle(
                  color: Theme.of(context).textSelectionColor,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

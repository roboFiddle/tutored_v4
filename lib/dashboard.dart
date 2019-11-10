import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';
import 'profile.dart';
import 'home.dart';
import 'chat.dart';
import 'settings.dart';

class Dashboard extends StatefulWidget {
  static String title = 'TutorED';
  @override
  DashboardState createState() => new DashboardState();
}

class DashboardState extends State<Dashboard> {
  var auth = new Authentication();
  PageController _pageController;
  int _page = 1;
  @override
  void initState() {
    super.initState();
    _pageController = new PageController(
      initialPage: 1,
    );
  }
  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
  void navigationTapped(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
  }
  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  void onItemMenuPress(Choice item) {
    if (item.title == 'Log out') {
      auth.signOut(context);
    } else if (item.title == 'Settings') {
      Navigator.of(context).pushReplacementNamed('/settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Scaffold (
        backgroundColor: Colors.transparent,
        appBar: PreferredSize (
          preferredSize: Size.fromHeight(50),
          child: AppBar (
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: new Text (
              Dashboard.title,
              style: new TextStyle(
                color: Colors.white,
                fontSize: 30.0,
              ),
            ),
            actions: <Widget>[
              PopupMenuButton<Choice>(
                icon: Icon(Icons.menu, color: Colors.white),
                onSelected: onItemMenuPress,
                itemBuilder: (BuildContext context) {
                  return const <Choice>[
                    const Choice(title: 'Settings', icon: Icons.settings),
                    const Choice(title: 'Log out', icon: Icons.exit_to_app),
                  ].map((Choice choice) {
                    return PopupMenuItem<Choice>(
                      value: choice,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            choice.icon,
                            color: Colors.black,
                          ),
                          Container(
                            width: 10.0,
                          ),
                          Text(
                            choice.title,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ));
                  }).toList();
                },
              ),
            ],
          ),
        ),
        body: new PageView(
          children: [
            new Chat(),
            new Home(),
            new Profile(document: null),
          ],
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
        ),

        bottomNavigationBar: new Theme(
          data: Theme.of(context).copyWith(
            bottomAppBarColor: Colors.transparent,
            canvasColor: Theme.of(context).primaryColor,
          ),
          child: new BottomNavigationBar(
            onTap: navigationTapped,
            currentIndex: _page,
            items: [
              new BottomNavigationBarItem(
                icon: new Icon(
                  Icons.chat_bubble,
                  color: Theme.of(context).accentColor,
                ),
                title: new Text(
                  'Requests',
                  style: new TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              new BottomNavigationBarItem(
                icon: new Icon(
                  Icons.home,
                  color: Theme.of(context).accentColor,
                ),
                title: new Text(
                  'Home',
                  style: new TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
              new BottomNavigationBarItem(
                icon: new Icon(
                  Icons.person,
                  color: Theme.of(context).accentColor,
                ),
                title: new Text(
                  'Profile',
                  style: new TextStyle(
                    color: Theme.of(context).accentColor,
                  ),
                )
              ),
            ],
          ),
        )
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});
  final String title;
  final IconData icon;
}
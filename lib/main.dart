import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'settings.dart';
import 'login.dart';
import 'form.dart';


void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'TutorED',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primaryColorLight: const Color(0xFFDCF3EF),
        primaryColorDark: const Color(0xFF167F67),
        primaryColor: const Color(0xFF1853a5),
        accentColor: Colors.white,
        errorColor: const Color(0xFFFFAD32),
        textSelectionColor: const Color(0xFF382618),
        hintColor: const Color(0xFFAEAEAE),
        bottomAppBarColor: Colors.transparent,
        fontFamily: 'Lato'
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => new Login(),
        '/dashboard': (_) => new Dashboard(),
        '/user': (_) => new User(),
        '/form': (_) => new TutorForm(),
        '/settings': (_) => new Settings(),
      },
    );
  }
}
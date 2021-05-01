import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:thing_timer/common.dart';
import 'package:thing_timer/occupation/occupations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return InfoScreen(info: "Firebase bağlantısı kurulamadı.");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Occupations();
          }
          return InfoScreen(info: "Firebase bağlantısı kuruluyor.");
        },
      ),
    );
  }

  Future<FirebaseApp> _initializeFirebase() async {
    var app = await Firebase.initializeApp();
    return app;
  }
}

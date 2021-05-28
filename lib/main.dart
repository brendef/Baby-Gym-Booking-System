import 'package:babygym/ui/screens/home.dart';
import 'package:babygym/ui/screens/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

// ignore: must_be_immutable
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
  User? user = FirebaseAuth.instance.currentUser;
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Baby Gym',
      home: widget.user != null ? Home() : Splash(),
    );
  }
}

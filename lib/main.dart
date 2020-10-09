import 'package:flutter/material.dart';
import 'package:note_keeper/screens/home_screen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note Keeper',
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.redAccent
      ),
      home: HomePage(),
    );
  }
}

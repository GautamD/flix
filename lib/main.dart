import 'package:flix/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flix',
      theme: ThemeData(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.black,
          textTheme: TextTheme(bodyText2: TextStyle(color: Colors.white))),
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

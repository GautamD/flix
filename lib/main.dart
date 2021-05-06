import 'package:flix/home.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() {
  runApp(MyApp());
  OneSignal.shared.init('98179e03-9e39-4bb9-8213-941aa3267330');
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
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
        debugShowCheckedModeBanner: false);
  }
}

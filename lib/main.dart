import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fintechfilings/screens/splash.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'core/data/servicesList.dart';

Timer? timer;

Future<void> main() async {
  timer = Timer.periodic(
      Duration(minutes: 30), (Timer t) => ServiceList.refreshToken());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: EasyLoading.init(),
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Splash(),
    );
  }
}

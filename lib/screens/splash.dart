import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global/Shared/colors.dart';
import 'package:global/model/authorizationModelClass.dart';
import 'package:global/screens/auth/logInScreen.dart';
import 'package:global/screens/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home/mainScreen.dart';

class Splash extends StatefulWidget {
  Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage("assets/images/1.gif"))),
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder(
            future: Future.delayed(Duration(seconds: 6), () {
              getAuthorization();
            }),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(AppColors.kPrimaryColor),
                    ),
                    SizedBox(height: 8.0),
                    Text('Connecting server...',
                        style: TextStyle(color: Colors.white)),
                  ],
                );
              } else if (snapshot.hasData) {
                return Container(
                  width: 120.0,
                );
              } else {
                return Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(AppColors.kPrimaryColor),
                    ),
                    SizedBox(height: 8.0),
                    Text('Connecting server...',
                        style: TextStyle(color: Colors.white))
                  ],
                );
              }
            }),
      ),
    );
  }

  showPopup(errorMesage) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            title: Text(errorMesage),
          );
        });
  }

  getAuthorization() async {
    Dio dio = Dio();
    final response = await dio.post(
      'https://globalfinancialservices2.my.salesforce.com/services/oauth2/token?client_id=3MVG9fe4g9fhX0E5moFSMuVjXIILQdOycL_P4ZFUJ55.9fq8NiT1PoQIOLHr1c6iK1.sX9lGOzBfIgRNwSQoQ&client_secret=9EB92C337008E33EDD203D33ADC2879963F4AE63999B6F2B8D34300D61086444&username=dattagfs-m1gb@force.com&password=Gindu@1128&grant_type=password',
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.data);
      final result = new Map<String, dynamic>.from(response.data);
      List<AuthorizationModelClass> auth = [];
      auth.add(AuthorizationModelClass.fromJson(result));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(StorageValues.accessToken, auth[0].accessToken!);
      prefs.setString(StorageValues.instanceUrl, auth[0].instanceUrl!);
      if (prefs.getString(StorageValues.instanceUrl) != null &&
          prefs.getString(StorageValues.leadId) != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()),
            (route) => false);
      }

      return auth[0];
    } else {
      print(response.statusCode);
      debugPrint("Auth Failed");
      return null;
    }
  }
}

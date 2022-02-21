import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global/model/authorizationModelClass.dart';
import 'package:global/screens/auth/logInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceList {
  static Future<void> refreshToken() async {
    final dio = Dio();
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
    } else {
      print(response.statusCode);
      debugPrint("Auth Failed");
      return null;
    }
  }
}

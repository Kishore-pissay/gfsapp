import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global/screens/auth/logInScreen.dart';
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

//prod code
class ApiService {
  static Future sendDataValues(
      {required BuildContext context,
      String? businessName,
      String? fullName,
      String? mobileNo,
      String? email,
      String? regFor,
      String? businessActivity,
      String? personFullName,
      String? typeOfPerson,
      String? personMobile,
      String? personEmail,
      String? typeOfRegistration}) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        status: "Sending Data...",
        indicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ));
    try {
      final dio = Dio();
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      String? id = sharedPreferences.getString(StorageValues.leadId);
      String? instanceUrl =
          sharedPreferences.getString(StorageValues.instanceUrl);
      final response = await dio.post(
          //'$instanceUrl/services/apexrest/fluttergstregistration/GstReg?LeadId=$id&businessname=$businessName&regFor=$regFor&fullname=$fullName&mobileno=$mobileNo&emailid=$email&businessactivity=$businessActivity&typeofperson=$typeOfPerson&reqTyp=$typeOfRegistration&personfullname=$personFullName&personmobileno=$personMobile&personemailid=$personEmail',
          //"https://globalfinancialservices2.my.salesforce.com/services/apexrest/fluttergstregistration/GstReg?LeadId=$id&businessname=$businessName&regFor=$regFor&fullname=$fullName&mobileno=$mobileNo&emailid=$email&businessactivity=$businessActivity&typeofperson=$typeOfPerson&personfullname=$personFullName&personmobileno=$personMobile&personemailid=$personEmail",
          "$instanceUrl/services/apexrest/fluttergstregistration/GstReg?LeadId=$id&businessname=$businessName&regFor=$regFor&fullname=$fullName&mobileno=$mobileNo&emailid=$email&businessactivity=$businessActivity&typeofperson=$typeOfPerson&personfullname=$personFullName&personmobileno=$personMobile&personemailid=${personEmail ?? ''}",
          //data: {
          //  "businessname": businessName,
          //  "regFor": regFor,
          //  "fullname": fullName,
          //  "mobileno": mobileNo,
          //  "emailid": email,
          //  "businessactivity": businessActivity,
          //  "typeofperson": typeOfPerson,
          //  "personfullname": personFullName,
          //  "personmobileno": personMobile,
          //  "personemailid": personEmail,
          //},
          options: Options(headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'Bearer ${sharedPreferences.getString(StorageValues.accessToken)}',
            //"LeadId": id, // lead id
            //"Profession": regFor,

            //.selectedprofession, // sallary / bussiness radio button selection
            //"Type":
            // typeOfRegistration // type of registration = gst, udyami, pvt, prtf
          }));
      print(response.statusCode);
      print(response.data);
      //print(insta);
      //print(businessActivity);
      //print(businessName);
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        final result = jsonDecode(response.data);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Upload Successfull")));
        //debugPrint(result["gstRegId"]);
        //print(response.data);
        //print(result["gstRegId"]);
        return result["gstRegId"];
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(response.data)));
        //debugPrint("Auth Failed");
        return null;
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint(e.toString());
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
// sandbox testing

//class ApiService {
//  static Future sendDataValues(
//      {required BuildContext context,
//      String? businessName,
//      String? fullName,
//      String? mobileNo,
//      String? email,
//      String? regFor,
//      String? businessActivity,
//      String? personFullName,
//      String? typeOfPerson,
//      String? personMobile,
//      String? personEmail,
//      String? typeOfRegistration}) async {
//    EasyLoading.show(
//        maskType: EasyLoadingMaskType.black,
//        status: "Sending Data...",
//        indicator: CircularProgressIndicator(
//          valueColor: AlwaysStoppedAnimation(Colors.white),
//        ));
//    try {
//      final dio = Dio();
//      SharedPreferences sharedPreferences =
//          await SharedPreferences.getInstance();
//      String? id = '00Q0p0000026C8FEAU';
//      String? token =
//          '00D0p0000000O08!AQcAQEIIso1i62VA2H.lbdCMyu0_VCbbax076J70GdI7by.fIGqNbgU49WRG71iC42JGz5ITcDhyOX7X4OML5.0uaFUgJDTE';
//      //sharedPreferences.getString(StorageValues.leadId);
//      String? instanceUrl =
//          "https://globalfinancialservices2--devorg.my.salesforce.com";
//      //sharedPreferences.getString(StorageValues.instanceUrl);
//      final response = await dio.post(
//          "https://globalfinancialservices2--devorg.my.salesforce.com/services/apexrest/fluttergstregistration/GstReg?leadid=$id&businessname=$businessName&regfor=$regFor&fullname=$fullName&mobileno=$personMobile&emailid=$personEmail&businessactivity=$businessActivity&typeofperson=$typeOfPerson&reqTyp=$typeOfRegistration",
//          // data: {
//          //"leadid": id,
//          //"businessname": businessName,
//          //"regfor": regFor,
//          //"fullname": fullName,
//          //"mobileno": mobileNo,
//          //"emailid": email,
//          //"businessactivity": businessActivity,
//          //"typeofperson": typeOfPerson,
//          //"personfullname": personFullName,
//          //"personmobileno": personMobile,
//          //"personemailid": personEmail,
//          //"reqTyp": typeOfRegistration
//          // },
//          options: Options(headers: {
//            HttpHeaders.acceptHeader: 'application/json',
//            HttpHeaders.authorizationHeader: 'Bearer $token',
//
//            //"leadid": id, // lead id
//            //"Profession": regFor,
//
//            //.selectedprofession, // sallary / bussiness radio button selection
//            //"Type":
//            // typeOfRegistration // type of registration = gst, udyami, pvt, prtf
//          }));
//      //print(response.statusCode);
//      print("##########${response.statusCode}");
//      print("##########${response.data}");
//      EasyLoading.dismiss();
//      if (response.statusCode == 200) {
//        final result = jsonDecode(response.data);
//        ScaffoldMessenger.of(context)
//            .showSnackBar(SnackBar(content: Text("Upload Successfull")));
//        //debugPrint(result["gstrregId"]);
//        //print(response.data);
//        //print(result["gstrregId"]);
//        return result["gstrregId"];
//      } else {
//        ScaffoldMessenger.of(context)
//            .showSnackBar(SnackBar(content: Text("Upload failed")));
//
//        debugPrint("Auth Failed");
//        return null;
//      }
//    } catch (e) {
//      EasyLoading.dismiss();
//      ScaffoldMessenger.of(context)
//          .showSnackBar(SnackBar(content: Text("Upload failed")));
//    }
//  }
//}

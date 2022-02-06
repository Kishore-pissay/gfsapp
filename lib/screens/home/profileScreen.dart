import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global/Shared/customTextField.dart';
import 'package:global/Shared/customWidgets.dart';
import 'package:global/model/getUserDetailModelClass.dart';
import 'package:global/screens/auth/logInScreen.dart';
import 'dart:math' as math;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController aadharNoController = TextEditingController();
  TextEditingController panNoController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController gstNoController = TextEditingController();
  TextEditingController gstPasswordController = TextEditingController();
  TextEditingController gstUserNameController = TextEditingController();
  TextEditingController subscriptionPLanController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  Future<UserDetailsModel?> getUserDetails() async {
    String? accessToken;
    String? instanceUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(StorageValues.accessToken);
    instanceUrl = prefs.getString(StorageValues.instanceUrl);
    Dio dio = Dio();
    final response = await dio.get(
      "$instanceUrl/services/apexrest/flutteruserdetail/leadInfo?leadid=${prefs.getString(StorageValues.leadId)}",
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $accessToken'
          }),
    );
    print(response.statusCode);
    print(response.data);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.data);
      List<UserDetailsModel> userDetails = [];
      userDetails.add(UserDetailsModel.fromJson(result));
      if (userDetails[0].recordInfo != null) {
        print(userDetails[0].recordInfo);
        return userDetails[0];
      } else {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                  title: Text(userDetails[0].errorMsg.toString(),
                      textAlign: TextAlign.center));
            });
      }
    } else {
      print(response.statusCode);
      debugPrint("Fetching User Details Failed");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFE4FCFF),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: getUserDetails(),
              builder: (ctx, AsyncSnapshot<UserDetailsModel?> snap) {
                if (snap.hasData) {
                  final data = snap.data;
                  userNameController.text = data!.recordInfo!.lastName!;
                  userPasswordController.text = data.recordInfo!.passwordC!;
                  // aadharNoController.text = data.recordInfo!.aadharNumberC!;
                  // panNoController.text = data.recordInfo!.panNumberC!;
                  mobileNoController.text = data.recordInfo!.phone!;
                  emailController.text = data.recordInfo!.email!;
                  gstNoController.text =
                      data.gstInfo!.gstNum != null ? data.gstInfo!.gstNum! : '';
                  gstUserNameController.text =
                      data.gstInfo!.gstNum != null ? data.gstInfo!.gstNum! : '';
                  gstPasswordController.text =
                      data.gstInfo!.gstPsw != null ? data.gstInfo!.gstPsw! : '';
                  subscriptionPLanController.text =
                      data.gstInfo!.subscription != null
                          ? data.gstInfo!.subscription!
                          : '';
                  expiryDateController.text =
                      data.gstInfo!.planExpiryDate != null
                          ? data.gstInfo!.planExpiryDate!
                          : '';
                  statusController.text =
                      data.gstInfo!.status != null ? data.gstInfo!.status! : '';
                  return Padding(
                    padding: CustomWidgets.getPadding(size),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: size.width,
                          padding: EdgeInsets.all(10.0),
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(10.0),
                          //     color: Color(
                          //             (math.Random().nextDouble() * 0xFFFFFF)
                          //                 .toInt())
                          //         .withOpacity(0.2)),
                          child: Column(
                            children: [
                              Text('Personal Information',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 20.0),
                              ProfileFieldWidget(
                                  fieldName: 'UserName',
                                  hint: 'Enter Username',
                                  controller: userNameController),
                              ProfileFieldWidget(
                                  fieldName: 'Password',
                                  hint: 'Enter Password',
                                  controller: userPasswordController),
                              // ProfileFieldWidget(
                              //     fieldName: 'Aadhar No',
                              //     hint: 'Enter Aadhar No',
                              //     controller: aadharNoController),
                              // ProfileFieldWidget(
                              //     fieldName: 'Pan No',
                              //     hint: 'Enter Pan No',
                              //     controller: panNoController),
                              ProfileFieldWidget(
                                  fieldName: 'Mobile No',
                                  hint: 'Enter Mobile No',
                                  controller: mobileNoController),
                              ProfileFieldWidget(
                                  fieldName: 'Email Id',
                                  hint: 'Enter Email Id',
                                  controller: emailController),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          alignment: Alignment.center,
                          width: size.width,
                          padding: EdgeInsets.all(10.0),
                          // decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(10.0),
                          //     color: Color(
                          //             (math.Random().nextDouble() * 0xFFFFFF)
                          //                 .toInt())
                          //         .withOpacity(0.2)),
                          child: Column(
                            children: [
                              Text('GST Credentials',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 20.0),
                              ProfileFieldWidget(
                                  fieldName: 'GST No',
                                  hint: 'Enter GST No',
                                  controller: gstNoController),
                              ProfileFieldWidget(
                                  fieldName: 'UserName',
                                  hint: 'Enter Username',
                                  controller: gstUserNameController),
                              ProfileFieldWidget(
                                  fieldName: 'Password',
                                  hint: 'Enter Password',
                                  controller: gstPasswordController),
                              ProfileFieldWidget(
                                  fieldName: 'Subscription',
                                  hint: 'Enter Subscription',
                                  controller: subscriptionPLanController),
                              ProfileFieldWidget(
                                  fieldName: 'Expiry Date',
                                  hint: 'Enter Expiry Date',
                                  controller: expiryDateController),
                              ProfileFieldWidget(
                                  fieldName: 'Status',
                                  hint: 'Enter Status',
                                  controller: statusController),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SizedBox(
                      height: size.height / 1.5,
                      width: size.width,
                      child: Center(child: CircularProgressIndicator()));
                }
              }),
        ),
      ),
    );
  }
}

class ProfileFieldWidget extends StatelessWidget {
  final String fieldName;
  final String hint;

  const ProfileFieldWidget(
      {Key? key,
      required this.controller,
      required this.fieldName,
      required this.hint})
      : super(key: key);

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 100.0,
          child: Text(fieldName,
              textWidthBasis: TextWidthBasis.longestLine,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        ),
        SizedBox(width: 20.0),
        Expanded(
          // width: size.width / 2,
          child: CustomTextField(
              validateWith: Validator.nameValidator,
              hint: hint,
              readonly: true,
              controller: controller),
        ),
      ],
    );
  }
}

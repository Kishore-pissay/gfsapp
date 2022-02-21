import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global/Shared/customTextField.dart';
import 'package:global/Shared/customWidgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:global/screens/auth/forgotOtpScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotEmailScreen extends StatefulWidget {
  const ForgotEmailScreen({Key? key}) : super(key: key);

  @override
  _ForgotEmailScreenState createState() => _ForgotEmailScreenState();
}

class _ForgotEmailScreenState extends State<ForgotEmailScreen> {
  TextEditingController _emailController = TextEditingController();
  GlobalKey<FormState> _resetFormKey = GlobalKey<FormState>();

  Future<void> reset() async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        status: "Verifying...",
        indicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ));
    String? accessToken;
    String? instanceUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("accessToken");
    instanceUrl = prefs.getString("instanceUrl");
    Dio dio = Dio();
    final response = await dio.post(
      '$instanceUrl/services/apexrest/flutter/forgotpwd',
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
            'emailid': _emailController.text,
          }),
    );

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      final result = jsonDecode(response.data);
      final data = ResetModel.fromJson(result);
      if (data.recordId == "OTP has been sent to registered email address.") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ForgotOTPScreen(email: _emailController.text)));
      } else {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                  title: Text(data.recordId!, textAlign: TextAlign.center));
            });
      }
    } else {
      EasyLoading.dismiss();
      print(response.statusCode);
      debugPrint("Auth Failed");
      return null;
    }
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomWidgets.getAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/bg3.jpg'))),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.2),
              Text('Enter you email to reset your password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: size.height * 0.1),
              Form(
                key: _resetFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: CustomTextField(
                    validateWith: Validator.emailValidator,
                    hint: 'Enter your email',
                    readonly: false,
                    controller: _emailController),
              ),
              SizedBox(height: size.height * 0.05),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                CustomWidgets.getActionButton('Reset', 20.0, () {
                  if (FocusScope.of(context).hasFocus)
                    FocusScope.of(context).unfocus();
                  if (_resetFormKey.currentState!.validate()) {
                    reset();
                  } else {
                    print("fill the field");
                  }
                }),
                CustomWidgets.getActionButton('Cancel', 20.0, () {
                  Navigator.pop(context);
                })
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class ResetModel {
  int? respCode;
  String? recordId;
  String? errorMsg;

  ResetModel({this.respCode, this.recordId, this.errorMsg});

  ResetModel.fromJson(Map<String, dynamic> json) {
    respCode = json['respCode'];
    recordId = json['recordId'];
    errorMsg = json['errorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['respCode'] = this.respCode;
    data['recordId'] = this.recordId;
    data['errorMsg'] = this.errorMsg;
    return data;
  }
}

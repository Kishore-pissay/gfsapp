import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global/Shared/customTextField.dart';
import 'package:global/Shared/customWidgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../splashScreen.dart';
import 'forgotEmailScreen.dart';
import 'logInScreen.dart';

class ForgotOTPScreen extends StatefulWidget {
  final String email;
  const ForgotOTPScreen({Key? key, required this.email}) : super(key: key);

  @override
  _ForgotOTPScreenState createState() => _ForgotOTPScreenState();
}

class _ForgotOTPScreenState extends State<ForgotOTPScreen> {
  TextEditingController _otpController = new TextEditingController();
  TextEditingController _pController = new TextEditingController();
  TextEditingController _cpController = new TextEditingController();

  // Future<void> updatePassword() async {
  //   EasyLoading.show(
  //       maskType: EasyLoadingMaskType.black,
  //       status: "Verifying OTP...",
  //       indicator: CircularProgressIndicator(
  //         valueColor: AlwaysStoppedAnimation(Colors.white),
  //       ));
  //   String? accessToken;
  //   String? instanceUrl;
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   accessToken = prefs.getString(StorageValues.accessToken);
  //   instanceUrl = prefs.getString(StorageValues.instanceUrl);

  //   Dio dio = Dio();
  //   final response = await dio.post(
  //     '$instanceUrl/services/apexrest/flutter/forgototpvalidate',
  //     options: Options(
  //         followRedirects: false,
  //         validateStatus: (status) => true,
  //         headers: {
  //           HttpHeaders.acceptHeader: 'application/json',
  //           HttpHeaders.authorizationHeader: 'Bearer $accessToken',
  //           'emailid': widget.email,
  //           "otp": _otpController.text,
  //           'password': _pController.text,
  //         }),
  //   );
  //   if (response.statusCode == 200) {
  //     EasyLoading.dismiss();
  //     final result = jsonDecode(response.data);
  //     final data = ResetModel.fromJson(result);
  //     if (data.recordId == "OTP Validated successfully") {
  //       createLead();
  //     } else {
  //       EasyLoading.dismiss();
  //       return showDialog(
  //           context: context,
  //           builder: (ctx) {
  //             return AlertDialog(
  //                 title: Text(data.recordId!, textAlign: TextAlign.center));
  //           });
  //     }
  //   } else {
  //     EasyLoading.dismiss();
  //     print(response.statusCode);
  //     debugPrint("Auth Failed");
  //     return null;
  //   }
  // }

  Future<void> updatePassword() async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        status: "Creating Account...",
        indicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ));
    String? accessToken;
    String? instanceUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(StorageValues.accessToken);
    instanceUrl = prefs.getString(StorageValues.instanceUrl);

    Dio dio = Dio();
    final response = await dio.post(
      '$instanceUrl/services/apexrest/flutter/forgototpvalidate',
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
            'emailid': widget.email,
            'otp': _otpController.text,
            'password': _pController.text,
          }),
    );
    print(response.statusCode);
    print(response.data);
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      final result = jsonDecode(response.data);
      final data = ResetModel.fromJson(result);
      if (data.recordId!.isNotEmpty) {
        return showDialog(
            barrierDismissible: false,
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Column(
                  children: [
                    Text('Successfully password updated',
                        textAlign: TextAlign.center),
                    TextButton(
                        child: Text("Dismiss"),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SplashScreen()));
                        })
                  ],
                ),
              );
            });
      } else {
        EasyLoading.dismiss();
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
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomWidgets.getAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        //child: Container(
        //  height: size.height,
        //  width: size.width,
        //  decoration: BoxDecoration(
        //      image: DecorationImage(
        //          fit: BoxFit.cover,
        //          image: AssetImage('assets/images/WhiteBg.jpeg'))),
        //  padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SizedBox(height: size.height * 0.1),
            Text('OTP Screen',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w700)),
            SizedBox(height: 20.0),
            Text('Please enter your otp sent to ${widget.email}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500)),
            SizedBox(height: size.height * 0.1),
            Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                child: PinCodeTextField(
                  appContext: context,
                  // pastedTextStyle: TextStyle(
                  //   color: Colors.green.shade600,
                  //   fontWeight: FontWeight.bold,
                  // ),
                  length: 5,
                  obscureText: false,
                  obscuringCharacter: '*',
                  // obscuringWidget: FlutterLogo(
                  //   size: 24,
                  // ),
                  blinkWhenObscuring: true,
                  animationType: AnimationType.fade,
                  validator: (v) {
                    if (v!.length < 3) {
                      return "I'm from validator";
                    } else {
                      return null;
                    }
                  },
                  // pinTheme: PinTheme(
                  //   shape: PinCodeFieldShape.box,
                  //   borderRadius: BorderRadius.circular(5),
                  //   fieldHeight: 50,
                  //   fieldWidth: 40,
                  //   activeFillColor: Colors.white,
                  // ),
                  cursorColor: Colors.black,
                  animationDuration: Duration(milliseconds: 300),
                  enableActiveFill: true,
                  // errorAnimationController: errorController,
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  boxShadows: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      color: Colors.black12,
                      blurRadius: 10,
                    )
                  ],
                  onCompleted: (v) {
                    print("Completed");
                  },
                  // onTap: () {
                  //   print("Pressed");
                  // },
                  onChanged: (value) {
                    print(value);
                    // setState(() {
                    //   currentText = value;
                    // });
                  },
                  beforeTextPaste: (text) {
                    print("Allowing to paste $text");
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                )),
            if (_otpController.text.length == 5)
              Column(
                children: [
                  PasswordField(
                      //label: "Select Password",
                      validateWith: Validator.passWordValidator,
                      // hint: 'Enter password',
                      // readonly: false,
                      controller: _pController),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: PasswordField(
                        validateWith: Validator.passWordValidator,
                        //label: 'Confirm password',
                        // hint: 'Confirm password',
                        // readonly: false,
                        controller: _cpController),
                  ),
                ],
              ),
            if (_cpController.text.length > 0 &&
                _pController.text == _cpController.text)
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                CustomWidgets.getActionButton('Confirm', 20.0, () {
                  updatePassword();
                }),
                CustomWidgets.getActionButton('Cancel', 20.0, () {
                  Navigator.pop(context);
                })
              ])
          ],
        ),
      ),
    );
  }
}

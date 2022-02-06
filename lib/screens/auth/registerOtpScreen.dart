import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global/screens/auth/forgotEmailScreen.dart';
import 'package:global/screens/auth/logInScreen.dart';
import 'package:global/screens/splashScreen.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:global/Shared/customWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterOTPScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final String dob;
  final String password;
  final String address;
  final String city;
  final String postal;
  final String state;
  final String aadhar;
  final String pan;
  final List<String> services;
  final String? reference;
  final String occupation;
  const RegisterOTPScreen({
    Key? key,
    required this.name,
    required this.phone,
    required this.email,
    required this.dob,
    required this.password,
    required this.address,
    required this.city,
    required this.postal,
    required this.state,
    required this.aadhar,
    required this.pan,
    required this.services,
    this.reference,
    required this.occupation,
  }) : super(key: key);

  @override
  _RegisterOTPScreenState createState() => _RegisterOTPScreenState();
}

class _RegisterOTPScreenState extends State<RegisterOTPScreen> {
  TextEditingController _otpController = new TextEditingController();
  GlobalKey<FormState> _otpFormKey = GlobalKey<FormState>();

  EdgeInsetsGeometry getPadding(Size size) {
    if (size.width > 900) {
      return EdgeInsets.symmetric(horizontal: size.width * 0.3);
    } else if (size.width > 600 && size.width < 900) {
      return EdgeInsets.symmetric(horizontal: size.width * 0.2);
    } else {
      return EdgeInsets.symmetric(horizontal: size.width * 0.1);
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: CustomWidgets.getAppBar(),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: AssetImage('assets/images/wbacground.jpg'),
            )),
            padding: getPadding(size),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.15),
                Text('OTP Screen',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w500)),
                SizedBox(height: 20.0),
                Text(
                    'Please enter your otp to confirm OTP sent to ${widget.email}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500)),
                SizedBox(height: size.height * 0.1),
                Form(
                  key: _otpFormKey,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 30),
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
                ),
                SizedBox(height: 20.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomWidgets.getActionButton('Confirm', 20.0, () {
                        if (_otpController.text.length == 5) {
                          verifyOtp();
                        }
                      }),
                      CustomWidgets.getActionButton('Cancel', 20.0, () {
                        Navigator.pop(context);
                      })
                    ])
              ],
            ),
          ),
        ));
  }

  Future<void> verifyOtp() async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        status: "Verifying OTP...",
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
      '$instanceUrl/services/apexrest/flutter/validateotp',
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
            'emailid': widget.email,
            "otp": _otpController.text,
          }),
    );
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      final result = jsonDecode(response.data);
      final data = ResetModel.fromJson(result);
      if (data.recordId == "OTP Validated successfully") {
        createLead();
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

  Future<void> createLead() async {
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

    String service = widget.services.join(";");
    print(service);

    Dio dio = Dio();
    final response = await dio.post(
      '$instanceUrl/services/apexrest/flutter',
      data: {
        "LastName": widget.name,
        "Phone": widget.phone,
        "Email": widget.email,
        "DateOfBirth__c": widget.dob,
        "Password__c": widget.password,
        "City": widget.city,
        "State": widget.state,
        "PostalCode": widget.postal,
        "Pan_Number__c": widget.pan,
        "Aadhar_Number__c": widget.aadhar,
        "Services__c": service,
        "Refered_by__c": widget.reference,
        "Occupation__c": widget.occupation,
        "Company": "GlobalFinacialService"
      },
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
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
                    Text('Successfully account created',
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please Try Again')));
      return null;
    }
  }
}

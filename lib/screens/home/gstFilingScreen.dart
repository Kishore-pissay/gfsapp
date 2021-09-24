import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global/Shared/customTextField.dart';
import 'package:global/Shared/customWidgets.dart';
import 'dart:math' as math;
import 'dart:io' as Io;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:global/model/getUserDetailModelClass.dart';
import 'package:global/screens/auth/logInScreen.dart';
import 'package:global/screens/home/fileUploadResponse.dart';
import 'package:global/screens/home/payment/paymentScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../my_flutter_app_icons.dart';

class GSTFilingScreen extends StatefulWidget {
  const GSTFilingScreen({Key? key}) : super(key: key);

  @override
  _GSTFilingScreenState createState() => _GSTFilingScreenState();
}

class _GSTFilingScreenState extends State<GSTFilingScreen> {
  var initialize;
  TextEditingController _gstNoController = new TextEditingController();
  String? img64;
  ImagePicker picker = new ImagePicker();
  bool imagePicked = false;
  List imagelist = ['Camera', 'Media'];

  @override
  void initState() {
    initialize = getUserDetails();
    super.initState();
  }

  getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    Navigator.pop(context);
    setState(
      () {
        if (pickedFile != null) {
          final bytes = Io.File(pickedFile.path).readAsBytesSync();
          img64 = base64Encode(bytes);
          print(img64);
          imagePicked = true;
          getFileUpload(img64, "png");
        } else {
          print('No image selected.');
        }
      },
    );
  }

  Future modelBottomSheetCamera(BuildContext context) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () => getImage(ImageSource.camera),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 30,
                    ),
                    Text(
                      imagelist[0],
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => getImage(ImageSource.gallery),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      size: 30,
                    ),
                    Text(
                      imagelist[1],
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<FileUpload?> getFileUpload(base64Image, String filetype) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        status: "Uploading...",
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
      final response =
          await dio.post('$instanceUrl/services/apexrest/flutter/uploadfile',
              data: base64Image,
              options: Options(headers: {
                HttpHeaders.acceptHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'Bearer ${sharedPreferences.getString(StorageValues.accessToken)}',
                "parentid": id,
                "filename": StorageValues.gstReturns,
                "filetype": filetype
              }));
      print(response.data);
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        final result = jsonDecode(response.data);
        print(result['recordId']);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("File Uploaded")));
        print(result);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Upload failed")));
        debugPrint("Auth Failed");
        return null;
      }
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Upload failed")));
    }
  }

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
        setState(() {
          _gstNoController.text = userDetails[0].gstInfo!.gstNum ?? '';
        });
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
        appBar: CustomWidgets.getAppBar(),
        body: ListView(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              Text('GST Filing',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              SizedBox(width: 50)
            ],
          ),
          SizedBox(height: 20.0),
          Text('Prepare and upload your bills and vochers',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400)),
          SizedBox(height: 20.0),
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: Align(
          //     alignment: Alignment.centerLeft,
          //     child: Text('Entity Name: ',
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //             color: Colors.black,
          //             fontSize: 16.0,
          //             fontWeight: FontWeight.w500)),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Text('Name:  ',
                //         style: TextStyle(
                //             fontSize: 16, fontWeight: FontWeight.w500)),
                //     Expanded(
                //       child: CustomTextField(
                //           validateWith: Validator.nameValidator,
                //           hint: 'Entity Name',
                //           readonly: false,
                //           controller: _gstNoController),
                //     ),
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('GST No:  ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    Expanded(
                      child: CustomTextField(
                          validateWith: Validator.nameValidator,
                          hint: 'GST Number',
                          readonly: true,
                          controller: _gstNoController),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: size.height / 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              modelBottomSheetCamera(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              width: size.width / 2 - 36.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color((math.Random().nextDouble() *
                                              0xFFFFFF)
                                          .toInt())
                                      .withOpacity(0.2)),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(MyFlutterApp.add_a_photo),
                                    SizedBox(height: 10.0),
                                    Text('Upload Sales Invoices',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400))
                                  ]),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              modelBottomSheetCamera(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(16),
                              width: size.width / 2 - 36.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Color((math.Random().nextDouble() *
                                              0xFFFFFF)
                                          .toInt())
                                      .withOpacity(0.2)),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(MyFlutterApp.add_a_photo),
                                    SizedBox(height: 10.0),
                                    Text('Upload Purchase Invoices',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400))
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Under Development'),
                      ));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: size.width,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                  .toInt())
                              .withOpacity(0.2)),
                      child: Text('Create Sales Invoices',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                FutureBuilder(
                    future: initialize,
                    builder: (ctx, AsyncSnapshot<UserDetailsModel?> snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snap.hasData) {
                        UserDetailsModel data = snap.data!;
                        if (data.gstInfo!.subscription == null) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PaymentScreen()));
                            },
                            child: Container(
                                alignment: Alignment.center,
                                width: size.width,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Color((math.Random().nextDouble() *
                                                0xFFFFFF)
                                            .toInt())
                                        .withOpacity(0.2)),
                                child: Column(children: [
                                  Text('Subscribe',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500)),
                                ])),
                          );
                        } else {
                          return Text('');
                        }
                      } else {
                        return Text('');
                      }
                    }),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: SizedBox(
                //     height: size.height / 6,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Expanded(
                //           child: GestureDetector(
                //             onTap: () {
                //               ScaffoldMessenger.of(context)
                //                   .showSnackBar(SnackBar(
                //                 content: Text('Under Development'),
                //               ));
                //             },
                //             child: Container(
                //               padding: EdgeInsets.all(16),
                //               width: size.width / 2 - 36.0,
                //               decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(10.0),
                //                   color: Color((math.Random().nextDouble() *
                //                               0xFFFFFF)
                //                           .toInt())
                //                       .withOpacity(0.2)),
                //               child: Column(
                //                   mainAxisAlignment:
                //                       MainAxisAlignment.spaceAround,
                //                   children: [
                //                     RotationTransition(
                //                       turns:
                //                           new AlwaysStoppedAnimation(270 / 360),
                //                       child: Icon(Icons.arrow_back,
                //                           size: 30.0, color: Colors.black),
                //                     ),
                //                     SizedBox(height: 10.0),
                //                     Text('Create Credit Vochers/ Amt Recieved',
                //                         textAlign: TextAlign.center,
                //                         style: TextStyle(
                //                             color: Colors.black,
                //                             fontSize: 12.0,
                //                             fontWeight: FontWeight.w400))
                //                   ]),
                //             ),
                //           ),
                //         ),
                //         SizedBox(width: 20.0),
                //         Expanded(
                //           child: GestureDetector(
                //             onTap: () {
                //               ScaffoldMessenger.of(context)
                //                   .showSnackBar(SnackBar(
                //                 content: Text('Under Development'),
                //               ));
                //             },
                //             child: Container(
                //               padding: EdgeInsets.all(16),
                //               width: size.width / 2 - 36.0,
                //               decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(10.0),
                //                   color: Color((math.Random().nextDouble() *
                //                               0xFFFFFF)
                //                           .toInt())
                //                       .withOpacity(0.2)),
                //               child: Column(
                //                   mainAxisAlignment:
                //                       MainAxisAlignment.spaceAround,
                //                   children: [
                //                     RotationTransition(
                //                       turns:
                //                           new AlwaysStoppedAnimation(90 / 360),
                //                       child: Icon(Icons.arrow_back,
                //                           size: 30.0, color: Colors.black),
                //                     ),
                //                     SizedBox(height: 10.0),
                //                     Text('Create Debit Vochers/ Amt Paid',
                //                         textAlign: TextAlign.center,
                //                         style: TextStyle(
                //                             color: Colors.black,
                //                             fontSize: 12.0,
                //                             fontWeight: FontWeight.w400))
                //                   ]),
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                //       children: [
                //         CustomWidgets.getActionButton(
                //             'Submit', 10.0, 20.0, () {}),
                //         CustomWidgets.getActionButton('Cancel', 10.0, 20.0, () {
                //           Navigator.pop(context);
                //         })
                //       ]),
                // ),
                SizedBox(height: 40.0)
              ],
            ),
          ),
        ]));
  }
}

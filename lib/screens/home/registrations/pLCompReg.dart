import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global/Shared/customTextField.dart';
import 'package:global/Shared/customWidgets.dart';
import 'package:global/model/getUserDetailModelClass.dart';
import 'package:global/screens/apiservicessenddata.dart';
import 'package:global/screens/auth/logInScreen.dart';
import 'package:global/screens/home/fileUploadResponse.dart';
import 'package:global/screens/home/payment/paymentScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:io' as Io;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../my_flutter_app_icons.dart';

class PLCompRegistration extends StatefulWidget {
  const PLCompRegistration({Key? key}) : super(key: key);

  @override
  _PLCompRegistrationState createState() => _PLCompRegistrationState();
}

class _PLCompRegistrationState extends State<PLCompRegistration> {
  bool value = false;
  late bool isSubmited;
  String? recordId;
  String? selectedRegFor;
  TextEditingController _businessNameController = new TextEditingController();
  TextEditingController _businessMobileNumberController =
      new TextEditingController();
  TextEditingController _businesEmailIdController = new TextEditingController();
  TextEditingController _personFullNameController = new TextEditingController();
  TextEditingController _personMobileController = new TextEditingController();
  TextEditingController _personEmailController = new TextEditingController();
  TextEditingController _activityBusinessController =
      new TextEditingController();
  var initialize;
  @override
  void initState() {
    initialize = getUserDetails();
    isSubmited = false;
    super.initState();
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
        //setState(() {
        //   _gstNoController.text = userDetails[0].gstInfo!.gstNum ?? '';
        //});
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
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          child: Column(children: <Widget>[
            SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Flexible(
                    child: Text('Private Limited Company Registration',
                        //textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
                'Please fill all the fields & upload the list of documents required',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            SizedBox(height: 20),
            Text('Note: Long press on ⓘ to get additional information',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("*all the fields are mandatory",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500)),
                  SizedBox(height: 8.0),
                  CustomTextField(
                      hint: 'Company Name',
                      readonly: false,
                      controller: _businessNameController),
                  CustomTextField(
                      hint: 'Company Mobile Number',
                      readonly: false,
                      controller: _businessMobileNumberController),
                  CustomTextField(
                      hint: 'Company Email ID',
                      readonly: false,
                      controller: _businesEmailIdController),
                  CustomTextField(
                      hint: 'Activity of the Company',
                      readonly: false,
                      controller: _activityBusinessController),
                  SizedBox(height: 8.0),
                  Text("Enter Director Details",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500)),
                  SizedBox(height: 8.0),
                  CustomTextField(
                      hint: 'Director Full Name',
                      readonly: false,
                      controller: _personFullNameController),
                  CustomTextField(
                      hint: 'Director Mobile Number',
                      readonly: false,
                      controller: _personMobileController),
                  CustomTextField(
                      hint: 'Director Email ID',
                      readonly: false,
                      controller: _personEmailController),
                  SizedBox(height: 8.0),
                  CustomWidgets.getActionButton('Submit', 20.0, () async {
                    final response = await ApiService.sendDataValues(
                      context: context,
                      businessName: _businessNameController.text,
                      mobileNo: _businessMobileNumberController.text,
                      email: _businesEmailIdController.text,
                      personFullName: _personFullNameController.text,
                      personMobile: _personMobileController.text,
                      personEmail: _personEmailController.text,
                      businessActivity: _activityBusinessController.text,
                      regFor: 'Private Limited Company',
                      typeOfRegistration: 'PvtCompReg',
                      typeOfPerson: 'Business + Director',
                    );
                    print(response);
                    if (response != null) {
                      setState(() {
                        isSubmited = true;
                        recordId = response;
                      });
                    }
                  }),
                  SizedBox(height: 15.0),
                  if (isSubmited)
                    Column(
                      children: [
                        Text("*upload Company related documents",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),

                        SizedBox(height: 8.0),
                        PLCompRegistrationDocumentUploadWidget(
                            name: 'Company Pan Card',
                            filename: StorageValues.pvtLtdCompReg,
                            recID: recordId ?? ""),
                        SizedBox(height: 2.0),
                        PLCompRegistrationDocumentUploadWidget(
                            name: 'Company Incorporation Certificate',
                            filename: StorageValues.pvtLtdCompReg,
                            recID: recordId ?? ""),
                        SizedBox(height: 8.0),
                        PLCompRegistrationDocumentUploadWidget(
                            name: 'Memorandum of Associations (MoA)',
                            filename: StorageValues.pvtLtdCompReg,
                            recID: recordId ?? ""),
                        SizedBox(height: 8.0),
                        PLCompRegistrationDocumentUploadWidget(
                            name: 'Article of Associations (AoA)',
                            filename: StorageValues.pvtLtdCompReg,
                            recID: recordId ?? ""),
                        SizedBox(height: 8.0),
                        PLCompRegistrationDocumentUploadWidget(
                            name: 'Company Latest month electricity bill',
                            filename: StorageValues.pvtLtdCompReg,
                            recID: recordId ?? ""),
                        SizedBox(height: 8.0),
                        PLCompRegistrationDocumentUploadWidget(
                            name: 'Company Rental Deed - pdf',
                            info: 'for rented premises',
                            filename: StorageValues.pvtLtdCompReg,
                            recID: recordId ?? ""),
                        SizedBox(height: 8.0),
                        PLCompRegistrationDocumentUploadWidget(
                            name: 'Registered Company Address Proof',
                            filename: StorageValues.pvtLtdCompReg,
                            recID: recordId ?? ""),
                        SizedBox(height: 8.0),
                        PLCompRegistrationDocumentUploadWidget(
                            name: 'Board of Resolution document',
                            filename: StorageValues.pvtLtdCompReg,
                            recID: recordId ?? ""),

                        SizedBox(height: 8.0),
                        Text("*upload Director documents",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 8.0),
                        PLCompRegistrationDocumentUploadWidget(
                            name: 'Aadhar Card',
                            filename: StorageValues.pvtLtdCompReg,
                            recID: recordId ?? ""),
                        //SizedBox(height: 2.0),
                        PLCompRegistrationDocumentUploadWidget(
                            name: 'Pan Card',
                            filename: StorageValues.pvtLtdCompReg,
                            recID: recordId ?? ""),
                        //SizedBox(height: 2.0),
                        PLCompRegistrationDocumentUploadWidget(
                            name: 'Passport size photo',
                            filename: StorageValues.pvtLtdCompReg,
                            recID: recordId ?? ""),
                        //SizedBox(height: 2.0),
                        PLCompRegistrationDocumentUploadWidget(
                            name: 'Residential Address Proof',
                            filename: StorageValues.pvtLtdCompReg,
                            recID: recordId ?? ""),
                        //SizedBox(height: 20.0),
                        //CustomWidgets.getActionButton('+ Add Director', 15.0,
                        //    () {
                        //  //add partner repeat the above partnership firm list
                        //  Navigator.pop(context);
                        //}),
                      ],
                    ),
                  SizedBox(height: 30),
                  if (isSubmited)
                    Column(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //CustomWidgets.getActionButton(
                              //    'Proceed to Pay', 30.0, 15.0, () {}),
                              //CustomWidgets.getActionButton(
                              //    'Cancel', 30.0, 15.0, () {
                              //  Navigator.pop(context);
                              //}),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PaymentScreen(
                                              type: 'PvtCompReg',
                                              payfor:
                                                  'Private Limited Company Registration')));
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    width: size.width / 2,
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: Color(0xffef661a),
                                          width: 1.0,
                                        ),
                                        color: Color(
                                                (math.Random().nextDouble() *
                                                        0xFFFFFF)
                                                    .toInt())
                                            .withOpacity(0.2)),
                                    child: Column(children: [
                                      Text('Subscribe',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500)),
                                    ])),
                              )
                            ]),
                        SizedBox(height: 20),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    width: size.width / 2,
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(
                                          color: Color(0xffef661a),
                                          width: 1.0,
                                        ),
                                        color: Color(
                                                (math.Random().nextDouble() *
                                                        0xFFFFFF)
                                                    .toInt())
                                            .withOpacity(0.2)),
                                    child: Column(children: [
                                      Text('Cancel',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500)),
                                    ])),
                              )
                            ]),
                      ],
                    ),
                  SizedBox(height: 30),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class PLCompRegistrationDocumentUploadWidget extends StatefulWidget {
  final String name;
  final String? info;
  final String filename;
  final String? selectedprofession;
  final String? recID;
  const PLCompRegistrationDocumentUploadWidget(
      {Key? key,
      required this.name,
      this.info,
      required this.filename,
      this.selectedprofession,
      required this.recID})
      : super(key: key);

  @override
  _PLCompRegistrationDocumentUploadWidgetState createState() =>
      _PLCompRegistrationDocumentUploadWidgetState();
}

class _PLCompRegistrationDocumentUploadWidgetState
    extends State<PLCompRegistrationDocumentUploadWidget> {
  bool value = false;

  String? img64;
  ImagePicker picker = new ImagePicker();
  bool imagePicked = false;
  List imagelist = ['Camera', 'Media'];

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
      final response = await dio.post(
          '$instanceUrl/services/apexrest/fluttermediafiledetail/uploadFile?title=${widget.name}&pathOnClient=${widget.name + '.' + filetype}&leadId=$id&type=PartFirmReg&recordId=${widget.recID}&profession=${widget.selectedprofession}',
          data: base64Image,
          options: Options(headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'Bearer ${sharedPreferences.getString(StorageValues.accessToken)}',
            //"leadId": id, // lead id
            //"profession": widget
            //    .selectedprofession, // sallary / bussiness radio button selection
            //"title": widget.name, //file name_type of file
            //"type": 'PvtCompReg', // type of loan
            //"pathOnClient": widget.name + '.' + filetype,
            //"recordId": widget.recID
            //"filetype": filetype //image type (png/jpg)
          }));
      print(response.statusCode);
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        final result = jsonDecode(response.data);
        print(result);

        setState(() {
          value = true;
        });
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

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Row(
      children: <Widget>[
        Checkbox(
          value: this.value,
          onChanged: (bool? value) {},
        ),
        SizedBox(
          width: 10,
        ), //SizedBox
        SizedBox(
          width: size.width / 2,
          child: Text(
            '${widget.name}',
            style: TextStyle(fontSize: 17.0),
          ),
        ), //Text
        Spacer(),
        widget.info != null
            ? IconButton(
                icon: Icon(MyFlutterApp.info_outline),
                onPressed: null,
                tooltip: widget.info)
            : SizedBox(),
        IconButton(
            icon: Icon(Icons.upload),
            onPressed: () {
              modelBottomSheetCamera(context);
            })
      ],
    );
  }
}

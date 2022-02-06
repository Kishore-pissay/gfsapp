import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global/Shared/customWidgets.dart';
import 'package:global/screens/auth/logInScreen.dart';
import 'package:global/screens/home/fileUploadResponse.dart';
import 'package:global/screens/home/payment/paymentScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:html' as html;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enum_to_string/enum_to_string.dart';
import '../../../my_flutter_app_icons.dart';

enum SelectIDType { salaryBased, selfEmployed }

class AutoLoan extends StatefulWidget {
  const AutoLoan({Key? key}) : super(key: key);

  @override
  _AutoLoanState createState() => _AutoLoanState();
}

class _AutoLoanState extends State<AutoLoan> {
  SelectIDType? _character = SelectIDType.salaryBased;
  bool value = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomWidgets.getAppBar(),
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Text('Automobile Loan',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  SizedBox(width: 50)
                ],
              ),
              SizedBox(height: 20),
              Text('Documents required for both Salaried or Self-Employed',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              SizedBox(height: 20),
              Text('Note: Long press on ⓘ to get additional information',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
              SizedBox(height: 20),
              Padding(
                padding: CustomWidgets.getPadding(size),
                child: Column(
                  children: <Widget>[
                    AutoLoanDocumentUploadWidget(
                        name: 'Aadhar Card', filename: StorageValues.kyc),
                    AutoLoanDocumentUploadWidget(
                        name: 'Pan Card', filename: StorageValues.kyc),
                    AutoLoanDocumentUploadWidget(
                        name: 'Passport size Photo',
                        filename: StorageValues.autoLoanProposals),
                    AutoLoanDocumentUploadWidget(
                        name: 'Proforma Invoice',
                        filename: StorageValues.autoLoanProposals),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            // width: size.width / 2 - 20.0,
                            child: Row(children: [
                          Radio<SelectIDType>(
                            value: SelectIDType.salaryBased,
                            groupValue: _character,
                            onChanged: (SelectIDType? value) {
                              setState(() {
                                _character = value;
                                print(_character);
                              });
                            },
                          ),
                          const Text('Salary based'),
                        ])),
                        Expanded(
                          // width: size.width / 2 - 20.0,
                          child: Row(
                            children: [
                              Radio<SelectIDType>(
                                value: SelectIDType.selfEmployed,
                                groupValue: _character,
                                onChanged: (SelectIDType? value) {
                                  setState(() {
                                    _character = value;
                                  });
                                },
                              ),
                              const Text('Self Employed'),
                            ],
                          ),
                        )
                      ],
                    ),
                    _character == SelectIDType.salaryBased
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoLoanDocumentUploadWidget(
                                  name: 'Latest 2 months salary slips',
                                  filename: StorageValues.autoLoanProposals,
                                  selectedprofession:
                                      EnumToString.convertToString(
                                          SelectIDType.salaryBased)),
                              AutoLoanDocumentUploadWidget(
                                  name: 'Latest Form 16',
                                  filename: StorageValues.itra,
                                  selectedprofession:
                                      EnumToString.convertToString(
                                          SelectIDType.salaryBased)),
                              AutoLoanDocumentUploadWidget(
                                  name: 'Latest 3 months bank statments',
                                  filename: StorageValues.autoLoanProposals,
                                  selectedprofession:
                                      EnumToString.convertToString(
                                          SelectIDType.salaryBased)),
                              AutoLoanDocumentUploadWidget(
                                  name: 'Sign Verification Proof',
                                  info: 'PAN / Passport/ Bankers Verification',
                                  filename: StorageValues.autoLoanProposals,
                                  selectedprofession:
                                      EnumToString.convertToString(
                                          SelectIDType.salaryBased)),
                              AutoLoanDocumentUploadWidget(
                                  name: 'Employement Continuity Proof',
                                  info:
                                      'Copy of Appointment Letter/ Work Experience Certificate/ Relieving letter',
                                  filename: StorageValues.autoLoanProposals,
                                  selectedprofession:
                                      EnumToString.convertToString(
                                          SelectIDType.salaryBased)),
                              SizedBox(height: 20.0),
                            ],
                          )
                        //SizedBox(height: 20.0),
                        : Column(
                            children: [
                              AutoLoanDocumentUploadWidget(
                                  name: 'Business Proof',
                                  info:
                                      'Telephone Bill/ Electricity Bill/ Shop & Establishment act Certificate/ SSI or MSME Registration Certificate/ Sales Tax or VAT Certificate/ Current A/c Statement/ Regd Lease with other Utility Bills',
                                  filename: StorageValues.autoLoanProposals,
                                  selectedprofession:
                                      EnumToString.convertToString(
                                          SelectIDType.selfEmployed)),
                              AutoLoanDocumentUploadWidget(
                                  name: 'Latest ITR',
                                  filename: StorageValues.itra,
                                  selectedprofession:
                                      EnumToString.convertToString(
                                          SelectIDType.selfEmployed)),
                              AutoLoanDocumentUploadWidget(
                                  name: 'Latest 3 months bank statments',
                                  filename: StorageValues.autoLoanProposals,
                                  selectedprofession:
                                      EnumToString.convertToString(
                                          SelectIDType.selfEmployed)),
                              AutoLoanDocumentUploadWidget(
                                  name: 'Sign Verification Proof',
                                  info: 'PAN / Passport/ Bankers Verification',
                                  filename: StorageValues.autoLoanProposals,
                                  selectedprofession:
                                      EnumToString.convertToString(
                                          SelectIDType.selfEmployed)),
                              AutoLoanDocumentUploadWidget(
                                  name: 'Business Continuity Proof',
                                  info:
                                      'Shop & Establishment act Certificate/ SSI or MSME Registration Certificate/ Sales Tax or VAT Certificate/ Current A/c Statement',
                                  filename: StorageValues.autoLoanProposals,
                                  selectedprofession:
                                      EnumToString.convertToString(
                                          SelectIDType.selfEmployed)),
                              SizedBox(height: 20.0),
                            ],
                          ),
                    SizedBox(height: 30),
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
                                          type: 'AutoLoan',
                                          payfor: 'Automobile Loan')));
                            },
                            child: Container(
                                alignment: Alignment.center,
                                // width: size.width / 2,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: Color(0xffef661a),
                                      width: 1.0,
                                    ),
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
                                // width: size.width / 2,
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: Color(0xffef661a),
                                      width: 1.0,
                                    ),
                                    color: Color((math.Random().nextDouble() *
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
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AutoLoanDocumentUploadWidget extends StatefulWidget {
  final String name;
  final String? info;
  final String filename;
  final String? selectedprofession;

  const AutoLoanDocumentUploadWidget(
      {Key? key,
      required this.name,
      this.info,
      required this.filename,
      this.selectedprofession})
      : super(key: key);

  @override
  _AutoLoanDocumentUploadWidgetState createState() =>
      _AutoLoanDocumentUploadWidgetState();
}

class _AutoLoanDocumentUploadWidgetState
    extends State<AutoLoanDocumentUploadWidget> {
  bool value = false;

  String? img64;
  ImagePicker picker = new ImagePicker();
  bool imagePicked = false;
  List imagelist = ['Camera', 'Media'];

  getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    setState(
      () {
        if (pickedFile != null) {
          final bytes = html.File(pickedFile.path.codeUnits, pickedFile.path);
          Uint8List b = Uint8List(bytes.toString().length);
          img64 = Base64Encoder().convert(b);
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
          '$instanceUrl/services/apexrest/fluttermediafiledetail/uploadFile?title=${widget.name}&pathOnClient=${widget.name + '.' + filetype}&leadId=$id&type=AutoLoan&profession=${widget.selectedprofession}',
          data: base64Image,
          options: Options(headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'Bearer ${sharedPreferences.getString(StorageValues.accessToken)}',
            //"leadId": id, // lead id
            //"profession": widget
            //    .selectedprofession, // sallary / bussiness radio button selection
            //"title": widget.name, //file name_type of file
            //"type": 'AutoLoan', // type of loan
            //"pathOnClient": widget.name + '.' + filetype,
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
          // width: size.width / 2,
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
              getImage(ImageSource.gallery);
            })
      ],
    );
  }
}

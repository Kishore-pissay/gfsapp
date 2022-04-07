import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fintechfilings/Shared/customWidgets.dart';
import 'package:fintechfilings/screens/auth/logInScreen.dart';
import 'package:fintechfilings/screens/home/fileUploadResponse.dart';
import 'package:fintechfilings/screens/home/payment/paymentScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:io' as Io;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../my_flutter_app_icons.dart';

//enum SelectIDType { salaryBased, bussiness }

class MsmeLoan extends StatefulWidget {
  const MsmeLoan({Key? key}) : super(key: key);

  @override
  _MsmeLoanState createState() => _MsmeLoanState();
}

class _MsmeLoanState extends State<MsmeLoan> {
  //SelectIDType? _character = SelectIDType.salaryBased;
  bool value = false;
  TextEditingController _optionController = new TextEditingController();
  String? serviceValue;
  String? optionValue;
  bool optionVal = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: CustomWidgets.getAppBar(),
        body: SingleChildScrollView(
          child: SizedBox(
            width: size.width,
            child: Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Text('MSME Loan',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  SizedBox(width: 50)
                ],
              ),
              SizedBox(height: 20),
              Text('List of documents to be submitted',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              SizedBox(height: 20),
              Text('Note: Long press on ⓘ to get additional information',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
              SizedBox(height: 20),
              MsmeLoanDocumentUploadWidget(
                  name: 'Aadhar Card', filename: StorageValues.kyc),
              //SizedBox(height: 15),
              MsmeLoanDocumentUploadWidget(
                  name: 'Pan Card', filename: StorageValues.kyc),
              //SizedBox(height: 15),
              MsmeLoanDocumentUploadWidget(
                  name: 'Passport size Photo', filename: StorageValues.kyc),
              //SizedBox(height: 15),
              MsmeLoanDocumentUploadWidget(
                  name: 'Present Address Proof',
                  info: 'Electricity bill or Driving License or Ration card',
                  filename: StorageValues.kyc),
              //SizedBox(height: 15),
              MsmeLoanDocumentUploadWidget(
                  name: 'Business Address Proof',
                  info:
                      'Trade License/ Lease Agreement/ Sales Tax Certificate/ Utility Bill under the name of the business – Telephone or Electricity bill, not more than 3 months old',
                  filename: StorageValues.msmeLoanProposals),
              //SizedBox(height: 15),
              MsmeLoanDocumentUploadWidget(
                  name: 'Business Plan',
                  info:
                      'Necessary to ascertain your business, the industry and the long term growth prospects before the loan is sanctioned',
                  filename: StorageValues.msmeLoanProposals),
              // SizedBox(height: 10),
              MsmeLoanDocumentUploadWidget(
                  name: 'Latest 6 months Bank Statement - pdf',
                  info: 'Bank account statement under the name of the company',
                  filename: StorageValues.msmeLoanProposals),
              //SizedBox(height: 10),
              MsmeLoanDocumentUploadWidget(
                  name: 'Income Proof',
                  info:
                      'Income proof of the business that could be the Income Tax Returns with the profit and loss account and balance sheet',
                  filename: StorageValues.msmeLoanProposals),
              //SizedBox(height: 10),
              MsmeLoanDocumentUploadWidget(
                  name: 'Partnership deed',
                  filename: StorageValues.msmeLoanProposals),
              //SizedBox(height: 10),
              MsmeLoanDocumentUploadWidget(
                  name: 'Memorandum of Associations (MoA)',
                  filename: StorageValues.msmeLoanProposals),
              SizedBox(height: 10),
              MsmeLoanDocumentUploadWidget(
                  name: 'MSME Certificate/ Udyam Registration Certificate ',
                  filename: StorageValues.msmeLoanProposals),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: AppDropdownInput(
                  hintText: "MSME Loan amount range",
                  options: [
                    StorageValues.msmeLoan10to100,
                    StorageValues.msmeLoan100to500
                  ],
                  value: optionValue,
                  onChanged: (String? optionVal) {
                    setState(() {
                      this.optionValue = optionVal;
                      _optionController.text = optionVal!;
                    });
                  },
                  getLabel: (String value) => value,
                ),
              ),
              SizedBox(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
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
                                  type: _optionController.text ==
                                          StorageValues.msmeLoan10to100
                                      ? 'MLPBLow'
                                      : 'MLPBHigh',
                                  payfor: 'MSME Loan',
                                )));
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: size.width / 2,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Color(0xffef661a),
                            width: 1.0,
                          ),
                          color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                  .toInt())
                              .withOpacity(0.2)),
                      child: Column(children: [
                        Text('Subscribe',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                      ])),
                )
              ]),
              SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: size.width / 2,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Color(0xffef661a),
                            width: 1.0,
                          ),
                          color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                  .toInt())
                              .withOpacity(0.2)),
                      child: Column(children: [
                        Text('Cancel',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                      ])),
                )
              ]),
              SizedBox(height: 30),
            ]),
          ),
        ));
  }
}

class MsmeLoanDocumentUploadWidget extends StatefulWidget {
  final String name;
  final String? info;
  final String filename;
  final String? selectedprofession;

  const MsmeLoanDocumentUploadWidget(
      {Key? key,
      required this.name,
      this.info,
      required this.filename,
      this.selectedprofession})
      : super(key: key);

  @override
  _MsmeLoanDocumentUploadWidgetState createState() =>
      _MsmeLoanDocumentUploadWidgetState();
}

class _MsmeLoanDocumentUploadWidgetState
    extends State<MsmeLoanDocumentUploadWidget> {
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
          '$instanceUrl/services/apexrest/fluttermediafiledetail/uploadFile?title=${widget.name}&pathOnClient=${widget.name + '.' + filetype}&leadId=$id&type=MsmeFreshLoan&profession=${widget.selectedprofession}',
          data: base64Image,
          options: Options(headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'Bearer ${sharedPreferences.getString(StorageValues.accessToken)}',
            //"leadId": id, // lead id
            //"profession": widget
            //    .selectedprofession, // sallary / bussiness radio button selection
            //"title": widget.name, //file name_type of file
            //"type": 'MsmeFreshLoan', // type of loan
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

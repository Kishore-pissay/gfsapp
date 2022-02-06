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

class PersonalLoan extends StatefulWidget {
  const PersonalLoan({Key? key}) : super(key: key);

  @override
  _PersonalLoanState createState() => _PersonalLoanState();
}

class _PersonalLoanState extends State<PersonalLoan> {
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
                  Text('Personal Loan',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  SizedBox(width: 50)
                ],
              ),
              SizedBox(height: 20),
              Text('Please upload the list of documents required',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              SizedBox(height: 20),
              Text('Note: Long press on ⓘ to get additional information',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
              SizedBox(height: 20),
              Padding(
                padding: CustomWidgets.getPadding(size),
                child: Column(children: <Widget>[
                  PersonalLoanDocumentUploadWidget(
                      name: 'Aadhar Card', filename: StorageValues.kyc),
                  PersonalLoanDocumentUploadWidget(
                      name: 'Pan Card', filename: StorageValues.kyc),
                  PersonalLoanDocumentUploadWidget(
                      name: 'Passport size Photo',
                      filename: StorageValues.personalLoanProposals),
                  PersonalLoanDocumentUploadWidget(
                      name: 'Proof of Residence',
                      info:
                          'Leave and License Agreement / Utility Bill (not more than 3 months old) / Passport (any one).',
                      filename: StorageValues.personalLoanProposals),
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
                      Container(
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
                            PersonalLoanDocumentUploadWidget(
                                name: 'Latest 3 months salary slips',
                                filename: StorageValues.autoLoanProposals,
                                selectedprofession:
                                    EnumToString.convertToString(
                                        SelectIDType.salaryBased)),
                            SizedBox(height: 20.0),
                            PersonalLoanDocumentUploadWidget(
                                name: 'Latest 3 months Bank Statement -pdf',
                                info: 'where salary/income is credited',
                                filename: StorageValues.autoLoanProposals,
                                selectedprofession:
                                    EnumToString.convertToString(
                                        SelectIDType.salaryBased)),
                          ],
                        )
                      : Column(
                          children: [
                            PersonalLoanDocumentUploadWidget(
                                name: 'Income proof',
                                info: 'Audited financials for the last 2 years',
                                filename: StorageValues.autoLoanProposals,
                                selectedprofession:
                                    EnumToString.convertToString(
                                        SelectIDType.selfEmployed)),
                            PersonalLoanDocumentUploadWidget(
                                name: 'Latest 6 months Bank statement - pdf',
                                filename: StorageValues.autoLoanProposals,
                                selectedprofession:
                                    EnumToString.convertToString(
                                        SelectIDType.selfEmployed)),
                            PersonalLoanDocumentUploadWidget(
                                name: 'Office address proof',
                                filename: StorageValues.autoLoanProposals,
                                selectedprofession:
                                    EnumToString.convertToString(
                                        SelectIDType.selfEmployed)),
                            PersonalLoanDocumentUploadWidget(
                                name: 'Proof of residence or office ownership',
                                filename: StorageValues.autoLoanProposals,
                                selectedprofession:
                                    EnumToString.convertToString(
                                        SelectIDType.selfEmployed)),
                            SizedBox(height: 20.0),
                            PersonalLoanDocumentUploadWidget(
                                name: 'Proof of continuity of business',
                                info:
                                    'Shop & Establishment act Certificate/ SSI or MSME Registration Certificate/ Sales Tax or VAT Certificate/ Current A/c Stateme',
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
                                        type: 'PersonalLoan',
                                        payfor: 'Personal Loan')));
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
                  SizedBox(height: 30),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PersonalLoanDocumentUploadWidget extends StatefulWidget {
  final String name;
  final String? info;
  final String filename;
  final String? selectedprofession;

  const PersonalLoanDocumentUploadWidget(
      {Key? key,
      required this.name,
      this.info,
      required this.filename,
      this.selectedprofession})
      : super(key: key);

  @override
  _PersonalLoanDocumentUploadWidgetState createState() =>
      _PersonalLoanDocumentUploadWidgetState();
}

class _PersonalLoanDocumentUploadWidgetState
    extends State<PersonalLoanDocumentUploadWidget> {
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
          '$instanceUrl/services/apexrest/fluttermediafiledetail/uploadFile?title=${widget.name}&pathOnClient=${widget.name + '.' + filetype}&leadId=$id&type=PersonalLoan&profession=${widget.selectedprofession}',
          data: base64Image,
          options: Options(headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'Bearer ${sharedPreferences.getString(StorageValues.accessToken)}',
            //"leadId": id, // lead id
            //"profession": widget
            //    .selectedprofession, // sallary / bussiness radio button selection
            //"title": widget.name, //file name_type of file
            //"type": 'PersonalLoan', // type of loan
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Row(
            children: [
              Checkbox(
                value: this.value,
                onChanged: (bool? value) {},
              ),
              SizedBox(
                width: 10,
              ), //SizedBox
              Flexible(
                child: Text(
                  '${widget.name}',
                  style: TextStyle(fontSize: 17.0),
                ),
              ),
            ],
          ),
        ),
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

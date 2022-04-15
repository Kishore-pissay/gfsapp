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

import '../../../my_flutter_app_icons.dart';

class EducationLoan extends StatefulWidget {
  const EducationLoan({Key? key}) : super(key: key);

  @override
  _EducationLoanState createState() => _EducationLoanState();
}

class _EducationLoanState extends State<EducationLoan> {
  //SelectIDType? _character = SelectIDType.salaryBased;
  bool value = false;

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
                  Text('Education Loan',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  SizedBox(width: 50)
                ],
              ),
              SizedBox(height: 20),
              Text('Documents required for both Salaried & Other Individual',
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
                  children: [
                    EduLoanDocumentUploadWidget(
                        name: 'Aadhar Card', filename: StorageValues.kyc),
                    EduLoanDocumentUploadWidget(
                        name: 'Passport', filename: StorageValues.kyc),
                    EduLoanDocumentUploadWidget(
                        name: 'Latest 6 months Bank Statement',
                        info: '6 months Bank Statements pdf or Passbook pdf',
                        filename: StorageValues.eduLoanProposals),
                    SizedBox(height: 10),
                    EduLoanDocumentUploadWidget(
                        name: 'Guarantor Form (Optional)',
                        filename: StorageValues.eduLoanProposals),
                    SizedBox(height: 10),
                    EduLoanDocumentUploadWidget(
                        name: 'Admission Letter including Fee schedule',
                        info:
                            'Copy of Admission Letter of the inistitute along with fees schedule',
                        filename: StorageValues.eduLoanProposals),
                    SizedBox(height: 10),
                    EduLoanDocumentUploadWidget(
                        name: 'Educational MarkSheets - pdf',
                        info:
                            'Till date all the educational memos merged in pdf format',
                        filename: StorageValues.eduLoanProposals),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Documents required for first disbursement',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w500)),
                    ),
                    //Text('Documents required for first disbursement ',
                    //    textAlign: TextAlign.center,
                    //    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                    //SizedBox(height: 20),
                    EduLoanDocumentUploadWidget(
                        name: 'Demand letter from college/university',
                        filename: StorageValues.eduLoanProposals),
                    EduLoanDocumentUploadWidget(
                        name: 'Signed Loan agreement',
                        info:
                            'Loan agreement signed by applicant, co-applicants',
                        filename: StorageValues.eduLoanProposals,
                        selectedprofession: 'first disbursement'),
                    SizedBox(height: 5),
                    EduLoanDocumentUploadWidget(
                        name: 'Signed Sanction letter',
                        info:
                            'Sanction letter signed by applicant, co-applicants',
                        filename: StorageValues.eduLoanProposals,
                        selectedprofession: 'first disbursement'),
                    SizedBox(height: 5),
                    EduLoanDocumentUploadWidget(
                        name: 'Signed Disbursement request form',
                        info:
                            'Disbursement request form signed by applicant, co-applicants',
                        filename: StorageValues.eduLoanProposals,
                        selectedprofession: 'first disbursement'),
                    SizedBox(height: 10),
                    EduLoanDocumentUploadWidget(
                        name:
                            'Receipts of margin money with proof of transaction - pdf',
                        info:
                            'Receipts of margin money paid to the college / university along with bank statement reflecting the transaction',
                        filename: StorageValues.eduLoanProposals,
                        selectedprofession: 'first disbursement'),
                    SizedBox(height: 10),
                    EduLoanDocumentUploadWidget(
                        name:
                            'Documents for collateral security (if applicable) - pdf',
                        filename: StorageValues.eduLoanProposals,
                        selectedprofession: 'first disbursement'),
                    SizedBox(height: 10),
                    EduLoanDocumentUploadWidget(
                        name: 'Signed Form A2 in case of overseas institute',
                        info:
                            'Form A2 signed by applicant or co-applicants in case of overseas institute',
                        filename: StorageValues.eduLoanProposals,
                        selectedprofession: 'first disbursement'),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Documents required for subsequent disbursement',
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.w500)),
                    ),
                    EduLoanDocumentUploadWidget(
                        name: 'Signed Disbursement request form',
                        info:
                            'Disbursement request form signed by applicant, co-applicants',
                        filename: StorageValues.eduLoanProposals,
                        selectedprofession: 'subsequent disbursement'),
                    SizedBox(height: 10),
                    EduLoanDocumentUploadWidget(
                        name:
                            'Receipts of margin money with proof of transaction - pdf',
                        info:
                            'Receipts of margin money paid to the college / university along with bank statement reflecting the transaction',
                        filename: StorageValues.eduLoanProposals,
                        selectedprofession: 'subsequent disbursement'),
                    SizedBox(height: 10),
                    EduLoanDocumentUploadWidget(
                        name:
                            'Exam progress report, marksheet, bonafide certificate (Any one)',
                        filename: StorageValues.eduLoanProposals,
                        selectedprofession: 'subsequent disbursement'),
                    SizedBox(height: 10),
                    EduLoanDocumentUploadWidget(
                        name: 'Signed Form A2 in case of overseas institute',
                        info:
                            'Form A2 signed by applicant or co-applicants in case of overseas institute',
                        filename: StorageValues.eduLoanProposals,
                        selectedprofession: 'subsequent disbursement'),
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
                                          type: 'EDUPB',
                                          payfor: 'Education Loan')));
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
                  ],
                ),
              )
            ]),
          ),
        ));
  }
}

class EduLoanDocumentUploadWidget extends StatefulWidget {
  final String name;
  final String? info;
  final String filename;
  final String? selectedprofession;

  const EduLoanDocumentUploadWidget(
      {Key? key,
      required this.name,
      this.info,
      required this.filename,
      this.selectedprofession})
      : super(key: key);

  @override
  _EduLoanDocumentUploadWidgetState createState() =>
      _EduLoanDocumentUploadWidgetState();
}

class _EduLoanDocumentUploadWidgetState
    extends State<EduLoanDocumentUploadWidget> {
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
          '$instanceUrl/services/apexrest/fluttermediafiledetail/uploadFile?title=${widget.name}&pathOnClient=${widget.name + '.' + filetype}&leadId=$id&type=EducationLoan&profession=${widget.selectedprofession}',
          data: base64Image,
          options: Options(headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'Bearer ${sharedPreferences.getString(StorageValues.accessToken)}',
            HttpHeaders.accessControlRequestHeadersHeader:
                true, // add this line cors policy
            //"leadId": id, // lead id
            //"profession": widget
            //    .selectedprofession, // sallary / bussiness radio button selection
            //"title": widget.name, //file name_type of file
            //"type": 'EducationLoan', // type of loan
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
        // Spacer(),
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

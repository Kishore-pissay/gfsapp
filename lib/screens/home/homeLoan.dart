import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global/Shared/customWidgets.dart';
import 'package:global/screens/auth/logInScreen.dart';
import 'package:global/screens/home/fileUploadResponse.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io' as Io;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../my_flutter_app_icons.dart';

enum SelectIDType { salaryBased, bussiness }

class HomeLoan extends StatefulWidget {
  const HomeLoan({Key? key}) : super(key: key);

  @override
  _HomeLoanState createState() => _HomeLoanState();
}

class _HomeLoanState extends State<HomeLoan> {
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
            child: Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Text('Home Loan',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  SizedBox(width: 50)
                ],
              ),
              SizedBox(height: 20),
              Text('List of documents to be submitted',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              SizedBox(height: 20),
              Text('Identity proof of applicant & co-applicant',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
              SizedBox(height: 6),
              Text('Note: Long press on ⓘ to get tool tips',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
              SizedBox(height: 20),
              LoanDocumentUploadWidget(
                  name: '1. Voter Id', filename: StorageValues.kyc),
              LoanDocumentUploadWidget(
                  name: '2. Passport', filename: StorageValues.kyc),
              LoanDocumentUploadWidget(
                  name: '3. Proof of the present residence',
                  info: 'Electricity bill or Telephone bill or Ration card',
                  filename: StorageValues.kyc),
              LoanDocumentUploadWidget(
                  name: '4. Sales deed',
                  info:
                      'Agreement of sale along with link documents for the last 30 years',
                  filename: StorageValues.loanProposalsA),
              LoanDocumentUploadWidget(
                  name: '5. Approved plan copy',
                  info: 'By Municipality/ Layout approval/ NOC under ULC Act',
                  filename: StorageValues.loanProposalsA),
              LoanDocumentUploadWidget(
                  name: '6. Valuation Report',
                  info:
                      'Incase Loan Value Above 1 Cr - 2 valuation reports required',
                  filename: StorageValues.loanProposalsA),
              LoanDocumentUploadWidget(
                  name: '7. Legal Report',
                  info:
                      'Incase Loan Value Above 1 Cr - 2 legal reports required',
                  filename: StorageValues.loanProposalsA),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: size.width / 2 - 20.0,
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
                      width: size.width / 2 - 20.0,
                      child: Row(children: [
                        Radio<SelectIDType>(
                          value: SelectIDType.bussiness,
                          groupValue: _character,
                          onChanged: (SelectIDType? value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                        Flexible(
                            child: const Text(
                                'Businessmen/ Self Employed/ Professionals')),
                      ]))
                ],
              ),
              _character == SelectIDType.salaryBased
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Applicant :',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w500)),
                        ),
                        Column(
                          children: [
                            LoanDocumentUploadWidget(
                                name: 'Latest 6 months pay slips',
                                filename: StorageValues.pfStatementA),
                            LoanDocumentUploadWidget(
                                name: 'Latest 6 months salary bank statements',
                                filename: StorageValues.itra),
                            LoanDocumentUploadWidget(
                                name: 'Latest 3 years form 16',
                                filename: StorageValues.itra),
                            LoanDocumentUploadWidget(
                                name: 'Applicant passport size photo',
                                filename: StorageValues.loanProposalsA),
                            LoanDocumentUploadWidget(
                                name: 'Applicant ID proof',
                                filename: StorageValues.loanProposalsA),
                            LoanDocumentUploadWidget(
                                name: 'Employee offer letter',
                                filename: StorageValues.loanProposalsA),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Co-Applicant',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w500)),
                        ),
                        Column(
                          children: [
                            LoanDocumentUploadWidget(
                                name: 'Latest 6 months pay slips',
                                filename: StorageValues.pfStatementCA),
                            LoanDocumentUploadWidget(
                                name: 'Latest 6 months salary bank statements',
                                filename: StorageValues.itrca),
                            LoanDocumentUploadWidget(
                                name: 'Latest 3 years form 16',
                                filename: StorageValues.itrca),
                            LoanDocumentUploadWidget(
                                name: 'Applicant passport size photo',
                                filename: StorageValues.loanProposalsCA),
                            LoanDocumentUploadWidget(
                                name: 'Applicant ID proof',
                                filename: StorageValues.loanProposalsCA),
                            LoanDocumentUploadWidget(
                                name: 'Employee offer letter',
                                filename: StorageValues.loanProposalsCA),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        LoanDocumentUploadWidget(
                            name: '3 years of ITR',
                            info: 'Incase turn over Above 1 Cr audit required',
                            filename: StorageValues.itra),
                        LoanDocumentUploadWidget(
                            name: 'Bussiness registration certificate',
                            filename: StorageValues.loanProposalsA),
                        LoanDocumentUploadWidget(
                            name:
                                'Latest 6 months bank statements (Savings/Current',
                            filename: StorageValues.loanProposalsA),
                        LoanDocumentUploadWidget(
                            name: 'Latest 6 months GST returns',
                            filename: StorageValues.gstReturns),
                        LoanDocumentUploadWidget(
                            name: 'KYC verification report',
                            filename: StorageValues.kyc),
                        LoanDocumentUploadWidget(
                            name: 'IT verification report',
                            filename: StorageValues.loanProposalsA),
                        LoanDocumentUploadWidget(
                            name: 'Firm/ Pvt.Ltd Latest 3 years IT Returns',
                            filename: StorageValues.rocReturns),
                        LoanDocumentUploadWidget(
                            name: 'Assets & Liabilities',
                            filename: StorageValues.loanProposalsA),
                        LoanDocumentUploadWidget(
                            name: 'Power of Attorney',
                            filename: StorageValues.loanProposalsA),
                        LoanDocumentUploadWidget(
                            name: 'Passport size photo - Applicant',
                            filename: StorageValues.loanProposalsA),
                        LoanDocumentUploadWidget(
                            name: 'Passport size photo - Co-Applicant',
                            filename: StorageValues.loanProposalsCA),
                      ],
                    )
            ]),
          ),
        ));
  }
}

class LoanDocumentUploadWidget extends StatefulWidget {
  final String name;
  final String? info;
  final String filename;
  const LoanDocumentUploadWidget(
      {Key? key, required this.name, this.info, required this.filename})
      : super(key: key);

  @override
  _LoanDocumentUploadWidgetState createState() =>
      _LoanDocumentUploadWidgetState();
}

class _LoanDocumentUploadWidgetState extends State<LoanDocumentUploadWidget> {
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
      final response =
          await dio.post('$instanceUrl/services/apexrest/flutter/uploadfile',
              data: base64Image,
              options: Options(headers: {
                HttpHeaders.acceptHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'Bearer ${sharedPreferences.getString(StorageValues.accessToken)}',
                "parentid": id,
                "filename": widget.filename,
                "filetype": filetype
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

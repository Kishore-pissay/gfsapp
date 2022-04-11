import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global/Shared/customWidgets.dart';
import 'package:global/screens/auth/logInScreen.dart';
import 'package:global/screens/home/fileUploadResponse.dart';
import 'package:global/screens/home/payment/paymentScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:io' as Io;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enum_to_string/enum_to_string.dart';

import '../../../my_flutter_app_icons.dart';

enum SelectIDType { salaryBased, bussiness }

class HomeLoan extends StatefulWidget {
  const HomeLoan({Key? key}) : super(key: key);

  @override
  _HomeLoanState createState() => _HomeLoanState();
}

class _HomeLoanState extends State<HomeLoan> {
  SelectIDType? _character = SelectIDType.salaryBased;
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
              Text('Note: Long press on ⓘ to get additional information',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500)),
              SizedBox(height: 20),
              LoanDocumentUploadWidget(
                  name: 'Aadhar Card', filename: StorageValues.kyc),
              LoanDocumentUploadWidget(
                  name: 'Pan Card', filename: StorageValues.kyc),
              LoanDocumentUploadWidget(
                  name: 'Passport', filename: StorageValues.kyc),
              LoanDocumentUploadWidget(
                  name: 'Proof of the present residence',
                  info: 'Electricity bill or Telephone bill or Ration card',
                  filename: StorageValues.kyc),
              LoanDocumentUploadWidget(
                  name: 'Sales deed',
                  info:
                      'Agreement of sale along with link documents for the last 30 years',
                  filename: StorageValues.loanProposalsA),
              LoanDocumentUploadWidget(
                  name: 'Approved plan copy',
                  info: 'By Municipality/ Layout approval/ NOC under ULC Act',
                  filename: StorageValues.loanProposalsA),
              LoanDocumentUploadWidget(
                  name: 'Valuation Report',
                  info:
                      'Incase Loan Value Above 1 Cr - 2 valuation reports required',
                  filename: StorageValues.loanProposalsA),
              LoanDocumentUploadWidget(
                  name: 'Legal Report',
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
                                filename: StorageValues.pfStatementA,
                                selectedprofession:
                                    EnumToString.convertToString(
                                            SelectIDType.salaryBased) +
                                        '_Applicant'),
                            LoanDocumentUploadWidget(
                                name: 'Latest 6 months salary bank statements',
                                filename: StorageValues.itra,
                                selectedprofession:
                                    EnumToString.convertToString(
                                            SelectIDType.salaryBased) +
                                        '_Applicant'),
                            LoanDocumentUploadWidget(
                                name: 'Latest 3 years form 16',
                                filename: StorageValues.itra,
                                selectedprofession:
                                    EnumToString.convertToString(
                                            SelectIDType.salaryBased) +
                                        '_Applicant'),
                            LoanDocumentUploadWidget(
                                name: 'Applicant passport size photo',
                                filename: StorageValues.loanProposalsA,
                                selectedprofession:
                                    EnumToString.convertToString(
                                            SelectIDType.salaryBased) +
                                        '_Applicant'),
                            LoanDocumentUploadWidget(
                                name: 'Applicant ID proof',
                                filename: StorageValues.loanProposalsA,
                                selectedprofession:
                                    EnumToString.convertToString(
                                            SelectIDType.salaryBased) +
                                        '_Applicant'),
                            LoanDocumentUploadWidget(
                                name: 'Employee offer letter',
                                filename: StorageValues.loanProposalsA,
                                selectedprofession:
                                    EnumToString.convertToString(
                                            SelectIDType.salaryBased) +
                                        '_Applicant'),
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
                                filename: StorageValues.pfStatementCA,
                                selectedprofession:
                                    EnumToString.convertToString(
                                            SelectIDType.salaryBased) +
                                        '_Co-Applicant'),
                            LoanDocumentUploadWidget(
                                name: 'Latest 6 months salary bank statements',
                                filename: StorageValues.itrca,
                                selectedprofession:
                                    EnumToString.convertToString(
                                            SelectIDType.salaryBased) +
                                        '_Co-Applicant'),
                            LoanDocumentUploadWidget(
                                name: 'Latest 3 years form 16',
                                filename: StorageValues.itrca,
                                selectedprofession:
                                    EnumToString.convertToString(
                                            SelectIDType.salaryBased) +
                                        '_Co-Applicant'),
                            LoanDocumentUploadWidget(
                                name: 'Applicant passport size photo',
                                filename: StorageValues.loanProposalsCA,
                                selectedprofession:
                                    EnumToString.convertToString(
                                            SelectIDType.salaryBased) +
                                        '_Co-Applicant'),
                            LoanDocumentUploadWidget(
                                name: 'Applicant ID proof',
                                filename: StorageValues.loanProposalsCA,
                                selectedprofession:
                                    EnumToString.convertToString(
                                            SelectIDType.salaryBased) +
                                        '_Co-Applicant'),
                            LoanDocumentUploadWidget(
                                name: 'Employee offer letter',
                                filename: StorageValues.loanProposalsCA,
                                selectedprofession:
                                    EnumToString.convertToString(
                                            SelectIDType.salaryBased) +
                                        '_Co-Applicant'),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        LoanDocumentUploadWidget(
                            name: '3 years of ITR',
                            info: 'Incase turn over Above 1 Cr audit required',
                            filename: StorageValues.itra,
                            selectedprofession: EnumToString.convertToString(
                                SelectIDType.bussiness)),
                        LoanDocumentUploadWidget(
                            name: 'Bussiness registration certificate',
                            filename: StorageValues.loanProposalsA,
                            selectedprofession: EnumToString.convertToString(
                                SelectIDType.bussiness)),
                        LoanDocumentUploadWidget(
                            name:
                                'Latest 6 months bank statements (Savings/Current',
                            filename: StorageValues.loanProposalsA,
                            selectedprofession: EnumToString.convertToString(
                                SelectIDType.bussiness)),
                        LoanDocumentUploadWidget(
                            name: 'Latest 6 months GST returns',
                            filename: StorageValues.gstReturns,
                            selectedprofession: EnumToString.convertToString(
                                SelectIDType.bussiness)),
                        LoanDocumentUploadWidget(
                            name: 'KYC verification report',
                            filename: StorageValues.kyc,
                            selectedprofession: EnumToString.convertToString(
                                SelectIDType.bussiness)),
                        LoanDocumentUploadWidget(
                            name: 'IT verification report',
                            filename: StorageValues.loanProposalsA,
                            selectedprofession: EnumToString.convertToString(
                                SelectIDType.bussiness)),
                        LoanDocumentUploadWidget(
                            name: 'Firm/ Pvt.Ltd Latest 3 years IT Returns',
                            filename: StorageValues.rocReturns,
                            selectedprofession: EnumToString.convertToString(
                                SelectIDType.bussiness)),
                        LoanDocumentUploadWidget(
                            name: 'Assets & Liabilities',
                            filename: StorageValues.loanProposalsA,
                            selectedprofession: EnumToString.convertToString(
                                SelectIDType.bussiness)),
                        LoanDocumentUploadWidget(
                            name: 'Power of Attorney',
                            filename: StorageValues.loanProposalsA,
                            selectedprofession: EnumToString.convertToString(
                                SelectIDType.bussiness)),
                        LoanDocumentUploadWidget(
                            name: 'Passport size photo - Applicant',
                            filename: StorageValues.loanProposalsA,
                            selectedprofession: EnumToString.convertToString(
                                    SelectIDType.bussiness) +
                                '_Applicant'),
                        LoanDocumentUploadWidget(
                            name: 'Passport size photo - Co-Applicant',
                            filename: StorageValues.loanProposalsCA,
                            selectedprofession: EnumToString.convertToString(
                                    SelectIDType.bussiness) +
                                "_Co-Applicant"),
                      ],
                    ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: AppDropdownInput(
                  hintText: "Home Loan amount range",
                  options: [
                    StorageValues.homeLoan25to75,
                    StorageValues.homeLoan75to150
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
                if (optionVal ==
                    optionVal) // if selected option is 1 then payment type is diff
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentScreen(
                                    type: _optionController.text ==
                                            StorageValues.homeLoan25to75
                                        ? 'HomeLoanLow'
                                        : 'HomeLoanHigh',
                                    payfor: 'Home Loan',
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
                ],
              ),
              SizedBox(height: 30),
            ]),
          ),
        ));
  }
}

class LoanDocumentUploadWidget extends StatefulWidget {
  final String name;
  final String? info;
  final String filename;
  final String? selectedprofession;

  const LoanDocumentUploadWidget(
      {Key? key,
      required this.name,
      this.info,
      required this.filename,
      this.selectedprofession})
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
      final response = await dio.post(
          '$instanceUrl/services/apexrest/fluttermediafiledetail/uploadFile?title=${widget.name}&pathOnClient=${widget.name + '.' + filetype}&leadId=$id&type=HomeLoan&profession=${widget.selectedprofession}',
          data: base64Image,
          options: Options(headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'Bearer ${sharedPreferences.getString(StorageValues.accessToken)}',
            //"leadId": id, // lead id
            //"profession": widget
            //    .selectedprofession, // sallary / bussiness radio button selection
            //"title": widget.name, //file name_type of file
            //"type": 'HomeLoan', // type of loan
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

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:fintechfilings/Shared/customTextField.dart';
import 'package:fintechfilings/Shared/customWidgets.dart';
import 'package:fintechfilings/model/getUserDetailModelClass.dart';
import 'package:fintechfilings/screens/apiservicessenddata.dart';
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

enum SelectIDType { proprietor, partnershipfirm, pvtltdcompany }

class GstRegistration extends StatefulWidget {
  const GstRegistration({Key? key}) : super(key: key);

  @override
  _GstRegistrationState createState() => _GstRegistrationState();
}

class _GstRegistrationState extends State<GstRegistration> {
  SelectIDType? _character = SelectIDType.proprietor;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Text('GST Fresh Registration',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                SizedBox(width: 50)
              ],
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
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: size.width,
                  child: Row(children: [
                    Radio<SelectIDType>(
                      value: SelectIDType.proprietor,
                      groupValue: _character,
                      onChanged: (SelectIDType? value) {
                        setState(() {
                          _character = value;
                          print(_character);
                        });
                      },
                    ),
                    const Text('Proprietor / Individual Business'),
                  ]),
                )
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: size.width,
                  child: Row(children: [
                    Radio<SelectIDType>(
                      value: SelectIDType.partnershipfirm,
                      groupValue: _character,
                      onChanged: (SelectIDType? value) {
                        setState(() {
                          _character = value;
                          print(_character);
                        });
                      },
                    ),
                    const Text('Partnership Firm'),
                  ]),
                )
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: size.width,
                  child: Row(
                    children: [
                      Radio<SelectIDType>(
                        value: SelectIDType.pvtltdcompany,
                        groupValue: _character,
                        onChanged: (SelectIDType? value) {
                          setState(() {
                            _character = value;
                          });
                        },
                      ),
                      const Text('Private Limited Company'),
                    ],
                  ),
                )
              ],
            ),
            _character == SelectIDType.proprietor
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("*all the fields are mandatory",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 8.0),
                        CustomTextField(
                            hint: 'Business Name',
                            readonly: false,
                            controller: _businessNameController),
                        CustomTextField(
                            hint: 'Owner Full Name',
                            readonly: false,
                            controller: _personFullNameController),
                        CustomTextField(
                            hint: 'Owner Mobile Number',
                            readonly: false,
                            controller: _personMobileController),
                        CustomTextField(
                            hint: 'Owner Email ID',
                            readonly: false,
                            controller: _personEmailController),
                        CustomTextField(
                            hint: 'Activity of the Business',
                            readonly: false,
                            controller: _activityBusinessController),
                        SizedBox(height: 10.0),
                        //selectedRegFor = 'Proprietor',
                        //= widget.EnumToString.convertToString(
                        //SelectIDType.proprietor),
                        CustomWidgets.getActionButton('Submit', 20.0, () async {
                          final response = await ApiService.sendDataValues(
                              context: context,
                              businessName: _businessNameController.text,
                              fullName: _personFullNameController.text,
                              mobileNo: _personMobileController.text,
                              email: _personEmailController.text,
                              businessActivity:
                                  _activityBusinessController.text,
                              regFor: 'Proprietor',
                              typeOfRegistration: 'GstReg',
                              typeOfPerson: 'Owner');
                          //print(response);
                          if (response != null) {
                            setState(() {
                              isSubmited = true;
                              print(response);

                              recordId = response;
                              //print(recordId.toString());
                            });
                          }
                        }),
                        SizedBox(height: 15),
                        if (isSubmited)
                          Column(
                            children: [
                              Text("*upload documents",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 2.0),
                              GstRegistrationDocumentUploadWidget(
                                  name: 'Owner Aadhar Card',
                                  filename: StorageValues.gstFreshRegBusiness,
                                  recID: recordId ?? "",
                                  selectedprofession:
                                      EnumToString.convertToString(
                                          SelectIDType.proprietor)),
                              SizedBox(height: 2.0),
                              GstRegistrationDocumentUploadWidget(
                                  name: 'Owner Pan Card',
                                  filename: StorageValues.gstFreshRegBusiness,
                                  recID: recordId ?? "",
                                  selectedprofession:
                                      EnumToString.convertToString(
                                          SelectIDType.proprietor)),
                              SizedBox(height: 2.0),
                              GstRegistrationDocumentUploadWidget(
                                  name: 'Business Pan Card',
                                  filename: StorageValues.gstFreshRegBusiness,
                                  recID: recordId ?? "",
                                  selectedprofession:
                                      EnumToString.convertToString(
                                          SelectIDType.proprietor)),
                              SizedBox(height: 2.0),
                              GstRegistrationDocumentUploadWidget(
                                  name:
                                      'Latest month electricity bill - Business',
                                  filename: StorageValues.gstFreshRegBusiness,
                                  recID: recordId ?? "",
                                  selectedprofession:
                                      EnumToString.convertToString(
                                          SelectIDType.proprietor)),
                              SizedBox(height: 2.0),
                              GstRegistrationDocumentUploadWidget(
                                  name: 'Property Tax receipt',
                                  filename: StorageValues.gstFreshRegBusiness,
                                  recID: recordId ?? "",
                                  selectedprofession:
                                      EnumToString.convertToString(
                                          SelectIDType.proprietor)),
                              SizedBox(height: 2.0),
                              GstRegistrationDocumentUploadWidget(
                                  name: 'Rental Deed - pdf',
                                  info: 'for rented premises',
                                  filename: StorageValues.gstFreshRegBusiness,
                                  recID: recordId ?? "",
                                  selectedprofession:
                                      EnumToString.convertToString(
                                          SelectIDType.proprietor)),
                              SizedBox(height: 2.0),
                              GstRegistrationDocumentUploadWidget(
                                  name: 'Owner Passport size photo',
                                  filename: StorageValues.gstFreshRegBusiness,
                                  recID: recordId ?? "",
                                  selectedprofession:
                                      EnumToString.convertToString(
                                          SelectIDType.proprietor)),
                              SizedBox(height: 2.0),
                              GstRegistrationDocumentUploadWidget(
                                  name: 'Address Proof of the Business',
                                  filename: StorageValues.gstFreshRegBusiness,
                                  recID: recordId ?? "",
                                  selectedprofession:
                                      EnumToString.convertToString(
                                          SelectIDType.proprietor)),
                              SizedBox(height: 20.0),
                            ],
                          )
                      ], //
                    ),
                  )
                : _character == SelectIDType.partnershipfirm
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("*all the fields are mandatory",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(height: 8.0),
                            CustomTextField(
                                hint: 'Firm Name',
                                readonly: false,
                                controller: _businessNameController),
                            CustomTextField(
                                hint: 'Firm Mobile Number',
                                readonly: false,
                                controller: _businessMobileNumberController),
                            CustomTextField(
                                hint: 'Firm Email ID',
                                readonly: false,
                                controller: _businesEmailIdController),
                            CustomTextField(
                                hint: 'Activity of the Business',
                                readonly: false,
                                controller: _activityBusinessController),
                            SizedBox(height: 20.0),
                            Text("Enter Partner1 Details",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(height: 8.0),
                            CustomTextField(
                                hint: 'Partner1 Full Name',
                                readonly: false,
                                controller: _personFullNameController),
                            CustomTextField(
                                hint: 'Parner1 Mobile Number',
                                readonly: false,
                                controller: _personMobileController),
                            CustomTextField(
                                hint: 'Partner1 Email ID',
                                readonly: false,
                                controller: _personEmailController),
                            SizedBox(height: 10.0),
                            CustomWidgets.getActionButton('Submit', 20.0,
                                () async {
                              final response = await ApiService.sendDataValues(
                                  context: context,
                                  businessName: _businessNameController.text,
                                  mobileNo:
                                      _businessMobileNumberController.text,
                                  email: _businesEmailIdController.text,
                                  personFullName:
                                      _personFullNameController.text,
                                  personMobile: _personMobileController.text,
                                  personEmail: _personEmailController.text,
                                  businessActivity:
                                      _activityBusinessController.text,
                                  regFor: 'Partnership Firm',
                                  typeOfRegistration: 'GstReg',
                                  typeOfPerson: 'business + Partner1');
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
                                  Text("*upload Firm related documents",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(height: 8.0),
                                  GstRegistrationDocumentUploadWidget(
                                      name: 'Firm Pan Card',
                                      filename: StorageValues.gstFreshRegFirm,
                                      recID: recordId ?? ""),
                                  SizedBox(height: 2.0),
                                  GstRegistrationDocumentUploadWidget(
                                      name:
                                          'Firm Latest month electricity bill',
                                      filename: StorageValues.gstFreshRegFirm,
                                      recID: recordId ?? ""),
                                  SizedBox(height: 2.0),
                                  GstRegistrationDocumentUploadWidget(
                                      name: 'Partnership Deed - pdf',
                                      filename: StorageValues.gstFreshRegFirm,
                                      recID: recordId ?? ""),
                                  SizedBox(height: 2.0),
                                  GstRegistrationDocumentUploadWidget(
                                      name: 'Rental Deed - pdf',
                                      info: 'for rented premises',
                                      filename: StorageValues.gstFreshRegFirm,
                                      recID: recordId ?? ""),
                                  SizedBox(height: 2.0),
                                  GstRegistrationDocumentUploadWidget(
                                      name: 'Address Proof of the Firm',
                                      filename: StorageValues.gstFreshRegFirm,
                                      recID: recordId ?? ""),
                                  SizedBox(height: 2.0),
                                  GstRegistrationDocumentUploadWidget(
                                      name: 'Resolution by Partners document',
                                      filename: StorageValues.gstFreshRegFirm,
                                      recID: recordId ?? ""),

                                  SizedBox(height: 10.0),
                                  Text("*upload Partner1 documents",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),

                                  SizedBox(height: 8.0),
                                  GstRegistrationDocumentUploadWidget(
                                      name: 'Aadhar Card',
                                      filename: StorageValues.gstFreshRegFirm,
                                      recID: recordId ?? ""),
                                  //SizedBox(height: 2.0),
                                  GstRegistrationDocumentUploadWidget(
                                      name: 'Pan Card',
                                      filename: StorageValues.gstFreshRegFirm,
                                      recID: recordId ?? ""),
                                  //SizedBox(height: 2.0),
                                  GstRegistrationDocumentUploadWidget(
                                      name: 'Passport size photo',
                                      filename: StorageValues.gstFreshRegFirm,
                                      recID: recordId ?? ""),
                                  //SizedBox(height: 2.0),
                                  GstRegistrationDocumentUploadWidget(
                                      name: 'Residential Address Proof',
                                      filename: StorageValues.gstFreshRegFirm,
                                      recID: recordId ?? ""),
                                  SizedBox(height: 10.0),
                                  Text(
                                      'We shall Contact you for further Partner details.')
                                ],
                              ),
                            SizedBox(height: 10.0),
                            //CustomWidgets.getActionButton(
                            //    '+ Add Partner', 30.0, 15.0, () {
                            //  //add partner repeat the above partnership firm list
                            //  Navigator.pop(context);
                            //}),
                            //SizedBox(height: 20.0),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("*all the fields are mandatory",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
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
                            SizedBox(height: 10.0),
                            Text("Enter Director Details",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
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
                            CustomWidgets.getActionButton('Submit', 20.0,
                                () async {
                              final response = await ApiService.sendDataValues(
                                context: context,
                                businessName: _businessNameController.text,
                                mobileNo: _businessMobileNumberController.text,
                                email: _businesEmailIdController.text,
                                personFullName: _personFullNameController.text,
                                personMobile: _personMobileController.text,
                                personEmail: _personEmailController.text,
                                businessActivity:
                                    _activityBusinessController.text,
                                regFor: 'Private Limited Company',
                                typeOfRegistration: 'GstReg',
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
                                  GstRegistrationDocumentUploadWidget(
                                    name: 'Company Pan Card',
                                    filename: StorageValues.gstFreshRegCompany,
                                    recID: recordId ?? "",
                                  ),
                                  SizedBox(height: 2.0),
                                  GstRegistrationDocumentUploadWidget(
                                    name: 'Company Incorporation Certificate',
                                    filename: StorageValues.gstFreshRegCompany,
                                    recID: recordId ?? "",
                                  ),
                                  SizedBox(height: 2.0),
                                  GstRegistrationDocumentUploadWidget(
                                    name: 'Memorandum of Associations (MoA)',
                                    filename: StorageValues.gstFreshRegCompany,
                                    recID: recordId ?? "",
                                  ),
                                  SizedBox(height: 2.0),
                                  GstRegistrationDocumentUploadWidget(
                                    name: 'Article of Associations (AoA)',
                                    filename: StorageValues.gstFreshRegCompany,
                                    recID: recordId ?? "",
                                  ),
                                  SizedBox(height: 2.0),
                                  GstRegistrationDocumentUploadWidget(
                                    name:
                                        'Company Latest month electricity bill',
                                    filename: StorageValues.gstFreshRegCompany,
                                    recID: recordId ?? "",
                                  ),
                                  SizedBox(height: 2.0),
                                  GstRegistrationDocumentUploadWidget(
                                    name: 'Company Rental Deed - pdf',
                                    info: 'for rented premises',
                                    filename: StorageValues.gstFreshRegCompany,
                                    recID: recordId ?? "",
                                  ),
                                  SizedBox(height: 2.0),
                                  GstRegistrationDocumentUploadWidget(
                                    name: 'Registered Company Address Proof',
                                    filename: StorageValues.gstFreshRegCompany,
                                    recID: recordId ?? "",
                                  ),
                                  SizedBox(height: 2.0),
                                  GstRegistrationDocumentUploadWidget(
                                    name: 'Board of Resolution document',
                                    filename: StorageValues.gstFreshRegCompany,
                                    recID: recordId ?? "",
                                  ),

                                  SizedBox(height: 8.0),

                                  Text("*upload Director documents",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),

                                  SizedBox(height: 8.0),
                                  GstRegistrationDocumentUploadWidget(
                                    name: 'Aadhar Card',
                                    filename: StorageValues.gstFreshRegCompany,
                                    recID: recordId ?? "",
                                  ),
                                  //SizedBox(height: 2.0),
                                  GstRegistrationDocumentUploadWidget(
                                    name: 'Pan Card',
                                    filename: StorageValues.gstFreshRegCompany,
                                    recID: recordId ?? "",
                                  ),
                                  //SizedBox(height: 2.0),
                                  GstRegistrationDocumentUploadWidget(
                                    name: 'Passport size photo',
                                    filename: StorageValues.gstFreshRegCompany,
                                    recID: recordId ?? "",
                                  ),
                                  SizedBox(height: 2.0),
                                  GstRegistrationDocumentUploadWidget(
                                    name: 'Residential Address Proof',
                                    filename: StorageValues.gstFreshRegCompany,
                                    recID: recordId ?? "",
                                  ),
                                ],
                              ),
                            //SizedBox(height: 20.0),
                            //CustomWidgets.getActionButton(
                            //    '+ Add Director', 30.0, 15.0, () {
                            //  //add partner repeat the above partnership firm list
                            //  Navigator.pop(context);
                            //}),
                            //SizedBox(height: 20.0),
                          ],
                        ),
                      ),
            SizedBox(height: 30),
            if (isSubmited)
              Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PaymentScreen(
                                        type: 'GstFreshReg',
                                        payfor: 'GST Fresh Registration')));
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
                              width: size.width / 2,
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
                ],
              ),
            SizedBox(height: 30),
          ]),
        ),
      ),
    );
  }
}

class GstRegistrationDocumentUploadWidget extends StatefulWidget {
  final String name;
  final String? info;
  final String filename;
  final String? selectedprofession;
  final String? recID;

  const GstRegistrationDocumentUploadWidget(
      {Key? key,
      required this.name,
      this.info,
      required this.filename,
      this.selectedprofession,
      required this.recID})
      : super(key: key);

  @override
  _GstRegistrationDocumentUploadWidgetState createState() =>
      _GstRegistrationDocumentUploadWidgetState();
}

class _GstRegistrationDocumentUploadWidgetState
    extends State<GstRegistrationDocumentUploadWidget> {
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
      // prod
      final dio = Dio();
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? id = sharedPreferences.getString(StorageValues.leadId);
      String? instanceUrl =
          sharedPreferences.getString(StorageValues.instanceUrl);
      final response = await dio.post(
          '$instanceUrl/services/apexrest/fluttermediafiledetail/uploadFile?title=${widget.name}&pathOnClient=${widget.name + '.' + filetype}&leadId=$id&type=GstReg&recordId=${widget.recID}&profession=${widget.selectedprofession}',
          data: base64Image,
          options: Options(headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'Bearer ${sharedPreferences.getString(StorageValues.accessToken)}',
            //"leadId": id, // lead id
            //"profession": widget
            //    .selectedprofession, // sallary / bussiness radio button selection
            //"title": widget.name, //file name_type of file
            //"type": 'GstReg', // type of loan
            //"pathOnClient": widget.name + '.' + filetype,
            //"recordId": widget.recID
            //"filetype": filetype //image type (png/jpg)
          }));
      //sandbox testing
      //final dio = Dio();
      //SharedPreferences sharedPreferences =
      //    await SharedPreferences.getInstance();
      //String? id = '00Q0p0000026C8FEAU';
      //String? token =
      //    '00D0p0000000O08!AQcAQDInUqVzgUoffEh8pb8wTMvcWbZSwLd.hFxlZOtl_CEVIygwxDbFh0cmhwxT8WVNmo8hdGng6yr9Kk1z0tmVDLMgmjRd';
      ////String? instanceUrl =
      ////  sharedPreferences.getString(StorageValues.instanceUrl);
      //final response = await dio.post(
      //    "https://fintechfilingsfinancialservices2--devorg.my.salesforce.com/services/apexrest/fluttermediafiledetail/uploadFile",
      //    data: base64Image,
      //    options: Options(headers: {
      //      HttpHeaders.acceptHeader: 'application/json',
      //      HttpHeaders.authorizationHeader: 'Bearer $token',
      //      "leadid": id, // lead id
      //      //"Profession": widget
      //      //  .selectedprofession, // sallary / bussiness radio button selection
      //      "Title": widget.name, //file name_type of file
      //      "Type": 'GstReg', // type of loan
      //      "PathOnClient": widget.name + '.' + filetype,
      //      "recordId": widget.recID
      //      //"filetype": filetype //image type (png/jpg)
      //    }));
      print(response.statusCode);
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        final result = jsonDecode(response.data);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Upload Successfull")));
        print(result);
        //debugPrint(widget.recID);

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

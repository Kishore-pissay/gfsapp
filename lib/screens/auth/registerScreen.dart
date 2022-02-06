import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global/Shared/colors.dart';
import 'package:global/Shared/customTextField.dart';
import 'package:global/Shared/customWidgets.dart';
import 'package:global/screens/auth/forgotEmailScreen.dart';
import 'package:global/screens/auth/registerOtpScreen.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _dobController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _cpasswordController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();
  TextEditingController _cityController = new TextEditingController();
  TextEditingController _stateController = new TextEditingController();
  TextEditingController _zipController = new TextEditingController();
  TextEditingController _aadharController = new TextEditingController();
  TextEditingController _panCardController = new TextEditingController();
  TextEditingController _referedByController = new TextEditingController();
  TextEditingController _optionController = new TextEditingController();
  String? serviceValue;
  String? optionValue;
  bool value = false;
  static List<ServicesModel> _servicesList = [
    ServicesModel(id: 1, name: "GST Returns"),
    ServicesModel(id: 2, name: "Income Tax Returns"),
    ServicesModel(id: 3, name: "TDS Returns"),
    ServicesModel(id: 4, name: "ROC Returns"),
    ServicesModel(id: 5, name: "Registrations"),
    ServicesModel(id: 6, name: "Loans"),
    ServicesModel(id: 7, name: "Tally Book Keeping"),
    ServicesModel(id: 8, name: "Cibil"),
    ServicesModel(id: 9, name: "Insurance"),
    ServicesModel(id: 10, name: "Investments")
  ];
  final _items = _servicesList
      .map((service) => MultiSelectItem<ServicesModel?>(service, service.name!))
      .toList();
  List<String> _selectedServicesModels = [];

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime selectedDate = DateTime.now().subtract(Duration(days: 1));
  String? formattedDate;
  final f = new DateFormat('MM/dd/yyyy');

  Future<void> sendOTP() async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        status: "Sending OTP...",
        indicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ));
    String? accessToken;
    String? instanceUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString("accessToken");
    instanceUrl = prefs.getString("instanceUrl");
    print(accessToken);
    print(_emailController.text);
    print(_passwordController.text);
    Dio dio = Dio();
    final response = await dio.post(
      '$instanceUrl/services/apexrest/flutter/sendotp',
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
            'emailid': _emailController.text,
          }),
    );
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      final result = jsonDecode(response.data);
      final data = ResetModel.fromJson(result);
      if (data.recordId == "OTP has been sent to the email address.") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RegisterOTPScreen(
                      name: _nameController.text,
                      phone: _phoneNumberController.text,
                      email: _emailController.text,
                      dob: f.format(selectedDate),
                      password: _passwordController.text,
                      address: _addressController.text,
                      city: _cityController.text,
                      postal: _zipController.text,
                      state: _stateController.text,
                      aadhar: _aadharController.text,
                      pan: _panCardController.text,
                      services: _selectedServicesModels,
                      reference: _referedByController.text,
                      occupation: _optionController.text,
                    )));
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

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  EdgeInsetsGeometry getPadding(Size size) {
    if (size.width > 900) {
      return EdgeInsets.symmetric(horizontal: size.width * 0.3);
    } else if (size.width > 600 && size.width < 900) {
      return EdgeInsets.symmetric(horizontal: size.width * 0.2);
    } else {
      return EdgeInsets.symmetric(horizontal: size.width * 0.1);
    }
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        builder: (context, widget) => Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.teal,
                primaryColorDark: Colors.teal,
                accentColor: Colors.teal,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: widget!),
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime.now().subtract(Duration(days: 1)));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat.yMMMd().format(selectedDate);
        _dobController.text = formattedDate!;
      });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: CustomWidgets.getAppBar(),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: AssetImage('assets/images/wbacground.jpg'),
                ),
              ),
            ),
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                child: Padding(
                  padding: getPadding(size),
                  child: Column(
                    children: [
                      Text('Welcome on board',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w500)),
                      SizedBox(height: 20.0),
                      Text('Please fill in all the details to register',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500)),
                      SizedBox(height: 20.0),
                      CustomTextField(
                          validateWith: Validator.nameValidator,
                          hint: 'Enter full name',
                          readonly: false,
                          controller: _nameController),
                      CustomTextField(
                          maxCount: 10,
                          maxLines: 1,
                          validateWith: Validator.phoneValidator,
                          formatters: [FilteringTextInputFormatter.digitsOnly],
                          keyboardType: TextInputType.phone,
                          hint: 'Enter mobile number',
                          readonly: false,
                          controller: _phoneNumberController),
                      CustomTextField(
                          validateWith: Validator.emailValidator,
                          hint: 'Enter email id',
                          readonly: false,
                          controller: _emailController),
                      // CustomTextField(
                      //     validateWith: Validator.nameValidator,
                      //     onTap: () {
                      //       selectDate(context);
                      //     },
                      //     hint: 'Enter date of birth',
                      //     readonly: true,
                      //     controller: _dobController),
                      PasswordField(
                          hintText: 'Select password',
                          validateWith: Validator.passWordValidator,
                          controller: _passwordController),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: PasswordField(
                            hintText: 'Confirm password',
                            validateWith: Validator.passWordValidator,
                            controller: _cpasswordController),
                      ),
                      // CustomTextField(
                      //     validateWith: Validator.addressValidator,
                      //     maxLines: 5,
                      //     hint: 'Full Address',
                      //     readonly: false,
                      //     controller: _addressController),
                      CustomTextField(
                          validateWith: Validator.cityValidator,
                          hint: 'Enter city',
                          readonly: false,
                          controller: _cityController),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     SizedBox(
                      //       width: size.width / 2 - 24.0,
                      //       child: CustomTextField(
                      //           validateWith: Validator.stateValidator,
                      //           hint: 'Enter state',
                      //           maxLines: 1,
                      //           readonly: false,
                      //           controller: _stateController),
                      //     ),
                      //     SizedBox(
                      //       width: size.width / 2 - 24.0,
                      //       child: CustomTextField(
                      //           maxLines: 1,
                      //           maxCount: 6,
                      //           validateWith: Validator.postalCodeValidator,
                      //           keyboardType: TextInputType.number,
                      //           formatters: [
                      //             FilteringTextInputFormatter.digitsOnly
                      //           ],
                      //           hint: 'Postal Code',
                      //           readonly: false,
                      //           controller: _zipController),
                      //     ),
                      //   ],
                      // ),
                      // CustomTextField(
                      //     formatters: [
                      //       FilteringTextInputFormatter.digitsOnly,
                      //       new CustomInputFormatter()
                      //     ],
                      //     validateWith: Validator.aadharCardNumberValidator,
                      //     maxCount: 14,
                      //     maxLines: 1,
                      //     keyboardType: TextInputType.phone,
                      //     hint: 'Enter aadhar number',
                      //     readonly: false,
                      //     controller: _aadharController),
                      // CustomTextField(
                      //     validateWith: Validator.panCardNumberValidator,
                      //     hint: 'Enter pancard number',
                      //     textCapitalization: TextCapitalization.characters,
                      //     formatters: [UpperCaseTextFormatter()],
                      //     maxCount: 10,
                      //     maxLines: 1,
                      //     readonly: false,
                      //     controller: _panCardController),
                      MultiSelectDialogField(
                        items: _items,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colors.black.withOpacity(0.4),
                            width: 1.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                        buttonText: Text("Select Services",
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize: 16.0)),
                        onConfirm: (List<ServicesModel?> results) {
                          _selectedServicesModels.clear();
                          for (int i = 0; i < results.length; i++) {
                            _selectedServicesModels.add(results[i]!.name!);
                          }
                        },
                      ),
                      SizedBox(height: 20.0),
                      CustomTextField(
                          hint: 'Reference /Channel patner',
                          readonly: false,
                          controller: _referedByController),
                      AppDropdownInput(
                        hintText: "Select Occupation ",
                        options: [
                          "Business",
                          "Salaried",
                          "Doctor",
                          "Engineer",
                          "Advocate",
                          "Chattered Accountant",
                          "Consultant",
                          "Contractor"
                        ],
                        value: optionValue,
                        onChanged: (String? value) {
                          setState(() {
                            this.optionValue = value;
                            _optionController.text = value!;
                          });
                        },
                        getLabel: (String value) => value,
                      ),
                      SizedBox(height: 10.0),
                      Row(children: [
                        Checkbox(
                          value: this.value,
                          onChanged: (bool? v) {
                            setState(() {
                              value = v!;
                            });
                          },
                        ),
                        Flexible(
                          child: Text(
                              'I accept to share my personal and financial information to Global Financial Services'),
                        )
                      ]),
                      SizedBox(height: 10.0),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomWidgets.getActionButton('Register', 20.0, () {
                              if (_formKey.currentState!.validate()) {
                                if (value) {
                                  sendOTP();
                                } else {
                                  Fluttertoast.showToast(
                                      msg: 'Accept the condition to register');
                                }
                                print(f.format(selectedDate));
                              } else {
                                print(f.format(selectedDate));
                                Fluttertoast.showToast(
                                    backgroundColor: Colors.grey,
                                    msg: "Please fill all the fields");
                              }
                            }),
                            CustomWidgets.getActionButton('Cancel', 20.0, () {
                              Navigator.pop(context);
                            })
                          ]),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account?',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500)),
                          SizedBox(width: 10.0),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text('Login',
                                style: TextStyle(
                                    color: AppColors.kPrimaryColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      SizedBox(height: 40.0)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class ServicesModel {
  final int? id;
  final String? name;

  ServicesModel({
    this.id,
    this.name,
  });
}

class CustomInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = new StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: new TextSelection.collapsed(offset: string.length));
  }
}

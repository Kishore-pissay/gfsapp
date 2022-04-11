import 'dart:convert';
import 'dart:io';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global/Shared/customTextField.dart';
import 'package:global/Shared/customWidgets.dart';
import 'package:global/model/loginModelClass.dart';
import 'package:global/screens/auth/forgotEmailScreen.dart';
import 'package:global/screens/home/mainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> _logInFormKey = GlobalKey<FormState>();

  Future<LogInModelClass?> login() async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        status: "Verifying...",
        indicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ));
    String? accessToken;
    String? instanceUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(StorageValues.accessToken);
    instanceUrl = prefs.getString(StorageValues.instanceUrl);
    Dio dio = Dio();
    final response = await dio.get(
      "$instanceUrl/services/apexrest/flutter/login",
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
            'password': _passwordController.text,
            'emailid': _emailController.text,
          }),
    );
    print(response.statusCode);
    print(response.data);
    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      final result = jsonDecode(response.data);
      List<LogInModelClass> auth = [];
      auth.add(LogInModelClass.fromJson(result));
      if (auth[0].recordId == null) {
        print(response.data);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(StorageValues.username, auth[0].recordInfo!.lastName!);
        prefs.setString(StorageValues.leadId, auth[0].recordInfo!.id!);
        prefs.setString(StorageValues.email, auth[0].recordInfo!.email!);
        prefs.setString(StorageValues.mobile, auth[0].recordInfo!.phone!);
        //prefs.setString(StorageValues.pan, auth[0].recordInfo!.panNumberC!);
        //prefs.setString(
        //  StorageValues.aadhar, auth[0].recordInfo!.aadharNumberC!);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      } else {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                  title: Text(auth[0].recordId.toString(),
                      textAlign: TextAlign.center));
            });
      }
    } else {
      print(response.statusCode);
      debugPrint("Auth Failed");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: CustomWidgets.getAppBar(),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: _logInFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SizedBox(height: size.height * 0.1),
                      Text('Login Page',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w500)),
                      SizedBox(height: 20.0),
                      Text('Please fill the details to login',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500)),
                      SizedBox(height: size.height * 0.1),
                      CustomTextField(
                          validateWith: Validator.emailValidator,
                          hint: 'Enter your email',
                          readonly: false,
                          controller: _emailController),
                      CustomTextField(
                          validateWith: Validator.passWordValidator,
                          hint: 'Enter password',
                          readonly: false,
                          controller: _passwordController),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          child: Text('Forgot Password ?'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotEmailScreen()));
                          },
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CustomWidgets.getActionButton('Login', 20.0, () {
                              if (FocusScope.of(context).hasFocus)
                                FocusScope.of(context).unfocus();
                              if (_logInFormKey.currentState!.validate()) {
                                login();
                              } else {}
                            }),
                            CustomWidgets.getActionButton('Cancel', 20.0, () {
                              Navigator.pop(context);
                            })
                          ]),
                      SizedBox(height: 70.0),
                      CustomWidgets.getLoginCarousel()
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

class StorageValues {
  static String accessToken = "accessToken";
  static String leadId = "leadId";
  static String username = "username";
  static String instanceUrl = "instanceUrl";
  static String email = "email";
  static String mobile = "mobile";
  static String pan = "pan";
  static String aadhar = "aadhar";
  static String kyc = "KYC";
  static String loanProposalsA = "HomeloanProposals-Applicant";
  static String loanProposalsCA = "HomeloanProposals-Co-Applicant";
  static String eduLoanProposals = "eduLoanProposals-Applicant";
  static String autoLoanProposals = "automobileLoanProposales-Applicant";
  static String mudraLoanProposals = 'mudraLoanProposals-Applicant';
  static String personalLoanProposals = 'personalLaonProposals-Applicant';
  static String msmeLoanProposals = 'msmeLaonProposals-Applicant';
  static String gstFreshRegBusiness = 'GstFreshRegistration-Business';
  static String gstFreshRegFirm = 'GstFreshRegistration-PartnershipFirm';
  static String gstFreshRegCompany = 'GstFreshRegistration-PvtLtdCompany';
  static String udyamiRegBusiness = 'UdyamiRegistration-Business';
  static String udyamiRegFirm = 'UdyamiRegistration-PartnershipFirm';
  static String udyamiRegCompany = 'UdyamiRegistration-PvtLtdCompany';
  static String partFirmReg = 'PartnershipFirmRegistration';
  static String pvtLtdCompReg = 'PrivateLimitedCompanyRegistration';
  static String pfStatementA = "pfStatement-Applicant";
  static String pfStatementCA = "pfStatement-Co-Applicant";
  static String itra = "ITR-Applicant";
  static String itrca = "ITR-Co-Applicant";
  static String loanStatus = "loanStatus";
  static String gstReturns = "gstReturns";
  static String rocReturns = "rocReturns";
  static String electricityBill = "ElectricityBill";
  static String gasBill = "GasBill";
  static String insuranceDoc = "InsuranceDocument";
  static String homeLoan25to75 = "25 lakhs to 75 lakhs";
  static String homeLoan75to150 = "75 lakhs to 150 lakhs";
  static String msmeLoan10to100 = "10 lakhs to 100 lakhs";
  static String msmeLoan100to500 = "100 lakhs to 500 lakhs";
}

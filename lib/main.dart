import 'dart:async';
import 'package:flutter/material.dart';
import 'package:global/Shared/routes.dart';
import 'package:global/screens/auth/forgotEmailScreen.dart';
import 'package:global/screens/auth/forgotOtpScreen.dart';
import 'package:global/screens/auth/logInScreen.dart';
import 'package:global/screens/auth/registerScreen.dart';
import 'package:global/screens/home/ewalletScreen.dart';
import 'package:global/screens/home/finAdv.dart';
import 'package:global/screens/home/gstFilingScreen.dart';
import 'package:global/screens/home/homeLoan.dart';
import 'package:global/screens/home/itr.dart';
import 'package:global/screens/home/loans/autoLoan.dart';
import 'package:global/screens/home/loans/educationLoan.dart';
import 'package:global/screens/home/loans/msmeFreshLoan.dart';
import 'package:global/screens/home/loans/personalLoan.dart';
import 'package:global/screens/home/mainScreen.dart';
import 'package:global/screens/home/payment/paymentScreen.dart';
import 'package:global/screens/splash.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:global/screens/splashScreen.dart';
import 'core/data/servicesList.dart';

Timer? timer;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  timer = Timer.periodic(
      Duration(minutes: 30), (Timer t) => ServiceList.refreshToken());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: CustomRoutes.splash,
      // onGenerateRoute: RouteGenerator.generateRoute,
      routes: {
        CustomRoutes.splash: (context) => Splash(),
        CustomRoutes.splashScreen: (context) => SplashScreen(),
        CustomRoutes.logIn: (context) => LogInScreen(),
        CustomRoutes.signup: (context) => RegisterScreen(),
        CustomRoutes.forgototp: (context) => ForgotOTPScreen(),
        CustomRoutes.forgotpassword: (context) => ForgotEmailScreen(),
        CustomRoutes.home: (context) => MainScreen(),
        CustomRoutes.gstBilling: (context) => GSTFilingScreen(),
        CustomRoutes.incomeTaxReturns: (context) => ItrFiling(),
        CustomRoutes.financialAdvices: (context) => FinAdv(),
        CustomRoutes.ewalletScreen: (context) => EWalletScreen(),
        CustomRoutes.homeloan: (context) => HomeLoan(),
        CustomRoutes.educationloan: (context) => EducationLoan(),
        CustomRoutes.automobileloan: (context) => AutoLoan(),
        CustomRoutes.msmeloan: (context) => MsmeLoan(),
        CustomRoutes.personaloan: (context) => PersonalLoan(),
        CustomRoutes.loanAdvisory: (context) =>
            PaymentScreen(type: "", payfor: ""),
        CustomRoutes.gstFreshRegistration: (context) => EWalletScreen(),
      },
      builder: EasyLoading.init(),
      theme: ThemeData(primarySwatch: Colors.blue),
      // home: Splash(),
    );
  }
}

class HomePage extends StatelessWidget {
  final Widget child;

  const HomePage({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
    );
  }
}

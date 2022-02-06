import 'package:flutter/material.dart';
import 'package:global/screens/splash.dart';
import 'package:global/screens/auth/forgotEmailScreen.dart';
import 'package:global/screens/auth/forgotOtpScreen.dart';
import 'package:global/screens/auth/logInScreen.dart';
import 'package:global/screens/auth/registerScreen.dart';
import 'package:global/screens/splashScreen.dart';

class CustomRoutes {
  static const String splash = '/splash';
  static const String splashScreen = '/welcome';

  static const String logIn = '/login';
  static const String signup = '/signup';
  static const String forgototp = '/forgotOTP';
  static const String forgotpassword = '/forgotpassword';

  static const String mainScreen = '/home';
  static const String home = '/Home';
  static const String gstBilling = '/GST&Billing';
  static const String incomeTaxReturns = '/IncomeTaxReturns';
  static const String financialAdvices = '/FinancialAdvisor';
  static const String ewalletScreen = '/ewallet';
  static const String homeloan = '/homeloan';
  static const String educationloan = '/educationloan';
  static const String automobileloan = '/automobileloan';
  static const String msmeloan = '/msmeloan';
  static const String personaloan = '/personalloan';
  static const String loanAdvisory = '/loanAdvisory';
  static const String gstFreshRegistration = '/GSTFreshRegistration';
  static const String patnershipFirmRegistration =
      '/PatnershipFirmRegistration';
  static const String pvtLtdRegistration = '/pvtLtdRegistration';
  static const String udayamRegistration = '/UdayamRegistration';
}

class _GeneratePageRoute extends PageRouteBuilder {
  final Widget? widget;
  final String? routeName;
  _GeneratePageRoute({this.widget, this.routeName})
      : super(
            settings: RouteSettings(name: routeName),
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return widget!;
            },
            transitionDuration: Duration(milliseconds: 500),
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              return SlideTransition(
                textDirection: TextDirection.rtl,
                position: Tween<Offset>(
                  begin: Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            });
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings gfsRoute) {
    switch (gfsRoute.name) {
      case CustomRoutes.splash:
        return _GeneratePageRoute(widget: Splash(), routeName: gfsRoute.name);
      case CustomRoutes.splashScreen:
        return _GeneratePageRoute(
            widget: SplashScreen(), routeName: gfsRoute.name);
      case CustomRoutes.logIn:
        return _GeneratePageRoute(
            widget: LogInScreen(), routeName: gfsRoute.name);
      case CustomRoutes.signup:
        return _GeneratePageRoute(
            widget: RegisterScreen(), routeName: gfsRoute.name);
      case CustomRoutes.forgotpassword:
        return _GeneratePageRoute(
            widget: ForgotEmailScreen(), routeName: gfsRoute.name);
      case CustomRoutes.forgototp:
        return _GeneratePageRoute(
            widget: ForgotOTPScreen(), routeName: gfsRoute.name);
      default:
        return _GeneratePageRoute(widget: Splash(), routeName: gfsRoute.name);
    }
  }
}

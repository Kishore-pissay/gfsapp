import 'package:flutter/material.dart';
import 'package:global/Shared/customWidgets.dart';
import 'package:global/screens/auth/logInScreen.dart';
import 'package:global/screens/auth/registerScreen.dart';
import 'package:marquee/marquee.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/LoginBg.jpg"))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Text('Welcome\nto',
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 30.0,
            //         fontWeight: FontWeight.w500)),
            // SizedBox(height: 10.0),
            // RichText(
            //     text: TextSpan(children: [
            //   TextSpan(
            //       text: ('A'),
            //       style: TextStyle(
            //         fontFamily: 'Algeria',
            //         fontSize: 40.0,
            //         color: Colors.black,
            //       )),
            //   TextSpan(
            //       text: ('utomation  of '),
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 16.0,
            //         fontStyle: FontStyle.italic,
            //       )),
            //   TextSpan(
            //       text: ('A'),
            //       style: TextStyle(
            //         fontFamily: 'Algeria',
            //         fontSize: 40.0,
            //         color: Colors.black,
            //       )),
            //   TextSpan(
            //       text: ('ccounting & '),
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 16.0,
            //         fontStyle: FontStyle.italic,
            //       )),
            //   TextSpan(
            //       text: ('A'),
            //       style: TextStyle(
            //         fontFamily: 'Algeria',
            //         fontSize: 40.0,
            //         color: Colors.black,
            //       )),
            //   TextSpan(
            //       text: ('udits'),
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 16.0,
            //         fontStyle: FontStyle.italic,
            //       ))
            // ])),
            // Text('Scientific way of accounting',
            //     textAlign: TextAlign.center,
            //     style: TextStyle(
            //         fontStyle: FontStyle.italic,
            //         color: Colors.black,
            //         fontSize: 20.0,
            //         fontWeight: FontWeight.w500)),
            Spacer(), Spacer(), Spacer(),
            CustomWidgets.getActionButton('SignIn', 20.0, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LogInScreen()));
            }),
            SizedBox(height: 30.0),
            CustomWidgets.getActionButton('SignUp', 20.0, () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()));
            }),
            Spacer(),
            SizedBox(child: Image.asset('assets/images/Logo.png')),
            SizedBox(height: 20.0),
            // Container(
            //   margin: const EdgeInsets.symmetric(vertical: 4.0),
            //   padding: EdgeInsets.symmetric(vertical: 4.0),
            //   color: Colors.green,
            //   height: 30.0,
            //   child: Marquee(
            //     text: 'Global Financial Services',
            //     style: TextStyle(
            //         fontStyle: FontStyle.italic,
            //         fontSize: 20.0,
            //         fontWeight: FontWeight.w500),
            //     scrollAxis: Axis.horizontal,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     blankSpace: 20.0,
            //     velocity: 100.0,
            //     pauseAfterRound: Duration(seconds: 1),
            //     startPadding: 10.0,
            //     accelerationDuration: Duration(seconds: 1),
            //     accelerationCurve: Curves.linear,
            //     decelerationDuration: Duration(milliseconds: 500),
            //     decelerationCurve: Curves.easeOut,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

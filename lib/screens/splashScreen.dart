import 'package:flutter/material.dart';
import 'package:global/Shared/customWidgets.dart';
import 'package:global/Shared/routes.dart';
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
            image: AssetImage('assets/images/splashbg.jpg'),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(CustomRoutes.logIn);
                        },
                        child: Container(
                          width: size.width * 0.2,
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Sign In".toUpperCase(),
                            style: TextStyle(
                              color: Color(0xFF2596BE),
                              fontSize: 20.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(2.0, 2.0),
                                blurRadius: 2.0,
                              )
                            ],
                            border: Border.all(width: 1.0, color: Colors.white),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(CustomRoutes.signup);
                        },
                        child: Container(
                          width: size.width * 0.2,
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          alignment: Alignment.center,
                          child: Text(
                            "Sign Up".toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(width: 4.0, color: Colors.white),
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

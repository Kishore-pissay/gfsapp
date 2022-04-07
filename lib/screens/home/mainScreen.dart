import 'package:flutter/material.dart';
import 'package:fintechfilings/Shared/customWidgets.dart';
import 'package:fintechfilings/screens/auth/logInScreen.dart';
import 'package:fintechfilings/screens/home/notificationsScreen.dart';
import 'package:fintechfilings/screens/home/profileScreen.dart';
import 'package:fintechfilings/screens/home/serviceScreen.dart';
import 'package:fintechfilings/screens/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../my_flutter_app_icons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget _pages(int index) {
    if (index == 0) {
      return ServiceScreen();
    } else if (index == 1) {
      return NotificationsScreen();
    } else if (index == 2) {
      return ProfileScreen();
    }
    return ServiceScreen();
  }

  showPopup(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            title: Column(
              children: [
                Text('Are you sure you want to exit/logout?',
                    textAlign: TextAlign.center),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomWidgets.getActionButton('Confirm', 16.0, () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Splash()),
                          (route) => false);
                    }),
                    CustomWidgets.getActionButton('Cancel', 16.0, () {
                      Navigator.pop(context);
                    })
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.getAppBar(),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hello,',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                  FutureBuilder(
                      future: SharedPreferences.getInstance(),
                      builder: (ctx, AsyncSnapshot<SharedPreferences> snap) {
                        if (snap.hasData) {
                          String? userName =
                              snap.data!.getString(StorageValues.username);
                          return Text(userName ?? 'Username',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500));
                        } else {
                          return Text('Username',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500));
                        }
                      })
                ],
              ),
              RotationTransition(
                turns: new AlwaysStoppedAnimation(270 / 360),
                child: IconButton(
                    icon: Icon(MyFlutterApp.logout, size: 20.0),
                    onPressed: () {
                      showPopup(context);
                    }),
              )
            ],
          ),
        ),
        Expanded(child: _pages(currentIndex))
      ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 20.0, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_add, size: 20.0, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 20.0, color: Colors.black),
            label: 'Home',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.calculate, size: 20.0, color: Colors.black),
          //   label: 'Home',
          // ),
        ],
      ),
    );
  }
}

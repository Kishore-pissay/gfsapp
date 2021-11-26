import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:global/Shared/customWidgets.dart';
import 'package:global/my_flutter_app_icons.dart';
import 'package:global/screens/home/ewalletScreen.dart';
import 'package:global/screens/home/finAdv.dart';
import 'package:global/screens/home/gstFilingScreen.dart';
import 'package:global/screens/home/itr.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  ScrollController scrollController = new ScrollController();
  IconData getIcons(index) {
    if (index == 0) {
      return MyFlutterApp.assignment;
    } else if (index == 1) {
      return MyFlutterApp.rupee;
    } else if (index == 2) {
      return MyFlutterApp.chart_line;
    } else if (index == 3) {
      return MyFlutterApp.edit;
    } else if (index == 4) {
      return MyFlutterApp.account_balance;
    } else if (index == 5) {
      return MyFlutterApp.edit;
    } else if (index == 6) {
      return MyFlutterApp.account_box;
    } else if (index == 7) {
      return MyFlutterApp.assignment_turned_in;
    } else if (index == 8) {
      return MyFlutterApp.percent;
    } else if (index == 9) {
      return MyFlutterApp.account_balance_wallet;
    } else if (index == 10) {
      return MyFlutterApp.file_signature;
    } else {
      return MyFlutterApp.pencil_1;
    }
  }

  String getServiceNames(index) {
    if (index == 0) {
      return 'GST & Billing';
    } else if (index == 1) {
      return 'Income Tax Returns';
    } else if (index == 2) {
      return 'TDS & TCS Returns';
    } else if (index == 3) {
      return 'ROC';
    } else if (index == 4) {
      return 'Loans';
    } else if (index == 5) {
      return 'Registrations';
    } else if (index == 6) {
      return 'Financial Advisor';
    } else if (index == 7) {
      return 'Insurance';
    } else if (index == 8) {
      return 'Investment';
    } else if (index == 9) {
      return 'E-Wallet';
    } else if (index == 10) {
      return 'Tally Book Keeping';
    } else {
      return 'Credit & Debit Vochers Preparations';
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Services',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: GridView.builder(
                controller: scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if (index == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GSTFilingScreen()));
                      } else if (index == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ItrFiling()));
                      } //else if (index == 2) {
                      ////tds returns
                      //Navigator.push(
                      //    context,
                      //    MaterialPageRoute(
                      //        builder: (context) => GSTFilingScreen()));
                      //} //else if (index == 3) {
                      ////Roc returns
                      //Navigator.push(
                      //    context,
                      //    MaterialPageRoute(
                      //        builder: (context) => GSTFilingScreen()));
                      //}
                      else if (index == 4) {
                        CustomWidgets.showLoansPopup(context, size);
                      } else if (index == 5) {
                        CustomWidgets.showRegistrationsPopup(context, size);
                      } else if (index == 6) {
                        //Fnancial advisor
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => FinAdv()));
                      } else if (index == 9) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EWalletScreen()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Under Development')));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(6.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                  .toInt())
                              .withOpacity(0.2)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(getIcons(index),
                              size: 30.0, color: Colors.black),
                          Text(getServiceNames(index),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w500))
                        ],
                      ),
                    ),
                  );
                },
                itemCount: 12),
          ),
        ],
      ),
    ));
  }
}

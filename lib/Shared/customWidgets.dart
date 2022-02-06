import 'package:flutter/material.dart';
import 'package:global/Shared/colors.dart';
import 'dart:math' as math;
import 'package:global/screens/home/loans/homeLoan.dart';
import 'package:global/screens/home/loans/autoLoan.dart';
import 'package:global/screens/home/loans/educationLoan.dart';
import 'package:global/screens/home/loans/msmeFreshLoan.dart';
import 'package:global/screens/home/loans/personalLoan.dart';
import 'package:global/screens/home/payment/paymentScreen.dart';
import 'package:global/screens/home/registrations/gstFreshReg.dart';
import 'package:global/screens/home/registrations/pLCompReg.dart';
import 'package:global/screens/home/registrations/partFirmReg.dart';
import 'package:global/screens/home/registrations/udyamiReg.dart';

class CustomWidgets {
  static getActionButton(String text, double fontSize, void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Text(text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w500)),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(2.0, 2.0),
                  blurRadius: 2.0,
                )
              ],
              border: Border.all(width: 1.0, color: Colors.white),
              color: AppColors.kPrimaryColor,
              borderRadius: BorderRadius.circular(10))),
    );
  }

  static getAppBar() {
    return PreferredSize(
      preferredSize: Size(double.infinity, 70.0),
      child: AppBar(
        elevation: 0.0,
        backgroundColor: AppColors.kPrimaryColor,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 60.0,
              child: Image.asset('assets/images/newLogo.png'),
            ),
            // SizedBox(width: 10.0),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Text(
            //       'Fintech Filings',
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 22.0,
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //     Text(
            //       'Automation of Statutory Filings',
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 12.0,
            //         fontWeight: FontWeight.w500,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  static showLoansPopup(BuildContext context, Size size) {
    String getImages(index) {
      if (index == 0) {
        return 'assets/images/hl.png';
      } else if (index == 1) {
        return 'assets/images/el.png';
      } else if (index == 2) {
        return 'assets/images/al.png';
      } else if (index == 3) {
        return 'assets/images/msme1.png';
      } else if (index == 4) {
        return 'assets/images/msme2.png';
      } else {
        return 'assets/images/user.png';
      }
    }

    String getLoanNames(index) {
      if (index == 0) {
        return 'Home Loan';
      } else if (index == 1) {
        return 'Education Loan';
      } else if (index == 2) {
        return 'Automobile Loan';
      } else if (index == 3) {
        return 'MSME Loan';
      } else if (index == 4) {
        return 'Personal Loan';
      } else {
        return 'Loan Advisory';
      }
    }

    double getWidth() {
      if (size.width > 900) {
        return size.width * 0.4;
      } else if (size.width > 600 && size.width < 900) {
        return size.width * 0.6;
      } else {
        return size.width * 0.8;
      }
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              titlePadding: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Container(
                height: size.height * 0.4,
                width: getWidth(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Loans',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                size.width > 900 ? size.width * 0.025 : 0.0),
                        child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: size.width > 900 ? 3 : 2),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  if (index == 0) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeLoan()));
                                  } else if (index == 1) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EducationLoan()));
                                    // education loan
                                  } else if (index == 2) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AutoLoan()));
                                    // automobile loan
                                  } else if (index == 3) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MsmeLoan()));
                                    //msme loan
                                  } else if (index == 4) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PersonalLoan()));
                                    // PersonalLoan
                                  } else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PaymentScreen(
                                                type: 'LoanAdv',
                                                payfor: 'Loan Advisory')));
                                    // Loan Advisory
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.all(6.0),
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Color((math.Random().nextDouble() *
                                                  0xFFFFFF)
                                              .toInt())
                                          .withOpacity(0.2)),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Container(
                                          height: 50,
                                          // width: 50,
                                          child: index == 5
                                              ? Icon(Icons.person)
                                              : Image.asset(getImages(index),
                                                  fit: BoxFit.cover)),
                                      // Icon(Icons.account_circle,
                                      //     size: 50, color: Colors.white),
                                      Text(getLoanNames(index),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ),
                              );
                            },
                            itemCount: 6),
                      ),
                    ],
                  ),
                ),
              ));
        });
  }

  static String getImage(Size size) {
    if (size.width > 900) {
      return 'assets/images/splashbg.jpg';
    } else if (size.width > 600 && size.width < 900) {
      return 'assets/images/bgd2.jpg';
    } else {
      return 'assets/images/bgd1.jpg';
    }
  }

  static EdgeInsetsGeometry getPadding(Size size) {
    if (size.width > 900) {
      return EdgeInsets.symmetric(horizontal: size.width * 0.3);
    } else if (size.width > 600 && size.width < 900) {
      return EdgeInsets.symmetric(horizontal: size.width * 0.2);
    } else {
      return EdgeInsets.symmetric(horizontal: size.width * 0.1);
    }
  }

  static showRegistrationsPopup(BuildContext context, Size size) {
    String getRegNames(index) {
      if (index == 0) {
        return 'GST Fresh Registration';
      } else if (index == 1) {
        return 'Partnership Firm Registration';
      } else if (index == 2) {
        return 'Pvt Ltd Company Registration';
      } else {
        return 'Udyam Registration';
      }
    }

    double getWidth() {
      if (size.width > 900) {
        return size.width * 0.3;
      } else if (size.width > 600 && size.width < 900) {
        return size.width * 0.4;
      } else {
        return size.width * 0.5;
      }
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              titlePadding: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Container(
                height: size.height * 0.4,
                width: getWidth(),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Registrations',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                      GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if (index == 0) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              GstRegistration()));
                                  //gst fresh registration
                                } else if (index == 1) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PartFirmRegistration()));
                                  // partnership firm reg
                                } else if (index == 2) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PLCompRegistration()));
                                  // pvt ltd company reg
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UdyamiRegistration()));
                                  // udyami reg
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.all(6.0),
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Color((math.Random().nextDouble() *
                                                0xFFFFFF)
                                            .toInt())
                                        .withOpacity(0.2)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    //Container(
                                    //  height: 50,
                                    // width: 50,
                                    //child: Image.asset(getImages(index),
                                    //fit: BoxFit.cover)
                                    // ),
                                    // Icon(Icons.account_circle,
                                    //     size: 50, color: Colors.white),
                                    Text(getRegNames(index),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: 4),
                    ],
                  ),
                ),
              ));
        });
  }
}

class AppDropdownInput<T> extends StatelessWidget {
  final String? hintText;
  final List<T> options;
  final T? value;
  final String Function(T) getLabel;
  final Function(T?) onChanged;

  AppDropdownInput({
    this.hintText,
    this.options = const [],
    required this.getLabel,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
      builder: (FormFieldState<T> state) {
        return InputDecorator(
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 16.0),
            contentPadding:
                new EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            focusedBorder: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(12.0),
              borderSide: BorderSide(
                width: 1.0,
                color: Colors.black.withOpacity(0.4),
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(12.0),
              borderSide: BorderSide(
                width: 1.0,
                color: Colors.black.withOpacity(0.4),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: new BorderRadius.circular(12.0),
              borderSide: BorderSide(
                width: 1.0,
                color: Colors.black.withOpacity(0.4),
              ),
            ),
          ),
          isEmpty: value == null || value == '',
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              icon: Icon(
                Icons.expand_more_outlined,
              ),
              value: value,
              isDense: true,
              onChanged: onChanged,
              items: options.map((T value) {
                return DropdownMenuItem<T>(
                  value: value,
                  child: Text(
                    getLabel(value),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class BulletPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 15.0,
      width: 15.0,
      decoration: new BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }
}

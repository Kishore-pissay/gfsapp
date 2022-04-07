import 'package:flutter/material.dart';
import 'package:fintechfilings/Shared/colors.dart';
import 'dart:math' as math;
import 'package:fintechfilings/screens/home/loans/homeLoan.dart';
import 'package:fintechfilings/screens/home/loans/autoLoan.dart';
import 'package:fintechfilings/screens/home/loans/educationLoan.dart';
import 'package:fintechfilings/screens/home/loans/msmeFreshLoan.dart';
import 'package:fintechfilings/screens/home/loans/personalLoan.dart';
import 'package:fintechfilings/screens/home/payment/paymentScreen.dart';
import 'package:fintechfilings/screens/home/registrations/gstFreshReg.dart';
import 'package:fintechfilings/screens/home/registrations/pLCompReg.dart';
import 'package:fintechfilings/screens/home/registrations/partFirmReg.dart';
import 'package:fintechfilings/screens/home/registrations/udyamiReg.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
    return AppBar(
      elevation: 0.0,
      backgroundColor: AppColors.kPrimaryColor,
      automaticallyImplyLeading: false,
      //title: Column(
      //  children: [
      //    Container(
      //      height: 40.0,
      //      child: Image.asset('assets/images/HeaderImg.png'),
      //    )
      //  ],
      //)
      title: Row(
        children: [
          Container(
            height: 40.0,
            child: Image.asset('assets/images/AppLogo.png'),
          ),
          SizedBox(width: 20.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('FINTECH FILINGS PVT LTD',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500)),
              Text('AUTOMATION OF STATUTORY FILINGS',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ],
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

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              titlePadding: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Container(
                height: size.height / 1.7,
                width: size.width / 1.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Loans',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                    Expanded(
                      child: GridView.builder(
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
              ));
        });
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

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              titlePadding: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              title: Container(
                height: size.height / 1.7,
                width: size.width / 1.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Registrations',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                    Expanded(
                      child: GridView.builder(
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
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: 4),
                    ),
                  ],
                ),
              ));
        });
  }

  static getLoginCarousel() {
    return CarouselSlider(
        items: [
          MyImageView('assets/images/carousal2.jpg'),
          MyImageView('assets/images/carousal3.jpg'),
          MyImageView('assets/images/carousal1.jpg'),
          MyImageView('assets/images/carousal4.jpg')
        ],
        options: CarouselOptions(
          height: 180.0,
          enlargeCenterPage: true,
          autoPlay: true,
          //aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          viewportFraction: 0.8,
        ));
    //CarouselSlider(
    //  items: [
    //    //1st Image of Slider
    //    Container(
    //      margin: EdgeInsets.all(6.0),
    //      decoration: BoxDecoration(
    //        borderRadius: BorderRadius.circular(8.0),
    //        image: DecorationImage(
    //          image: AssetImage('assets/images/hl.png'),
    //          fit: BoxFit.cover,
    //        ),
    //      ),
    //    ),
//
    //    //2nd Image of Slider
    //    Container(
    //      margin: EdgeInsets.all(6.0),
    //      decoration: BoxDecoration(
    //        borderRadius: BorderRadius.circular(8.0),
    //        image: DecorationImage(
    //          image: AssetImage('assets/images/msme2.png'),
    //          fit: BoxFit.cover,
    //        ),
    //      ),
    //    ),
    //  ],
    //  options: CarouselOptions(
    //    height: 180.0,
    //    enlargeCenterPage: true,
    //    autoPlay: true,
    //    //aspectRatio: 16 / 9,
    //    autoPlayCurve: Curves.fastOutSlowIn,
    //    enableInfiniteScroll: true,
    //    autoPlayAnimationDuration:
    //        Duration(milliseconds: 800),
    //    viewportFraction: 0.8,
    //  ),
    //),
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

class MyImageView extends StatelessWidget {
  String imgPath;

  MyImageView(this.imgPath);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: FittedBox(
          fit: BoxFit.cover,
          child: Image.asset(
            imgPath,
          ),
        ));
  }
}

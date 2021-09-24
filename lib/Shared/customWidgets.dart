import 'package:flutter/material.dart';
import 'package:global/Shared/colors.dart';
import 'dart:math' as math;

import 'package:global/screens/home/homeLoan.dart';

class CustomWidgets {
  static getActionButton(String text, double borderRadius, double fontSize,
      void Function()? onTap) {
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
              border: Border.all(width: 2.0, color: Colors.white),
              color: AppColors.kPrimaryColor,
              borderRadius: BorderRadius.circular(borderRadius))),
    );
  }

  static getAppBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: AppColors.kPrimaryColor,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Container(
            height: 40.0,
            child: Image.asset('assets/images/Logo.png'),
          ),
          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Global Financial Services',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w500)),
              Text('Scientific way of accounting',
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
        return 'assets/images/mudra loan.png';
      } else if (index == 4) {
        return 'assets/images/msme1.png';
      } else {
        return 'assets/images/msme2.png';
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
        return 'Mudra Loan';
      } else if (index == 4) {
        return 'MSME Loan';
      } else {
        return 'Personal Loan';
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
                // width: size.width / 1.5,
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
                                        child: Image.asset(getImages(index),
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

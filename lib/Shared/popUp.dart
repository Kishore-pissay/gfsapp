import 'package:flutter/material.dart';

class PopUpDialog extends StatelessWidget {
  final String title;

  PopUpDialog({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            backgroundColor: Colors.white,
            child: Center(
              child: Container(
                  child: Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(title, textAlign: TextAlign.center),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RaisedButton(
                            color: Colors.green[700], // background
                            textColor: Colors.white, // foreground
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: Text('Confirm'),
                          ),
                          RaisedButton(
                            color: Colors.white,
                            // background
                            textColor: Colors.white, // foreground
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: Text('Cancel'),
                          )
                        ],
                      )
                    ]),
              )),
            )),
      ],
    );
  }
}

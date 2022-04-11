import 'package:flutter/material.dart';
import 'package:global/Shared/customWidgets.dart';
import 'package:global/screens/home/payment/paymentScreen.dart';
import 'dart:math' as math;

class FinAdv extends StatefulWidget {
  const FinAdv({Key? key}) : super(key: key);
  @override
  _FinAdvState createState() => _FinAdvState();
}

class _FinAdvState extends State<FinAdv> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomWidgets.getAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Text('Financial Advisory',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                SizedBox(width: 50)
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Financial Advisory / Contact us for any queries related to Finance.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 150.0,
                  child: Image.asset('assets/images/finAdv.png'),
                ),
                SizedBox(height: 30),
              ],
            ),
            //SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      children: [
                        Text(
                            'Get the right advice at the right time from our 20 years plus experienced Accountant.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 10),
                        //Text(
                        //    'Please proceed with the subscribe button and we shall call you with the in person appointment else a video conference and find a solution for all your financial problems or quries or stuck with any problem regarding money.',
                        //    textAlign: TextAlign.center,
                        //    style: TextStyle(
                        //        color: Colors.black,
                        //        fontSize: 15.0,
                        //        fontWeight: FontWeight.w500)),
                        //SizedBox(height: 10),
                        Text('Advisory only at 149 INR. And the Benefits are:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 10),
                        Column(children: <Widget>[
                          new ListTile(
                            leading: new BulletPoint(),
                            title: new Text(
                                'Not sure which loan to take and where to apply?'),
                          ),
                          SizedBox(height: 8),
                          new ListTile(
                            leading: new BulletPoint(),
                            title: new Text(
                                'stressed on managing expenses and emis?'),
                          ),
                          new ListTile(
                            leading: new BulletPoint(),
                            title: new Text('want to check on returns filing?'),
                          ),
                          SizedBox(height: 8),
                          new ListTile(
                            leading: new BulletPoint(),
                            title: new Text(
                                'Company/Firm/Partnership related issues?'),
                          ),
                          SizedBox(height: 8),
                        ]),
                        SizedBox(height: 15),
                        Text('One stop solution and a click away...',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 8),
                        Text('Click on "Subscribe and we shall contact you.',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                                type: 'FinAdv',
                                payfor: 'Financial Advisory',
                              )));
                },
                child: Container(
                    alignment: Alignment.center,
                    width: size.width / 2,
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(
                          color: Color(0xffef661a),
                          width: 1.0,
                        ),
                        color: Color(
                                (math.Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(0.2)),
                    child: Column(children: [
                      Text('Subscribe',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                    ])),
              )
            ]),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      alignment: Alignment.center,
                      width: size.width / 2,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Color(0xffef661a),
                            width: 1.0,
                          ),
                          color: Color((math.Random().nextDouble() * 0xFFFFFF)
                                  .toInt())
                              .withOpacity(0.2)),
                      child: Column(children: [
                        Text('Cancel',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                      ])),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

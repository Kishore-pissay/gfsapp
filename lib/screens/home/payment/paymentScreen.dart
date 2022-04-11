import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:global/Shared/customWidgets.dart';
import 'package:global/model/orderIdModel.dart';
import 'package:global/screens/auth/logInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentScreen extends StatefulWidget {
  final String type;
  final String payfor;
  const PaymentScreen({Key? key, required this.type, required this.payfor})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var initialize;
  //var paytype = widget.type;
  String orderId = "ORDER_ID";
  String stage = "PROD";
  String orderAmount = "ORDER_AMOUNT";
  String tokenData = "TOKEN_DATA";
  String customerName = "Customer Name";
  String orderNote = "Order_Note";
  String orderCurrency = "INR";
  String appId = "APP_ID";
  String customerPhone = "9094395340";
  String customerEmail = "sample@gmail.com";

  Future<OrderIdModel?> getOrderId() async {
    String? accessToken;
    String? instanceUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(StorageValues.accessToken);
    instanceUrl = prefs.getString(StorageValues.instanceUrl);
    Dio dio = Dio();
    final response = await dio.post(
      "$instanceUrl/services/apexrest/fluttercashfree/generateCashFreeToken",
      data: {
        "leadId": prefs.getString(StorageValues.leadId),
        //"leadId": '00Q5g000008L43CEAS',
        "paymenttype": widget.type
      },
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          }),
    );
    print(response.statusCode);
    //debugPrint(response.data);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.data);
      List<OrderIdModel> paymentDetails = [];
      paymentDetails.add(OrderIdModel.fromJson(result));
      print(paymentDetails[0]);
      if (response.data != null) {
        print(paymentDetails[0]);
        setState(() {
          tokenData = paymentDetails[0].cftoken!;
          appId = paymentDetails[0].clientId!;
          orderId = paymentDetails[0].orderId!;
          orderAmount = paymentDetails[0].orderAmount!.toString();
          orderCurrency = paymentDetails[0].orderCurrency!;
          customerName = prefs.getString(StorageValues.username)!;
          customerEmail = prefs.getString(StorageValues.email)!;
          customerPhone = prefs.getString(StorageValues.mobile)!;
        });
        return paymentDetails[0];
      } else {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                  title: Text(paymentDetails[0].message.toString(),
                      textAlign: TextAlign.center));
            });
      }
    } else {
      print(response.statusCode);

      debugPrint("Auth Failed");
      return null;
    }
  }

  initiatePayment() {
    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": widget.type,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData
    };

    print(inputParams);

    CashfreePGSDK.doPayment(inputParams)
        .then((value) => value?.forEach((key, value) {
              print("$key : $value");
            }));
  }

  @override
  void initState() {
    initialize = getOrderId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomWidgets.getAppBar(),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                Text('Payment Screen',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                SizedBox(width: 50)
              ],
            ),
            //SizedBox(height: 50),
            Text('Please proceed with the payment.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                  'On click of "Payment button" you shall initiate the payment for ' +
                      widget.payfor +
                      ' service.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ),
            SizedBox(height: 50),
            FutureBuilder(
              future: initialize,
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snap.hasData) {
                  return Center(
                      child: CustomWidgets.getActionButton(
                          'Payment', 20.0, () => initiatePayment()));
                } else {
                  return Center(child: Text("Please try again"));
                }
              },
            ),
            SizedBox(height: 30),
            CustomWidgets.getActionButton('Cancel', 20.0, () {
              Navigator.pop(context);
            }),
          ],
        ));
  }
}

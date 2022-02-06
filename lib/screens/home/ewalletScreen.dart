import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:global/Shared/customWidgets.dart';
import 'package:global/model/getAllFiles.dart';
import 'package:global/screens/auth/logInScreen.dart';
import 'package:global/screens/home/walletDocumentsScreens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../my_flutter_app_icons.dart';

class EWalletScreen extends StatefulWidget {
  const EWalletScreen({Key? key}) : super(key: key);

  @override
  _EWalletScreenState createState() => _EWalletScreenState();
}

class _EWalletScreenState extends State<EWalletScreen> {
  String getFileNames(index) {
    if (index == 0) {
      return StorageValues.kyc;
    } else if (index == 5) {
      return StorageValues.pfStatementA;
    } else if (index == 6) {
      return StorageValues.electricityBill;
    } else if (index == 7) {
      return StorageValues.gasBill;
    } else if (index == 8) {
      return StorageValues.insuranceDoc;
    } else {
      return StorageValues.loanProposalsA;
    }
  }

  bool getgetShowUploader(index) {
    if (index == 0) {
      return true;
    } else if (index == 1) {
      return false;
    } else if (index == 2) {
      return false;
    } else if (index == 3) {
      return false;
    } else if (index == 4) {
      return false;
    } else if (index == 5) {
      return true;
    } else if (index == 6) {
      return true;
    } else if (index == 7) {
      return true;
    } else if (index == 8) {
      return true;
    } else if (index == 9) {
      return false;
    } else if (index == 10) {
      return false;
    } else if (index == 11) {
      return true;
    } else if (index == 12) {
      return false;
    } else if (index == 13) {
      return false;
    } else {
      return false;
    }
  }

  String getServiceNames(index) {
    if (index == 0) {
      return 'KYC & Redg Docs';
    } else if (index == 1) {
      return 'GST Returns';
    } else if (index == 2) {
      return 'Income Tax Returns';
    } else if (index == 3) {
      return 'TDS Returns';
    } else if (index == 4) {
      return 'ROC Returns';
    } else if (index == 5) {
      return 'PF Statements';
    } else if (index == 6) {
      return 'Electricity Bills';
    } else if (index == 7) {
      return 'Gas Bills';
    } else if (index == 8) {
      return 'Insurance Docs';
    } else if (index == 9) {
      return 'Loan Proposals';
    } else if (index == 10) {
      return 'Loan Renewals';
    } else if (index == 11) {
      return 'Stock Statements';
    } else if (index == 12) {
      return 'NetWorth Statements';
    } else if (index == 13) {
      return 'Cibil/ Credit Report';
    } else {
      return 'Tally Books';
    }
  }

  String getListFilter(index) {
    if (index == 0) {
      return StorageValues.kyc;
    } else if (index == 1) {
      return StorageValues.gstReturns;
    } else if (index == 2) {
      return StorageValues.itra;
    } else if (index == 4) {
      return StorageValues.rocReturns;
    } else if (index == 5) {
      return StorageValues.pfStatementA;
    } else if (index == 6) {
      return StorageValues.electricityBill;
    } else if (index == 7) {
      return StorageValues.gasBill;
    } else if (index == 8) {
      return StorageValues.insuranceDoc;
    } else if (index == 9) {
      return StorageValues.loanProposalsA;
    } else {
      return 'Insurance Docs';
    }
  }

  Future<GetAllFilesModel?> getAllFiles() async {
    String? accessToken;
    String? instanceUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(StorageValues.accessToken);
    instanceUrl = prefs.getString(StorageValues.instanceUrl);
    Dio dio = Dio();
    final response = await dio.get(
      "$instanceUrl/services/apexrest/flutter/getallfiles",
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
            'leadid': prefs.getString(StorageValues.leadId),
          }),
    );
    print(response.statusCode);
    print(response.data);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.data);
      List<GetAllFilesModel> allfiles = [];
      allfiles.add(GetAllFilesModel.fromJson(result));
      if (allfiles[0].relatedRecordInfo != null) {
        return allfiles[0];
      } else {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                  title: Text(allfiles[0].errorMsg.toString(),
                      textAlign: TextAlign.center));
            });
      }
    } else {
      print(response.statusCode);
      debugPrint("Auth Failed");
      return null;
    }
  }

  int getGridCount(Size size) {
    if (size.width > 900) {
      return 8;
    } else if (size.width > 600 && size.width < 900) {
      return 6;
    } else {
      return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomWidgets.getAppBar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              Text('E-Wallet',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              SizedBox(width: 50)
            ],
          ),
          FutureBuilder(
            future: getAllFiles(),
            builder: (ctx, AsyncSnapshot<GetAllFilesModel?> snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snap.hasData) {
                final data = snap.data!.relatedRecordInfo;
                return Expanded(
                  child: GridView.builder(
                    itemCount: 15,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: getGridCount(size)),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WalletDocumentScreen(
                                fileName: getFileNames(index),
                                showUploadButton: getgetShowUploader(index),
                                title: getServiceNames(index),
                                documents: data!
                                    .where(
                                      (record) =>
                                          record.title == getListFilter(index),
                                    )
                                    .toList(),
                              ),
                            ),
                          ).then(
                            (value) {
                              setState(() {});
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(6.0),
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Icon(
                                MyFlutterApp.folder_open,
                                size: 45.0,
                                color: Colors.orange,
                              ),
                              Text(
                                getServiceNames(index),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    'Please try again',
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}

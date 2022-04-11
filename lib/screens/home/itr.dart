import 'package:flutter/material.dart';
import 'package:global/Shared/customWidgets.dart';

class ItrFiling extends StatefulWidget {
  const ItrFiling({Key? key}) : super(key: key);
  @override
  _ItrFilingState createState() => _ItrFilingState();
}

class _ItrFilingState extends State<ItrFiling> {
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
                Text('Income Tax Returns Filing',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                SizedBox(width: 50)
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Please fill in all the details.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 6),
            Text('Note: Long press on ⓘ to get addditional information',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400)),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

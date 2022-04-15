import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:global/Shared/colors.dart';
import 'package:global/Shared/customWidgets.dart';
import 'package:global/model/getAllFiles.dart';
import 'package:global/model/loginModelClass.dart';
import 'package:global/screens/auth/logInScreen.dart';
import 'package:http_parser/http_parser.dart';
import 'package:universal_io/io.dart' as Un;
import 'package:global/screens/home/fileUploadResponse.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image/image.dart' as imageLib;

class WalletDocumentScreen extends StatefulWidget {
  final String? fileName;
  final bool? showUploadButton;
  final String title;
  final List<RelatedRecordInfo>? documents;
  const WalletDocumentScreen(
      {Key? key,
      this.fileName,
      required this.title,
      this.documents,
      this.showUploadButton})
      : super(key: key);

  @override
  _WalletDocumentScreenState createState() => _WalletDocumentScreenState();
}

class _WalletDocumentScreenState extends State<WalletDocumentScreen> {
  String? img64;
  ImagePicker picker = new ImagePicker();
  bool imagePicked = false;
  List imagelist = ['Camera', 'Media'];

  getImage(ImageSource source) async {
    final pickedFile = await FilePicker.platform.pickFiles();
    setState(
      () {
        if (pickedFile != null) {
          print("---------------------1");
          // final bytes = html.File(pickedFile.files.first.bytes!,
          //     pickedFile.files.first.path!);
          print("---------------------2");
          // final img6 = imageLib.decodeImage(pickedFile.path.codeUnits);
          print("---------------------3");
          // final byte = bytes.readAsBytesSync();
          // Uint8List b = Uint8List(bytes.toString().length);

          img64 = base64.encode(pickedFile.files.first.bytes!);
          // Uint8List b = Uint8List(bytes.toString().length);
          // print("+++++++$bytes");
          // img64 = base64Encode(File(pickedFile.path).readAsBytesSync());
          // print(img64);
          imagePicked = true;
          getFileUpload(img64, pickedFile.files.first.name);
        } else {
          print('No image selected.');
        }
      },
    );
  }

  Future modelBottomSheetCamera(BuildContext context) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () => getImage(ImageSource.camera),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 30,
                    ),
                    Text(
                      imagelist[0],
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => getImage(ImageSource.gallery),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image,
                      size: 30,
                    ),
                    Text(
                      imagelist[1],
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  int getGridCount(Size size) {
    if (size.width > 900) {
      return 6;
    } else if (size.width > 600 && size.width < 900) {
      return 4;
    } else {
      return 3;
    }
  }

  Future<FileUpload?> getFileUpload(img, name) async {
    print(name);
    EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        status: "Uploading...",
        indicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ));
    print("---------------------4");
    // final result = await FlutterImageCompress.compressWithFile(imageFile.path,
    //     quality: 50);
    // Uint8List imageInUnit8List = result!;
    // print(imageFile.name);
    // final tempDir = await getTemporaryDirectory();
    // File file = await File('${tempDir.path}/${imageFile.name}').create();
    // file.writeAsBytesSync(imageInUnit8List);
    List<String> splitag = name.split(".");

    try {
      final dio = Dio();
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String? id = sharedPreferences.getString(StorageValues.leadId);
      String? instanceUrl =
          sharedPreferences.getString(StorageValues.instanceUrl);
      print("---------------------5");
      // String fileName = base64Image.path.split('/').last;
      // FormData formData = FormData.fromMap(
      //   {
      //     "file": await MultipartFile.fromFile(base64Image.path,
      //         filename: fileName, contentType: MediaType("image", "jpeg")),
      //   },
      // );
      print("---------------------5++++++++++++++++");
      final response = await dio.post(
        '$instanceUrl/services/apexrest/flutter/uploadfile',
        data: img,
        options: Options(
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'Bearer ${sharedPreferences.getString(StorageValues.accessToken)}',
            "parentid": id,
            "filename": widget.fileName,
            "filetype": splitag.last
          },
        ),
      );
      print("---------------------6");
      print(response.statusCode);
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        final result = jsonDecode(response.data);
        print(result['recordId']);
        setState(() {
          widget.documents!.add(RelatedRecordInfo(id: result['recordId']));
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("File Uploaded")));
        print(result);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Upload failed")));
        debugPrint("Auth Failed");
        return null;
      }
    } catch (e, s) {
      print(e);
      print(s);
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Upload failed")));
    }
  }

  @override
  void dispose() {
    EasyLoading.dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: CustomWidgets.getAppBar(),
        floatingActionButton:
            widget.showUploadButton != null && widget.showUploadButton == true
                ? FloatingActionButton(
                    backgroundColor: AppColors.kPrimaryColor,
                    child: Icon(Icons.upload, color: Colors.white),
                    onPressed: () {
                      getImage(ImageSource.gallery);
                    })
                : SizedBox(),
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
                Text(widget.title + ' Documents',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                SizedBox(width: 50)
              ],
            ),
            if (widget.documents!.length == 0) Text('No documents found.'),
            if (widget.documents!.length > 0)
              Expanded(
                child: GridView.builder(
                    itemCount: widget.documents!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: getGridCount(size),
                    ),
                    itemBuilder: (ctx, i) {
                      return DocumentView(docId: widget.documents![i].id!);
                    }),
              ),
          ],
        ));
  }
}

class DocumentView extends StatefulWidget {
  final String? docId;
  const DocumentView({Key? key, this.docId}) : super(key: key);

  @override
  State<DocumentView> createState() => _DocumentViewState();
}

class _DocumentViewState extends State<DocumentView> {
  bool? isDeleted;
  Future<LogInModelClass?> getImageBase(context) async {
    String? accessToken;
    String? instanceUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(StorageValues.accessToken);
    instanceUrl = prefs.getString(StorageValues.instanceUrl);
    Dio dio = Dio();
    final response = await dio.get(
      "$instanceUrl/services/apexrest/flutter/fileinfo",
      options: Options(
          followRedirects: false,
          validateStatus: (status) => true,
          headers: {
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'Bearer $accessToken',
            'fileid': widget.docId,
          }),
    );
    print(response.statusCode);
    print(response.data);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.data);
      List<LogInModelClass> allfiles = [];
      allfiles.add(LogInModelClass.fromJson(result));
      if (allfiles[0].recordId!.isNotEmpty) {
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

  Future<LogInModelClass?> deleteImageBase(context) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.black,
        status: "Deleting File...",
        indicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.white),
        ));
    String? accessToken;
    String? instanceUrl;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString(StorageValues.accessToken);
    instanceUrl = prefs.getString(StorageValues.instanceUrl);
    try {
      Dio dio = Dio();
      final response = await dio.delete(
        "$instanceUrl/services/apexrest/flutter/deletefile",
        options: Options(
            followRedirects: false,
            validateStatus: (status) => true,
            headers: {
              HttpHeaders.acceptHeader: 'application/json',
              HttpHeaders.authorizationHeader: 'Bearer $accessToken',
              HttpHeaders.accessControlRequestHeadersHeader:
                  true, // add this line cors policy
              'fileid': widget.docId,
            }),
      );
      print(response.statusCode);
      print(response.data);
      EasyLoading.dismiss();
      if (response.statusCode == 200) {
        final result = jsonDecode(response.data);
        List<LogInModelClass> allfiles = [];
        allfiles.add(LogInModelClass.fromJson(result));
        if (allfiles[0].recordId!.isNotEmpty) {
          setState(() {
            isDeleted = true;
          });
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
    } catch (e) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Unable to delete the file")));
    }
  }

  @override
  void initState() {
    isDeleted = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isDeleted == true) {
      return Center(child: Text("File Deleted"));
    } else {
      return FutureBuilder(
          future: getImageBase(context),
          builder: (ctx, AsyncSnapshot<LogInModelClass?> snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snap.hasData) {
              var data = snap.data!.recordId;
              if (data == 'No Content available for the given record Id.') {
                return Center(child: Text("File not found"));
              } else {
                print("----------------${snap.data!}");
                var bytes = base64Decode(data!);
                return Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover, image: MemoryImage(bytes)),
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20.0))),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteImageBase(context);
                          }),
                    )
                  ],
                );
              }
            } else {
              return Center(child: Text('Unable to fetch image'));
            }
          });
    }
  }
}

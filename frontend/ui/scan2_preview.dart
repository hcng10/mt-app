import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:image/image.dart' as Img;
import 'package:http/http.dart' as http;

import 'package:device_info_plus/device_info_plus.dart';

import 'widgets/load_overlay.dart';
import 'widgets/scan2_field.dart';

import '../services/auth_service.dart';
import '../services/photolist_service.dart';

import '../macro/constant.dart';
import '../macro/text.dart';

//Added UCropActivity into your AndroidManifest.xml

class Scan2PreviewScreen extends StatefulWidget {
  const Scan2PreviewScreen({required this.param, Key? key}) : super(key: key);
  final List param;
  //final String param;

  @override
  Scan2PreviewScreenState createState() => Scan2PreviewScreenState();
}

class Scan2PreviewScreenState extends State<Scan2PreviewScreen> {
  late String imagePath;

  late double HOG_scaling;
  late double HOG_image_x;
  late double HOG_image_y_ofst;

  late double cam_container_w;
  late double cam_container_h;
  late double scaling;

  String testInfo1 = "NA";
  String testInfo2 = "NA";
  String deviceTxt = "NA";



  @override
  void initState() {
    super.initState();

    imagePath = widget.param[0];

    HOG_scaling = widget.param[1];
    HOG_image_x = widget.param[2];
    HOG_image_y_ofst = widget.param[3];

    cam_container_w = widget.param[4];
    cam_container_h = widget.param[5];
    scaling = widget.param[6];

    if (HAS_QRSCREEN == true){
      testInfo1 = widget.param[7];
      testInfo2 = widget.param[8];
      deviceTxt = widget.param[9];
    }


  }

  Future<LFTPhotosCombo> cropImgNPhoneInfo(String imagePath) async {

    var bytes;
    if (kIsWeb) {
      http.Response response = await http.get(Uri.parse(imagePath),);
      bytes = response.bodyBytes;

    }else{
      bytes = File(imagePath).readAsBytesSync();
    }

    //final ByteData data = await NetworkAssetBundle(Uri.parse(imagePath)).load(imagePath);
    //var bytes = data.buffer.asInt8List();

    Img.Image src = Img.decodeImage(bytes)!;

    // use the actual image resolution to determine where thr HOG frame is
    // because I can't get it from camera controller
    double widthRatio = src.width / cam_container_w;
    double heightRatio = src.height / cam_container_h;

    double cam2ContainerRatio = 1.0;

    if (widthRatio < 1 && heightRatio >= 1) {
      // camera preview expanded based on the width
      // just get the width metric
      cam2ContainerRatio = widthRatio;

    } else if (widthRatio >= 1 && heightRatio < 1) {
      cam2ContainerRatio = heightRatio;

    } else if (widthRatio < 1 && heightRatio < 1) { //this case works
      // When they are smaller than 1, we need the smaller one because
      // when you divide it by 1, it will be be the bigger one O
      // which means the camera preview expanded based on that O
      cam2ContainerRatio = widthRatio < heightRatio ?
              widthRatio : heightRatio;

    } else if (widthRatio >= 1 && heightRatio >= 1) {
      cam2ContainerRatio = widthRatio < heightRatio ?
                          widthRatio : heightRatio;
    }



    var camRatio = scaling;
    scaling = camRatio / (src.width/src.height);
    scaling = scaling < 1 ? 1 / scaling : scaling;

    if (DEBUG_MODE) {
      print("*******************************1 new scaling");
      //print(cam2ContainerRatio);
      print(widthRatio);
      print(heightRatio);
    }


    //double HOG_width = (cam2ContainerRatio * HOG_scaling * 128) / scaling;
    //double HOG_height = (cam2ContainerRatio * HOG_scaling * 384) / scaling;

    double HOG_width = (cam2ContainerRatio * HOG_scaling * 128);
    double HOG_height = (cam2ContainerRatio * HOG_scaling * 384);
    //

    //double image_x = HOG_image_x * cam2ContainerRatio * HOG_scaling;
    double image_x = src.width / 2 - HOG_width / 2;
    double image_y = src.height / 2 - HOG_height/2 + ((HOG_image_y_ofst-1)*cam2ContainerRatio)/2 ;
    //TODO: Hack the (-1 and divided by 2), it appears to be working for now
    //TODO: But don't understand why it works

    /*print("*******************************2 new scaling");
    print(HOG_height);
    print(src.height);
    print(HOG_image_y_ofst );*/





    int width = HOG_width.toInt();
    int height = HOG_height.toInt();

    Img.Image destImage = Img.copyCrop(src!, image_x.toInt(), image_y.toInt(), width, height);
    if (DEBUG_MODE) {
      print(
          "Crop info: x, y, width, height: $image_x, $image_y, $width, $height");
    }

    List<int> jpg = Img.encodeJpg(destImage);
    if (kIsWeb == false) {
      File('test.jpg').writeAsBytesSync(jpg);
    }

    //get info about phone
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.data.toString();
    if (DEBUG_MODE) {
      print("Platform info: $allInfo");
    }

    LFTPhotosCombo lFTPhotosCombo = LFTPhotosCombo(bytes, jpg, image_x.toInt(),
                                                image_y.toInt(), width, height, allInfo,
                                                testInfo1, testInfo2, deviceTxt);

    return lFTPhotosCombo;

    //var jpg = Img.encodeJpg(destImage);
    //File('test.png').writeAsBytesSync(jpg);
    //await File('out/test').writeAsBytes(jpg);

  }

  @override
  Widget build(BuildContext context) {

    final ld_overlay = LoadingOverlay.of(context);
    final authService = Provider.of<AuthService>(context);
    final photoListService =  Provider.of<PhotoListService>(context);

    //TODO: make a better transition
    return Scaffold(
      appBar: AppBar(title: const Text('Test Photo'),
        backgroundColor: DARKCOLOR_SCHEME,
        foregroundColor: Colors.white,
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      //body: FutureBuilder<List<int>>(LFTPhotosCombo
      body: FutureBuilder<LFTPhotosCombo>(
        future: cropImgNPhoneInfo(imagePath),
        builder: (context, snapshot) {
          Icon icon_photo = Icon(Icons.insert_photo_outlined, color: IMPERIAL_GREEN);
          Icon icon_insight = Icon(Icons.insights_outlined, color: IMPERIAL_GREEN);
          Icon icon_time = Icon(Icons.access_time_outlined, color: IMPERIAL_GREEN);


          if (snapshot.hasData) {
            final mediaSize = MediaQuery.of(context).size;
            final mediaSizeHeight = mediaSize.height > DEFAULT_PHOTOHEIGHT ?
                                        mediaSize.height: DEFAULT_PHOTOHEIGHT;

            final lFTPhotosCombo = snapshot.data!;
            final lftImageByte = lFTPhotosCombo.cropPhotoByte;
            final lftImage = Image(image: MemoryImage(Uint8List.fromList(lftImageByte)));


            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, USUAL_EDGE_GAP, 0, 0),
              child: Column(
                //snapshot.data;
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: mediaSize.width,
                    height: mediaSizeHeight - AppBar().preferredSize.height -
                        USUAL_EDGE_GAP - SCAN2_INFOHEIGHT,
                    child: lftImage

                    /*child: const DecoratedBox(
                      decoration: const BoxDecoration(
                          color: Colors.red
                      ),
                    ),*/
                  ),

                  SizedBox(
                    width: mediaSize.width,
                    height: SCAN2_INFOHEIGHT,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First text
                        Scan2CustomField(
                          icon: icon_photo,
                          txt: scan2_info1,
                        ),

                        Scan2CustomField(
                          icon: icon_insight,
                          txt: scan2_info2,
                        ),

                        Scan2CustomField(
                          icon: icon_time,
                          txt: scan2_info3,
                        ),


                        Container(
                          padding: const EdgeInsets.only(left: USUAL_EDGE_GAP,
                                                        top: USUAL_EDGE_GAP/3,
                                                        right: USUAL_EDGE_GAP),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              //context.pop();
                              ServerRslt serverRslt = ServerRslt.rejected;
                              serverRslt = await ld_overlay
                                  .waiting(authService.onSendPhoto(lFTPhotosCombo));

                              if (serverRslt == ServerRslt.completed){
                                // inform rebuilt
                                photoListService.updateState(true, toNotify: true);

                                List param = [lftImage, ];

                                if (HAS_QRSCREEN == true){
                                  context.push('/scan/scan0a_question/scan0b_qr/scan0_info/scan1_camera/scan2_preview/scan3_finish',
                                      extra: param);
                                }else {
                                  context.push(
                                      '/scan/scan0_info/scan1_camera/scan2_preview/scan3_finish',
                                      extra: param);
                                }
                                //context.push(
                                    //'/scan/scan0_info/scan1_camera/scan2_preview/scan3_finish',
                                    //extra: param);
                              }
                              else{
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Oh no ... something goes wrong."),
                                        icon: Icon(Icons.error_outline_rounded, color: Colors.red, size: 30),
                                        actions: <Widget>[
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              textStyle: Theme.of(context).textTheme.labelLarge,
                                            ),
                                            child: const Text('OK',
                                                style: TextStyle(fontSize: SCAN_FONTSIZE,
                                                    color: TEXT_COLOR)
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    }
                                );
                              }

                            },
                            style: ElevatedButton.styleFrom(
                              primary: YESBUTTON_COLOR,
                              //shape: CircleBorder(),
                              padding: EdgeInsets.all(20),
                            ),
                                //context.push('/scan/scan0_info/scan1_camera'),

                            child: const Text(
                              'It looks good',
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.only(top: USUAL_EDGE_GAP/2,
                                                        left: USUAL_EDGE_GAP,
                                                        right: USUAL_EDGE_GAP,
                                                        bottom: USUAL_EDGE_GAP),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => context.pop(),
                            style: ElevatedButton.styleFrom(
                              primary: SOSOBUTTON_COLOR,
                              //shape: CircleBorder(),
                              padding: EdgeInsets.all(20),
                            ),
                            child: const Text(
                              'Try again',
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),

                      ]
                    )
                  )
                ],
                //children: [kIsWeb? Image.network(imagePath): Image.file(File(imagePath))],
              ),
            );
          }
          else{
            return const Center(child: CircularProgressIndicator(
              backgroundColor: Colors.grey,
              color: NAV_COLOR,
            ));
          }
        }
      )
      //Image.network(imagePath),

      //Image.file(File(imagePath)),
      //const Center(child: CircularProgressIndicator()),

    );
  }
}

/*
Future<List<int>> cropImg(String imagePath) async {

    var bytes;
    if (kIsWeb) {
      http.Response response = await http.get(Uri.parse(imagePath),);
      bytes = response.bodyBytes;

    }else{
      bytes = File(imagePath).readAsBytesSync();
    }

    //final ByteData data = await NetworkAssetBundle(Uri.parse(imagePath)).load(imagePath);
    //var bytes = data.buffer.asInt8List();

    Img.Image src = Img.decodeImage(bytes)!;

    // use the actual image resolution to determine where thr HOG frame is
    double widthRatio = src.width / cam_container_w;
    double heightRatio = src.height / cam_container_h;

    double cam2ContainerRatio = widthRatio > heightRatio ?
              widthRatio: heightRatio;


    double HOG_width = (cam2ContainerRatio * HOG_scaling * 128) / scaling;
    double HOG_height = (cam2ContainerRatio * HOG_scaling * 384) / scaling;

    //double image_x = HOG_image_x * cam2ContainerRatio * HOG_scaling;
    double image_x = src.width / 2 - HOG_width/2;
    //TODO: Hack the (HOG_image_y_ofst/scaling) for now still need fixing
    double image_y = src.height / 2 - HOG_height/2 + (HOG_image_y_ofst/scaling) ;
    //(HOG_image_y * cam2ContainerRatio);


    int width = HOG_width.toInt();
    int height = HOG_height.toInt();

    Img.Image destImage = Img.copyCrop(src!, image_x.toInt(), image_y.toInt(), width, height);
    print("..........get to crop sth3");

    List<int> jpg = Img.encodeJpg(destImage);
    if (kIsWeb == false) {
      File('test.jpg').writeAsBytesSync(jpg);
    }

    return jpg;

    //var jpg = Img.encodeJpg(destImage);
    //File('test.png').writeAsBytesSync(jpg);
    //await File('out/test').writeAsBytes(jpg);

  }
 */
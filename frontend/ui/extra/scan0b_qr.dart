import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:html' as html;
import 'dart:ui' as ui;

import 'scanner.dart';
import '../../macro/constant.dart';
import '../../macro/text.dart';

class Scan0bQRScreen extends StatefulWidget {
  const Scan0bQRScreen({required this.param, Key? key}) : super(key: key);
  final List param;

  @override
  Scan0bQRScreenState createState() => Scan0bQRScreenState();
}

class Scan0bQRScreenState extends State<Scan0bQRScreen> {

  Future<bool> ? camAvailable;
  late String deviceTxt;

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }


  @override
  void initState() {
    super.initState();
    // sourcesF = navigator.mediaDevices.getSources();
    deviceTxt = widget.param[0];
    camAvailable = Scanner.cameraAvailable();
  }

  @override
  Widget build(BuildContext context) {

    AppBar qr_appBar = AppBar(title: const Text('Scan QR Code'),
      backgroundColor: DARKCOLOR_SCHEME,
      foregroundColor: Colors.white,
    );

    return Scaffold(
      appBar: qr_appBar,
      body: FutureBuilder<bool>(
        future: camAvailable,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            /*if (snapshot.data!) {

            }else{
              showInSnackBar("ERROR: No camera available");
            }*/
            final mediaSize = MediaQuery.of(context).size;

            // ** Calculate size for the container
            final double appBarHeight = qr_appBar.preferredSize.height;
            double qrMediaHeight = mediaSize.height - SCAN0b_INFOHEIGHT - appBarHeight;

            double qrCamHeight = 0.0;
            double qrCamWidth = 0.0;

            if (MediaQuery.of(context).orientation == Orientation.portrait){
              qrCamHeight = SCAN0b_CAMWIDTH;
              qrCamWidth = SCAN0b_CAMHEIGHT;
            }else{
              qrCamHeight = SCAN0b_CAMHEIGHT;
              qrCamWidth = SCAN0b_CAMWIDTH;
            }

            double qrOffsetX = (mediaSize.width - qrCamWidth)/2;
            double qrOffsetY = (qrMediaHeight- qrCamHeight)/2;

            /*double qrFramePad = 50;
            double qrFrameWidth = (mediaSize.width > SCAN0b_CAMWIDTH ?
                                    SCAN0b_CAMWIDTH : mediaSize.width) - qrFramePad;
            double qrFrameHeight = (mediaSize.height > SCAN0b_CAMHEIGHT ?
                                    SCAN0b_CAMHEIGHT : mediaSize.height) - qrFramePad;
            double qrFrameLength = qrFrameWidth > qrFrameHeight? qrFrameHeight: qrFrameWidth;*/
            var w_display = mediaSize.width;

            ////print("QRScan: mediaSize.width - $w_display");
            ////print(MediaQuery.of(context).orientation);

            return SingleChildScrollView(
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    ConstrainedBox(
                      // the main background
                      constraints: BoxConstraints(
                        maxHeight: mediaSize.height-appBarHeight, // - scan1_infoHeight,
                        minHeight: mediaSize.height-appBarHeight,
                        minWidth: mediaSize.width,
                        maxWidth: mediaSize.width,
                      ),
                      child: Container(
                        color: Colors.black,
                      ),
                    ),

                    Positioned(
                      left: qrOffsetX,//offsetX
                      top: qrOffsetY,//offsety
                      child: ConstrainedBox(
                          // the main background
                          constraints: BoxConstraints(
                            maxHeight: qrMediaHeight-qrOffsetY, // - scan1_infoHeight,
                            minHeight: qrMediaHeight-qrOffsetY,
                            minWidth: mediaSize.width,
                            maxWidth: mediaSize.width,
                          ),
                          child: Scanner(nxtScreen: '/scan/scan0a_question/scan0b_qr/scan0_info',
                            deviceTxt: deviceTxt,
                          ),

                        ),
                      /*child: Container(
                        // height: height - 20,
                          width:  mediaSize.width,
                          height: qrMediaHeight,
                         // child: Scanner()
                      )*/

                    ),

                    Positioned(
                      left: 0,
                      top: qrMediaHeight ,//mediaSize.height - scan1_infoHeight,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: SCAN0b_INFOHEIGHT,
                          maxHeight: SCAN0b_INFOHEIGHT,
                          maxWidth: mediaSize.width,
                        ),
                        child: Stack(children: <Widget>[
                          Container(
                            width: mediaSize.width,
                            height: SCAN0b_INFOHEIGHT,
                            color: Colors.white,
                          ),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  padding:
                                  const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Text(
                                    scan0b_info1,
                                    textAlign: TextAlign.center,
                                    //overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: SCAN_FONTSIZE,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  padding:
                                  const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Text(
                                    scan0b_info2,
                                    textAlign: TextAlign.center,
                                    //overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: SCAN_FONTSIZE),
                                  ),
                                ),
                                /*Container(
                                  padding: const EdgeInsets.all(20),
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    // ** take pic button
                                    onPressed: (){
                                      List<double> param = [
                                        HOG_scaling,
                                        HOG_image_x,
                                        HOG_image_y_ofst,
                                        mediaSize.width,
                                        mediaHeight,
                                        scaling
                                      ];

                                      if (controller != null &&
                                          controller!.value.isInitialized &&
                                          !controller!.value.isRecordingVideo){
                                        onTakePictureButtonPressed(param);
                                      }
                                      //print("***********Why it didn't work 3");
                                    },
                                    icon: const Icon(Icons.camera_alt,
                                        color: Colors.white),
                                    label: const Text(
                                      'Take photo',
                                      style: TextStyle(
                                          fontSize: SCAN_FONTSIZE,
                                          color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: YESBUTTON_COLOR,
                                      //shape: CircleBorder(),
                                      //padding: EdgeInsets.all(20),
                                    ),
                                  ),
                                ),*/
                              ]),
                        ]),
                      ),
                    ),

                  ],
                ),

            );
          }
          else{
            if (snapshot.hasError){
              showInSnackBar("ERROR: ${snapshot.error}");
            }
            return const Center(child: CircularProgressIndicator(
              backgroundColor: Colors.grey,
              color: NAV_COLOR,
            ));
          }
        }
      )
    );
  }

}
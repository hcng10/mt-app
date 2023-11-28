import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';

import 'package:camera/camera.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;



import '../macro/constant.dart';
import '../macro/text.dart';


void _logError(String code, String? message) {
  if (message != null) {
    print('Error: $code\nError Message: $message');
  } else {
    print('Error: $code');
  }
}




class Scan1CameraScreen extends StatefulWidget {
  //const Scan1CameraScreen({Key? key}) : super(key: key);
  const Scan1CameraScreen({required this.param, Key? key}) : super(key: key);
  final List param;

  @override
  Scan1CameraScreenState createState() => Scan1CameraScreenState();
}


class Scan1CameraScreenState extends State<Scan1CameraScreen> with WidgetsBindingObserver{
  List<CameraDescription> _cameras = [];

  CameraController? controller;
  String webPlatform = "None";
  //late Future<void> _initializeControllerFuture;

  String testInfo1 = "NA";
  String testInfo2 = "NA";
  String deviceTxt = "NA";


  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void setWebPlatform() {
    // check platform
    if (kIsWeb) {
      final userAgent = html.window.navigator.userAgent.toString().toLowerCase();
      if (userAgent.contains("iphone"))
        webPlatform = "ios";
      else if (userAgent.contains("ipad"))
        webPlatform = "ios";
      else if (userAgent.contains("android"))
        webPlatform = "Android";
      else
        webPlatform = "Web";
      //print("****GET THE PLATFORM: $userAgent");
    }
  }


  Future<void> initCameras() async {
    if (DEBUG_MODE){
      print("Starting future for availableCameras");
    }

    try {
      WidgetsFlutterBinding.ensureInitialized();
      _cameras = await availableCameras();
    } on CameraException catch (e) {
      _logError(e.code, e.description);
    }
    if (DEBUG_MODE) {
      print("Done future for availableCameras");
    }
  }


  Future<void> getCameras() async {

    setWebPlatform();
    await initCameras();

    final CameraController? oldController = controller;

    if (oldController != null) {
      // `controller` needs to be set to null before getting disposed,
      // to avoid a race condition when we use the controller that is being
      // disposed. This happens when camera permission dialog shows up,
      // which triggers `didChangeAppLifecycleState`, which disposes and
      // re-creates the controller.

      if (DEBUG_MODE) {
        print("*******0. check null to find problem");
      }
      controller = null;
      await oldController.dispose();
    }

    if (DEBUG_MODE) {
      print("*******0. check null found nothing ");
    }

    try {

      //get the first camera idx that is back camera
      int camIdx = 0;
      for (var i = 0; i < _cameras.length; i++) {
        if (_cameras[i].lensDirection == CameraLensDirection.back){
          camIdx = i;
          break;
        }
      }

      if (DEBUG_MODE) {
        print("*******1. Available_initializeControllerFuture");
      }
      final CameraController cameraController = CameraController(
        // Get a specific camera from the list of available cameras.
        _cameras[camIdx],
        // Define the resolution to use.
        CAMERA_RSTN,
        //ResolutionPreset.veryHigh,
        enableAudio: false,
      );
      if (DEBUG_MODE) {
        print("*******2. Available_initializeControllerFuture");
      }
      controller = cameraController;

      //_initializeControllerFuture = cameraController.initialize();
      //await _initializeControllerFuture;
      await cameraController.initialize();
      if (DEBUG_MODE) {
        print("*****3 Done future for _initializeControllerFuture");
      }

    } on CameraException catch (e) {
      print('Error in fetching the cameras: $e');
    }

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      getCameras();
    }
  }

  @override
  void initState() {
    //SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (HAS_QRSCREEN == true && widget.param.length > 0){
      testInfo1 = widget.param[0];
      testInfo2 = widget.param[1];
      deviceTxt = widget.param[2];
    }
    if (DEBUG_MODE) {
      print("initState Called");
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();

  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      if (DEBUG_MODE) {
        print("%%%%%%%% capture is done");
      }
      return file;
    } on CameraException catch (e) {
      _logError(e.code, e.description);
      return null;
    }
  }

  void onTakePictureButtonPressed(List<double> param_i){
    takePicture().then((XFile? file) {

      if (file != null) {

        if (HAS_QRSCREEN == true){

          List param = [
            file!.path,
            param_i[0],
            param_i[1],
            param_i[2],
            param_i[3],
            param_i[4],
            param_i[5],
            testInfo1,
            testInfo2,
            deviceTxt,
          ];

          context.push('/scan/scan0a_question/scan0b_qr/scan0_info/scan1_camera/scan2_preview',
              extra: param);
        }else {

          List param = [
            file!.path,
            param_i[0],
            param_i[1],
            param_i[2],
            param_i[3],
            param_i[4],
            param_i[5],
            //param_i[6],
            //param_i[7],
            //param_i[8]
          ];

          context.push(
              '/scan/scan0_info/scan1_camera/scan2_preview',
              extra: param);
        }

        //context.push(
            //'/scan/scan0_info/scan1_camera/scan2_preview',
            //extra: param);
      }else{
        showInSnackBar('Error: Capturing is not successful');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    /*if (!controller.value.isInitialized) {
      //TODO: Page to display camera error
      print("Camera not initialized");
      return Container();
    }*/

    AppBar camera_appBar = AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      title: Text("Scan a test", style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: camera_appBar,
        body: FutureBuilder<void>(
            future: getCameras(), //_initializeControllerFuture,
            builder: (context, snapshot) {
              //if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.done) {

                final mediaSize = MediaQuery.of(context).size;

                // ** Calculate size for the container
                final double appBarHeight = camera_appBar.preferredSize.height;
                double mediaHeight = mediaSize.height - SCAN1_INFOHEIGHT;

                // for the camera review to be bigger than certain resolution
                // SingleChildScrollView to save the day
                mediaHeight = mediaHeight > DEFAULT_CAMERAHEIGHT ?
                                mediaHeight: DEFAULT_CAMERAHEIGHT;
                double HOG_Height = mediaHeight - appBarHeight - USUAL_EDGE_GAP * 2;


                // ** new way to calculate camera ratio
                // get the camera width & height based on aspect ratio

                //double cam_w = 0.0;
                //double cam_h = 0.0;
                double camRatio = 0.0;

                if (webPlatform == "Web") {
                  //cam_w = CAMERA_RSTN_VAL[1];
                  //cam_h = CAMERA_RSTN_VAL[0];
                  camRatio = controller!.value.aspectRatio;
                }
                else{
                  //cam_w = CAMERA_RSTN_VAL[0];
                  //cam_h = CAMERA_RSTN_VAL[1];
                  camRatio = 1/controller!.value.aspectRatio;
                }


                //double widthRatio = cam_w / mediaSize.width;
                //double heightRatio = cam_h / mediaHeight;

                //double cam2ContainerRatio = widthRatio > heightRatio ?
                                            //widthRatio: heightRatio;

                final containerRatio = (mediaSize.width / mediaHeight); //- scan1_infoHeight);

                double scaling = camRatio / containerRatio;
                scaling = scaling < 1 ? 1 / scaling : scaling;

                if (DEBUG_MODE) {
                  print(
                      "Media info: height $mediaHeight, width $mediaSize.width");
                  print("CamRatio $camRatio");
                  print("Scaling $scaling");
                }

                //print("width_ratio "+ widthRatio.toString());
                //print("height_ratio "+ heightRatio.toString());
                //print("controller!.value.aspectRatio " +
                    //camRatio.toString());

                double HOG_scaling = HOG_Height / HOG_FRAME_H;
                //HOG_scaling = HOG_scaling < 1 ? 1 / HOG_scaling : HOG_scaling;

                // ** calculate the frame position in the final photo
                double HOG_image_x =
                    mediaSize.width / 2 - ((HOG_scaling * HOG_FRAME_W) / 2);
                //HOG_image_x = HOG_image_x / (scaling * 1.1);

                double HOG_image_y_ofst = (appBarHeight);
                //HOG_image_y = HOG_image_y / (scaling * 1.1);

                return SingleChildScrollView(
                  child: Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      ConstrainedBox(
                        // the main background
                        constraints: BoxConstraints(
                          maxHeight: mediaSize.height, // - scan1_infoHeight,
                          minHeight: mediaSize.height,
                          minWidth: mediaSize.width,
                          maxWidth: mediaSize.width,
                        ),
                        child: Container(
                          color: Colors.black,
                        ),
                      ),

                      // ** The camera
                      Positioned(
                        left: 0,//offsetX
                        top: 0,//offsety
                        child: ConstrainedBox(
                          // the main background
                          constraints: BoxConstraints(
                          maxHeight: mediaHeight, // - scan1_infoHeight,
                          minHeight: mediaHeight,
                          minWidth: mediaSize.width,
                          maxWidth: mediaSize.width,
                          ),
                          child: CameraPreview(controller!),

                        ),

                      ),


                      /*Transform.scale(
                        scale: scaling,//cam_2_container_ratio,
                            //scaling * 1.1, //controller.value.aspectRatio / deviceRatio,
                        //child: AspectRatio(
                        //aspectRatio: (1 / controller.value.aspectRatio),
                        transformHitTests: true,
                        alignment: Alignment.center,
                        child: CameraPreview(controller!),
                        //),
                      ),*/

                      // ** The green frame
                      Positioned(
                        left: mediaSize.width / 2 - ((HOG_scaling * HOG_FRAME_W) / 2),//offsetX
                        top: appBarHeight + USUAL_EDGE_GAP,//offsety
                        child: Container(
                          width: HOG_scaling * HOG_FRAME_W,
                          height: HOG_scaling * HOG_FRAME_H,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 5,
                              color: Colors.green,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),

                      // ** The bottom info box with button
                      Positioned(
                        top: mediaHeight,//mediaSize.height - scan1_infoHeight,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: SCAN1_INFOHEIGHT,
                            maxHeight: SCAN1_INFOHEIGHT,
                            maxWidth: mediaSize.width,
                          ),
                          child: Stack(children: <Widget>[
                            Container(
                              width: mediaSize.width,
                              height: SCAN1_INFOHEIGHT,
                              color: Colors.white,
                            ),
                            Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      scan1_info1,
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
                                      scan1_info2,
                                      textAlign: TextAlign.center,
                                      //overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: SCAN_FONTSIZE),
                                    ),
                                  ),
                                  Container(
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
                                          scaling //scaling no longer needed actually
                                        ];

                                        if (controller != null &&
                                            controller!.value.isInitialized &&
                                            !controller!.value.isRecordingVideo){
                                          onTakePictureButtonPressed(param);
                                        }

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
                                  ),
                                ]),
                          ]),
                        ),
                      ),
                    ],
                  )
                );


              } else {
                // Otherwise, display a loading indicator.

                return const Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white54,
                      color: NAV_COLOR,
                      strokeWidth: 6.0,
                ));
              }
            }) //
        );
  }
}

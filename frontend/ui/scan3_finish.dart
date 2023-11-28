import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as Img;
import 'package:provider/provider.dart';

import 'widgets/load_overlay.dart';
import 'widgets/scan2_field.dart';

import '../services/auth_service.dart';

import '../macro/constant.dart';
import '../macro/text.dart';

//Added UCropActivity into your AndroidManifest.xml

class Scan3FinishScreen extends StatefulWidget {
  const Scan3FinishScreen({required this.param, Key? key}) : super(key: key);
  final List param;
  //final String param;

  @override
  Scan3FinishScreenState createState() => Scan3FinishScreenState();
}

class Scan3FinishScreenState extends State<Scan3FinishScreen> {
  late Image lftImage;

  @override
  void initState() {
    super.initState();

    lftImage = widget.param[0];
  }


  @override
  Widget build(BuildContext context) {

    final mediaSize = MediaQuery.of(context).size;
    final mediaSizeHeight = mediaSize.height > DEFAULT_PHOTOHEIGHT ?
                                          mediaSize.height: DEFAULT_PHOTOHEIGHT;

    Icon icon_photo = Icon(Icons.insert_photo, color: NAV_COLOR);
    Icon icon_insight = Icon(Icons.insights_outlined, color: NAV_COLOR);
    Icon icon_time = Icon(Icons.access_time_outlined, color: NAV_COLOR);

    //TODO: make a better transition
    return Scaffold(
      appBar: AppBar(title: const Text('Congratulations!'),
        backgroundColor: DARKCOLOR_SCHEME,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /*Text(
              "Congratulations!",
              textAlign: TextAlign.center,
              //overflow: TextOverflow.ellipsis,
              style:
              const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),*/
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                scan3_info,
                textAlign: TextAlign.center,
                //overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 20),
              ),
            ),

            SizedBox(
                width: mediaSize.width,
                height: mediaSizeHeight - AppBar().preferredSize.height -
                    USUAL_EDGE_GAP - SCAN2_INFOHEIGHT,
                child: lftImage

            ),

            Container(
              padding: const EdgeInsets.all(20),//.only(left: edge_gap, right: edge_gap),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.pop();
                  context.pop();
                  context.pop();
                  context.pop();
                  if (HAS_QRSCREEN == true){
                    context.pop();
                    context.pop();
                  }
                },
                child: const Text(
                  'Finish',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  primary: YESBUTTON_COLOR,
                  //shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),
              ),
            ),
        ]

        )

      )

    );

  }
}
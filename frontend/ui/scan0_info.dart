import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../macro/constant.dart';
import '../macro/text.dart';

class Scan0InfoScreen extends StatefulWidget {
  const Scan0InfoScreen({Key? key}) : super(key: key);

  @override
  Scan0InfoScreenState createState() => Scan0InfoScreenState();
}

class Scan0InfoScreenState extends State<Scan0InfoScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //title: Text("Scan a test"),
          backgroundColor: DARKCOLOR_SCHEME,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Please make sure you read the following instructions:",
                textAlign: TextAlign.left,
                //overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  scan0_info,
                  textAlign: TextAlign.left,
                  //overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 40),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    context.push('/scan/scan0_info/scan1_camera',
                        extra: []);
                  },
                  child: Text(
                    scan0_yes,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: YESBUTTON_COLOR,
                    //shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.pop(),
                  child: Text(
                    scan0_no,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: NOBUTTON_COLOR,
                    //shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

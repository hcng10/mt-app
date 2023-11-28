import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../macro/constant.dart';
import '../../macro/text.dart';

class Scan0InfoScreen extends StatefulWidget {
  const Scan0InfoScreen({required this.param, Key? key}) : super(key: key);
  final List param;

  @override
  Scan0InfoScreenState createState() => Scan0InfoScreenState();
}

class Scan0InfoScreenState extends State<Scan0InfoScreen> {

  late String qrStr;
  late String deviceTxt;
  late bool hasError;

  String testInfo1 = "NA";
  String testInfo2 = "NA";

  @override
  void initState() {
    super.initState();

    qrStr = widget.param[0];
    deviceTxt = widget.param[1];
    //"The string format should be "brand=xxx&concentration=xxx""

    var qrStrSplit = qrStr.split('&');
    if (qrStrSplit.length < 2){
      hasError = true;
    }else{
      var qrStrSplit1 = qrStrSplit[0].split('=');
      var qrStrSplit2 = qrStrSplit[1].split('=');

      if (qrStrSplit1.length < 2 ||
          qrStrSplit2.length < 2 ||
          qrStrSplit1[0] != scan0c_qrstr1 ||
          qrStrSplit2[0] != scan0c_qrstr2 ){
        hasError = true;
      }else{
        testInfo1 = qrStrSplit1[1];
        testInfo2 = qrStrSplit2[1];
        hasError = false;
      }
    }


  }


  void showAlert(BuildContext context) {
    if (hasError){
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text("Oh no ... I think you have scanned an incorrect QR code"),
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
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          }
      );
    }

  }


  @override
  Widget build(BuildContext context) {

    String fullInfo1 = '${scan0c_qrstr1.capitalize()}: $testInfo1\n\n';
    String fullInfo2 = '${scan0c_qrstr2.capitalize()}: $testInfo2';

    //Hack to work with previous page when wrong QR code is used
    Future.delayed(Duration.zero, () => showAlert(context));
    return Scaffold(
        appBar: AppBar(
          title: Text("Instructions"),
          backgroundColor: DARKCOLOR_SCHEME,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "$scan0c_info3 $fullInfo1 $fullInfo2" ,
                  textAlign: TextAlign.left,
                  //overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: SCAN_FONTSIZE+3, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(
                height: USUAL_EDGE_GAP * 1.8,
              ),

              Text(
                scan0c_info1,
                textAlign: TextAlign.start,
                //overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: SCAN_FONTSIZE, fontWeight: FontWeight.w300),
              ),

              const SizedBox(
                height: USUAL_EDGE_GAP * 1.5,
              ),

              Text(
                scan0c_info2,
                textAlign: TextAlign.left,
                //overflow: TextOverflow.ellipsis,
                style:
                const TextStyle(fontSize: SCAN_FONTSIZE, fontWeight: FontWeight.w400),
              ),

              const SizedBox(
                height: USUAL_EDGE_GAP ,
              ),


              Container(
                padding: const EdgeInsets.only(top: 40),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (HAS_QRSCREEN == true){
                      List param = [testInfo1, testInfo2, deviceTxt];
                      context.push('/scan/scan0a_question/scan0b_qr/scan0_info/scan1_camera',
                                      extra: param);
                      }else {
                      context.push('/scan/scan0_info/scan1_camera',
                                      extra: []);
                    }
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

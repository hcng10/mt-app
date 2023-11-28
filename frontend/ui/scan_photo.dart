import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../macro/constant.dart';
import '../macro/text.dart';

int flashing_time = 2;

class Scan extends StatefulWidget {
  const Scan({Key? key}) : super(key: key);

  @override
  _ScanState createState() => _ScanState();
}

class _ScanState extends State<Scan> with SingleTickerProviderStateMixin {
  //const Scan({Key? key}) : super(key: key);

  late AnimationController animationController;
  late Animation<double> animation;
  late Animation<double> sizeAnimation;

  int currentState = 0;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    animation =
        Tween<double>(begin: 200, end: 230).animate(animationController);

    animation.addListener(() {
      this.setState(() {});
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        animationController.forward();
      }
    });

    animationController.forward();

    /* = Tween<double>(begin: 100, end: 300).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn))
      ..addListener(() {
        setState(() {});
      });*/
  }

  @override
  Widget build(BuildContext context) {
    //appBar: AppBar(title: const Text("Test for scan")),
    //print("testing animation val, ");
    //print(animation.value);
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              width: animation.value,
              height: animation.value,
              child: ElevatedButton(
                onPressed: () { //=> context.go('/scan/scan0_info'),
                  if (HAS_QRSCREEN == true){
                    GoRouter.of(context).go('/scan/scan0a_question');
                  }else{
                    GoRouter.of(context).go('/scan/scan0_info');
                  }

                },
                style: ElevatedButton.styleFrom(
                  primary: CIRBUTTON_COLOR,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),
                child: const Text(
                  'Scan a test',
                  style: TextStyle(fontSize: 22,
                      color: Colors.white),//color: Colors.black)
                ),
              ),
            ),

            SizedBox(
              height: 230 - animation.value  + 10,
            ),

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'Report a bug',
                  style: const TextStyle(fontSize: SCAN_FONTSIZE-5,
                                          fontWeight: FontWeight.w300,
                                          decoration: TextDecoration.underline,
                                          color: PHONETXT_COLOR0,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = (){
                      launch(BUG_REPORT, forceWebView: false);
                    }
              )
            )
          ],
        ),
      )
    );
  }

  @override
  dispose() {
    animationController.dispose(); // you need this
    super.dispose();
  }
}

/*
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => context.go('/'),
            child: const Text('Go to home page'),
          ),
        ],
      ),
          ),*/


          /*
          child: Container(
      color: Colors.black,
      height: animation.value,
      width: animation.value,
    )*/

import 'package:flutter/material.dart';
import '../../macro/constant.dart';

class Scan2CustomField extends StatelessWidget {
  final Icon icon;
  final String txt;


  Scan2CustomField({
    required this.icon,
    required this.txt,
  });


  @override
  Widget build(BuildContext context) {

    return Container(
        padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
        child: Text.rich(
          TextSpan(
              style: const TextStyle(
                fontSize: SCAN_FONTSIZE,
              ),
              children: [
                 WidgetSpan(
                  child: this.icon
                ),
                TextSpan(
                  text: " " + txt,
                ),
              ]
          ),
        )
    );
  }
}






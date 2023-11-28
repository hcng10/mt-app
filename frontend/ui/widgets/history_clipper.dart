import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../macro/constant.dart';

class HistoryClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    // TODO: implement getClip
    var path = new Path();
    //go vertical
    path.lineTo(0, size.height) ;

    var firstControlPoint = new Offset(size.width / 5, size.height - size.height / 2);
    var firstEndPoint = new Offset(size.width / 2, size.height- size.height / 3);
    var secondControlPoint =
              new Offset(size.width - (size.width / 4), size.height- 20);
    var secondEndPoint = new Offset(size.width, size.height - size.height / 2 - 10);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper)
  {
    return false;
  }
}
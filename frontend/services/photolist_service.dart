import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:archive/archive_io.dart';

import '../macro/constant.dart';


class PhotoListService with ChangeNotifier {
  late final SharedPreferences sharedPreferences;

  bool _listUpdated = false;

  //Constructor
  PhotoListService(this.sharedPreferences);

  bool get listUpdatedState {
    return _listUpdated;
  }

  void updateState(bool state, {bool toNotify=false}) {
    //sharedPreferences.setBool(LOGIN_KEY, state);
    if (DEBUG_MODE) {
      print("It is time to notify that the photo histroy needs changing");
    }
    _listUpdated = state;
    if (toNotify){
      notifyListeners();
    }
  }




//List<ListImage>
  Future<PhotoListResult> onGetPhotos() async {
    //await Future.delayed(const Duration(seconds: 5));

    PhotoListResult photoListResult = PhotoListResult();

    //get token first
    String ? token = sharedPreferences.getString("token");
    String ? userID = sharedPreferences.getString("userID");

    if (token == null || userID == null) {
      if (DEBUG_MODE) {
        print("**DEBUG-MSG** onSendPhoto: token unknown");
      }
      photoListResult.serverRslt = ServerRslt.unknownTokenOrUser;
      return photoListResult;

    }
    else {
      // Yeah! I can download pics with the token
      var url;
      if (IS_HTTPS){
        url = Uri.https(BASE_WEBURL_S, 'sgusers/images/downloads/');
      }else {
        if (kIsWeb) {
          url = Uri.parse("$BASE_WEBURL/sgusers/images/downloads/");
        } else {
          url = Uri.parse("$BASE_APPURL/sgusers/images/downloads/");
        }
      }

      var res = await http.get(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token'
        },
      );
      var rtnCode = res.statusCode;
      if (DEBUG_MODE) {
        print("On get photo: Did I receive good return code? $rtnCode");
      }
      if (res.statusCode == 200) {

        final archive = ZipDecoder().decodeBytes(res.bodyBytes);
        if (DEBUG_MODE) {
          print("The magical file length is:");
          print(archive.length);
        }

        for (final file in archive) {

          if (file.isFile) {
            final filedata = file.content as List<int>;
            final filename = file.name;

            // determine if it is a cropped one, or original based on the
            // start of the filename
            String filenameWInfo = filename.startsWith('crop_') ?
                                filename.substring(5): filename.substring(9);
            //extract the info at the tail of the filename
            List<String> filenameWInfoList = filenameWInfo.split(RegExp(r'[_.]'));

            String info = "";
            for (var i = 1; i < filenameWInfoList.length; i++){
              bool appendComma = true;
              String infoStr = filenameWInfoList[i];

              // Hack to find special string
              if (infoStr.toLowerCase().contains("ngml-1")){
                var idxTmp = infoStr.toLowerCase().indexOf("ngml-1");
                infoStr = infoStr.substring(0, idxTmp) + ' ng/mL';//
                // + infoStr.substring(idxTmp + 6); // normally it should be the end

              }
              //hack to solve the 0.16 concentration
              else if (infoStr =='0'){
                appendComma = false;
                infoStr = infoStr + '.';
              }

              info = (appendComma == false || i == filenameWInfoList.length - 1 )?
                      info + infoStr:
                      info + infoStr + ', ';

              //info = (i == filenameWInfoList.length - 1)?
              //  info + filenameWInfoList[i]:
              //  info + filenameWInfoList[i] + ', ';
            }
            PhotoList photoListTmp = PhotoList(filedata, filenameWInfoList[0], info);
            
            if (filename.startsWith('crop_')){

              //PhotoList photoListTmp = PhotoList(filedata, filename.substring(5), "Covid");
              photoListResult.cropPhotoList.add(photoListTmp);
              photoListResult.listLen += 1;
            }
            else{
              //PhotoList photoListTmp = PhotoList(filedata, filename.substring(9), "Covid (original)");
              photoListResult.originalPhotoList.add(photoListTmp);
            }

            if (DEBUG_MODE) {
              print(filename);
            }
          }
        }

        // sort the photoListResult.photoList
        photoListResult.cropPhotoList.sort(
          (a,b) {
            return b.dateTime.compareTo(a.dateTime);
          }
        );

        photoListResult.originalPhotoList.sort(
                (a,b) {
              return b.dateTime.compareTo(a.dateTime);
            }
        );

        //print(res.headers);
        photoListResult.serverRslt = ServerRslt.completed;
        return photoListResult;
      }
    }

    photoListResult.serverRslt = ServerRslt.rejected;
    return photoListResult;
  }

}


class PhotoListResult{
  ServerRslt serverRslt = ServerRslt.rejected;
  List<PhotoList> cropPhotoList = [];
  List<PhotoList> originalPhotoList = [];
  int listLen = 0;

}

class PhotoList{
  late List<int> _photoByte;
  late String _dateTimeStr;
  late DateTime _dateTime;
  late String _lftType;

  PhotoList(
      this._photoByte,
      this._dateTimeStr,
      this._lftType){

    _dateTime = filenameToDateTime(_dateTimeStr);
  }

  List<int> get photoByte {
    return _photoByte;
  }

  String get dateTimeStr {
    return _dateTimeStr;
  }

  String get lftType {
    return _lftType;
  }

  DateTime get dateTime{
    return _dateTime;
}

  DateTime filenameToDateTime(String filename){
    try {
      final dateTime = filename.split('.')[0];
      final date = dateTime.substring(0,10);
      final time = '${dateTime.substring(11,13)}:${dateTime.substring(13,15)}:${dateTime.substring(15,17)}';

      return DateTime.parse('$date $time');

    } catch (e){
      return DateTime.parse('1970-01-01');
    }

  }
}

class LFTPhotosCombo {
  late List<int> _originalPhotoByte;
  late List<int> _cropPhotoByte;

  late int _cropX;
  late int _cropY;

  late int _cropWdith;
  late int _cropHeight;

  late String _phoneInfo;

  late String _testInfo1;
  late String _testInfo2;
  late String _deviceTxt;

  LFTPhotosCombo(
      this._originalPhotoByte,
      this._cropPhotoByte,
      this._cropX,
      this._cropY,
      this._cropWdith,
      this._cropHeight,
      this._phoneInfo,

      this._testInfo1,
      this._testInfo2,
      this._deviceTxt
  );

  List<int> get originalPhotoByte {
    return _originalPhotoByte;
  }

  List<int> get cropPhotoByte {
    return _cropPhotoByte;
  }

  int get cropX {
    return _cropX;
  }

  int get cropY {
    return _cropY;
  }

  int get cropWdith{
    return _cropWdith;
  }

  int get cropHeight{
    return _cropHeight;
  }

  String get phoneInfo{
    return _phoneInfo;
  }

  String get testInfo1{
    return _testInfo1;
  }

  String get testInfo2{
    return _testInfo2;
  }

  String get deviceTxt{
    return _deviceTxt;
  }
}




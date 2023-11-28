import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:shared_preferences/shared_preferences.dart';

import './photolist_service.dart';
import '../macro/constant.dart';


class AuthService with ChangeNotifier {
  late final SharedPreferences sharedPreferences;

  bool _initState = false;
  bool _loginState = false;

  //Constructor
  AuthService(this.sharedPreferences);

  bool get loginState {
    return _loginState;
  }

  bool get initState {
    return _initState;
  }

  set loginState(bool state) {
    //sharedPreferences.setBool(LOGIN_KEY, state);
    _loginState = state;
    notifyListeners();
  }

  Future<void> onAutoLogin() async {
    //TODO: write the code for matching the key/session of Django, which makes
    //TODO: the user auto login (use saved username and password instead of token)
    String ? token = sharedPreferences.getString("token");
    if (token != null) {
      print("has already loggin: " + token);
    }
    await Future.delayed(const Duration(seconds: 2));
    //notifyListeners();
  }

//dynamic
  Future<bool> onLogin(String email, String password) async {

    //await Future.delayed(const Duration(seconds: 2));
    await sharedPreferences.clear();

    var url;
    if (IS_HTTPS){
      url = Uri.https(BASE_WEBURL_S, 'sgusers/auth/login/');
    }else {
      if (kIsWeb) {
        url = Uri.parse("$BASE_WEBURL/sgusers/auth/login/");
        //url = Uri.http("$BASE_WEBURL", "/sgusers/auth/login/");

      } else {
        url = Uri.parse("$BASE_APPURL/sgusers/auth/login/");
        //url = Uri.http("$BASE_APPURL", "sgusers/auth/login/");
      }
    }
    if (DEBUG_MODE) {
      print("Login Url set: $url");
    }

    var res = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
    );
    //print("Login post return");
    var rtnCode = res.statusCode.toString();
    if (DEBUG_MODE) {
      print("Login return code: $rtnCode");
    }

    //return false;

    if (res.statusCode == 200) {
      Map json = jsonDecode(res.body);
      String token = json['key'];
      String userID = json['user'].toString();

      if (DEBUG_MODE) {
        print(res.headers);
        print(res.body);
      }

      await sharedPreferences.setString("token", token);
      await sharedPreferences.setString("userID", userID);

      if (IS_HTTPS){
        url = Uri.https(BASE_WEBURL_S, 'sgusers/auth/user/');
      }else {
        // get user name and email as well
        if (kIsWeb) {
          url = Uri.parse("$BASE_WEBURL/sgusers/auth/user/");
        } else {
          url = Uri.parse("$BASE_APPURL/sgusers/auth/user/");
        }
      }

      String tokenStr = "Token $token";
      res = await http.get(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization':  tokenStr,
        },
      );

      if (res.statusCode == 200) {
        //Map json = jsonDecode(res.body);
        Map json = jsonDecode(Utf8Decoder().convert(res.bodyBytes));

        String email = json['email'];
        String firstName = json['first_name'].toString();
        String lastName = json['last_name'].toString();

        await sharedPreferences.setString("email", email);
        await sharedPreferences.setString("userName", "$firstName $lastName");
      }
      if (DEBUG_MODE) {
        print("Before notify listener");
      }
      loginState = true;
      notifyListeners();
      return true;
    }
    else{
      return false;
    }
  }

  Future<bool> onForgotpwd(String email) async {
    var url;
    if (IS_HTTPS){
      url = Uri.https(BASE_WEBURL_S, 'sgusers/auth/password/reset/');
    }else {
      if (kIsWeb) {
        url = Uri.parse("$BASE_WEBURL/sgusers/auth/password/reset/");
      } else {
        url = Uri.parse("$BASE_APPURL/sgusers/auth/password/reset/");
      }
    }

    var res = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email
      }),
    );

    var rtnCode = res.statusCode.toString();
    if (DEBUG_MODE) {
      print("Forgotpwd return code: $rtnCode");
    }

    if (res.statusCode == 200) {
      Map json = jsonDecode(res.body);
      //print(json);

      return true;
    }
    else{
      return false;
    }

  }


  Future<bool> onRegister(String email, String fName,
      String lName, String password) async {

    //await Future.delayed(const Duration(seconds: 2));

    //set if it is DEBUG or IMPLEMENT
    var url;

    if (IS_HTTPS){
      url = Uri.https(BASE_WEBURL_S, 'sgusers/auth/registration/');

    }else{
      if (kIsWeb) {
        url = Uri.parse("$BASE_WEBURL/sgusers/auth/registration/");
      }else {
        url = Uri.parse("$BASE_APPURL/sgusers/auth/registration/");
      }
    }
    if (DEBUG_MODE) {
      print("Register URL set $url");
    }

    var res = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password1': password,
        'password2': password,
        'first_name': fName,
        'last_name': lName,
      }),
    );

    var rtnCode = res.statusCode.toString();
    if (DEBUG_MODE) {
      print("Register return code: $rtnCode");
    }

    if (res.statusCode == 201 || res.statusCode == 204) {
      //Map json = jsonDecode(res.body);
      //String token = json['key'];
      //print(token);

      return true;
    }
    else{
      return false;
    }

    return false;
  }


  Future<bool> onLogout() async {

    //get token first
    String ? token = sharedPreferences.getString("token");

    if (token == null) {
      return true;
    }
    else{
      var url;
      if (IS_HTTPS){
        url = Uri.https(BASE_WEBURL_S, 'sgusers/auth/logout/');
      }else {
        if (kIsWeb) {
          url = Uri.parse("$BASE_WEBURL/sgusers/auth/logout/");
        } else {
          url = Uri.parse("$BASE_APPURL/sgusers/auth/logout/");
        }
      }

      var res = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Token $token'
        },
      );

      var rtnCode = res.statusCode.toString();
      if (DEBUG_MODE) {
        print("Logout return code: $rtnCode");
      }

      if (res.statusCode == 200) {
        //print("Logout successful");

        loginState = false;
        notifyListeners();

        return true;
      }else{
        return false;
      }
    }
    return false;
  }



  Future<ServerRslt> onSendPhoto(LFTPhotosCombo lFTPhotosCombo ) async {
    //await Future.delayed(const Duration(seconds: 2));
    //get token first
    String ? token = sharedPreferences.getString("token");
    String ? userID = sharedPreferences.getString("userID");

    if (token == null || userID == null) {
      print("**DEBUG-MSG** onSendPhoto: token unknown");
      return ServerRslt.unknownTokenOrUser;
    }
    else{
      // Yeah! I can upload pics with the token
      var url;
      if (IS_HTTPS){
        url = Uri.https(BASE_WEBURL_S, 'sgusers/images/upload/');
      }else {
        if (kIsWeb) {
          url = Uri.parse("$BASE_WEBURL/sgusers/images/upload/");
        } else {
          url = Uri.parse("$BASE_APPURL/sgusers/images/upload");
        }
      }

      final request = http.MultipartRequest('POST', url);

      request.headers['Authorization'] = 'Token $token';
      //print(request.headers['Authorization']);

      request.fields['user'] = userID;

      // adding the cropped images
      List<int> imgByte = lFTPhotosCombo.cropPhotoByte;
      //final file = await http.MultipartFile.fromPath('lftimage', img.path);
      final file0 =  await http.MultipartFile.fromBytes('crop_lftimage', imgByte,
                      contentType: MediaType('crop_lftimage', 'jpg'),
                      filename: 'crop_lftimage.jpg');
      request.files.add(file0);

      // adding the original images
      List<int> originalImgByte = lFTPhotosCombo.originalPhotoByte;
      final file2 =  await http.MultipartFile.fromBytes('original_lftimage', originalImgByte,
          contentType: MediaType('original_lftimage', 'jpg'),
          filename: 'original_lftimage.jpg');
      request.files.add(file2);

      request.fields['cropX'] = lFTPhotosCombo.cropX.toString();
      request.fields['cropY'] = lFTPhotosCombo.cropY.toString();

      request.fields['cropWdith'] = lFTPhotosCombo.cropWdith.toString();
      request.fields['cropHeight'] = lFTPhotosCombo.cropHeight.toString();

      request.fields['phoneInfo'] = lFTPhotosCombo.phoneInfo;

      request.fields['testInfo1'] = lFTPhotosCombo.testInfo1;
      request.fields['testInfo2'] = lFTPhotosCombo.testInfo2;
      request.fields['deviceTxt'] = lFTPhotosCombo.deviceTxt;

      final response = await request.send();
      if (DEBUG_MODE) {
        print(response.headers);
      }

      var rtnCode = response.statusCode.toString();
      if (DEBUG_MODE) {
        print("sendPhoto return code: $rtnCode");
      }

      if (response.statusCode == 201) {
        //print("Image uploaded successfully");
        return ServerRslt.completed;

      } else {
        //print("Image upload failed");
        return ServerRslt.rejected;
      }

    }
    return ServerRslt.rejected;

  }



  Map<String, String> getSavedUserDetail(){
    String ? email = sharedPreferences.getString("email");
    String ? userName = sharedPreferences.getString("userName");

    if (email == null) {
      email = "It seems that some of your information is missing";
    }
    else{
      email = "Email: $email";
    }

    if (userName == null) {
      userName = "Hello!";
    }
    else{
      userName = "Hello $userName";
    }
    Map<String, String> rtnMap = {'userName': userName, 'email': email};

    return rtnMap;
  }

}



class PwdConfirmAuthService{

  Future<bool> onPwdConfirm(String userid, String token,
      String password) async {
    var url;
    if (IS_HTTPS){
      url = Uri.https(BASE_WEBURL_S, 'sgusers/user/password/reset/confirm/$userid/$token/');
    }else {
      if (kIsWeb) {
        url = Uri.parse(
            "$BASE_WEBURL/sgusers/user/password/reset/confirm/$userid/$token/");
      } else {
        url = Uri.parse(
            "$BASE_APPURL/sgusers/user/password/reset/confirm/$userid/$token/");
      }
    }

    var res = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'new_password1': password,
        'new_password2': password,
        'uid': userid,
        'token': token,
      }),
    );
    if (DEBUG_MODE) {
      print(res.statusCode);
    }

    if (res.statusCode == 200) {
      return true;
    }
    else{
      return false;
    }
  }

}





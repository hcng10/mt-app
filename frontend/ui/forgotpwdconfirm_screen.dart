import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import './widgets/register_field.dart';
import '../services/auth_service.dart';

import '../macro/constant.dart';
import '../macro/text.dart';

class ForgotpwdconfirmScreen extends StatefulWidget {
  const ForgotpwdconfirmScreen({Key? key}) : super(key: key);

  @override
  ForgotpwdconfirmScreenState createState() => ForgotpwdconfirmScreenState();
}

class ForgotpwdconfirmScreenState extends State<ForgotpwdconfirmScreen> {

  bool showSplash = false;
  bool waiting = false;

  String _errorMsgPwd = '';

  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();

  @override
  void initState() {

    showSplash = false;
    waiting = false;

    _errorMsgPwd = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Icon icon_pwd = Icon(Icons.lock_outlined , color: Colors.white,);
    PwdConfirmAuthService pwdConfirmAuthService= PwdConfirmAuthService();

    String urlStr = "";
    String userid = "";
    String token = "";

    if (kIsWeb) {
      urlStr = Uri.base.toString();

      // hcak to obtain the GET value,
      // don't understand why standard way not working
      var splitList = urlStr.split('?');
      splitList = splitList[1].split('&');

      //assume only two vars
      var var1List = splitList[0].split('=');
      var var2List = splitList[1].split('=');

      userid = var1List[1];
      token = var2List[1];

      //userid = Uri.base.queryParameters["var1"];
      //token = Uri.base.queryParameters["var2"];

      if (DEBUG_MODE) {
        print("Password reset confirm userid $userid: token: $token");
      }

    }



    bool validatePwdNApp(String val1, String val2) {
      RegExp regex = RegExp(r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

      if(val1.isEmpty || val1.isEmpty){
        _errorMsgPwd = "Password cannot be empty";
      }else if (val1 != val2){
        _errorMsgPwd = "Password not equal";
      }else if (!regex.hasMatch(val1)) {
        _errorMsgPwd = "Password format not valid";
        return false;
      }else if(!kIsWeb){
        _errorMsgPwd = "You cannot reset password within the app";
        return false;
      }else if (urlStr == '' || userid == '' || token == ''){
        _errorMsgPwd = "URL incorrect";
        return false;
      }else{
        return true;
      }
      return false;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        stops: const [0.2, 0.5, 0.8, 0.7],
          colors: [
          COLOR_GRAD1,
          COLOR_GRAD2,
          COLOR_GRAD3,
          COLOR_GRAD4
          ]
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,//no back button
          title: const Text(
            'Reset your password',
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: USUAL_EDGE_GAP*1.2,
            vertical: 0,//edge_gap*2,
          ),
          children: [
            const SizedBox(
              height: 3,
            ),

            showSplash ? const Center(
              child: SizedBox( width: 20, height: 20, child:
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))),
            ): Container(
              child: const SizedBox(
                height: 20,
              ),
            ),

            SizedBox(
              height: 10,
            ),

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  children: [
                    TextSpan(
                      text: forgotpwdconfirm_info,
                      style: const TextStyle(color: Colors.white, fontSize: REG_FONTSIZE),
                    ),
                  ]
              ),
            ),

            RegCustomField(
                icon: icon_pwd,
                is_pwd1: true,
                is_pwd2: false,
                is_email: false,
                keyboard_type: TextInputType.visiblePassword,
                hint: 'Password',
                txtcontroller: passwordController,
                //errorMsg: _errorMsgEmail,
                onTextChanged: (String val){

                }
            ),

            RegCustomField(
              //key: pwdKey,
                icon: icon_pwd,
                is_pwd1: false,
                is_pwd2: true,
                is_email: false,
                keyboard_type: TextInputType.visiblePassword,
                hint: 'Password confirm',
                txtcontroller: passwordController2,
                //errorMsg: _errorMsgPwd,
                onTextChanged: (String val){
                }
            ),


            Container(
              padding: const EdgeInsets.only(top: 40),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  //GoRouter.of(context).goNamed('_homeRouteName', params: {'tab': 'scan'});
                  if (!waiting) {

                    String pwdVal1 = passwordController.text;
                    String pwdVal2 = passwordController2.text;

                    bool pwdValid = validatePwdNApp(pwdVal1, pwdVal2);

                    if (pwdValid) {
                      // disable the user to input again
                      waiting = true;

                      setState(() {
                        showSplash = true;
                      });

                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              //icon: Icon(Icons.question_mark_rounded, color: Colors.black),
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  SizedBox(
                                    height: 60,
                                  ),
                                  CircularProgressIndicator(
                                    backgroundColor: Colors.white54,
                                    color: NAV_COLOR,
                                    strokeWidth: 6.0,
                                  ),
                                  SizedBox(
                                    height: 60,
                                  ),

                                  /*Container(margin: EdgeInsets.only(left: 10),
                                      child:Text("  Loading...",
                                          style: TextStyle(fontSize: REG_FONTSIZE))),*/
                                ],
                              ),
                            );
                          }
                      );

                      // Send email to reset
                      var authRtr = await pwdConfirmAuthService.onPwdConfirm(
                                    userid!, token!, pwdVal1);

                      //pop the alert
                      Navigator.of(context).pop();

                      setState(() {
                        showSplash = false;
                      });

                      // Done trying to do registration
                      //TODO: need to capture the msg from Django
                      Text regPostMsg = authRtr?
                      const Text('Yeah! You have successfully reset your password'):
                      const Text('Error with server communication! Please contact administrator');
                      Icon regPostIcon = authRtr?
                      Icon(Icons.check_circle_outline_rounded , color: Colors.green, size: 30):
                      Icon(Icons.error_outline_rounded, color: Colors.red, size: 30);

                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return AlertDialog(
                              title: regPostMsg,
                              icon: regPostIcon,
                              actions: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle: Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('OK',
                                      style: TextStyle(fontSize: REG_FONTSIZE,
                                          color: TEXT_COLOR)
                                    //color:  COLOR_BLUE? Colors.blueAccent: Colors.black54)
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    if (authRtr == true){
                                      context.pop();
                                    }
                                  },
                                )
                              ],
                            );
                          }
                      );
                      // enable the user to input again
                      waiting = false;

                    } else {
                      String concatStr = _errorMsgPwd != "" ?
                      _errorMsgPwd+ "\n" : "";

                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                                title: const Text('Please check:'),
                                //icon: Icon(Icons.question_mark_rounded, color: Colors.black),
                                content: Text(concatStr)
                            );
                          }
                      );
                    }
                  } // if (waiting) finishes
                },
                style: ElevatedButton.styleFrom(
                  primary: RECBUTTON_COLOR0,
                  //shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),

                child: const Text(
                  'Reset password!',
                  style: TextStyle(fontSize: REG_FONTSIZE,
                      color: TEXTBUTTON_COLOR_FLIP),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

}
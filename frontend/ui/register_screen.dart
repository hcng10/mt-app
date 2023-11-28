import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:email_validator/email_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import './widgets/register_field.dart';
import '../services/auth_service.dart';

import '../macro/constant.dart';
import '../macro/text.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {

  bool showSplash = false;
  bool waiting = false;

  String _errorMsgEmail = '';
  String _errorMsgNames = '';
  String _errorMsgPwd = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameContoller = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();

  @override
  void initState() {

    showSplash = false;
    waiting = false;

    _errorMsgEmail = '';
    _errorMsgNames = '';
    _errorMsgPwd = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
    ));*/

    final authService = Provider.of<AuthService>(context);
    var height = MediaQuery.of(context).size.height;

    Icon icon_email = Icon(Icons.email_outlined, color: Colors.white, );
    Icon icon_pwd = Icon(Icons.lock_outlined , color: Colors.white,);
    Icon icon_person = Icon(Icons.person_outline , color: Colors.white,);


    bool validateEmail(String val) {
      if(val.isEmpty){
        _errorMsgEmail = "Email cannot be empty";

      }else if(!EmailValidator.validate(val, true)){
        _errorMsgEmail = "Invalid email address";
      }else{
        _errorMsgEmail = "";
        return true;
      }
      return false;
    }

    bool validatePwd(String val1, String val2) {
      RegExp regex = RegExp(r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');

      if(val1.isEmpty || val1.isEmpty){
        _errorMsgPwd = "Password cannot be empty";
      }else if (val1 != val2){
        _errorMsgPwd = "Password not equal";
      }else if (!regex.hasMatch(val1)) {
        _errorMsgPwd = "Password format not valid";
        return false;
      }else{
        return true;
      }
      return false;
    }

    bool validateNames(String val1, String val2) {
      if(val1.isEmpty || val1.isEmpty) {
        _errorMsgNames = "Name(s) cannot be empty";
      }else{
        _errorMsgNames = "";
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
            title: const Text(
              'Sign Up',
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
              child: SizedBox( width: 30, height: 30, child:
                CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))),
            ): Container(
              child: const SizedBox(
                height: 30,
              ),
            ),

            RegCustomField(
              icon: icon_email,
              is_pwd1: false,
              is_pwd2: false,
              is_email: true,
              keyboard_type: TextInputType.emailAddress,
              hint: 'Email',
              txtcontroller: emailController,
              //errorMsg: _errorMsgEmail,
              onTextChanged: (String val){
                validateEmail(val);
              }
            ),

            RegCustomField(
                icon: icon_person,
                is_pwd1: false,
                is_pwd2: false,
                is_email: false,
                keyboard_type: TextInputType.name,
                hint: 'First Name',
                txtcontroller: fNameController,
                //errorMsg: _errorMsgFName,
                onTextChanged: (String val){

                }
            ),

            RegCustomField(
                icon: icon_person,
                is_pwd1: false,
                is_pwd2: false,
                is_email: false,
                keyboard_type: TextInputType.name,
                hint: 'Last Name',
                txtcontroller: lNameContoller,
                //errorMsg: _errorMsgLName,
                onTextChanged: (String val){

                }
            ),

            RegCustomField(
              //key: pwdKey,
              icon: icon_pwd,
              is_pwd1: true,
              is_pwd2: false,
              is_email: false,
              keyboard_type: TextInputType.visiblePassword,
              hint: 'Password',
              txtcontroller: passwordController,
              pwd1Msg: register_pwd1Info,
              //errorMsg: _errorMsgPwd,
              onTextChanged: (String val){
                //validatePwd(val);
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

            SizedBox(
              height: 4,
            ),

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'By signing up you are agreeing to the ',
                    style: const TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: 'terms of use',
                    style: const TextStyle(color: TEXT_COLOR),
                    recognizer: TapGestureRecognizer()
                      ..onTap = (){
                        launch(TERMS_URL, forceWebView: false);
                      }
                  ),
                  TextSpan(
                    text: ' and acknowledging the ',
                    style: const TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: 'privacy policy',
                    style: const TextStyle(color: TEXT_COLOR),
                    recognizer: TapGestureRecognizer()
                      ..onTap = (){
                        launch(TERMS_PRIVACY, forceWebView: false);
                      }
                  ),
                ]
              ),
            ),


            Container(
              padding: const EdgeInsets.only(top: 40),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  //GoRouter.of(context).goNamed('_homeRouteName', params: {'tab': 'scan'});
                  if (!waiting) {

                    String emailVal = emailController.text;
                    String pwdVal1 = passwordController.text;
                    String pwdVal2 = passwordController2.text;
                    String fName = fNameController.text;
                    String lName = lNameContoller.text;

                    bool emailValid = validateEmail(emailVal);
                    bool pwdValid = validatePwd(pwdVal1, pwdVal2);
                    bool namesValid = validateNames(fName, lName);

                    if (emailValid && pwdValid && namesValid) {
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

                      // Register
                      var authRtr = await authService.onRegister(
                          emailVal,
                          fName,
                          lName,
                          pwdVal1);

                      Navigator.of(context).pop();

                      setState(() {
                        showSplash = false;
                      });

                      // Done trying to do registration
                      //TODO: need to capture the msg from Django
                      Text regPostMsg = authRtr?
                                      const Text('Registration successful!\nPlease login'):
                                      const Text('Error with user registration! Please contact administrator');
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
                      String concatStr = _errorMsgEmail != "" ?
                                                _errorMsgEmail + "\n" : "";
                      concatStr = concatStr + (_errorMsgNames != "" ?
                                              _errorMsgNames + "\n" : "");
                      concatStr = concatStr + (_errorMsgPwd != "" ?
                                              _errorMsgPwd : "");

                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Please check the following:'),
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
                  'Sign up',
                  style: TextStyle(fontSize: REG_FONTSIZE,
                      color: TEXTBUTTON_COLOR_FLIP),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: RECBUTTON_COLOR2,
                  //shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),
                child: const Text(
                  'Back',
                  style: TextStyle(fontSize: REG_FONTSIZE,
                      color: TEXTBUTTON_COLOR),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

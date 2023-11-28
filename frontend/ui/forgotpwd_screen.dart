import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:email_validator/email_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import './widgets/register_field.dart';
import '../services/auth_service.dart';

import '../macro/constant.dart';
import '../macro/text.dart';


class ForgotpwdScreen extends StatefulWidget {
  const ForgotpwdScreen({Key? key}) : super(key: key);

  @override
  ForgotpwdScreenState createState() => ForgotpwdScreenState();
}


class ForgotpwdScreenState extends State<ForgotpwdScreen> {

  bool showSplash = false;
  bool waiting = false;

  String _errorMsgEmail = '';

  TextEditingController emailController = TextEditingController();

  @override
  void initState() {

    showSplash = false;
    waiting = false;

    _errorMsgEmail = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);

    Icon icon_email = Icon(Icons.email_outlined, color: Colors.white, );

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
            'Forgot password',
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
                      text: forgotpwd_info,
                      style: const TextStyle(color: Colors.white, fontSize: REG_FONTSIZE),
                    ),
                  ]
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


            Container(
              padding: const EdgeInsets.only(top: 40),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  //GoRouter.of(context).goNamed('_homeRouteName', params: {'tab': 'scan'});
                  if (!waiting) {

                    String emailVal = emailController.text;
                    bool emailValid = validateEmail(emailVal);

                    if (emailValid) {
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
                      var authRtr = await authService.onForgotpwd(
                          emailVal);

                      Navigator.of(context).pop();

                      setState(() {
                        showSplash = false;
                      });

                      // Done trying to do registration
                      //TODO: need to capture the msg from Django
                      Text regPostMsg = authRtr?
                      const Text('If you created an account before, an email will be on its way!'):
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
                      String concatStr = _errorMsgEmail != "" ?
                      _errorMsgEmail + "\n" : "";

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
                  'Email me!',
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
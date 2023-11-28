import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:email_validator/email_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../services/secure_store_service.dart';
import './widgets/login_field.dart';

import '../macro/constant.dart';
import '../macro/text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {

  bool showSplash = false;
  bool waiting = false;
  String _errorMsgEmail = '';
  String _errorMsgPwd = '';

  final SecureStoreService _secureStorage = SecureStoreService();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> fetchSecureStorageData() async {
    emailController.text = await _secureStorage.getUserEmail() ?? '';
    passwordController.text = await _secureStorage.getPassword() ?? '';
  }

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    showSplash = false;
    waiting = false;
    _errorMsgEmail = '';
    _errorMsgPwd = '';

    fetchSecureStorageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context);
    var height = MediaQuery.of(context).size.height;

    Icon iconEmail = const Icon(Icons.email_outlined, color: Colors.white, );
    Icon iconPwd = const Icon(Icons.lock_outlined , color: Colors.white,);


    bool validateEmail(String val) {
      if(val.isEmpty){
        setState(() {
          _errorMsgEmail = "Email cannot be empty";
        });
      }else if(!EmailValidator.validate(val, true)){
        setState(() {
          _errorMsgEmail = "Invalid email address";
        });
      }else{
        setState(() {
          _errorMsgEmail = "";
        });
        return true;
      }
      return false;
    }

    bool validatePwd(String val) {
      if(val.isEmpty){
        setState(() {
          _errorMsgPwd = "Password cannot be empty";
        });
      }else{
        setState(() {
          _errorMsgPwd = "";
        });
        return true;
      }
      return false;
    }


    return Scaffold(
      backgroundColor: DARKCOLOR_SCHEME,
      //COLOR_BLUE? Colors.blue:COLOR_GREY? Colors.grey: Colors.black,
      appBar: null,
      body: Container(
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

        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: USUAL_EDGE_GAP,
            vertical: USUAL_EDGE_GAP*2,
          ),
          children: [
            showSplash ? const Center(
              child: SizedBox( width: 30, height: 30, child:
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))),
            ): Container(
              child: const SizedBox(
                height: 30,
              ),
            ),

            Container(
                margin: EdgeInsets.only(top: height/6),
                child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children:  [
                        Icon(Icons.medical_services,
                          color: LOGO_COLOR,
                          size: 42.0,),
                        Text(
                          " " + APP_NAME,
                          textAlign: TextAlign.center,
                          //overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white,
                              fontSize: 46,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w900),
                        ),
                      ],
                    )
                ),

            ),

            const SizedBox(
              height: 5,
            ),

            Container(
              child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 100,
                      ),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(text: 'by ', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white)),
                            TextSpan(text: " " + CREATOR_NAME, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
              ),

            ),


            const SizedBox(
              height: 5,
            ),
            LoginCustomField(
                icon: iconEmail,
                is_pwd: false,
                is_email: true,
                keyboard_type: TextInputType.emailAddress,
                hint: 'Email',
                txtcontroller: emailController,
                errorMsg: _errorMsgEmail,
                onTextChanged: (String val){
                  validateEmail(val);
                }

            ),
            LoginCustomField(
              //key: pwdKey,
                icon: iconPwd,
                is_pwd: true,
                is_email: false,
                keyboard_type: TextInputType.visiblePassword,
                hint: 'Password',
                txtcontroller: passwordController,
                errorMsg: _errorMsgPwd,
                onTextChanged: (String val){
                  validatePwd(val);
                }
            ),

            Align(
              alignment: Alignment.centerRight,
              child: Container(
                child: TextButton(
                  onPressed: () {
                    //Navigator.push(
                    //context,
                    //MaterialPageRoute(builder: (context) => ForgotPassPage()),
                    context.push('/rootRouteName/forgotpwd');
                    //);
                  },
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(color: Colors.white,
                        fontSize: 20,
                        //fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(top: 40),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  //GoRouter.of(context).goNamed('_homeRouteName', params: {'tab': 'scan'});

                  String emailVal = emailController.text;
                  String pwdVal = passwordController.text;

                  if (!waiting &&
                      validateEmail(emailVal) && validatePwd(pwdVal)){

                    waiting = true;
                    setState(() {
                      showSplash = true;
                    });
                    // save the login email and password
                    await _secureStorage.setUserEmail(emailVal);
                    await _secureStorage.setPassword(pwdVal);

                    // call auth_servcie to login
                    var authRtr = await authService.onLogin(emailController.text,
                        passwordController.text);

                    if (authRtr == false){
                      setState(() {
                        showSplash = false;
                        _errorMsgPwd = "Email and/or password not correct";
                      });
                    }else{
                      setState(() {
                        showSplash = false;
                      });
                    }
                    waiting = false;
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 20, color: TEXTBUTTON_COLOR_FLIP),
                ),
                style: ElevatedButton.styleFrom(
                  primary: RECBUTTON_COLOR0,
                  //shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.only(top: 20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  //GoRouter.of(context).goNamed('_homeRouteName', params: {'tab': 'scan'});
                  if (!waiting) {
                    context.push('/rootRouteName/register');
                  }
                },
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 20, color: TEXTBUTTON_COLOR),
                ),
                style: ElevatedButton.styleFrom(
                  primary: RECBUTTON_COLOR1,
                  //shape: CircleBorder(),
                  padding: EdgeInsets.all(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
Container(
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
                  onPressed: () =>
                      context.push('/scan/scan0_info/scan1_camera'),
                  child: const Text(
                    'Yes! I am good to go',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
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
                  child: const Text(
                    'No! I want my Mommy',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 182, 64, 64),
                    //shape: CircleBorder(),
                    padding: EdgeInsets.all(20),
                  ),
                ),
              ),
            ],
          ),
        ));
*/
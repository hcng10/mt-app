import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

$YOURHOST = "your domain";
$DEBUGHOST = "debug reporting domain";


const Color IMPERIAL_BLUE =  Color.fromARGB(255, 0, 64, 116);

const Color IMPERIAL_ORANGE = Color.fromARGB(255, 210, 64, 0);
const Color IMPERIAL_GREEN = Color.fromARGB(255, 2, 137, 59);
const Color IMPERIAL_POOLBLUE = Color.fromARGB(255, 0, 172, 215);


const DARKCOLOR_SCHEME = IMPERIAL_BLUE;//IMPERIAL_BLUE;//Colors.blue;
const DARKCOLOR_SCHEME_STR = "imperial_blue";//imperial_blue

const LOGO_COLOR = Colors.white;


// Color for the gradient color in the background

// for gradient use
const Color IMPERIAL_BLUE_PROCESSBLUE = Color.fromARGB(255, 0, 145, 212);
const Color IMPERIAL_BLUE_LIGHTBLUE = Color.fromARGB(255, 28, 89, 142);
const Color IMPERIAL_BLUE_PURPLE = Color.fromARGB(255, 27, 0, 116);


Color COLOR_GRAD1 = (DARKCOLOR_SCHEME_STR == "blue") ? Colors.blue[300]! :
                    (DARKCOLOR_SCHEME_STR == "black") ? Colors.grey :
                    (DARKCOLOR_SCHEME_STR == "imperial_blue") ? IMPERIAL_BLUE_PROCESSBLUE: Colors.blue[300]!;

Color COLOR_GRAD2 = (DARKCOLOR_SCHEME_STR == "blue") ? Colors.blue[500]! :
                        (DARKCOLOR_SCHEME_STR == "black") ? Colors.grey[850]! :
                        (DARKCOLOR_SCHEME_STR == "imperial_blue") ? IMPERIAL_BLUE_LIGHTBLUE: Colors.blue[500]!;

Color COLOR_GRAD3 = (DARKCOLOR_SCHEME_STR == "blue") ? Colors.blue :
                        (DARKCOLOR_SCHEME_STR == "black") ? Colors.black :
                        (DARKCOLOR_SCHEME_STR == "imperial_blue") ? IMPERIAL_BLUE: Colors.blue;

Color COLOR_GRAD4 = (DARKCOLOR_SCHEME_STR == "blue") ? Colors.blue[700]! :
                      (DARKCOLOR_SCHEME_STR == "black") ? Colors.blueGrey[900]! :
                      (DARKCOLOR_SCHEME_STR == "imperial_blue") ? IMPERIAL_BLUE_PURPLE: Colors.blue[700]!;



// Button colors for login and registration
const RECBUTTON_COLOR0 =  (DARKCOLOR_SCHEME_STR == "blue") ? Colors.white :
                          (DARKCOLOR_SCHEME_STR == "black") ? Colors.green :
                          (DARKCOLOR_SCHEME_STR == "imperial_blue") ? Colors.white: Colors.green;

const RECBUTTON_COLOR1 =  (DARKCOLOR_SCHEME_STR == "blue") ? Colors.white :
                          (DARKCOLOR_SCHEME_STR == "black") ? Colors.indigo :
                          (DARKCOLOR_SCHEME_STR == "imperial_blue") ? IMPERIAL_POOLBLUE: Colors.indigo;

const RECBUTTON_COLOR2 =  (DARKCOLOR_SCHEME_STR == "blue") ? Colors.white :
                            (DARKCOLOR_SCHEME_STR == "black") ? Color.fromARGB(255, 182, 64, 64) :
                            (DARKCOLOR_SCHEME_STR == "imperial_blue") ? IMPERIAL_POOLBLUE: Color.fromARGB(255, 182, 64, 64);

// Button colors for main
const CIRBUTTON_COLOR = (DARKCOLOR_SCHEME_STR == "blue") ? Colors.indigo :
                          (DARKCOLOR_SCHEME_STR == "black") ? Colors.green :
                          (DARKCOLOR_SCHEME_STR == "imperial_blue") ? IMPERIAL_POOLBLUE: Colors.green;

const YESBUTTON_COLOR =  (DARKCOLOR_SCHEME_STR == "blue") ? Colors.indigo :
                            (DARKCOLOR_SCHEME_STR == "black") ? Colors.green :
                            (DARKCOLOR_SCHEME_STR == "imperial_blue") ? IMPERIAL_POOLBLUE: Colors.green;

//customized red for No button
const NOBUTTON_COLOR =  (DARKCOLOR_SCHEME_STR == "blue") ? Colors.blue :
                            (DARKCOLOR_SCHEME_STR == "black") ? Color.fromARGB(255, 182, 64, 64) :
                            (DARKCOLOR_SCHEME_STR == "imperial_blue") ? IMPERIAL_BLUE: Color.fromARGB(255, 182, 64, 64);

const SOSOBUTTON_COLOR =  (DARKCOLOR_SCHEME_STR == "blue") ? Colors.blue :
                            (DARKCOLOR_SCHEME_STR == "black") ? Colors.indigo :
                            (DARKCOLOR_SCHEME_STR == "imperial_blue") ? IMPERIAL_BLUE: Colors.indigo;

const TEXTAPPBAR_COLOR =  Colors.white;


const TEXTBUTTON_COLOR =  (DARKCOLOR_SCHEME_STR == "blue") ? Colors.black :
                    (DARKCOLOR_SCHEME_STR == "black") ? Colors.white :
                    (DARKCOLOR_SCHEME_STR == "imperial_blue") ? Colors.white: Colors.white;

const TEXTBUTTON_COLOR_FLIP =  (DARKCOLOR_SCHEME_STR == "blue") ? Colors.black :
                          (DARKCOLOR_SCHEME_STR == "black") ? Colors.white :
                          (DARKCOLOR_SCHEME_STR == "imperial_blue") ? Colors.black: Colors.white;

const TEXT_COLOR =  (DARKCOLOR_SCHEME_STR == "blue") ? Colors.black54 :
                    (DARKCOLOR_SCHEME_STR == "black") ? Colors.blueAccent :
                    (DARKCOLOR_SCHEME_STR == "imperial_blue") ? IMPERIAL_POOLBLUE: Colors.blueAccent;

const NAV_COLOR = (DARKCOLOR_SCHEME_STR == "blue") ? Colors.blue :
                  (DARKCOLOR_SCHEME_STR == "black") ? Colors.black :
                  (DARKCOLOR_SCHEME_STR == "imperial_blue") ? IMPERIAL_BLUE: Colors.grey;

const PHONETXT_COLOR0 =  (DARKCOLOR_SCHEME_STR == "blue") ? IMPERIAL_BLUE:
                            (DARKCOLOR_SCHEME_STR == "black") ? Colors.black :
                            (DARKCOLOR_SCHEME_STR == "imperial_blue") ? IMPERIAL_BLUE: Colors.indigo;

const PHONETXT_COLOR1 =  (DARKCOLOR_SCHEME_STR == "blue") ? IMPERIAL_POOLBLUE:
                          (DARKCOLOR_SCHEME_STR == "black") ? Colors.black :
                          (DARKCOLOR_SCHEME_STR == "imperial_blue") ? IMPERIAL_POOLBLUE: Colors.indigo;



const double SCAN_FONTSIZE = 20;
const double REG_FONTSIZE = 20;
const double USUAL_EDGE_GAP = 20;

// use the constant to set the max width you want for text and button
const double USUAL_WIDTH_BND = 600;

const double NAMEBOX_HEIGHT = 70;
const double LOGOUT_WIDTH = 40;
const double EMAIL_WIDTH = 300;

const double SCAN0a_BIGFONTSIZE = 60;
const double SCAN0a_CLIPHEIGHT = 580;

const double SCAN0b_INFOHEIGHT = 120;
const double SCAN0b_CAMHEIGHT = 480;
const double SCAN0b_CAMWIDTH = 640;

const double SCAN1_INFOHEIGHT = 200;
const double SCAN2_INFOHEIGHT = 270;

const double DEFAULT_CAMERAHEIGHT = 350;
const double DEFAULT_PHOTOHEIGHT = 600;





//TODO: Hack the width and height for now
const PHOTO_HISTORY_TOP_W = (HOG_FRAME_W / 4)*4;
const PHOTO_HISTORY_TOP_H = (HOG_FRAME_H / 4)*4;
const double PHOTO_HISTORY_TITLE_PADDING = 30;

const HOG_FRAME_W = 128;
const HOG_FRAME_H = 384;

const CAMERA_RSTN = ResolutionPreset.veryHigh;
const CAMERA_RSTN_VAL = [1080.0, 1920.0];

const PHOTO_VIEW_NOTYPE = 2;


const BASE_WEBURL_S = "$YOURHOST:8000";
const BASE_WEBURL = "http://127.0.0.1:8000";
//"http://172.22.43.54:8000";
    //"http://127.0.0.1:8000";
const BASE_APPURL = "10.0.2.2:8000";

const TERMS_URL = "https://$YOURHOST/tnc/tnc.html";
const TERMS_PRIVACY = "https://$YOURHOST/tnc/pn.html";
const BUG_REPORT = "https://$DEBUGHOST";


enum ServerRslt {
  unknownTokenOrUser,
  completed,
  rejected,
}

const IS_HTTPS = false;
// The route.dart code still needs a bit of handcraft change
const HAS_QRSCREEN = true;
const SKIP_LOGGIN = false;

const DEBUG_MODE = false;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

String APP_NAME = "Qwikapp mini";
String CREATOR_NAME = "THE STEVENS GROUP";

String register_pwd1Info = "Use 8 or more characters with a mix of letters, numbers & symbols (!, #, \$)";

String forgotpwd_info = "We will send you an email with a magic link to reset your password. Don't forget to check your spam, junk, or promotions folder.";
String forgotpwdconfirm_info = "Please reset your password. Use 8 or more characters with a mix of letters, numbers & symbols (!, #, \$)";

String scan0_info =
    "You must have waited for 10 minutes to read the result. Do not leave the test to develop for longer than 20 minutes. This will make the test void.";
String scan0_yes = "Yes! I am good to go";
String scan0_no = "No! I want my Mommy";
const String HOME_ACC_INFO = "History";

String scan0b_info1 = "Please scan the QR code on the tray";
String scan0b_info2 = "Attention: Not the QR code on the test itself";

String scan0c_info1 =
    "If the above detail doesn't match the QR code description, please return to 'Your phone detail' page, using the top left button.";
String scan0c_info2 = "(DON'T use the back button in your browser)";
String scan0c_info3 = "You are submitting photo for the following test:\n\n";

String scan0c_qrstr1 = "brand";
String scan0c_qrstr2 = "concentration";

String scan1_info1 = "Pick a cardboard as background, put the test on it";
String scan1_info2 =
    "Please make sure the test cassette is within the green frame";

String scan2_info1 = "It shows the whole test cassette";
String scan2_info2 =
    "It's clear - there's no blur or glare";
String scan2_info3 =
    "It was taken just now";

String scan3_info = "Your photo is uploaded! \nYou can go to $HOME_ACC_INFO to review your previous photos.";

extension StringExtensions on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
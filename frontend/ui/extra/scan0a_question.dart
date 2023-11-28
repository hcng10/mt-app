import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

//import '../../services/auth_service.dart';
import '../../services/secure_store_service.dart';
import '../../macro/constant.dart';
import '../../macro/text.dart';

class Scan0aQuestionScreen extends StatefulWidget {
  const Scan0aQuestionScreen({Key? key}) : super(key: key);

  @override
  Scan0aQuestionScreenState createState() => Scan0aQuestionScreenState();
}

class Scan0aQuestionScreenState extends State<Scan0aQuestionScreen> {

  final SecureStoreService _secureStorage = SecureStoreService();

  TextEditingController deviceTxtController = TextEditingController();
  late String deviceTxt;

  Future<void> fetchSecureStorageData() async {
    deviceTxt = await _secureStorage.getSavedPhoneDetail() ?? '';
    deviceTxtController.text = deviceTxt;

  }

  @override
  void initState() {
    fetchSecureStorageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    //final authService = Provider.of<AuthService>(context);

    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    double clipWidth = mediaWidth < USUAL_WIDTH_BND? mediaWidth: USUAL_WIDTH_BND;
    clipWidth = clipWidth - USUAL_EDGE_GAP * 4;

    AppBar question_appBar = AppBar(title: const Text('Your Phone Details'),
      backgroundColor: DARKCOLOR_SCHEME,
      foregroundColor: Colors.white,
      //automaticallyImplyLeading: false,
    );
    final double appBarHeight = question_appBar.preferredSize.height;

    return Scaffold(
        appBar: question_appBar,
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: Center(
          child: SingleChildScrollView(
            //padding: const EdgeInsets.fromLTRB(USUAL_EDGE_GAP * 4,
            //                                    USUAL_EDGE_GAP * 2,
            //                                    USUAL_EDGE_GAP * 4,
            //                                    USUAL_EDGE_GAP * 2 ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  Stack(
                    children: [
                      ConstrainedBox(
                        // the main background
                        constraints: BoxConstraints(
                          maxHeight: SCAN0a_CLIPHEIGHT + USUAL_EDGE_GAP * 4, // - scan1_infoHeight,
                          minHeight: mediaHeight-appBarHeight,
                          minWidth: mediaWidth,
                          maxWidth: mediaWidth,
                        ),
                        child: Container(
                          color: Colors.transparent,
                        ),
                      ),

                      Positioned(
                        left: mediaWidth/2 - (clipWidth/2),
                        top: USUAL_EDGE_GAP * 2,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              alignment: Alignment.center,
                              constraints: BoxConstraints(
                                maxHeight: SCAN0a_CLIPHEIGHT,
                                maxWidth: clipWidth,
                              ),
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFEBEBF4),
                                      Color(0xFFF4F4F4),
                                      Color(0xFFEBEBF4),
                                    ],
                                    stops: [
                                      0.1,
                                      0.3,
                                      0.4,
                                    ],
                                    begin: Alignment(-1.0, -0.3),
                                    end: Alignment(1.0, 0.3),
                                    tileMode: TileMode.clamp,
                                  )
                              ),
                            ),
                        )
                      ),

                      Positioned(
                        //left: height > width ? 0: width/4,//offsetX
                        //top: 0,//offsety
                        left: mediaWidth/2 - (clipWidth/2),
                        top: USUAL_EDGE_GAP * 3,
                        child: Container(
                          margin: const EdgeInsets.all(USUAL_EDGE_GAP),
                          alignment: Alignment.topLeft,
                          constraints: BoxConstraints(
                            maxHeight: SCAN0a_CLIPHEIGHT,
                            maxWidth: clipWidth,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('What is \nyour \ndevice?',
                                  style: TextStyle(color: PHONETXT_COLOR0,
                                      fontSize: SCAN0a_BIGFONTSIZE/1.2,
                                      fontWeight: FontWeight.bold)),

                              const SizedBox(
                                height: USUAL_EDGE_GAP - 5,
                              ),

                              const Text(' iPad 6th Gen? \n Galaxy S23?',
                                  style: TextStyle(color: IMPERIAL_BLUE,
                                      fontSize: SCAN0a_BIGFONTSIZE/3,
                                      fontWeight: FontWeight.w300)),

                              const SizedBox(
                                height: USUAL_EDGE_GAP - 5,
                              ),

                              const Text('Please type in \nthe full device name, \nincluding the generation.',
                                  style: TextStyle(color: IMPERIAL_BLUE,
                                      fontSize: SCAN0a_BIGFONTSIZE/3,
                                      fontWeight: FontWeight.w400)),

                              const SizedBox(
                                height: USUAL_EDGE_GAP * 1.5 ,
                              ),

                              Container(
                                height: 60,
                                width: clipWidth - USUAL_EDGE_GAP * 2,
                                //margin: EdgeInsets.only(top: USUAL_EDGE_GAP),
                                padding: EdgeInsets.only(left: USUAL_EDGE_GAP, right: USUAL_EDGE_GAP),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: PHONETXT_COLOR1,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: 40,
                                      child: Icon(Icons.perm_device_info_outlined,
                                              color: PHONETXT_COLOR1),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: deviceTxtController,
                                        //obscureText: (this.is_pwd1 || this.is_pwd2),
                                        //keyboardType: this.keyboard_type,
                                        cursorColor: IMPERIAL_POOLBLUE,
                                        decoration: const InputDecoration.collapsed(
                                          hintText: "Your device",
                                          hintStyle: TextStyle(
                                            color: PHONETXT_COLOR1,
                                            fontSize: SCAN0a_BIGFONTSIZE/3,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        style: const TextStyle(
                                          color: PHONETXT_COLOR1,
                                          fontSize: SCAN0a_BIGFONTSIZE/3,
                                          fontWeight: FontWeight.w400,
                                        ),

                                        //onChanged: (val) => onTextChanged(val),

                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: USUAL_EDGE_GAP * 1.5,
                              ),


                              Container(
                                //padding: const EdgeInsets.only(left: USUAL_EDGE_GAP,
                                    //right: USUAL_EDGE_GAP),
                                width: clipWidth - USUAL_EDGE_GAP * 2,

                                child: ElevatedButton(
                                  onPressed: () async{

                                    deviceTxt = deviceTxtController.text;

                                    if (deviceTxt.trim().isNotEmpty){
                                      List param = [deviceTxt,];

                                      //await authService.setSavedPhoneDetail(deviceTxt);
                                      await _secureStorage.setSavedPhoneDetail(deviceTxt);

                                      context.push('/scan/scan0a_question/scan0b_qr/',
                                          extra: param);
                                    }
                                    else{
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Oh no ... You haven't typed anything"),
                                              icon: Icon(Icons.error_outline_rounded, color: Colors.red, size: 30),
                                              actions: <Widget>[
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    textStyle: Theme.of(context).textTheme.labelLarge,
                                                  ),
                                                  child: const Text('OK',
                                                      style: TextStyle(fontSize: SCAN_FONTSIZE,
                                                          color: TEXT_COLOR)
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          }
                                      );
                                    }

                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: YESBUTTON_COLOR,
                                    //shape: CircleBorder(),
                                    padding: EdgeInsets.all(20),
                                  ),


                                  child: const Text(
                                    'OK',
                                    style: TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                ),
                              ),


                            ]
                          ),
                        )
                      ),

                    ],
                  ),

              ],
            )
          )
      )
    );

  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
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
      ),
    );
  }
}

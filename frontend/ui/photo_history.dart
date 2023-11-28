import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/animation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'widgets/history_clipper.dart';
import 'widgets/load_overlay.dart';
import 'widgets/shimmer_loading.dart';

import '../services/auth_service.dart';
import '../services/photolist_service.dart';

import '../macro/constant.dart';
import '../macro/text.dart';



class PhotoHistory extends StatefulWidget {
  const PhotoHistory({Key? key}) : super(key: key);

  @override
  _PhotoHistoryState createState() => _PhotoHistoryState();
}

class _PhotoHistoryState extends State<PhotoHistory> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final ldOverlay = LoadingOverlay.of(context);

    final authService = Provider.of<AuthService>(context);
    final photoListService = Provider.of<PhotoListService>(context);

    Map<String, String> userInfoMap = authService.getSavedUserDetail();

    //Future<void> asynGetPhotosValue = authService.onGetPhotos();
    double accInfoBarHeight = NAMEBOX_HEIGHT + NAMEBOX_HEIGHT * 3/4;

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // The top bar that displays user information
          Stack(
            alignment: Alignment.topLeft,
            children: [
              SizedBox(
                height: accInfoBarHeight,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  //color: NAV_COLOR,
                  child:  ClipPath(
                    clipper: HistoryClipper(),
                    child: Container(
                      color: NAV_COLOR,
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 0,//offsetX
                top: 0,//offsety
                child: SizedBox(
                    height: NAMEBOX_HEIGHT,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width-LOGOUT_WIDTH - USUAL_EDGE_GAP,
                              child: Container(
                                padding: const EdgeInsets.only(left: USUAL_EDGE_GAP, right: USUAL_EDGE_GAP),
                                child: Text(
                                  userInfoMap['userName']!,
                                  textAlign: TextAlign.left,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(fontSize: 20 + 5,
                                      color: TEXTAPPBAR_COLOR,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),

                            SizedBox(
                              width: MediaQuery.of(context).size.width-
                                      LOGOUT_WIDTH - USUAL_EDGE_GAP,

                              child: Container(
                                padding: const EdgeInsets.only(left: USUAL_EDGE_GAP,
                                    right: USUAL_EDGE_GAP,
                                    top: USUAL_EDGE_GAP/3,
                                    bottom: USUAL_EDGE_GAP/3),
                                child: Text(
                                  userInfoMap['email']!,
                                  textAlign: TextAlign.left,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(fontSize: 15,
                                                  color: TEXTAPPBAR_COLOR),
                                ),
                              ),
                            ),


                          ],
                        ),

                        Container(
                          //padding: const EdgeInsets.all(edge_gap),
                            width: LOGOUT_WIDTH,
                            child: IconButton(
                              icon: const Icon(Icons.logout ,
                                  color: Colors.white),
                              onPressed: () async {
                                //TODO: display alert
                                var authRtr = await ldOverlay
                                    .waiting(authService.onLogout());
                              },

                              style: ElevatedButton.styleFrom(
                                primary: NAV_COLOR,
                                //shape: CircleBorder(),
                                //padding: EdgeInsets.all(20),
                              ),
                            )
                        ),
                      ],
                    )
                ),
              ),
            ],
          ),

          //listview for the LFT photos
          Consumer<PhotoListService>(
            builder: (context, photoListService2, child){
              Future<PhotoListResult> asynPhotoListsValue = photoListService.onGetPhotos();
              photoListService.updateState(false);

              return Shimmer(
                child: Expanded(
                  child: FutureBuilder<PhotoListResult>(
                    future: asynPhotoListsValue,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                       return ListView.builder(
                         itemCount: snapshot.data!.listLen,
                         itemBuilder: (BuildContext context, int index)  {

                              var lftImage = Image(image: MemoryImage(
                                  Uint8List.fromList(
                                  snapshot.data!.cropPhotoList[index].photoByte)),
                                  width: PHOTO_HISTORY_TOP_W,
                                  height: PHOTO_HISTORY_TOP_H,
                                  fit:BoxFit.fitHeight);

                              DateTime dateTime = snapshot.data!.cropPhotoList[index].dateTime;
                              String dateTimeStr = snapshot.data!.cropPhotoList[index].dateTimeStr;
                              String infoStr = snapshot.data!.cropPhotoList[index].lftType;

                              String date = "";
                              //String time = "";
                              String info = "";

                              // check if it is 1970, that would be error
                              if (dateTime.year == 1970){
                                date = "Date: Some days ago";
                                //time = "Time: Some time ago";
                              }else{
                                date = "Date: ${dateTime.day}-${dateTime.month}-${dateTime.year}";
                                date =  date + "  ${dateTime.hour}:${dateTime.minute}";
                                //time = 'Time: ${dateTimeStr.substring(11,13)}:${dateTimeStr.substring(13,15)}';
                              }

                              info = "Test Info: " + infoStr;

                              //String dateTimeExt = snapshot.data!.photoList[index].dateStr;
                              //final dateTime = dateTimeExt.split('.')[0];
                              //final date = "Date: ${dateTime.substring(0,10)}";
                              //final time = 'Time: ${dateTime.substring(11,13)}:${dateTime.substring(13,15)}';

                              return Card(
                                child: ListTile(
                                  visualDensity: VisualDensity(vertical: 4),
                                  minVerticalPadding: PHOTO_HISTORY_TITLE_PADDING,
                                  leading: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                      child: lftImage
                                  ),
                                  title: Text(date, style: const TextStyle(
                                    fontSize: 20.0,
                                    //color: Colors.black,
                                    //fontWeight: FontWeight.w600,
                                  ),),
                                  subtitle: Text(info, style: const TextStyle(
                                    fontSize: 20.0,
                                    //color: Colors.black,
                                    //fontWeight: FontWeight.w600,
                                  ),),
                                  //trailing: Icon(icons[index]),
                                  onTap: () async{
                                    List param = [snapshot.data!, index];
                                    context.go(
                                        '/history/photo0_view',
                                        extra: param);
                                  },
                                ),
                              );
                            }
                        );
                      }else{
                        return const Center(
                          child: CircularProgressIndicator(
                          backgroundColor: Colors.white54,
                          color: NAV_COLOR,
                          strokeWidth: 6.0,
                          ));

                                            /*return ShimmerLoading(
                          isLoading:true,// snapshot.connectionState == ConnectionState.waiting,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height -
                                    accInfoBarHeight,
                            child: const DecoratedBox(
                              decoration: BoxDecoration(
                                  color: Colors.white
                              ),
                            ),
                          )
                        );*/
                      }
                    }
                  ),
                  //padding: const EdgeInsets.all(edge_gap),

                ),
              );
            }
          ),

        ],
      );


  }
}


import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../services/photolist_service.dart';

import '../macro/constant.dart';
import '../macro/text.dart';

class Photo0ViewScreen extends StatefulWidget {
  const Photo0ViewScreen({required this.param, Key? key}) : super(key: key);
  final List param;

  @override
  Photo0ViewScreenState createState() => Photo0ViewScreenState();
}


class Photo0ViewScreenState extends State<Photo0ViewScreen> {
  late PhotoListResult photoListResult;
  late int photoIndex;

  late List<List<int>> photoViewList = <List<int>>[];

  @override
  void initState() {
    super.initState();

    photoListResult = widget.param[0];
    photoIndex = widget.param[1];

    photoViewList.add(photoListResult.cropPhotoList[photoIndex].photoByte);
    photoViewList.add(photoListResult.originalPhotoList[photoIndex].photoByte);
  }

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = photoListResult.cropPhotoList[photoIndex].dateTime;


    void onPageChanged(int index) {
      setState(() {
        //photoIndex = index;
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Date: ${dateTime.day}-${dateTime.month}-${dateTime.year}"),
          backgroundColor: DARKCOLOR_SCHEME,
          foregroundColor: Colors.white,
        ),
        body: WillPopScope(
          onWillPop: () async {
            //useless code for now to return something
            Navigator.pop(context, photoIndex);
            return Future(() => false);
          },

          child: Container(
            child: PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              itemCount: PHOTO_VIEW_NOTYPE,// the crop and original// photoListResult.listLen,
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: MemoryImage(
                    Uint8List.fromList(photoViewList[index])),
                    //photoListResult.cropPhotoList[photoIndex].photoByte)),
                  initialScale: PhotoViewComputedScale.contained * 1,
                  minScale: PhotoViewComputedScale.contained * 0.8,
                  maxScale: PhotoViewComputedScale.covered * 1.5,
                  heroAttributes:
                    PhotoViewHeroAttributes(tag: photoListResult.cropPhotoList[photoIndex].dateTimeStr),
                );
              },
              loadingBuilder: (context, event) => const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white54,
                    color: NAV_COLOR,
                    strokeWidth: 6.0,
                  )
              ),
              //backgroundDecoration: widget.backgroundDecoration,
              //pageController: widget.pageController,
              onPageChanged: onPageChanged,
              scrollDirection: Axis.horizontal,
            ),

          ),
        ),
    );


  }
}
import 'dart:io';

import 'package:apis/core/view_models/devices_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class DeviceView extends GetWidget<DevicesViewModel> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<DevicesViewModel>(
        builder: (controller) => Container(
            width: screenWidth,
            height: screenHeight,
            child: LayoutBuilder(
              builder: (context, constrains) {
                double height = constrains.maxHeight;
                double width = constrains.maxWidth;
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: SafeArea(
                    child: GridView.builder(
                        gridDelegate:
                            SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 2,childAspectRatio: 2,crossAxisSpacing: 1,mainAxisSpacing: 1),
                        itemBuilder: (BuildContext context, index) =>
                            Container(
                              width: width *0.3,
                              height: height*0.5,
                              child: Column(children: [
                                CachedNetworkImage(
                                  imageUrl: 'https://tetoplay.herokuapp.com/static/images/ping-pong.png',
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.all(30),
                                          child: CircularProgressIndicator(value: downloadProgress.progress,color: Colors.lightBlue,)),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                  width: width * 0.37,
                                  height: height * 0.12,
                                ),
                              SizedBox(height: height*0.03,),Text('device name')],),
                            )),
                  ),
                );
              },
            )));
  }
}

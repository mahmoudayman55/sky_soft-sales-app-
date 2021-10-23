
import 'dart:io';
import 'package:get/get.dart';
import 'package:apis/core/view_models/home_view_models.dart';
import 'package:apis/models/device_model.dart';
import 'package:apis/view/devices_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
//import 'package:skysoft_admin/core/view_model/home_view_model.dart';

class HomeView extends GetWidget<HomeViewModel> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<HomeViewModel>(
        builder: (controller) => Container(
            width: screenWidth,
            height: screenHeight,
            child: LayoutBuilder(
              builder: (context, constrains) {
                double height = constrains.maxHeight;
                double width = constrains.maxWidth;
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: Padding(
                    padding: EdgeInsets.all(25),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextField(
                              decoration:
                                  InputDecoration(labelText: 'device name'),
                              onChanged: (value) => controller.name = value,
                            ),
                            TextField(
                              keyboardType: TextInputType.number,
                              decoration:
                                  InputDecoration(labelText: 'device price'),
                              onChanged: (value) =>
                                  controller.price = int.parse(value),
                            ),
                            GetBuilder<HomeViewModel>(
                              builder: (controller) => DropdownButton<String>(
                                dropdownColor: Colors.blueGrey,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.limeAccent,
                                ),
                                items: controller.services,
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.icon = value;
                                    controller.update();
                                  }
                                },
                                value: controller.services[0].value,
                              ),
                            ),
                            ElevatedButton(
                                onPressed: ()=>controller.insertNewDevice(Device('icon', 'name', 'status', 5))
                            ,
                                child: Text('save')) ,
                            Text(controller.data)
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            )));
  }
}

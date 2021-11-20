import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:skysoft/constants.dart';
import 'package:skysoft/core/view_model/constants_view_model.dart';

class ConstantsView extends GetWidget<ConstantsViewModel> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<ConstantsViewModel>(
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Container(
                            width: width,
                            height: height,
                            child: SingleChildScrollView(
                              child: Form(
                                key: controller.formKey,
                                child: Column(
                                  children: [
                                    Text(
                                      'الثوابت',
                                      style: labelsTextStyle,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          width: width * 0.4,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                decoration: TextInputDecoration(
                                                    'الضريبة', null),
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: width * 0.4,
                                          child: Column(
                                            children: [
                                              TextFormField(
                                                onSaved: (value){
                                                  controller.setStartValue=int.parse(value!);
                                                },
                                                decoration: TextInputDecoration(
                                                    'بداية الفواتير', null),
                                                initialValue: controller.startValue.toString(),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height*0.03,),
                                    defaultButton(function: ()=>controller.saveConstants(),text: 'حفظ',height: height*0.1,width: width*0.3),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ));
              },
            )));
  }
}

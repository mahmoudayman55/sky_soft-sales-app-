import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import 'package:skysoft/constants.dart';
import 'package:skysoft/core/%20services/database_helper.dart';
import 'package:skysoft/core/view_model/add_item_view_model.dart';
import 'package:skysoft/core/view_model/home_view_model.dart';
import 'package:skysoft/core/view_model/previous_receipts_view_model.dart';
import 'package:skysoft/view/account_view.dart';
import 'package:skysoft/view/item_view.dart';
import 'package:skysoft/view/previous_receipts_view.dart';
import 'package:skysoft/view/receipt_view.dart';
import 'package:skysoft/view/search_account_view.dart';
import 'package:sqflite/sqflite.dart';



class HomeView extends GetWidget<HomeViewModel> {

  @override
  Widget build(BuildContext context) {


    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.height;
    return GetBuilder<HomeViewModel>(
        builder: (controller) => Container(
            width: screenWidth,
            height: screenHeight,
            child: LayoutBuilder(
              builder: (context, constrains) {
                double height = constrains.maxHeight;
                double width = constrains.maxWidth;
                return Scaffold(
                  backgroundColor: blue5,
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        defaultButton(
                            function:()=>Get.to(ItemsView()) ,
                            width: width,
                            height: height,
                            fontSize: ScreenUtil().setSp(50),text: 'العناصر'),
                        SizedBox(height: height*0.03,),
                        defaultButton(
                            function: () {Get.to(AccountView());},
                            width: width,
                            height: height,
                            fontSize: ScreenUtil().setSp(50),text: 'الحسابات'),  SizedBox(height: height*0.03,),
                        defaultButton(
                            function: () {Get.to(SearchAccountView());},
                            width: width,
                            height: height,
                            fontSize: ScreenUtil().setSp(50),text: 'اضافة فاتورة'),
                        defaultButton(
                            function: () {Get.to(PreviousReceiptsView());},
                            width: width,
                            height: height,
                            fontSize: ScreenUtil().setSp(50),text: 'عرض الفواتير'),

                      ],
                    ),
                  ),
                );
              },
            )));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skysoft/constants.dart';
import 'package:skysoft/core/%20services/database_helper.dart';
import 'package:dio/dio.dart';
import 'package:skysoft/core/%20services/dio_helper.dart';
import 'package:skysoft/models/receipt_model.dart';
import 'dart:convert';
class HomeViewModel extends GetxController{
@override
  Future<void> onInit() async {
    DatabaseHelper.db.database;
  }
  ValueNotifier<bool> loading=ValueNotifier(false);
  testApi()async{
    loading.value=true;
    update();
    List<int> bytes = utf8.encode('1');
   try {
      var res = await dioHelper.get(url + getData,
          queryParameters: {'sql': 'select * from dbo.api_users'},
          options: Options(headers: {'Authorization': bytes}));
      loading.value=false;
      update();


      Get.defaultDialog(title: 'نجح الاتصال',content: Container(child: SingleChildScrollView(child: Text(res.data.toString()),)),cancel: ElevatedButton(onPressed:()=> Get.back(), child: Text('اغلاق')));
   }
    catch(e){
      loading.value=false;
      update();


      print(e.toString());
    Get.defaultDialog(title: 'فشل الاتصال',content: SingleChildScrollView(
      child: Container(child: Column(
        children: [
          Text(e.toString()),
        ],
      )),
    ),cancel: ElevatedButton(onPressed:()=> Get.back(), child: Text('اغلاق')));

    }
    update();

  }


}
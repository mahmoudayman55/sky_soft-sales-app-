import 'package:apis/models/device_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class HomeViewModel extends GetxController {
  String?icon, name,status;
  int? price,id;
  String url='https://roayty.herokuapp.com/returnAllS';

  List<DropdownMenuItem<String>> services = [
    DropdownMenuItem(
      child: Text('xbox'),
      value: 'xbox-logo.png',
    ),
    DropdownMenuItem(
      child: Text(
        'ps',
      ),
      value: 'ps-logo-of-games.png',
    ),
    DropdownMenuItem(
      child: Text('ping pong'),
      value: 'ping-pong.png',
    ),
    DropdownMenuItem(
      child: Text('بلياردو'),
      value: 'Out line.png',
    ),
  ];

  Dio myDio=Dio();
  insertNewDevice(Device device) async {
 var  response=await myDio.get(url,queryParameters: {'m':5});
   data=response.data.toString();
   print(data);
   update();
  }
String data='';
}

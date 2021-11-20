import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:skysoft/constants.dart';
import 'package:skysoft/core/%20services/database_helper.dart';
import 'package:skysoft/models/receipt_model.dart';
class ConstantsViewModel extends GetxController{
  ConstantsViewModel(){
    Hive.openBox(constBoxName);
    if(constBox.get(startValueName)==null){
      _startValue=1;
    }
    else{
      _startValue=constBox.get(startValueName);


    }
  }
int _startValue=1;
  var formKey=GlobalKey<FormState>();
saveConstants()async{
 var x= await DatabaseHelper.db.getAllReceipts();
 if(x.isEmpty){  formKey.currentState!.save();
 Hive.openBox(constBoxName);

 constBox.put(startValueName, startValue);
 await DatabaseHelper.db.insertReceipt(ReceiptModel(
     receiptId: startValue,
     fAccountId: 2,
     type: 'return',
     netReceipt: 500,
     bankPayment: 44,
     rest: 55,
     cashPayment: 45,
     tax: 78,
     addition: 54,
     discount: 89,
     total: 500,
     saveDate: '45',
     saveTime: '12',
     startDate: '15',
     startTime: '44'));

 await DatabaseHelper.db.deleteReceipt(startValue);

 print('saved !');
 print(  constBox.values
 );}
 else {
   snackBar('خطأ', 'لا يمكن تغيير الثابت في حالة وجود فواتير');
 }

}
int get startValue => _startValue;

  set setStartValue(int value) {
    _startValue = value;


  }
}
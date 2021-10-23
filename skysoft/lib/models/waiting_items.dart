import 'package:flutter/cupertino.dart';

class WaitingItemsModel{
  int? id;
  String? name;
  double? price,discount,quantity,freeQuantity=0;
  double? value;
  double? maxReturnQuantity,maxFreeReturnQuantity;
   var quantityTextController=TextEditingController();
   var freeQuantityTextController=TextEditingController();
   var discountTextController=TextEditingController();


  setValue(){
    value=price!*quantity!-discount!;
  }


  WaitingItemsModel(

      {required this.id,
        this.maxReturnQuantity,
        this.maxFreeReturnQuantity,
        required this.quantityTextController,
        required this.freeQuantityTextController,
        this.freeQuantity=0,
        required this.discountTextController,
      required this.name,
    required this.quantity,
      required this.price,
       this.value,
      required this.discount})
  {
    setValue();
  }

}
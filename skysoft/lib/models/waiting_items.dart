import 'package:flutter/cupertino.dart';

class WaitingItemsModel{
  int? id,quantity;
  String? name;
  double? price,discount;
  double? value;
  int? maxReturnQuantity;
   var quantityTextController=TextEditingController();
   var discountTextController=TextEditingController();


  setValue(){
    value=price!*quantity!-discount!;
    maxReturnQuantity=quantity;
  }


  WaitingItemsModel(

      {required this.id,
        this.maxReturnQuantity,
        required this.quantityTextController,
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
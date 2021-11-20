import 'package:flutter/cupertino.dart';

class WaitingItemsModel{
  int? id,itemNumber;
  String? name,unitName;
  double? price,discount,quantity,freeQuantity=0,conversionFactor;
  double? value;
  double? maxReturnQuantity,maxFreeReturnQuantity;
   var quantityTextController=TextEditingController();
   var freeQuantityTextController=TextEditingController();
   var discountTextController=TextEditingController();


  setValue(){
    value=price!*quantity!-discount!;
    // maxReturnQuantity=maxReturnQuantity!*conversionFactor!;
    // maxFreeReturnQuantity=maxFreeReturnQuantity!*conversionFactor!;
  }


  WaitingItemsModel(

      {required this.id,
        this.conversionFactor=1,
        this.unitName='قطعة',
        this.itemNumber,

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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skysoft/core/%20services/database_helper.dart';
import 'package:skysoft/models/item_model.dart';

class ItemsViewModel extends GetxController{
  ItemsViewModel(){
    getAllItems();
  }
  String? itemName, itemGroup;
  double? wholesalePrice, sellingPrice, avgPurchasePrice, lastPurchasePrice;
  int?  itemBarcode, itemQuantity;

  List <DropdownMenuItem<ItemModel>>itemListItems=[] ;

  addItemsToMenu() async {
    await getAllItems();
    _itemModelList.forEach((item) {

      itemListItems.add(DropdownMenuItem<ItemModel>(value: item,child: Text(item.itemName.toString())));
      print(item.itemName.toString());

    });
    update();
  }




 addNewItem(ItemModel item) async {
    var dbHelper = DatabaseHelper.db;
    await dbHelper.insertItem(item);
    update();
    print('values inserted');
  }


  List<ItemModel> _itemModelList = [];

  List<ItemModel> get itemModelList {

    return _itemModelList;
  }

 getAllItems()async{

    var dbHelper=DatabaseHelper.db;
    _itemModelList = await dbHelper.getAllItems();
    update();
    print('items returned successfully');
  }


}
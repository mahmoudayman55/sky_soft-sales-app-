import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skysoft/core/%20services/database_helper.dart';
import 'package:skysoft/models/item_model.dart';

class ItemsViewModel extends GetxController{
  // ItemsViewModel(){
  //
  // }


  @override
  void onInit() {
    getAllItems();
   // calculateAllQuantity();
  }

  String? itemName, itemGroup;
  double? wholesalePrice, sellingPrice, avgPurchasePrice, lastPurchasePrice,itemQuantity;
  int?  itemBarcode ;

  List <DropdownMenuItem<ItemModel>>itemListItems=[] ;

  addItemsToMenu() async {
    await getAllItems();
    _itemModelList.forEach((item) {

      itemListItems.add(DropdownMenuItem<ItemModel>(value: item,child: Text(item.itemName.toString())));
      print(item.itemName.toString());

    });
    update();
  }
  String _itemSearchQuery='';


  String get itemSearchQuery => _itemSearchQuery;

  set setItemSearchQuery(String value) {
    _itemSearchQuery = value;
  }


  double _allQuantity=0;


  double get allQuantity => _allQuantity;

  set setAllQuantity(double value) {
    _allQuantity = value;
  }

  calculateAllQuantity(){
    _allQuantity=0;
    print(itemModelList.length);
    itemModelList.forEach((element) {
      _allQuantity+=element.itemQuantity!;
      print(allQuantity);
    });
    print(allQuantity);

    update();
  }

  searchForItem() async {
    var dbHelper = DatabaseHelper.db;
    _itemModelList = _itemModelList.isEmpty
        ? await dbHelper.getAllItems()
        : await dbHelper.findItem(itemSearchQuery);
    calculateAllQuantity();
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
    calculateAllQuantity();
    update();
    print('items returned successfully');
  }


}
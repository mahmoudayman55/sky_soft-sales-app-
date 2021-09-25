import 'package:skysoft/constants.dart';

class ReceiptItemModel{
  String? rItemName;
  int? rItemQuantity,fReceiptId,fItemId,maxReturnQuantity;
  double? rItemPrice;
  double? rItemDiscount=0;

  ReceiptItemModel(
      {
      required this.rItemName,
      required this.rItemQuantity,
      this.maxReturnQuantity,
      required this.fItemId,
      required this.fReceiptId,
      required this.rItemPrice,
      required this.rItemDiscount,
      }){this.maxReturnQuantity=this.rItemQuantity;}
  toJson(){
return{
  columnReceiptItemName:rItemName,
  columnReceiptItemPrice:rItemPrice,
  columnReceiptItemDiscount:rItemDiscount,
  columnReceiptItemQuantity:rItemQuantity,
  columnReceiptItemFReceiptId:fReceiptId,
  columnReceiptFItemId:fItemId
};
  }




  ReceiptItemModel.fromJson(Map<String,dynamic>map){
    rItemName=map[columnReceiptItemName];
    rItemQuantity=map[columnReceiptItemQuantity];
    rItemDiscount=map[columnReceiptItemDiscount];
    rItemPrice=map[columnReceiptItemPrice];
    fItemId=map[columnReceiptFItemId];
  }
}
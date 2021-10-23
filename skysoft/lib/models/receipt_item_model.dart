import 'package:skysoft/constants.dart';

class ReceiptItemModel{
  String? rItemName;
  double? rItemQuantity,rItemPrice,returnableQuantity,freeReturnableQuantity,freeQuantity=0;
  int? fReceiptId,fItemId,receiptItemId;
  double? rItemDiscount=0;

  ReceiptItemModel(
      {
      required this.rItemName,
      required this.rItemQuantity,
      this.returnableQuantity,
        this.freeReturnableQuantity,
      required this.fItemId,
        this.freeQuantity=0,
      required this.fReceiptId,
      required this.rItemPrice,
      required this.rItemDiscount,
      this.receiptItemId
      });
  toJson(){
return{
  columnReceiptItemName:rItemName,
  columnReceiptItemPrice:rItemPrice,
  columnReceiptItemDiscount:rItemDiscount,
  columnReceiptItemQuantity:rItemQuantity,
  columnReceiptItemFreeQuantity:freeQuantity,
  columnReceiptItemFReceiptId:fReceiptId,
  columnReceiptFItemId:fItemId,
  columnReceiptItemReturnableQuantity:returnableQuantity,
  columnReceiptItemFreeReturnableQuantity:freeReturnableQuantity,
  columnReceiptItemId:receiptItemId
};
  }




  ReceiptItemModel.fromJson(Map<String,dynamic>map){
    rItemName=map[columnReceiptItemName];
    returnableQuantity=map[columnReceiptItemReturnableQuantity];
    rItemQuantity=map[columnReceiptItemQuantity];
    rItemDiscount=map[columnReceiptItemDiscount];
    rItemPrice=map[columnReceiptItemPrice];
    fItemId=map[columnReceiptFItemId];
    fReceiptId=map[columnReceiptItemFReceiptId];
    receiptItemId=map[columnReceiptItemId];
    freeQuantity=map[columnReceiptItemFreeQuantity];
    freeReturnableQuantity=map[columnReceiptItemFreeReturnableQuantity];
  }
}
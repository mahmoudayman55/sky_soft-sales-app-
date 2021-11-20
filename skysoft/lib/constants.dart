import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/snackbar/snack.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
var constBox= Hive.box(constBoxName);

final String constBoxName = 'account';
final String startValueName = 'start_value';

///account table
final String accountTableName = 'account';
//string acc columns
final String columnAccountName = 'acc_name';
final String columnAccountAccId = 'acc_Id';
final String columnAccountNote = 'note';
final String columnAccountAccBarcode = 'acc_barcode';
final String columnAccountEmployCode = 'employ_code';
final String columnAccountEmployName = 'employ_name';

//real acc (dcolumnAccount columns
final String columnAccountCurrentBalance = 'current_balance';
final String columnAccountMaxCredit = 'max_credit';

//int acc colcolumnAccount
final String columnAccountDefEmployId = 'def_employ_id';
final String columnAccountPriceId = 'price_id';
final String columnAccountWaitDays = 'wait_days';
final String columnAccountCurrencyId = 'currency_ids';
final String columnAccountCostCenterId = 'cost_center_id';
final String columnAccountBranchId = 'branch_id';
final String columnAccountUserId = 'user_id';

//boolean acccolumnAccountns
final String columnAccountPayByCashOnly = 'pay_by_cash_only';
final String columnAccountStopped = 'stopped';

/// item model
//string
final String itemTableName = 'items';
final String columnItemName = 'item_name';
final String columnItemQuantity = 'item_quantity';
final String columnItemGroup = 'item_group';
final String columnItemWholesalePrice = 'item_wholesale_price';
final String columnItemSellingPrice = 'item_selling_price';
final String columnItemAvgPurchasePrice = 'item_avg_purchase_price';
final String columnItemLastPurchasePrice = 'item_last_purchase_price';
final String columnItemId = 'item_column_id';
final String columnItemBarcode = 'item_barcode';


final String columnItemNumber = 'item_Number';
final String columnItemUnitName = 'item_unit_name';
final String columnItemConversionFactor = 'item_conversion_factor';


///Receipt item model
//table name
final String receiptItemTableName='receipt_item';
final String columnReceiptItemReturnableQuantity='returnable_quantity';
final String columnReceiptItemFreeReturnableQuantity='free_returnable_quantity';
final String columnReceiptItemName='receipt_item_name';
final String columnReceiptItemId='receipt_item_id';
final String columnReceiptItemQuantity='receipt_item_quantity';
final String columnReceiptItemPrice='receipt_item_price';
final String columnReceiptItemDiscount='receipt_item_discount';
final String columnReceiptItemFReceiptId='receipt_id';
final String columnReceiptFItemId='item_id';
final String columnReceiptItemFreeQuantity='free_quantity';
final String columnReceiptMaxReturnQuantity='returned_quantity';

final String columnReceiptItemFNumber=           'receipt_item_Number';
final String columnReceiptItemUnitName=          'receipt_item_unit_name';
final String columnReceiptItemConversionFactor=  'receipt_item_conversion_factor';


///Receipt model
final String receiptTableName=           'receipt';
final String columnReceiptId=            'receipt_id';
final String columnReceiptStartDate=      'start_date';
final String columnReceiptSaveDate=      'save_date';
final String columnReceiptStartTime=      'receipt_Start_time';
final String columnReceiptSaveTime=      'receipt_Save_time';
final String columnReceiptTotal=         'total';
final String columnReceiptDiscount=      'discount';
final String columnReceiptAddition=      'addition';
final String columnReceiptTax=           'tax';
final String columnReceiptCashPayment=   'cash_payment';
final String columnReceiptBankPayment=   'bank_payment';
final String columnReceiptRest=          'rest';
final String columnReceiptFAccountId=    'account_id';
final String columnReceiptNetReceipt =   'net_receipt';
final String columnReceiptType =   'receipt_type';


const Color blue1 = Color.fromARGB(255, 80, 184, 231);

const Color blue2 = Color.fromARGB(255, 132, 205, 238);

const Color blue3 = Color.fromARGB(255, 185, 226, 245);

const Color blue4 = Color.fromARGB(255, 220, 240, 250);

const Color blue5 = Color.fromARGB(255, 237, 247, 252);

double pdfTableFontSize = 12;
String getNumber(double input, {int precision = 2}) =>
    double.parse('$input'.substring(0, '$input'.indexOf('.') + precision + 1)).toString();

Color selectorColor = Colors.lightGreen;
Color edgesSelectorAColor = Colors.blue;
Color edgesSelectorBColor = Colors.red;
void snackBar(String title,String message,
    {Color titleColor=Colors.red, Color messageColor =Colors.black54})=> Get.snackbar('', '',
    titleText: Directionality(
      textDirection: TextDirection.rtl,
      child: Text(title,style: txtStyle(titleColor),),
    ),
    messageText: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(message,style: txtStyle(messageColor),)),
    snackPosition: SnackPosition.BOTTOM);

TextStyle txtStyle(Color color,{double fontSize=18}){return
  TextStyle(

      fontFamily:'Tajawal',
      color: color,
      fontSize: ScreenUtil().setSp(fontSize),
      fontWeight: FontWeight.bold);}

TextInputDecoration(String label,Icon? PrefixIcon){

  return  InputDecoration(
      prefixIcon: PrefixIcon,

      labelText: label,
      alignLabelWithHint: true,
      labelStyle: new TextStyle(
          fontFamily:'Tajawal',
          fontSize: ScreenUtil().setSp(20),
          fontWeight: FontWeight.bold),
      hintTextDirection: TextDirection.rtl,
      border: OutlineInputBorder());


}


TextStyle labelsInReceiptRowsStyle(
    {Color color = Colors.limeAccent, double fontSize=30}){
  return TextStyle(color: color,fontSize: ScreenUtil().setSp(fontSize),fontWeight: FontWeight.bold,fontFamily: 'Tajawal',);
}

TextStyle labelsTextStyle=TextStyle(
color: Colors.red,
fontWeight: FontWeight.bold,
fontSize: ScreenUtil().setSp(30));

BoxDecoration circularBoxDecoration=BoxDecoration(color: Colors.green,borderRadius: BorderRadius.circular(50),);


TextStyle rowItemTextStyle()=>TextStyle(fontSize: ScreenUtil().setSp(26),color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Tajawal');
TextStyle rowItemElementTextStyle({Color color=Colors.black87,FontWeight fontWeight=FontWeight.normal})=>TextStyle(fontSize: ScreenUtil().setSp(30),color: color,fontWeight: fontWeight);
TextStyle rowAccountElementTextStyle()=>TextStyle(fontSize: ScreenUtil().setSp(22),);
BoxDecoration myBoxDecoration(){
  return  BoxDecoration(
      boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 6,spreadRadius: 1)],
      borderRadius: BorderRadius.circular(20),
      color: Colors.white);
}
Widget loadingScreen(){
  return Center(child: CircularProgressIndicator(color: Colors.lightGreen,),);
}
BoxDecoration? boxDecor(double radius) {
  return BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
          color: Colors.grey.shade300,
          offset: Offset.fromDirection(2),
          blurRadius: 3)
    ],
    borderRadius: BorderRadius.circular(radius),
  );
}

final ButtonStyle buttonStyle =
    ElevatedButton.styleFrom(primary: Colors.lightGreen, shape: RoundedRectangleBorder());

Widget defaultButton({
  double width = double.infinity,
  double height = double.infinity,
  required Function function,
  Color background = Colors.lightGreen,
  String text = 'تأكيد',
  double fontSize = 25,
  double radius = 20,
})

{
  return SizedBox(
 width: width,
    height: height,
    child: ElevatedButton(
      onPressed: () {
        function();
      },
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Text(

          text,textAlign: TextAlign.center,
          style: new TextStyle(fontFamily: 'Tajawal',fontWeight: FontWeight.bold,
               fontSize: ScreenUtil().setSp(fontSize)),
        ),
      ),
      style: ElevatedButton.styleFrom(
          primary: background,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
    ),
  );



}

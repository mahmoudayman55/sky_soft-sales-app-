import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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


///Receipt item model
//table name
final String receiptItemTableName='receipt_item';
final String columnReceiptItemName='receipt_item_name';
final String columnReceiptItemId='receipt_item_id';
final String columnReceiptItemQuantity='receipt_item_quantity';
final String columnReceiptItemPrice='receipt_item_price';
final String columnReceiptItemDiscount='receipt_item_discount';
final String columnReceiptItemFReceiptId='receipt_id';
final String columnReceiptFItemId='item_id';
final String columnReceiptMaxReturnQuantity='returned_quantity';

///Receipt model
final String receiptTableName=           'receipt';
final String columnReceiptId=            'receipt_id';
final String columnReceiptDate=      'receipt_date';
final String columnReceiptTime=      'receipt_time';
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


TextStyle rowItemTextStyle()=>TextStyle(fontSize: ScreenUtil().setSp(30),color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Tajawal');
TextStyle rowItemElementTextStyle()=>TextStyle(fontSize: ScreenUtil().setSp(30),);
TextStyle rowAccountElementTextStyle()=>TextStyle(fontSize: ScreenUtil().setSp(22),);
BoxDecoration myBoxDecoration(){
  return  BoxDecoration(
      boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 6,spreadRadius: 1)],
      borderRadius: BorderRadius.circular(20),
      color: Colors.white);
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
    ElevatedButton.styleFrom(primary: blue2, shape: RoundedRectangleBorder());

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
  return ConstrainedBox(
    constraints: BoxConstraints(minWidth: width * 0.6, maxWidth: width * 0.6
    ,minHeight:height*0.08 ),
    child: ElevatedButton(
      onPressed: () {
        function();
      },
      child: Text(
        text,
        style: new TextStyle(
             fontSize: ScreenUtil().setSp(fontSize)),
      ),
      style: ElevatedButton.styleFrom(
          primary: background,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)))),
    ),
  );



}

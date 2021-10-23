import 'package:intl/intl.dart' as intl;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:skysoft/core/%20services/database_helper.dart';
import 'package:skysoft/core/view_model/receipt_view_model.dart';
import 'package:skysoft/models/item_model.dart';
import 'package:skysoft/models/receipt_model.dart';
import 'package:skysoft/models/waiting_items.dart';
import 'package:get/get.dart';
import 'package:skysoft/view/home_view.dart';

import '../../constants.dart';

class ReturnReceiptViewModel extends ReceiptViewModel{
  ReturnReceiptViewModel() {

    update();
    var data=Get.arguments;

    DatabaseHelper.db.initAccData();
    DatabaseHelper.db.initItemsData();
setReceiptType='return';
    update();
    searchForAccount();
    if(data!=null){
      //setReceiptNumber();
      receiptNumberSetter=data[2]+2;
      print(data.toString()+' argumentsssss');
      setReceiptAccount=data[0];
      waitingItemsList=data[1];

      updateItemCount();
      updateFreeItemCount();

      calculateTotal();
      updateNetReceipt();

      update();

    }

    update();
  }

  @override
  calculateNetReceipt() async {
    setReceiptType='return';
    if (totalDiscount == null || tax == null || addition == null) {
      Get.snackbar(
        'خطأ',
        'الرجاء اكمال بيانات الفاتورة بشكل صحيح',
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.GROUNDED,
      );
    } else {
      if (itemsCount == 0 && freeItemsCount == 0) {
        Get.snackbar('خطأ', 'لم يتم تحديد كمية الاصناف المراد استرجاعها');
        return;
      }


      ///calculate net receipt
      setNetReceipt = (total + addition) - totalDiscount + tax;

      ///calculate new balance of the account
      setBalanceAfter = receiptAccount.currentBalance! - netReceipt - cashPayment;

      ///update account balance in the database
      await DatabaseHelper.db
          .updateAccBalance(balanceAfter, receiptAccount.accId as int);

      /// update items quantities in database
      waitingItemsList.forEach((element) {
        DatabaseHelper.db.increaseItemQuantity(
            (element.quantity! + double.parse(element.freeQuantity.toString())),
            element.id);
      });

      /// set rest of receipt
      setRest = netReceipt - cashPayment;

      ///update the value of returnable quantities of items
    /// insert the new receipt into the database
    addNewReceipt(ReceiptModel(
    receiptId: receiptNumber,
    fAccountId: receiptAccount.accId,
    date: intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
    time: intl.DateFormat('kk:mm').format(DateTime.now()),
    total: total,
    discount: totalDiscount,
    addition: addition,
    tax: tax,
    cashPayment: cashPayment,
    rest: rest,
    netReceipt: netReceipt,
    type: receiptType));
    enabled = false;
   // receiptCalculated = true;
    update();
    Get.snackbar(
    'تم',
    'تم حفظ الفاتورة بنجاح',
    snackPosition: SnackPosition.BOTTOM,
    titleText: Text(
    'تم انشاء الفاتورة بنجاح',
    textAlign: TextAlign.right,
    style: labelsInReceiptRowsStyle(color: Colors.white),
    ),
    messageText: Directionality(
    textDirection: TextDirection.rtl,
    child: Column(
    children: [
    Row(
    children: [
    Text('لطباعة الفاتورة اضغط علي => '),
    GestureDetector(
    onTap: () {
    generatePDF();
    },
    child: Container(
    width: ScreenUtil().setWidth(5),
    child: Icon(
    Icons.receipt_long,
    size: 35,
    color: Colors.deepPurple,
    ),
    ),
    ),
    ],
    ),
    Row(
    children: [
    Text('للانهاء اضغط علي => '),
    GestureDetector(
    onTap: () {
    Get.offAll(HomeView());
    },
    child: Container(
    width: ScreenUtil().setWidth(5),
    child: Icon(
    Icons.exit_to_app,
    size: 35,
    color: Colors.black,
    ),
    ),
    ),
    ],
    )
    ],
    )),
    duration: Duration(seconds: 4),
    snackStyle: SnackStyle.GROUNDED,
    );

    ///
  }
  }

  @override
  updateNetReceipt() {
   // String currentBalance = receiptAccount.currentBalance.toString();
    setNetReceipt = ((total + addition) - totalDiscount + tax);
    setBalanceAfter = receiptAccount.currentBalance! - netReceipt - cashPayment;
    setRest = netReceipt - cashPayment;
    update();
  }
}
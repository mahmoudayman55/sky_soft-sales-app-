import 'dart:io';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skysoft/core/%20services/database_helper.dart';
import 'package:skysoft/core/view_model/receipt_view_model.dart';
import 'package:skysoft/models/account_model.dart';
import 'package:skysoft/models/receipt_item_model.dart';
import 'package:skysoft/models/receipt_model.dart';
import 'package:skysoft/models/waiting_items.dart';
import 'package:intl/intl.dart' as intl;
import 'package:skysoft/view/home_view.dart';
import 'package:skysoft/view/receipt_view.dart';

import '../../constants.dart';

class PreviousReceiptsViewModel extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    setReturnReceiptFlag = false;
    receiptCalculated = false;
    getReceipts();
    calculateTotalNetReceipts();
  }

  List<ReceiptModel> allReceipts = [];
  List<AccountModel> accountsInReceipts = [];
  RxList<WaitingItemsModel> receiptItems = RxList<WaitingItemsModel>();
  AccountModel _account = AccountModel();

  AccountModel get account => _account;

  set setAccount(AccountModel value) {
    _account = value;
  }

  static final tableFormKey1 = GlobalKey<FormState>();

  // List<GlobalKey>gList=[ GlobalKey<FormState>()];
  GlobalKey tableFormKey = tableFormKey1;
  bool receiptCalculated = false;
  double _total = 0,
      _totalDiscount = 0,
      _tax = 0,
      _netReceipt = 0,
      _cashPayment = 0,
      _rest = 0,
      _addition = 0,
      _balanceAfter = 0;

  int? _receiptNumber = 0;

  get receiptNumber => _receiptNumber;

  set setReceiptNumber(value) {
    _receiptNumber = value;
  }

  String _date = '', _time = '', _receiptType = '';

  get receiptType => _receiptType;

  set setReceiptType(value) {
    _receiptType = value;
  }

  String get date => _date;

  set setDate(String value) {
    _date = value;
  }

  get addition => _addition;

  set setAddition(value) {
    _addition = value;
  }

  double get total => _total;

  set setTotal(double value) {
    _total = value;
  }

  double _itemsCount = 0;

  double get itemsCount => _itemsCount;

  set setItemsCount(double value) {
    _itemsCount = value;
  }

  bool _returnReceiptFlag = false;

  bool get returnReceiptFlag => _returnReceiptFlag;

  set setReturnReceiptFlag(bool value) {
    _returnReceiptFlag = value;
    update();
  }

  get totalDiscount => _totalDiscount;

  set setTotalDiscount(value) {
    _totalDiscount = value;
  }

  get tax => _tax;

  set setTax(value) {
    _tax = value;
  }

  get netReceipt => _netReceipt;

  set setNetReceipt(value) {
    _netReceipt = value;
  }

  get cashPayment => _cashPayment;

  set setCashPayment(double value) {
    _cashPayment = value;
  }

  get rest => _rest;

  set setRest(value) {
    _rest = value;
  }

  var totalDiscountController = TextEditingController(text: '0');
  var totalAdditionController = TextEditingController(text: '0');
  var totalTaxController = TextEditingController(text: '0');
  var cashPaymentController = TextEditingController(text: '0');
  bool couldReturn = false;

  startReturnReceipt() {
    couldReturn = false;
    for (int i = 0; i < receiptItems.length; i++) {
      if (receiptItems[i].maxReturnQuantity != 0 ||
          receiptItems[i].maxFreeReturnQuantity != 0) {
        couldReturn = true;
        break;
      }
    }
    if (couldReturn == false) {
      Get.snackbar('خطأ', 'لقد تم استرجاع جميع اصناف الفاتورة من قبل',
          duration: Duration(seconds: 3));

      return;
    }
    setReturnReceiptFlag = true;
    enableCalculateReceipt = true;
    setDate = intl.DateFormat('yyyy-MM-dd').format(DateTime.now());
    setTime = intl.DateFormat('kk:mm').format(DateTime.now());
    setReceiptType = 'return';
    receiptItems.forEach((element) {
      element.quantityTextController.text = '0';
      element.freeQuantityTextController.text = '0';
      element.quantity = 0;
      element.freeQuantity = 0;

      element.value = 0;
      print(element.value);
    });
    update();
    // receiptItems.forEach(
    //         (element) {
    //       print(element.value);
    //     });
    updateItemCount();
    updateFreeItemCount();
    receiptItems.forEach((element) {
      print(element.value);
    });
    getReceiptNumber();
    receiptItems.forEach((element) {
      print(element.value);
    });
    calculateTotal();
    receiptItems.forEach((element) {
      print(element.value);
    });
    // Get.back();
  }

  double _freeItemsCount = 0;

  double get freeItemsCount => _freeItemsCount;

  set setFreeItemsCount(double value) {
    _freeItemsCount = value;
  }

  updateItemCount() {
    _itemsCount = 0;
    receiptItems.forEach((element) {
      _itemsCount += element.quantity!.toDouble();
    });
    update();
  }

  updateFreeItemCount() {
    _freeItemsCount = 0;
    receiptItems.forEach((element) {
      _freeItemsCount += element.freeQuantity!.toDouble();
    });
    update();
  }

  openExistReceipt(String receiptNumber) async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    final file = File(
      '${appDocDirectory.path}' + '/receipt $receiptNumber.pdf',
    );

    print(file.path);

    // print('file created');
    // await file.writeAsBytes(await receiptPDF.save());
    // print('file saved');

    try {
      await OpenFile.open(
          '${appDocDirectory.path}' + '/receipt $receiptNumber.pdf');
    } catch (e) {
      print(e.toString());
    }
    print('file created');
    update();
  }

  calculateTotal() {
    double totalValues = 0;
    receiptItems.forEach((element) {
      totalValues += element.value!;
    });
    setTotal = totalValues;
    print(total.toString() + '/**********************/**//**/*/*/**');
    update();
  }

  var searchKey2 = GlobalKey<FormFieldState>();
  bool loading = false;

  getReceipts() async {
    loading = true;
    update();

// await DatabaseHelper.db.deleteReceipt(1000);
// await DatabaseHelper.db.deleteReceipt(999);
    allReceipts.clear();
    accountsInReceipts.clear();

    print('scccccccccccc');
    allReceipts = await DatabaseHelper.db.getAllReceipts();
    allReceipts.forEach((element) {
      print(element.receiptId);
    });

    print('all receipts length ${allReceipts.length}');
    for (int i = 0; i < allReceipts.length; i++) {
      // print(
      //     'receipt id = ${allReceipts[i].receiptId} , accfid = ${allReceipts[i].fAccountId}');
      // if (allReceipts.length == accountsInReceipts.length) {
      //   break;
      // }

      accountsInReceipts +=
          (await DatabaseHelper.db.findAccount(allReceipts[i].fAccountId));
      //   if(allReceipts.length==accountsInReceipts.length){break;}

    }
    print(accountsInReceipts.length.toString() +
        "       " +
        allReceipts.length.toString() +
        '          ' +
        'getall');
    calculateTotalNetReceipts();
    loading = false;
    update();
  }

  findReceipts() async {
    loading = true;
    update();
    allReceipts.clear();
    accountsInReceipts.clear();

    allReceipts = await DatabaseHelper.db.findReceipt(searchForReceiptWord);
    print(allReceipts.length);
    if (allReceipts.isNotEmpty) {
      print('not empty');
      for (int i = 0; i < allReceipts.length; i++) {
        accountsInReceipts +=
            (await DatabaseHelper.db.findAccount(allReceipts[i].fAccountId));
        update();
        print(accountsInReceipts);
        // if(allReceipts.length==accountsInReceipts.length){break;}

      }
    }
// else{
//   accountsInReceipts=DatabaseHelper.db.getAllAccounts()
// }

    // calculateTotalNetReceipts();
    calculateTotalNetReceipts();
    loading = false;
    update();
    // print(allReceipts);
    // print('-----------');
    print(accountsInReceipts.length.toString() +
        "       " +
        allReceipts.length.toString() +
        '          ' +
        '12121212');
  }

  itemQuantityOnTap(index) {
    receiptItems[index].quantityTextController.selection = TextSelection(
        baseOffset: 0,
        extentOffset:
            receiptItems[index].quantityTextController.value.text.length);
  }

  itemFreeQuantityOnTap(index) {
    receiptItems[index].freeQuantityTextController.selection = TextSelection(
        baseOffset: 0,
        extentOffset:
            receiptItems[index].freeQuantityTextController.value.text.length);
  }

  itemQuantityOnSubmitted(value, index) {
    if (receiptItems[index].quantityTextController.text.isEmpty ||
        receiptItems[index].quantity! < 0 ||
        receiptItems[index].quantity! >
            double.parse(receiptItems[index].maxReturnQuantity.toString())) {
      receiptItems[index].quantity! >
              double.parse(receiptItems[index].maxReturnQuantity.toString())
          ? receiptItems[index].quantityTextController.text =
              receiptItems[index].maxReturnQuantity.toString()
          : receiptItems[index].quantityTextController.text = '0';
      receiptItems[index].quantity! >
              double.parse(receiptItems[index].maxReturnQuantity.toString())
          ? receiptItems[index].quantity = receiptItems[index].maxReturnQuantity
          : receiptItems[index].quantity = 0;

      receiptItems[index].value = receiptItems[index].quantity!.toDouble() *
          receiptItems[index].price!.toDouble();
      calculateTotal();
    }
    // else{
    //   controller.receiptItems[index].maxReturnQuantity=int.parse(controller.receiptItems[index].maxReturnQuantity.toString())-int.parse(value);
    // }
    if (double.parse(value) >
        receiptItems[index].maxReturnQuantity!.toDouble()) {
      Get.snackbar('خطأ', 'كمية الصنف اكبر من الكمية اللتي يمكن استرجاعها');
    }
    updateItemCount();
    updateNetReceipt();
  }

  bool _returnWholeItems = false;

  bool get returnWholeItems => _returnWholeItems;

  set setReturnWholeItems(bool value) {
    _returnWholeItems = value;
  }

  itemFreeQuantityOnSubmitted(value, index) {
    // switch(true){
    //   case receiptItems[index].freeQuantity
    // }

    if (receiptItems[index].freeQuantityTextController.text.isEmpty ||
        receiptItems[index].freeQuantity! < 0 ||
        receiptItems[index].freeQuantity! >
            double.parse(
                receiptItems[index].maxFreeReturnQuantity.toString())) {
      receiptItems[index].freeQuantity! >
              double.parse(receiptItems[index].maxFreeReturnQuantity.toString())
          ? receiptItems[index].freeQuantityTextController.text =
              receiptItems[index].maxFreeReturnQuantity.toString()
          : receiptItems[index].freeQuantityTextController.text = '0';
      receiptItems[index].freeQuantity! >
              double.parse(receiptItems[index].maxFreeReturnQuantity.toString())
          ? receiptItems[index].freeQuantity =
              receiptItems[index].maxFreeReturnQuantity
          : receiptItems[index].freeQuantity = 0;

      // receiptItems[index].value = receiptItems[index].freeQuantity!.toDouble() *
      //     receiptItems[index].price!.toDouble();
      updateFreeItemCount();
    }
    // else{
    //   receiptItems[index].maxFreeReturnQuantity=double.parse(receiptItems[index].maxFreeReturnQuantity.toString())-double.parse(value);
    //   updateFreeItemCount();
    //
    // }
    if (double.parse(value) >
        receiptItems[index].maxFreeReturnQuantity!.toDouble()) {
      Get.snackbar('خطأ', 'كمية الصنف اكبر من الكمية اللتي يمكن استرجاعها');
      updateFreeItemCount();
    }
    updateFreeItemCount();
  }

  savePdf() async {
    for (int i = 0; i < receiptItems.length; i++) {
      if (receiptItems[i].quantity == 0 && receiptItems[i].freeQuantity == 0) {
        continue;
      }
      pdfItemsTable.add(
        pw.TableRow(
            verticalAlignment: pw.TableCellVerticalAlignment.middle,
            children: [
              pw.Text(receiptItems[i].value.toString(),
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(fontSize: pdfTableFontSize)),
              pw.Text(receiptItems[i].price.toString(),
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(fontSize: pdfTableFontSize)),
              pw.Text(receiptItems[i].name.toString(),
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(fontSize: pdfTableFontSize)),
              pw.Text(receiptItems[i].quantity.toString(),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: pdfTableFontSize)),
              pw.Text(receiptItems[i].freeQuantity.toString(),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: pdfTableFontSize)),
            ]),
      );
    }
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    print(appDocDirectory);
    var data = await rootBundle.load('assets/fonts/ARIALBD.ttf');

    final ttf = pw.Font.ttf(data);
    receiptPDF.addPage(pw.Page(
        theme: pw.ThemeData.withFont(
          base: ttf,
        ),
        pageFormat:
            PdfPageFormat(7.3 * PdfPageFormat.cm, 20 * PdfPageFormat.cm),
        build: (pw.Context context) {
          List<int> m = 'SKY SOFT'.codeUnits;
          print(String.fromCharCodes(m));
          return (pw.Directionality(
            child: pw.Container(
                padding: pw.EdgeInsets.all(5),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.SizedBox(height: 10),
                      pw.Container(
                        padding: pw.EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        alignment: pw.Alignment.center,
                        width: ScreenUtil().setWidth(500),
                        height: ScreenUtil().setHeight(3),
                        child: pw.Text(
                          'SKY SOFT',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(fontSize: 15),
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Text(receiptNumber.toString(),
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize),
                                      textDirection: pw.TextDirection.rtl),
                                  pw.Text('رقم الفاتورة : ',
                                      style: pw.TextStyle(
                                        fontSize: pdfTableFontSize,
                                      ),
                                      textAlign: pw.TextAlign.center,
                                      textDirection: pw.TextDirection.rtl),
                                  pw.SizedBox(
                                    width: ScreenUtil().setWidth(6),
                                  ),
                                  pw.Text(
                                      (itemsCount + freeItemsCount).toString(),
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize),
                                      textDirection: pw.TextDirection.rtl),
                                  pw.Text('عدد القطع : ',
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize),
                                      textAlign: pw.TextAlign.center,
                                      textDirection: pw.TextDirection.rtl),
                                ])
                          ]),
                      pw.SizedBox(height: 5),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(account.name.toString(),
                                textAlign: pw.TextAlign.center,
                                textDirection: pw.TextDirection.rtl),
                            pw.Text('العميل : ',
                                style: pw.TextStyle(fontSize: pdfTableFontSize),
                                textAlign: pw.TextAlign.center,
                                textDirection: pw.TextDirection.rtl),
                          ]),
                      pw.SizedBox(height: 5),
                      pw.Table(
                          defaultVerticalAlignment:
                              pw.TableCellVerticalAlignment.middle,
                          columnWidths: {
                            0: pw.FlexColumnWidth(4),
                            1: pw.FlexColumnWidth(4),
                            2: pw.FlexColumnWidth(5),
                            3: pw.FlexColumnWidth(4),
                          },
                          children: [
                            pw.TableRow(
                                verticalAlignment:
                                    pw.TableCellVerticalAlignment.middle,
                                children: [
                                  pw.Text('قيمه',
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                        fontSize: pdfTableFontSize,
                                      )),
                                  pw.Text('سعر',
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text('صنف',
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text('كمية',
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text('كميه مجانيه',
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                ]),
                            for (int i = 0; i < pdfItemsTable.length; i++)
                              pdfItemsTable.elementAt(i)
                          ]),
                      pw.SizedBox(height: 25),
                      pw.Table(
                          defaultVerticalAlignment:
                              pw.TableCellVerticalAlignment.middle,
                          children: [
                            pw.TableRow(
                                verticalAlignment:
                                    pw.TableCellVerticalAlignment.middle,
                                children: [
                                  pw.Text('رص بعد',
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                        fontSize: pdfTableFontSize,
                                      )),
                                  pw.Text('رص قبل',
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text('صافي',
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text('اجمالي',
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                ]),
                            pw.TableRow(
                                verticalAlignment:
                                    pw.TableCellVerticalAlignment.middle,
                                children: [
                                  pw.Text(balanceAfter.toString(),
                                      style: pw.TextStyle(
                                        fontSize: pdfTableFontSize,
                                      )),
                                  pw.Text(account.currentBalance.toString(),
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text(netReceipt.toString(),
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text(total.toString(),
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                ])
                          ]),
                      pw.SizedBox(height: 15),
                      pw.Center(
                          child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                            pw.Text(cashPayment.toString(),
                                textAlign: pw.TextAlign.right,
                                style:
                                    pw.TextStyle(fontSize: pdfTableFontSize)),
                            pw.Text('سداد : ',
                                textAlign: pw.TextAlign.right,
                                style:
                                    pw.TextStyle(fontSize: pdfTableFontSize)),
                          ])),
                      pw.SizedBox(height: 25),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                                intl.DateFormat('kk:mm').format(DateTime.now()),
                                textAlign: pw.TextAlign.right,
                                style:
                                    pw.TextStyle(fontSize: pdfTableFontSize)),
                            pw.Text('الوقت : ',
                                textAlign: pw.TextAlign.right,
                                style:
                                    pw.TextStyle(fontSize: pdfTableFontSize)),
                            pw.Text(
                                intl.DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now()),
                                textAlign: pw.TextAlign.right,
                                style:
                                    pw.TextStyle(fontSize: pdfTableFontSize)),
                            pw.Text('التاريخ : ',
                                textAlign: pw.TextAlign.right,
                                style:
                                    pw.TextStyle(fontSize: pdfTableFontSize)),
                          ])
                    ])),
            textDirection: pw.TextDirection.rtl,
          ));
        }));

    final file = File(
      '${appDocDirectory.path}' + '/receipt $receiptNumber.pdf',
    );
    print(file.path);

    print('file created');
    await file.writeAsBytes(await receiptPDF.save());
    print('file saved');
  }

  itemQuantityOnChanged(value, index) {
    {
      receiptItems[index].quantity = double.parse(value);
      receiptItems[index].value = receiptItems[index].quantity!.toDouble() *
          receiptItems[index].price!.toDouble();
      calculateTotal();
      updateNetReceipt();
    }
  }

  startFullReturnAndFillNewReceipt() async {
    startFullReturn();
//await ReceiptViewModel().setReceiptNumber();
    _receiptNumber = (await DatabaseHelper.db.getAllReceipts()).length;

    print([account, receiptItems]);
    Get.to(ReceiptView(), arguments: [account, receiptItems, receiptNumber]);
  }

  startFullReturn() async {
    receiptItems.forEach((receipt) {
      receipt.freeQuantity = receipt.maxFreeReturnQuantity;
      receipt.freeQuantityTextController.text = receipt.freeQuantity.toString();

      receipt.quantity = receipt.maxReturnQuantity;
      receipt.quantityTextController.text = receipt.quantity.toString();

      receipt.value = (receipt.quantity! * (receipt.price as double)) -
          (receipt.discount as double);
    });
    calculateItemsCount();
    updateFreeItemCount();
    calculateTotal();
    updateNetReceipt();
    calculateNetReceipt();
    // await getReceipts();
  }

  fullReturn() async {
    receiptItems.forEach((receipt) {
      receipt.freeQuantity = receipt.maxFreeReturnQuantity;
      receipt.quantity = receipt.maxReturnQuantity;
      receipt.value = (receipt.quantity! * (receipt.price as double)) -
          (receipt.discount as double);
      _itemsCount += receipt.quantity!;
      _freeItemsCount += receipt.freeQuantity!;
      _total += receipt.value!;
      print(receipt.freeQuantity.toString() +
          '    ' +
          receipt.quantity.toString());
    });

    _netReceipt = total;
    _receiptType = 'return';
    _receiptNumber = (await DatabaseHelper.db.getAllReceipts()).length;
    print(_netReceipt);
    print(total);
    print(receiptNumber + 1);
    setBalanceAfter = account.currentBalance! - netReceipt;
    await DatabaseHelper.db
        .updateAccBalance(balanceAfter, account.accId as int);
    receiptItems.forEach((element) {
      DatabaseHelper.db.increaseItemQuantity(
          (element.quantity! + double.parse(element.freeQuantity.toString())) *
              element.conversionFactor!,
          element.itemNumber);
    });

    setRest = netReceipt;

    addNewReceipt(ReceiptModel(type: _receiptType));
  }

  itemFreeQuantityOnChanged(value, index) {
    {
      receiptItems[index].freeQuantity = double.parse(value);
      update();
      // receiptItems[index].value = receiptItems[index].quantity!.toDouble() * receiptItems[index].price!.toDouble();
      //  calculateTotal();
      // updateNetReceipt();
    }
  }

  getReceiptItems(int receiptId) async {
    receiptItems.clear();
    List<ReceiptItemModel> returnedItems =
        await DatabaseHelper.db.findReceiptItems(receiptId);
    returnedItems.forEach((element) {
      receiptItems.add(WaitingItemsModel(
          freeQuantity: element.freeQuantity,
          itemNumber: element.itemNumber,
          unitName: element.unitName,
          conversionFactor: element.conversionFactor,
          freeQuantityTextController:
              TextEditingController(text: element.freeQuantity.toString()),
          id: element.receiptItemId,
          maxFreeReturnQuantity: element.freeReturnableQuantity,
          quantity: element.rItemQuantity,
          quantityTextController:
              TextEditingController(text: element.rItemQuantity.toString()),
          discountTextController: TextEditingController(text: '0'),
          name: element.rItemName,
          price: element.rItemPrice,
          discount: element.rItemDiscount,
          value: (element.rItemQuantity! *
                  double.parse(element.rItemPrice.toString())) -
              double.parse(element.rItemDiscount.toString()),
          maxReturnQuantity: element.returnableQuantity!));
    });
    receiptItems.forEach((element) {
      print('**********************');
      print(element.maxReturnQuantity);
      print('**********************');
    });
    calculateItemsCount();
    updateFreeItemCount();
    update();
  }

  calculateItemsCount() {
    _itemsCount = 0;
    receiptItems.forEach((element) {
      _itemsCount += element.quantity!.toDouble();
    });
  }

  getReceiptNumber() async {
    List<ReceiptModel> allReceipts;
    allReceipts = await DatabaseHelper.db.getAllReceipts();
    print((allReceipts.length + 1).toString() +
        'asadasdasdasdasdasdasd898989asdasdasd');
    setReceiptNumber = (allReceipts.length + 1);
    update();
  }

  get time => _time;

  set setTime(value) {
    _time = value;
  }

  addNewReceipt(ReceiptModel receipt) async {
    var dbHelper = DatabaseHelper.db;
    await dbHelper.insertReceipt(receipt);
    for (int i = 0; i < receiptItems.length; i++) {
      print(
          '88888888888888888888888888888888888888888888888888888888888888888');
      print(receiptItems[i].quantity);
      if (receiptItems[i].quantity == 0) {
        continue;
      }

      await dbHelper.insertReceiptItem(ReceiptItemModel(
        fItemId: receiptItems[i].id,
        fReceiptId: receiptNumber,
        itemNumber: receiptItems[i].itemNumber,
        conversionFactor: receiptItems[i].conversionFactor,
        unitName: receiptItems[i].unitName,
        rItemDiscount: receiptItems[i].discount,
        rItemName: receiptItems[i].name,
        rItemPrice: receiptItems[i].price,
        freeReturnableQuantity: receiptItems[i].maxFreeReturnQuantity,
        freeQuantity: receiptItems[i].freeQuantity,
        returnableQuantity: receiptItems[i].maxReturnQuantity! -
            double.parse(receiptItems[i].quantity.toString()),
        rItemQuantity: receiptItems[i].quantity!,
      ));
    }
    receiptItems.forEach((element) {
      print('**********************');
      print(element.maxReturnQuantity);
      print('**********************');
    });
    update();
  }

  //////////////////////////////////// NET RECEIPT //////////////////////////////////////
  calculateNetReceipt() async {
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
      for (int i = 0; i < receiptItems.length; i++) {
        if (receiptItems[i].quantity! >
            (receiptItems[i].maxReturnQuantity as double)) {
          receiptItems[i].quantity = receiptItems[i].maxReturnQuantity;
          receiptItems[i].quantityTextController.text =
              receiptItems[i].maxReturnQuantity.toString();
          Get.snackbar('خطأ', 'كمية الصنف اكبر من الكمية اللتي يمكن استرجاعها');
          return;
        } else if (receiptItems[i].freeQuantity! >
            (receiptItems[i].maxFreeReturnQuantity as double)) {
          receiptItems[i].freeQuantity = receiptItems[i].maxFreeReturnQuantity;
          receiptItems[i].freeQuantityTextController.text =
              receiptItems[i].maxFreeReturnQuantity.toString();
          Get.snackbar('خطأ', 'كمية الصنف اكبر من الكمية اللتي يمكن استرجاعها');
          return;
        }
      }

      ///calculate net receipt
      setNetReceipt = (total + addition) - totalDiscount + tax;

      ///calculate new balance of the account
      setBalanceAfter = account.currentBalance! - netReceipt - cashPayment;

      ///update account balance in the database
      await DatabaseHelper.db
          .updateAccBalance(balanceAfter, account.accId as int);

      /// update items quantities in database
      receiptItems.forEach((element) {
        DatabaseHelper.db.increaseItemQuantity(
            (element.quantity! +
                    double.parse(element.freeQuantity.toString())) *
                element.conversionFactor!,
            element.itemNumber);
      });

      /// set rest of receipt
      setRest = netReceipt - cashPayment;

      ///update the value of returnable quantities of items
      receiptItems.forEach((element) {
        DatabaseHelper.db.decreaseItemReturnableQuantity(
            (element.maxReturnQuantity! -
                double.parse(element.quantity.toString())),
            element.id);
        DatabaseHelper.db.decreaseItemFreeReturnableQuantity(
            (element.maxFreeReturnQuantity! -
                double.parse(element.freeQuantity.toString())),
            element.id);
        print(
            '566666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666666');
        print(element.maxFreeReturnQuantity! -
            double.parse(element.freeQuantity.toString()));
        print(element.id);
      });

      _receiptNumber = (await DatabaseHelper.db.getAllReceipts()).length + 1;
      print(receiptNumber.toString() + 'asdasdasdasdasds');

      /// insert the new receipt into the database
      addNewReceipt(ReceiptModel(
          receiptId: receiptNumber,
          fAccountId: account.accId,
          startDate: date,
          startTime: time,
          saveDate: intl.DateFormat('yyyy-MM-dd').format(DateTime.now()),
          saveTime: intl.DateFormat('kk:mm').format(DateTime.now()),
          total: total,
          discount: totalDiscount,
          addition: addition,
          tax: tax,
          cashPayment: cashPayment,
          rest: rest,
          netReceipt: netReceipt,
          type: receiptType));
      enableCalculateReceipt = false;
      receiptCalculated = true;
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

  bool enableCalculateReceipt = true;

  get balanceAfter => _balanceAfter;

  set setBalanceAfter(value) {
    _balanceAfter = value;
  }

  final receiptPDF = pw.Document();
  List<pw.TableRow> pdfItemsTable = [];

  generatePDF() async {
    for (int i = 0; i < receiptItems.length; i++) {
      if (receiptItems[i].quantity == 0 && receiptItems[i].freeQuantity == 0) {
        continue;
      }
      pdfItemsTable.add(
        pw.TableRow(
            verticalAlignment: pw.TableCellVerticalAlignment.middle,
            children: [
              pw.Text(receiptItems[i].value.toString(),
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(fontSize: pdfTableFontSize)),
              pw.Text(receiptItems[i].price.toString(),
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(fontSize: pdfTableFontSize)),
              pw.Text(receiptItems[i].name.toString(),
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(fontSize: pdfTableFontSize)),
              pw.Text(receiptItems[i].quantity.toString(),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: pdfTableFontSize)),
              pw.Text(receiptItems[i].freeQuantity.toString(),
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(fontSize: pdfTableFontSize)),
            ]),
      );
    }
    Directory appDocDirectory = await getApplicationDocumentsDirectory();

    print(appDocDirectory);
    var data = await rootBundle.load('assets/fonts/ARIALBD.ttf');

    final ttf = pw.Font.ttf(data);
    receiptPDF.addPage(pw.Page(
        theme: pw.ThemeData.withFont(
          base: ttf,
        ),
        pageFormat:
            PdfPageFormat(7.3 * PdfPageFormat.cm, 20 * PdfPageFormat.cm),
        build: (pw.Context context) {
          List<int> m = 'SKY SOFT'.codeUnits;
          print(String.fromCharCodes(m));
          return (pw.Directionality(
            child: pw.Container(
                padding: pw.EdgeInsets.all(5),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.SizedBox(height: 10),
                      pw.Container(
                        padding: pw.EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        alignment: pw.Alignment.center,
                        width: ScreenUtil().setWidth(500),
                        height: ScreenUtil().setHeight(3),
                        child: pw.Text(
                          'SKY SOFT',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(fontSize: 15),
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.center,
                                crossAxisAlignment:
                                    pw.CrossAxisAlignment.center,
                                children: [
                                  pw.Text(receiptNumber.toString(),
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize),
                                      textDirection: pw.TextDirection.rtl),
                                  pw.Text('رقم الفاتورة : ',
                                      style: pw.TextStyle(
                                        fontSize: pdfTableFontSize,
                                      ),
                                      textAlign: pw.TextAlign.center,
                                      textDirection: pw.TextDirection.rtl),
                                  pw.SizedBox(
                                    width: ScreenUtil().setWidth(6),
                                  ),
                                  pw.Text(
                                      (itemsCount + freeItemsCount).toString(),
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize),
                                      textDirection: pw.TextDirection.rtl),
                                  pw.Text('عدد القطع : ',
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize),
                                      textAlign: pw.TextAlign.center,
                                      textDirection: pw.TextDirection.rtl),
                                ])
                          ]),
                      pw.SizedBox(height: 5),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Text(account.name.toString(),
                                textAlign: pw.TextAlign.center,
                                textDirection: pw.TextDirection.rtl),
                            pw.Text('العميل : ',
                                style: pw.TextStyle(fontSize: pdfTableFontSize),
                                textAlign: pw.TextAlign.center,
                                textDirection: pw.TextDirection.rtl),
                          ]),
                      pw.SizedBox(height: 5),
                      pw.Table(
                          defaultVerticalAlignment:
                              pw.TableCellVerticalAlignment.middle,
                          columnWidths: {
                            0: pw.FlexColumnWidth(4),
                            1: pw.FlexColumnWidth(4),
                            2: pw.FlexColumnWidth(5),
                            3: pw.FlexColumnWidth(4),
                          },
                          children: [
                            pw.TableRow(
                                verticalAlignment:
                                    pw.TableCellVerticalAlignment.middle,
                                children: [
                                  pw.Text('قيمه',
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                        fontSize: pdfTableFontSize,
                                      )),
                                  pw.Text('سعر',
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text('صنف',
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text('كمية',
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text('كميه مجانيه',
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                ]),
                            for (int i = 0; i < pdfItemsTable.length; i++)
                              pdfItemsTable.elementAt(i)
                          ]),
                      pw.SizedBox(height: 25),
                      pw.Table(
                          defaultVerticalAlignment:
                              pw.TableCellVerticalAlignment.middle,
                          children: [
                            pw.TableRow(
                                verticalAlignment:
                                    pw.TableCellVerticalAlignment.middle,
                                children: [
                                  pw.Text('رص بعد',
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                        fontSize: pdfTableFontSize,
                                      )),
                                  pw.Text('رص قبل',
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text('صافي',
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text('اجمالي',
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                ]),
                            pw.TableRow(
                                verticalAlignment:
                                    pw.TableCellVerticalAlignment.middle,
                                children: [
                                  pw.Text(balanceAfter.toString(),
                                      style: pw.TextStyle(
                                        fontSize: pdfTableFontSize,
                                      )),
                                  pw.Text(account.currentBalance.toString(),
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text(netReceipt.toString(),
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text(total.toString(),
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                ])
                          ]),
                      pw.SizedBox(height: 15),
                      pw.Center(
                          child: pw.Row(
                              crossAxisAlignment: pw.CrossAxisAlignment.center,
                              mainAxisAlignment: pw.MainAxisAlignment.end,
                              children: [
                            pw.Text(cashPayment.toString(),
                                textAlign: pw.TextAlign.right,
                                style:
                                    pw.TextStyle(fontSize: pdfTableFontSize)),
                            pw.Text('سداد : ',
                                textAlign: pw.TextAlign.right,
                                style:
                                    pw.TextStyle(fontSize: pdfTableFontSize)),
                          ])),
                      pw.SizedBox(height: 25),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                                intl.DateFormat('kk:mm').format(DateTime.now()),
                                textAlign: pw.TextAlign.right,
                                style:
                                    pw.TextStyle(fontSize: pdfTableFontSize)),
                            pw.Text('الوقت : ',
                                textAlign: pw.TextAlign.right,
                                style:
                                    pw.TextStyle(fontSize: pdfTableFontSize)),
                            pw.Text(
                                intl.DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now()),
                                textAlign: pw.TextAlign.right,
                                style:
                                    pw.TextStyle(fontSize: pdfTableFontSize)),
                            pw.Text('التاريخ : ',
                                textAlign: pw.TextAlign.right,
                                style:
                                    pw.TextStyle(fontSize: pdfTableFontSize)),
                          ])
                    ])),
            textDirection: pw.TextDirection.rtl,
          ));
        }));

    final file = File(
      '${appDocDirectory.path}' + '/receipt $receiptNumber.pdf',
    );
    print(file.path);

    print('file created');
    await file.writeAsBytes(await receiptPDF.save());
    print('file saved');
    await OpenFile.open(file.path);
  }

  String _searchForReceiptWord = '';

  String get searchForReceiptWord => _searchForReceiptWord;

  set setSearchForReceiptWord(String value) {
    _searchForReceiptWord = value;
  }

  var searchController = TextEditingController();

  updateNetReceipt() {
    _netReceipt = total + addition - totalDiscount + tax;
    setBalanceAfter = account.currentBalance! - netReceipt - cashPayment;
    setRest = netReceipt - cashPayment;
    update();
  }

  /////////////////////////////////////Total net receipts////////////////////
  double _totalSalesNetReceipts = 0;

  double get totalSalesNetReceipts => _totalSalesNetReceipts;

  set setTotalSalesNetReceipts(double value) {
    _totalSalesNetReceipts = value;
  }

  double _totalReturnNetReceipts = 0;
  double _totalAdditionsReturnReceipts = 0;
  double _totalAdditionsReceipts = 0;
  double _totalDiscountsReturnReceipts = 0;
  double _totalDiscountsReceipts = 0;
  double _totalTaxesReturnReceipts = 0;
  double _totalTaxesReceipts = 0;
  double _totalCashPaymentsReturnReceipts = 0;
  double _totalCashPaymentsReceipts = 0;
  double _totalTotalsReturnReceipts = 0;

  double get totalTotalsReturnReceipts => _totalTotalsReturnReceipts;

  set setTotalTotalsReturnReceipts(double value) {
    _totalTotalsReturnReceipts = value;
  }

  double _totalTotalsReceipts = 0;

  double get totalAdditionsReturnReceipts => _totalAdditionsReturnReceipts;

  set setTotalAdditionsReturnReceipts(double value) {
    _totalAdditionsReturnReceipts = value;
  }

  calculateTotalNetReceipts() {
    _totalReturnNetReceipts = 0;
    _totalAdditionsReturnReceipts = 0;
    _totalAdditionsReceipts = 0;
    _totalDiscountsReturnReceipts = 0;
    _totalDiscountsReceipts = 0;
    _totalTaxesReturnReceipts = 0;
    _totalTaxesReceipts = 0;
    _totalCashPaymentsReturnReceipts = 0;
    _totalCashPaymentsReceipts = 0;
    setTotalSalesNetReceipts = 0;
    setTotalReturnNetReceipts = 0;
    _totalTotalsReturnReceipts = 0;
    _totalTotalsReceipts = 0;
    allReceipts.forEach((element) {
      if (element.type == 'sales') {
        _totalAdditionsReceipts += element.addition!;
        _totalDiscountsReceipts += element.discount!;
        _totalTaxesReceipts += element.tax!;
        _totalTotalsReceipts += element.total!;
        _totalCashPaymentsReceipts += element.cashPayment!;
        _totalSalesNetReceipts += element.netReceipt!;
      } else if (element.type == 'return') {
        _totalAdditionsReturnReceipts += element.addition!;
        _totalDiscountsReturnReceipts += element.discount!;
        _totalTotalsReturnReceipts += element.total!;
        _totalTaxesReturnReceipts += element.tax!;
        _totalCashPaymentsReturnReceipts += element.cashPayment!;
        _totalReturnNetReceipts += element.netReceipt!;
      }
    });
    update();
  }

  void resetAll() {
    setSearchForReceiptWord = '';
    getReceipts();
    enableCalculateReceipt = true;
    setReturnReceiptFlag = false;
  }

  double get totalReturnNetReceipts => _totalReturnNetReceipts;

  set setTotalReturnNetReceipts(double value) {
    _totalReturnNetReceipts = value;
  }

  double get totalAdditionsReceipts => _totalAdditionsReceipts;

  set setTotalAdditionsReceipts(double value) {
    _totalAdditionsReceipts = value;
  }

  double get totalDiscountsReturnReceipts => _totalDiscountsReturnReceipts;

  set setTotalDiscountsReturnReceipts(double value) {
    _totalDiscountsReturnReceipts = value;
  }

  double get totalDiscountsReceipts => _totalDiscountsReceipts;

  set setTotalDiscountsReceipts(double value) {
    _totalDiscountsReceipts = value;
  }

  double get totalTaxesReturnReceipts => _totalTaxesReturnReceipts;

  set setTotalTaxesReturnReceipts(double value) {
    _totalTaxesReturnReceipts = value;
  }

  double get totalTaxesReceipts => _totalTaxesReceipts;

  set setTotalTaxesReceipts(double value) {
    _totalTaxesReceipts = value;
  }

  double get totalCashPaymentsReturnReceipts =>
      _totalCashPaymentsReturnReceipts;

  set setTotalCashPaymentsReturnReceipts(double value) {
    _totalCashPaymentsReturnReceipts = value;
  }

  double get totalCashPaymentsReceipts => _totalCashPaymentsReceipts;

  set setTotalCashPaymentsReceipts(double value) {
    _totalCashPaymentsReceipts = value;
  }

  double get totalTotalsReceipts => _totalTotalsReceipts;

  set setTotalTotalsReceipts(double value) {
    _totalTotalsReceipts = value;
  }
}

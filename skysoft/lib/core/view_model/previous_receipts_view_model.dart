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
import 'package:skysoft/models/account_model.dart';
import 'package:skysoft/models/receipt_item_model.dart';
import 'package:skysoft/models/receipt_model.dart';
import 'package:skysoft/models/waiting_items.dart';
import 'package:intl/intl.dart' as intl;
import 'package:skysoft/view/home_view.dart';

import '../../constants.dart';

class PreviousReceiptsViewModel extends GetxController {
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    getAllReceipts();
  }

  List<ReceiptModel> allReceipts = [];
  List<AccountModel> accountsInReceipts = [];
  List<WaitingItemsModel> receiptItems = [];
  AccountModel _account = AccountModel();

  AccountModel get account => _account;

  set setAccount(AccountModel value) {
    _account = value;
  }

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

  int _itemsCount = 0;

  int get itemsCount => _itemsCount;

  set setItemsCount(int value) {
    _itemsCount = value;
  }

  bool _returnReceiptFlag = false;

  bool get returnReceiptFlag => _returnReceiptFlag;

  set setReturnReceiptFlag(bool value) {
    _returnReceiptFlag = value;
    updateNetReceipt();
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

  set setCashPayment(value) {
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

  startReturnReceipt() {
    setReturnReceiptFlag = true;
    setDate = intl.DateFormat('yyyy-MM-dd').format(DateTime.now());
    setTime = intl.DateFormat('kk:mm').format(DateTime.now());
    setReceiptType = 'return';
    updateItemCount();
    getReceiptNumber();
    calculateTotal();
  }

  updateItemCount() {
    _itemsCount = 0;
    receiptItems.forEach((element) {
      _itemsCount += element.quantity!.toInt();
    });
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

  getAllReceipts() async {
    //allReceipts.clear();
    allReceipts =
        //searchForReceiptWord == ''
       // ?
    await DatabaseHelper.db.getAllReceipts();
       // : await DatabaseHelper.db.findReceipt(searchForReceiptWord);

    print(allReceipts.length);
    for (int i = 0; i < allReceipts.length; i++) {
      accountsInReceipts
          .add(await DatabaseHelper.db.findAccount(allReceipts[i].fAccountId));
    }
    update();
    print(allReceipts);
    print('-----------');
    print(accountsInReceipts);
  }

  getReceiptItems(int receiptId) async {
    receiptItems.clear();
    List<ReceiptItemModel> returnedItems =
        await DatabaseHelper.db.findReceiptItems(receiptId);
    returnedItems.forEach((element) {
      receiptItems.add(WaitingItemsModel(
          id: element.fItemId,
          quantity: element.rItemQuantity,
          quantityTextController:
              TextEditingController(text: element.rItemQuantity.toString()),
          discountTextController:
              TextEditingController(text: element.rItemDiscount.toString()),
          name: element.rItemName,
          price: element.rItemPrice,
          discount: element.rItemDiscount));
    });
    calculateItemsCount();
    update();
  }

  calculateItemsCount() {
    _itemsCount = 0;
    receiptItems.forEach((element) {
      _itemsCount += element.quantity!.toInt();
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
      if (receiptItems[i].quantity == 0) {
        continue;
      }

      await dbHelper.insertReceiptItem(ReceiptItemModel(
        fItemId: receiptItems[i].id,
        fReceiptId: receiptNumber,
        rItemDiscount: receiptItems[i].discount,
        rItemName: receiptItems[i].name,
        rItemPrice: receiptItems[i].price,
        rItemQuantity: receiptItems[i].quantity,
      ));
    }
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
      ///calculate net receipt
      _netReceipt = (total + addition) - totalDiscount + tax;

      ///calculate new balance of the account
      setBalanceAfter = account.currentBalance! - netReceipt - cashPayment;

      ///update account balance in the database
      await DatabaseHelper.db
          .updateAccBalance(balanceAfter, account.accId as int);

      /// update items quantities in database
      receiptItems.forEach((element) {
        DatabaseHelper.db.increaseItemQuantity(element.quantity, element.id);
      });

      /// set rest of receipt
      setRest = netReceipt - cashPayment;

      /// insert the new receipt into the database
      addNewReceipt(ReceiptModel(
          receiptId: receiptNumber,
          fAccountId: account.accId,
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
                        //  generatePDF();
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

  bool enabled = true;

  get balanceAfter => _balanceAfter;

  set setBalanceAfter(value) {
    _balanceAfter = value;
  }

  final receiptPDF = pw.Document();
  List<pw.TableRow> pdfItemsTable = [];

  generatePDF() async {
    for (int i = 0; i < receiptItems.length; i++) {
      if (receiptItems[i].quantity == 0) {
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
                                  pw.Text(itemsCount.toString(),
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
                                  pw.Text('القيمه',
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                        fontSize: pdfTableFontSize,
                                      )),
                                  pw.Text('السعر',
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text('الصنف',
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text('الكمية',
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
                                  pw.Text('الرصيد بعد',
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                        fontSize: pdfTableFontSize,
                                      )),
                                  pw.Text('الرصيد قبل',
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text('الصافي',
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text('الاجمالي',
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

  updateNetReceipt() {
    _netReceipt = total + addition - totalDiscount + tax;
    setBalanceAfter = account.currentBalance! - netReceipt - cashPayment;
    setRest = netReceipt - cashPayment;
    update();
  }
}

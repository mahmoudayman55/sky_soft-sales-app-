import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:core';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:skysoft/core/%20services/database_helper.dart';
import 'package:skysoft/core/view_model/add_item_view_model.dart';
import 'package:skysoft/core/view_model/previous_receipts_view_model.dart';
import 'package:skysoft/models/account_model.dart';
import 'package:intl/intl.dart' as intl;
import 'package:skysoft/models/item_model.dart';
import 'package:skysoft/models/receipt_item_model.dart';
import 'package:skysoft/models/receipt_model.dart';
import 'package:skysoft/models/waiting_items.dart';
import 'package:skysoft/view/home_view.dart';
import 'package:skysoft/view/receipt_view.dart';

import '../../constants.dart';

class ReceiptViewModel extends GetxController {
  ReceiptViewModel() {
    DatabaseHelper.db.initAccData();
    DatabaseHelper.db.initItemsData();

    update();
    searchForAccount();
    update();
  }

  var itemsKey = GlobalKey<FormState>();
  var totalDiscountController = TextEditingController(text: '0');
  var totalAdditionController = TextEditingController(text: '0');
  var totalTaxController = TextEditingController(text: '0');
  var cashPaymentController = TextEditingController(text: '0');

  String _total = '0';
  String _totalDiscount = '0';
  String _addition = '0';
  String _tax = '0';
  String _cashPayment = '0';
  String _bankPayment = '0';
  String _rest = '0';
  String _netReceipt = '0';
  String _balanceBefore = '0';
  String _balanceAfter = '0';

  String get balanceAfter => _balanceAfter;

  set setBalanceAfter(String value) {
    _balanceAfter = value;
  }

  bool showBalanceAfterReceipt = false;

  String get balanceBefore => _balanceBefore;

  set setBalanceBefore(String value) {
    _balanceBefore = value;
  }

  String get netReceipt => _netReceipt;

  set setNetReceipt(String value) {
    _netReceipt = value;
  }
String? receiptType='sales';
  List<DropdownMenuItem<String>> receiptTypes = [
    DropdownMenuItem<String>(
      value: 'sales',
        child: Text(
      'فاتورة مبيعات',
      style: TextStyle(
          color: Colors.limeAccent,
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.bold,
          fontSize: 25),
    )),
    DropdownMenuItem<String>(
        value: 'return',
        child: Text(
          'فاتورة مردود',
          style: TextStyle(
              color: Colors.limeAccent,
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ))
  ];

  int _itemsCount = 0;
  final receiptPDF = pw.Document();

  generatePDF() async {
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
                            pw.Text(receiptAccount.name.toString(),
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
                            for (int i = 0; i < waitingItemsList.length; i++)
                              pw.TableRow(
                                  verticalAlignment:
                                      pw.TableCellVerticalAlignment.middle,
                                  children: [
                                    pw.Text(
                                        waitingItemsList[i].value.toString(),
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                            fontSize: pdfTableFontSize)),
                                    pw.Text(
                                        waitingItemsList[i].price.toString(),
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                            fontSize: pdfTableFontSize)),
                                    pw.Text(waitingItemsList[i].name.toString(),
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                            fontSize: pdfTableFontSize)),
                                    pw.Text(
                                        waitingItemsList[i].quantity.toString(),
                                        textAlign: pw.TextAlign.center,
                                        style: pw.TextStyle(
                                            fontSize: pdfTableFontSize)),
                                  ]),
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
                                  pw.Text(balanceBefore.toString(),
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text(netReceipt,
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text(total,
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
                            pw.Text(cashPayment,
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
  savePDF() async {
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
                            pw.Text(receiptAccount.name.toString(),
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
                            for (int i = 0; i < waitingItemsList.length; i++)
                              pw.TableRow(
                                  verticalAlignment:
                                  pw.TableCellVerticalAlignment.middle,
                                  children: [
                                    pw.Text(
                                        waitingItemsList[i].value.toString(),
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                            fontSize: pdfTableFontSize)),
                                    pw.Text(
                                        waitingItemsList[i].price.toString(),
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                            fontSize: pdfTableFontSize)),
                                    pw.Text(waitingItemsList[i].name.toString(),
                                        textAlign: pw.TextAlign.left,
                                        style: pw.TextStyle(
                                            fontSize: pdfTableFontSize)),
                                    pw.Text(
                                        waitingItemsList[i].quantity.toString(),
                                        textAlign: pw.TextAlign.center,
                                        style: pw.TextStyle(
                                            fontSize: pdfTableFontSize)),
                                  ]),
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
                                  pw.Text(balanceBefore.toString(),
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text(netReceipt,
                                      textAlign: pw.TextAlign.left,
                                      style: pw.TextStyle(
                                          fontSize: pdfTableFontSize)),
                                  pw.Text(total,
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
                                pw.Text(cashPayment,
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

  updateNetReceipt()
{
  _netReceipt = ((double.parse(total) + double.parse(addition)) - double.parse(totalDiscount) + double.parse(tax)).toString();
  setBalanceAfter = (receiptAccount.currentBalance! + double.parse(netReceipt) - double.parse(cashPayment)).toString();
  setRest = (double.parse(netReceipt) - double.parse(cashPayment)).toString();
  update();
}
  calculateTotal() {
    double totalValues = 0;
    _waitingItemsList.forEach((element) {
      totalValues += element.value!;
    });
    _total = totalValues.toString();
  }

  addNewReceipt(ReceiptModel receipt) async {
    var dbHelper = DatabaseHelper.db;
    await dbHelper.insertReceipt(receipt);
    _waitingItemsList.forEach((element) async {
      await dbHelper.insertReceiptItem(
          ReceiptItemModel(
        fItemId: element.id,
        fReceiptId: int.parse(_receiptNumber),
        rItemDiscount: element.discount,
        rItemName: element.name,
        rItemPrice: element.price,
        rItemQuantity: element.quantity,
      ));
    });
    update();
  }

  calculateNetReceipt() async {
    if (_accountName == 'العميل' ||
        totalDiscount.isEmpty ||
        tax.isEmpty ||
        _addition.isEmpty ||
        waitingItemsList.isEmpty) {
      Get.snackbar(
        'خطأ',
        'الرجاء اكمال بيانات الفاتورة بشكل صحيح',
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.GROUNDED,
      );
    } else {
      // Get.dialog(SearchAccountView());
      _netReceipt = ((double.parse(_total) + double.parse(_addition)) -
              double.parse(_totalDiscount) +
              double.parse(_tax))
          .toString();
      _balanceBefore = receiptAccount.currentBalance.toString();
      double newBalance = receiptAccount.currentBalance! +
          double.parse(_netReceipt) -
          double.parse(_cashPayment);
      await DatabaseHelper.db
          .updateAccBalance(newBalance, receiptAccount.accId as int);
      setBalanceAfter = newBalance.toString();

      waitingItemsList.forEach((element) {
        DatabaseHelper.db.decreaseItemQuantity(element.quantity, element.id);
      });
      setRest =
          (double.parse(_netReceipt) - double.parse(cashPayment)).toString();
      showBalanceAfterReceipt = true;
      addNewReceipt(ReceiptModel(
         receiptId:  int.parse(_receiptNumber),
        fAccountId:   receiptAccount.accId,
        date:   date,
        total:   double.parse(_total),
        discount:   double.parse(_totalDiscount),
       addition:    double.parse(_addition),
      tax:     double.parse(tax),
       cashPayment:    double.parse(_cashPayment),
        bankPayment:   double.parse(bankPayment),
        rest:   double.parse(rest),
        netReceipt:   double.parse(_netReceipt),
      time: time,
        type: receiptType
      )

      );

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
savePDF();
      // Get.offAll(HomeView());
    }
  }

  bool enabled = true;

  int get itemsCount => _itemsCount;

  set setItemsCount(int value) {
    _itemsCount = value;
  }

  // List<int> list = 'xxx'.codeUnits;
  // Uint8List bytes = Uint8List.fromList(list);
  // String string = String.fromCharCodes(bytes);

//   createPDF() async {
//
//
//          Directory appDocDirectory = await getApplicationDocumentsDirectory();
//
//     //Create a new PDF document
//     PdfDocument document = PdfDocument();
//
// //Adds a page to the document
//     PdfPage page = document.pages.add();
//
//     String text =
//         'سنبدأ بنظرة عامة مفاهيمية على مستند PDF بسيط. تم تصميم هذا الفصل ليكون توجيهًا مختصرًا قبل الغوص في مستند حقيقي وإنشاءه من البداية.\r\n \r\nيمكن تقسيم ملف PDF إلى أربعة أجزاء: الرأس والجسم والجدول الإسناد الترافقي والمقطورة. يضع الرأس الملف كملف PDF ، حيث يحدد النص المستند المرئي ، ويسرد جدول الإسناد الترافقي موقع كل شيء في الملف ، ويوفر المقطع الدعائي تعليمات حول كيفية بدء قراءة الملف.\r\n\r\nرأس الصفحة هو ببساطة رقم إصدار PDF وتسلسل عشوائي للبيانات الثنائية. البيانات الثنائية تمنع التطبيقات الساذجة من معالجة ملف PDF كملف نصي. سيؤدي ذلك إلى ملف تالف ، لأن ملف PDF يتكون عادةً من نص عادي وبيانات ثنائية (على سبيل المثال ، يمكن تضمين ملف خط ثنائي بشكل مباشر في ملف PDF)';
//
// //Draw text
//     page.graphics.drawString(
//         text, PdfTrueTypeFont(File('assets/fonts/Arial.ttf').readAsBytesSync(), 14),
//         brush: PdfBrushes.black,
//         bounds: Rect.fromLTWH(
//             0, 0, page.getClientSize().width, page.getClientSize().height),
//         format: PdfStringFormat(
//             textDirection: PdfTextDirection.rightToLeft,
//             alignment: PdfTextAlignment.right,
//             paragraphIndent: 35));
//     final file = File(
//        '${appDocDirectory.path}' + '/test99.pdf',
//      );
// //Saves the document
//     File('Output.pdf').writeAsBytes(document.save());
//     OpenFile.open(file.path);
// //Disposes the document
//     document.dispose();
//   }

  updateItemCount() {
    _itemsCount = 0;
    _waitingItemsList.forEach((element) {
      _itemsCount += element.quantity!.toInt();
    });
  }

  String get total => _total;

  getItemByBarcode() async {
    // var options=ScanOptions(
    //   useCamera: 1 ,
    //   android: AndroidOptions(useAutoFocus: true)
    //
    //
    // );

    //     if(barcode.isEmpty){
    //   return;
    // }
    // else{
    // String barcode2;
    // FlutterBarcodeScanner.getBarcodeStreamReceiver("#ff6666", "Cancel", false, ScanMode.DEFAULT)!
    //     .listen((barcode) {
    //       barcode2=barcode;
    //       print(barcode2);
    //   /// barcode to be used
    // });
    // List<ItemModel> scannedItem=await DatabaseHelper.db.findItem(barcode);
    // scannedItem.forEach((element) { _waitingItemsList.add( WaitingItemsModel(id: element.itemId, quantityTextController: TextEditingController(), discountTextController: TextEditingController(), name: element.itemName, quantity: 1, price: element.sellingPrice, discount: 0));});
    // update();
    // }
  }

  List<DataRow> _allItems = [];

  List<DataRow> get allItems {
    return _allItems;
  }

  set setAllItems(List<DataRow> value) {
    _allItems = value;
  }

  void removeSelectedItems() {
    waitingItemsList.removeWhere((element) => selectedItems.contains(element));
    calculateTotal();
    updateItemCount();
    update();
  }

  returnAllItems() {
    setAllItems = List<DataRow>.generate(
      ItemsViewModel().itemModelList.length,
      (index) => DataRow(
          onSelectChanged: (_) {
            addToWaitingItems(itemsSearchResultList[index]);
            Get.off(ReceiptView());
          },
          color: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            // Even rows will have a grey color.
            if (index % 2 == 0) return Colors.grey.shade50;
            return Colors.grey
                .shade300; // Use default value for other states and odd rows.
          }),
          cells: [
            DataCell(Text(
              ItemsViewModel().itemModelList[index].itemId.toString(),
              style: rowItemElementTextStyle(),
            )),
            DataCell(Text(
              ItemsViewModel().itemModelList[index].itemName.toString(),
              style: rowItemElementTextStyle(),
            )),
            DataCell(Text(
              ItemsViewModel().itemModelList[index].itemQuantity.toString(),
              style: rowItemElementTextStyle(),
            )),
            DataCell(Text(
              ItemsViewModel().itemModelList[index].wholesalePrice.toString(),
              style: rowItemElementTextStyle(),
            )),
            DataCell(Text(
              ItemsViewModel().itemModelList[index].sellingPrice.toString(),
              style: rowItemElementTextStyle(),
            )),
            DataCell(Text(
              ItemsViewModel().itemModelList[index].avgPurchasePrice.toString(),
              style: rowItemElementTextStyle(),
            )),
            DataCell(Text(
              ItemsViewModel()
                  .itemModelList[index]
                  .lastPurchasePrice
                  .toString(),
              style: rowItemElementTextStyle(),
            )),
            DataCell(Text(
              ItemsViewModel().itemModelList[index].itemBarcode.toString(),
              style: rowItemElementTextStyle(),
            )),
          ]),
    ).toList();
    print(
        'asdasdjasdsdfjklasdjkfasdfjkbsdfj asff.sdhasdas546213213asdfsgtadfgsdgfs/*g/*/*/*/*///*');
  }

  String _date = intl.DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _time = intl.DateFormat('kk:mm').format(DateTime.now());

  String get time => _time;

  String get date => _date;

  String _accountName = 'العميل';

  String get accountName => _accountName;

  set setAccountName(String value) {
    _accountName = value;
    update();
  }

  AccountModel _receiptAccount = AccountModel();

  AccountModel get receiptAccount => _receiptAccount;

  String _receiptNumber = '';

  String get receiptNumber => _receiptNumber;

  setReceiptNumber() async {
    List<ReceiptModel> allReceipts;
    allReceipts = await DatabaseHelper.db.getAllReceipts();
    print((allReceipts.length + 1).toString() +
        'asadasdasdasdasdasdasd898989asdasdasd');
    _receiptNumber = (allReceipts.length + 1).toString();
    update();
  }

  set setReceiptAccount(AccountModel value) {
    _receiptAccount = value;
    _accountName = value.name.toString();
    _balanceBefore = value.currentBalance.toString();

    update();
  }

  int _selectedIndex = -1;

  int get selectedIndex {
    return _selectedIndex;
  }

  set updateSelectedIndex(int value) {
    _selectedIndex = value;
    update();
  }

  late String accountSearchQuery = '';
  late String itemSearchQuery = '';

  List<AccountModel> _accountSearchResultList = [];
  List<WaitingItemsModel> _selectedItems = [];

  List<WaitingItemsModel> get selectedItems => _selectedItems;

  set setSelectedItems(List<WaitingItemsModel> value) {
    _selectedItems = value;
  }

  List<AccountModel> get accountSearchResultList => _accountSearchResultList;
  List<ItemModel> _itemsSearchResultList = [];
  List<WaitingItemsModel> _waitingItemsList = [];

  List<WaitingItemsModel> get waitingItemsList => _waitingItemsList;

  addToSelectedItems(WaitingItemsModel model) {
    selectedItems.add(model);
    update();
  }

  String get totalDiscount => _totalDiscount;

  set setTotalDiscount(String value) {
    _totalDiscount = value;
  }

  removeFromSelectedItems(WaitingItemsModel model) {
    selectedItems.remove(model);
    update();
  }

  itemIsAdding(int index, WaitingItemsModel model, bool isAdding) {
    isAdding
        ? addToSelectedItems(waitingItemsList[index])
        : removeFromSelectedItems(waitingItemsList[index]);
    update();
  }

  set setWaitingItemsList(List<WaitingItemsModel> value) {
    _waitingItemsList = value;
  }

  addToWaitingItems(ItemModel item) {
    _waitingItemsList.add(WaitingItemsModel(
        quantityTextController: TextEditingController(text: '1'),
        discountTextController: TextEditingController(text: '0'),
        id: item.itemId,
        name: item.itemName,
        price: item.sellingPrice,
        discount: 0,
        quantity: 1));
    updateItemCount();
    update();
  }

  List<ItemModel> get itemsSearchResultList {
    // if(itemSearchQuery.isEmpty){
    //   return ItemsViewModel().itemModelList;
    // }
    return _itemsSearchResultList;
  }

  List<ItemModel> _receiptItems = [];

  List<ItemModel> get receiptItems => _receiptItems;

  set setReceiptItems(List<ItemModel> value) {
    _receiptItems = value;
  }

  searchForAccount() async {
    var dbHelper = DatabaseHelper.db;
    _accountSearchResultList = accountSearchQuery.isEmpty
        ? await dbHelper.getAllAccounts()
        : await dbHelper.findAccounts(accountSearchQuery);
    print(_accountSearchResultList);
    update();
    print('items returned successfully');
  }

  searchForItem() async {
    var dbHelper = DatabaseHelper.db;
    _itemsSearchResultList = itemSearchQuery.isEmpty
        ? await dbHelper.getAllItems()
        : await dbHelper.findItem(itemSearchQuery);
    update();
  }

  String get addition => _addition;

  set setAddition(String value) {
    _addition = value;
  }

  String get tax => _tax;

  set setTax(String value) {
    _tax = value;
  }

  String get cashPayment => _cashPayment;

  set setCashPayment(String value) {
    _cashPayment = value;
  }

  String get bankPayment => _bankPayment;

  String get rest => _rest;

  set setBankPayment(String value) {
    _bankPayment = value;
  }

  set setRest(String value) {
    _rest = value;
  }
}

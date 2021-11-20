import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:barcode_scan/barcode_scan.dart';

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
  var data=Get.arguments;
  ReceiptViewModel() {
    if(waitingItemsList.isNotEmpty){
      updateNetReceipt();

    }


   //   print(Get.arguments+'sdefdasfasd');


    update();
    var data = Get.arguments;

    DatabaseHelper.db.initAccData();
    DatabaseHelper.db.initItemsData();


    update();
    searchForAccount();
    if (data != null) {

      setStartDate=intl.DateFormat('yyyy-MM-dd').format(DateTime.now());
      setStartTime=intl.DateFormat('kk:mm').format(DateTime.now());
      //setReceiptNumber();
      _receiptNumber = data[2] + 2;
      print(data.toString() + ' argumentsssss');
      setReceiptAccount = data[0];
      waitingItemsList = data[1];
      updateItemCount();
      updateFreeItemCount();

      calculateTotal();
      updateNetReceipt();

      update();
    }

    update();
  }

  var itemsKey = GlobalKey<FormState>();
  var totalDiscountController = TextEditingController(text: '0');
  var totalAdditionController = TextEditingController(text: '0');
  var totalTaxController = TextEditingController(text: '0');
  var cashPaymentController = TextEditingController(text: '0');

  double _total = 0;

bool loading=false;
  set setTotal(double value) {
    _total = value;
  }

  double _totalDiscount = 0;
  double _addition = 0;
  double _tax = 0;
  double _cashPayment = 0;
  double _bankPayment = 0;
  double _rest = 0;
  double _netReceipt = 0;
  double _balanceBefore = 0;
  double _balanceAfter = 0;

  double get balanceAfter => _balanceAfter;

  set setBalanceAfter(double value) {
    _balanceAfter = value;
  }

  bool showBalanceAfterReceipt = false;

  double get balanceBefore => _balanceBefore;

  set setBalanceBefore(double value) {
    _balanceBefore = value;
  }

  double get netReceipt => _netReceipt;

  set setNetReceipt(double value) {
    _netReceipt = value;
  }

  String _receiptType = 'sales';

  String get receiptType => _receiptType;

  set setReceiptType(String value) {
    _receiptType = value;
  }

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

  double _itemsCount = 0;
  final receiptPDF = pw.Document();

  bool enabled = true;

  double get itemsCount => _itemsCount;

  set setItemsCount(double value) {
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

  double get total => _total;

  List<DataRow> _allItems = [];

  List<DataRow> get allItems {
    return _allItems;
  }

  set setAllItems(List<DataRow> value) {
    _allItems = value;
  }

  String _startDate = '';
  String _saveDate = '';

  String get saveDate => _saveDate;

  set setSaveDate(String value) {
    _saveDate = value;
  }

  String _saveTime = '';

  set setStartDate(String value) {
    _startDate = value;
  }

  String _startTime = '';

  set setStartTime(String value) {
    _startTime = value;
  }

  String get startTime => _startTime;

  String get startDate => _startDate;

  String _accountName = 'العميل';

  String get accountName => _accountName;

  set setAccountName(String value) {
    _accountName = value;
    update();
  }

  AccountModel _receiptAccount = AccountModel();

  AccountModel get receiptAccount => _receiptAccount;

  int _receiptNumber = 0;
int receiptNumberStartValue=0;

  set receiptNumberSetter(int value) {

    _receiptNumber = value;
  }

  int get receiptNumber {
    return _receiptNumber;
  }

  set setReceiptAccount(AccountModel value) {
    _receiptAccount = value;
    _accountName = value.name.toString();
    _balanceBefore = value.currentBalance!;

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

  set setAccountSearchResultList(List<AccountModel> value) {
    _accountSearchResultList = value;
  }

  List<WaitingItemsModel> _selectedItems = [];

  List<WaitingItemsModel> get selectedItems => _selectedItems;

  set setSelectedItems(List<WaitingItemsModel> value) {
    _selectedItems = value;
  }

  List<AccountModel> get accountSearchResultList => _accountSearchResultList;
  List<ItemModel> _itemsSearchResultList = [];

  set setItemsSearchResultList(List<ItemModel> value) {
    _itemsSearchResultList = value;
  }

  RxList<WaitingItemsModel> waitingItemsList =RxList<WaitingItemsModel>() ;

 // RxList<WaitingItemsModel> get waitingItemsList => _waitingItemsList;

  double get totalDiscount => _totalDiscount;

  set setTotalDiscount(double value) {
    _totalDiscount = value;
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
                            4: pw.FlexColumnWidth(4),
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
                                  pw.Text('الكمية المجانيه',
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
                                    pw.Text(
                                        waitingItemsList[i]
                                            .freeQuantity
                                            .toString(),
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

  updateNetReceipt() async {
    await Hive.openBox(constBoxName);
    if(constBox.get(startValueName)!=null){
      receiptNumberStartValue=constBox.get(startValueName);
    }
   // String currentBalance = receiptAccount.currentBalance.toString();
    setNetReceipt = ((total + addition) - totalDiscount + tax);
    // _cashPayment=0;
    // _totalDiscount=0;
    // _addition=0;
    // _tax=0;
    // cashPaymentController.text='0';
    // totalTaxController.text='0';
    // totalDiscountController.text='0';
    // totalAdditionController.text='0';
    setRest = netReceipt - cashPayment;
    setBalanceAfter = receiptAccount.currentBalance! + netReceipt - cashPayment;

    update();
  }

  resetAll() {
    setStartDate= '';
    setStartTime = '';
    setSaveDate='';
    setSaveTime='';
    waitingItemsList.clear();
    enabled = true;
    calculateTotal();
    updateNetReceipt();
    updateItemCount();
    setTotal = 0;
    setBalanceBefore=0;
    setBalanceAfter=0;
    setRest = 0;
    setAddition = 0;
    setTax = 0;
    totalDiscountController.text = '0';
    totalAdditionController.text = '0';
    totalTaxController.text = '0';
    cashPaymentController.text = '0';
    setBalanceAfter = 0;
    update();
  }

  calculateTotal() {
    double totalValues = 0;
    waitingItemsList.forEach((element) {
      totalValues += element.value!;
    });
    setTotal = totalValues;
    print(totalValues);
  }

  addNewReceipt(ReceiptModel receipt) async {
    var dbHelper = DatabaseHelper.db;
    await dbHelper.insertReceipt(receipt);
    waitingItemsList.forEach((element) async {
      await dbHelper.insertReceiptItem(ReceiptItemModel(
        fItemId: element.id,
        conversionFactor: element.conversionFactor,
        unitName: element.unitName,
        itemNumber: element.itemNumber,
        returnableQuantity: element.quantity,
        freeReturnableQuantity: element.freeQuantity!/element.conversionFactor!.toDouble(),
        fReceiptId: _receiptNumber+receiptNumberStartValue,
        rItemDiscount: element.discount,
        freeQuantity: element.freeQuantity,
        rItemName: element.name,
        rItemPrice: element.price,
        rItemQuantity: element.quantity,
      ));
    });
    update();
  }

  calculateNetReceipt() async {
    if (_accountName == 'العميل' || waitingItemsList.isEmpty) {
      Get.snackbar(
        'خطأ',
        'الرجاء اكمال بيانات الفاتورة بشكل صحيح',
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.GROUNDED,
      );
    } else {
      ///calculate net receipt
      setNetReceipt = ((_total + _addition) - _totalDiscount + _tax);

      ///calculate new balance of the account
      setBalanceAfter =
          receiptAccount.currentBalance! + netReceipt - cashPayment;

      //_balanceBefore = receiptAccount.currentBalance;
      // double newBalance = receiptAccount.currentBalance! +
      //     double.parse(_netReceipt) -
      //     double.parse(_cashPayment);
      ///update account balance in the database
      await DatabaseHelper.db
          .updateAccBalance(balanceAfter, receiptAccount.accId as int);
      //   setBalanceAfter = newBalance.toString();
      /// update items quantities in database
      waitingItemsList.forEach((element) {
        DatabaseHelper.db.decreaseItemQuantity(
            (element.quantity! + double.parse(element.freeQuantity.toString()))*element.conversionFactor!,
            element.itemNumber);
      });

      /// set rest of receipt
      setRest = setRest = netReceipt - cashPayment;

      /// insert the new receipt into the database
      showBalanceAfterReceipt = true;
      addNewReceipt(ReceiptModel(
          fAccountId: receiptAccount.accId,
          startDate: startDate,
          startTime: startTime,
          saveDate:intl.DateFormat('yyyy-MM-dd').format(DateTime.now()) ,
          saveTime: intl.DateFormat('kk:mm').format(DateTime.now()),
          total: total,
          discount: totalDiscount,
          addition: addition,
          tax: tax,
          cashPayment: cashPayment,
          bankPayment: bankPayment,
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

  double _freeItemsCount = 0;

  double get freeItemsCount => _freeItemsCount;

  set setFreeItemsCount(double value) {
    _freeItemsCount = value;
  }

  updateItemCount() {
    _itemsCount = 0;
    waitingItemsList.forEach((element) {
      _itemsCount += element.quantity!.toDouble();
    });
  }

  updateFreeItemCount() {
    setFreeItemsCount = 0;
    waitingItemsList.forEach((element) {
      _freeItemsCount += element.freeQuantity!.toDouble();
    });
  }

  getItemByBarcode() async {
    List<ItemModel> result = [];
    var options = ScanOptions(useCamera: -1);
    var scanResult = await BarcodeScanner.scan(options: options);
    if (scanResult.rawContent.isNotEmpty) {
      result = await DatabaseHelper.db.findItemByBarcode(scanResult.rawContent);
      print(scanResult.rawContent);
      print(result[0].itemBarcode);
      try {
        addToWaitingItems(result[0]);
      } catch (e) {
        Get.snackbar(e.toString(), e.toString());
      }
      getItemByBarcode();
    } else if (scanResult.rawContent.isEmpty) {
      updateItemCount();
      calculateTotal();
      updateNetReceipt();
      return;
    }
    updateItemCount();
    calculateTotal();
    updateNetReceipt();
  }

  removeSelectedItems() {
    waitingItemsList.removeWhere((element) => selectedItems.contains(element));
    calculateTotal();
    updateItemCount();
    updateNetReceipt();
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

  setReceiptNumber() async {
    List<ReceiptModel> allReceipts;
    allReceipts = await DatabaseHelper.db.getAllReceipts();
    print((allReceipts.length + 1).toString() +
        'asadasdasdasdasdasdasd898989asdasdasd');
    _receiptNumber = allReceipts.length + 1;
    update();
  }

  addToSelectedItems(WaitingItemsModel model) {
    selectedItems.add(model);
    update();
  }

  itemIsAdding(int index, WaitingItemsModel model, bool isAdding) {
    isAdding
        ? addToSelectedItems(waitingItemsList[index])
        : removeFromSelectedItems(waitingItemsList[index]);
    update();
  }

  removeFromSelectedItems(WaitingItemsModel model) {
    selectedItems.remove(model);
    update();
  }

  addToWaitingItems(ItemModel item) {
    // waitingItemsList.forEach((element) async {
    //   if (element.id == item.itemId && element.id != null) {
    //     element.quantity = int.parse(element.quantity.toString()) + 1;
    //     updateItemCount();
    //     update();
    //     return;
    //   }
    // });
    waitingItemsList.add(WaitingItemsModel(
        quantityTextController: TextEditingController(text: '1'),
        discountTextController: TextEditingController(text: '0'),
        freeQuantity: 0,
        itemNumber: item.itemNumber,
        unitName: item.unitName,
        conversionFactor: item.conversionFactor,
        id: item.itemId,
        name: item.itemName,
        price: item.sellingPrice,
        discount: 0,
        quantity: 1,
        freeQuantityTextController: TextEditingController(text: '0')));

    updateItemCount();
    updateFreeItemCount();

    calculateTotal();
    updateNetReceipt();

    update();
  }

  itemQuantityOnTap(int index) {
    waitingItemsList[index].quantityTextController.selection = TextSelection(
        baseOffset: 0,
        extentOffset:
            waitingItemsList[index].quantityTextController.value.text.length);
  }

  itemFreeQuantityOnTap(int index) {
    waitingItemsList[index].freeQuantityTextController.selection =
        TextSelection(
            baseOffset: 0,
            extentOffset: waitingItemsList[index]
                .freeQuantityTextController
                .value
                .text
                .length);
  }

  itemQuantityOnChanged(value, int index) {
    waitingItemsList[index].quantity = double.parse(value);
    waitingItemsList[index].value =
        waitingItemsList[index].quantity!.toDouble() *
            waitingItemsList[index].price!.toDouble();
    calculateTotal();
    updateNetReceipt();
    updateItemCount();
  }

  itemFreeQuantityOnChanged(value, int index) {
    waitingItemsList[index].freeQuantity = double.parse(value);
    updateFreeItemCount();
  }

  itemQuantityOnSubmitted(value, index) {
    if (waitingItemsList[index].quantityTextController.text.isEmpty ||
        waitingItemsList[index].quantityTextController.text == 0.toString()) {
      waitingItemsList[index].quantityTextController.text = '1';
      waitingItemsList[index].quantity = 1;

      waitingItemsList[index].value =
          waitingItemsList[index].quantity!.toDouble() *
              waitingItemsList[index].price!.toDouble();
      calculateTotal();
      updateItemCount();
    }
    updateNetReceipt();
  }

  itemFreeQuantityOnSubmitted(value, index) {
    if (waitingItemsList[index].freeQuantityTextController.text.isEmpty ||
        double.parse(waitingItemsList[index].freeQuantityTextController.text) <
            0) {
      waitingItemsList[index].freeQuantityTextController.text = '0';
      waitingItemsList[index].freeQuantity = 0;

      updateFreeItemCount();
    }
    update();
  }

  searchForAccount() async {
    await Hive.openBox(constBoxName);
    if(constBox.get(startValueName)!=null){
      receiptNumberStartValue=constBox.get(startValueName);
    }    var dbHelper = DatabaseHelper.db;
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
                            4: pw.FlexColumnWidth(4),
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
                                  pw.Text('الكمية المجانيه',
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
                                    pw.Text(
                                        waitingItemsList[i]
                                            .freeQuantity
                                            .toString(),
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

  set setWaitingItemsList( value){
    waitingItemsList.value =  value;
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

  double get addition => _addition;

  set setAddition(double value) {
    _addition = value;
  }

  double get tax => _tax;

  set setTax(double value) {
    _tax = value;
  }

  double get cashPayment => _cashPayment;

  set setCashPayment(double value) {
    _cashPayment = value;
  }

  double get bankPayment => _bankPayment;

  double get rest => _rest;

  set setBankPayment(double value) {
    _bankPayment = value;
  }

  set setRest(double value) {
    _rest = value;
  }

  String get saveTime => _saveTime;

  set setSaveTime(String value) {
    _saveTime = value;
  }
}

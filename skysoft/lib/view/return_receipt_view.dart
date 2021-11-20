import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart' as intl;
import 'package:skysoft/constants.dart';
import 'package:skysoft/core/%20services/database_helper.dart';
import 'package:skysoft/core/view_model/add_account_view_model.dart';
import 'package:skysoft/core/view_model/add_item_view_model.dart';
import 'package:skysoft/core/view_model/home_view_model.dart';
import 'package:skysoft/core/view_model/receipt_view_model.dart';
import 'package:skysoft/core/view_model/return_receipt_view_model.dart';
import 'package:skysoft/models/account_model.dart';
import 'package:skysoft/models/waiting_items.dart';
import 'package:skysoft/view/home_view.dart';
import 'package:skysoft/view/search_account_return_receipt.dart';
import 'package:skysoft/view/search_account_view.dart';
import 'package:skysoft/view/search_item_return_receipt.dart';
import 'package:skysoft/view/search_item_view.dart';
import 'package:sqflite/sqflite.dart';
class ReturnReceiptView extends GetWidget<ReturnReceiptViewModel> {

  @override
  Widget build(BuildContext context) {
    Get.find<ReturnReceiptViewModel>();
    //  print(data);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth,
      height: screenHeight,
      child: LayoutBuilder(
        builder: (context, constrains) {
          double height = constrains.maxHeight;
          double width = constrains.maxWidth;
          return WillPopScope (

            onWillPop: ()async{
              //  controller.enabled=true;
              // controller.waitingItemsList.clear();
              controller.resetAll();
              Get.back();
              return false;},

            child: Scaffold(
              backgroundColor: Colors.white,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          // Align(
                          //   alignment: Alignment.bottomLeft,
                          //   child: Text(
                          //     'فاتورة مبيعات',
                          //     style: labelsTextStyle,
                          //   ),
                          // ),
                          Container(
                            height: height * 0.09,
                            width: width,
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            color: Colors.blueGrey,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.blueGrey.shade100),
                                    child: Row(
                                      textBaseline: TextBaseline.alphabetic,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          controller.accountName,
                                          style: TextStyle(
                                              fontFamily: 'Tajawal',
                                              fontWeight: FontWeight.bold,
                                              fontSize: ScreenUtil().setSp(30),
                                              color: Colors.black54),
                                        ),
                                        GetBuilder<ReturnReceiptViewModel>(
                                          builder: (controller) => IconButton(
                                              onPressed: controller.enabled
                                                  ? () {
                                                Get.to(SearchAccountReturnReceiptView());
                                              }
                                                  : null,
                                              icon: Icon(
                                                Icons.search,
                                                color: controller.enabled
                                                    ? Colors.limeAccent
                                                    : Colors.black26,
                                                size: 20,
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.06,
                                  ),
                                  Text(
                                    'التاريخ   :  ',
                                    style: labelsInReceiptRowsStyle(),
                                  ),
                                  Text(
                                    '${controller.startDate}',
                                    style: rowItemTextStyle(),
                                  ),
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  Text(
                                    'الوقت   :  ',
                                    style: labelsInReceiptRowsStyle(),
                                  ),
                                  Text(
                                    '${controller.startTime}',
                                    style: rowItemTextStyle(),
                                  ),
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  Align(
                                      alignment: Alignment.bottomLeft,
                                  child:  Text(
                                      'فاتورة مردود',
                                      style: TextStyle(
                                          color: Colors.redAccent,
                                          fontFamily: 'Tajawal',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Container(
                            height: height * 0.09,
                            width: width,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            color: Colors.blueGrey,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  GetBuilder<ReturnReceiptViewModel>(
                                      builder: (controller2) {
                                        return Row(
                                          children: [
                                            Text(
                                              'عدد القطع : ',
                                              style: labelsInReceiptRowsStyle(),
                                            ),
                                            Text(
                                              controller2.itemsCount.toStringAsFixed(3) ,
                                              style: rowItemTextStyle(),
                                            ),
                                            SizedBox(width: width*0.03,),
                                            Text(
                                              'عدد القطع المجانيه : ',
                                              style: labelsInReceiptRowsStyle(),
                                            ),
                                            Text(
                                              controller2.freeItemsCount.toStringAsFixed(3) ,
                                              style: rowItemTextStyle(),
                                            ),
                                            SizedBox(
                                              width: width * 0.03,
                                            ),
                                            Text(
                                              'رقم الفاتورة   :  ',
                                              style: labelsInReceiptRowsStyle(),
                                            ),
                                            Text(
                                              '${controller.receiptNumber}',
                                              style: rowItemTextStyle(),
                                            ),
                                          ],
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Container(
                            width: width * 0.99,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    GetBuilder<ReturnReceiptViewModel>(
                                      builder: (controller) => GestureDetector(
                                          onTap: controller.enabled
                                              ? () async {
                                            controller.setItemsSearchResultList= await  DatabaseHelper.db.getAllItems();
                                            controller.itemSearchQuery='';
                                            Get.dialog(SearchItemReturnReceiptView());
                                          }
                                              : null,
                                          child: Icon(
                                            Icons.add_box,
                                            size: 35,
                                            color: controller.enabled
                                                ? Colors.blue
                                                : Colors.grey,
                                          )),
                                    ),
                                    GetBuilder<ReturnReceiptViewModel>(
                                      builder: (controller) => GestureDetector(
                                          onTap: controller.enabled
                                              ? () => controller.getItemByBarcode()
                                              : null,
                                          child: Icon(
                                            Icons.qr_code_scanner,
                                            size: 35,
                                            color: controller.enabled
                                                ? Colors.blue
                                                : Colors.grey,
                                          )),
                                    ),
                                    GetBuilder<ReturnReceiptViewModel>(
                                      builder: (controller) => GestureDetector(
                                        onTap: controller.enabled
                                            ? () {
                                          controller.removeSelectedItems();

                                        }
                                            : null,
                                        child: Container(
                                          width: width * 0.05,
                                          child: Icon(
                                            Icons.delete,
                                            size: 35,
                                            color: controller.enabled
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GetBuilder<ReturnReceiptViewModel>(
                                      builder: (controller) => GestureDetector(
                                        onTap: controller.enabled
                                            ? () {
                                          controller.calculateNetReceipt();
                                        }
                                            : null,
                                        child: Container(
                                          width: width * 0.05,
                                          child: Icon(
                                            Icons.save_outlined,
                                            size: 35,
                                            color: controller.enabled
                                                ? Colors.deepPurple
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    GetBuilder<ReturnReceiptViewModel>(
                                      builder: (controller) =>
                                      ! controller.enabled
                                          ? GestureDetector(
                                        onTap: () {
                                          controller.generatePDF();
                                        },
                                        child: Container(
                                          width: width * 0.05,
                                          child: Icon(
                                            Icons.receipt_long,
                                            size: 35,
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                      )
                                          : SizedBox(),
                                    ),
                                    GetBuilder<ReturnReceiptViewModel>(
                                      builder: (controller) =>
                                      ! controller.enabled
                                          ? GestureDetector(
                                        onTap: () {
                                          Get.offAll(HomeView());
                                        },
                                        child: Container(
                                          width: width * 0.05,
                                          child: Icon(
                                            Icons.exit_to_app,
                                            size: 35,
                                            color: Colors.black,
                                          ),
                                        ),
                                      )
                                          : SizedBox(),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: height * 0.4,
                                  width: width * 0.9,
                                  child: GetBuilder<ReturnReceiptViewModel>(
                                    builder: (controller) =>
                                        SingleChildScrollView(
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Container(
                                              width: width * .92,
                                              child: DataTable(
                                                  showCheckboxColumn:
                                                  controller.enabled,
                                                  dividerThickness: 1,
                                                  dataRowHeight: height * 0.07,
                                                  headingRowHeight: height * 0.07,
                                                  columnSpacing: width * 0.04,
                                                  headingRowColor:
                                                  MaterialStateColor.resolveWith(
                                                          (states) {
                                                        return Colors.red;
                                                      }),
                                                  columns: [
                                                    DataColumn(
                                                      label: Text(
                                                        'الرقم',
                                                        style: rowItemTextStyle(),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                        'الصنف',
                                                        style: rowItemTextStyle(),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                        'الكمية',
                                                        style: rowItemTextStyle(),
                                                      ),
                                                    ),

                                                    DataColumn(
                                                      label: Text(
                                                        'السعر',
                                                        style: rowItemTextStyle(),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                        'الخصم',
                                                        style: rowItemTextStyle(),
                                                      ),
                                                    ),
                                                    DataColumn(
                                                      label: Text(
                                                        'القيمه',
                                                        style: rowItemTextStyle(),
                                                      ),
                                                    ),

                                                    DataColumn(
                                                      label: Text(
                                                        'ك مجانية',
                                                        style: rowItemTextStyle(),
                                                      ),
                                                    ),
                                                  ],
                                                  rows: List<DataRow>.generate(
                                                    controller
                                                        .waitingItemsList.length,
                                                        (index) {
                                                      var quantityController =
                                                      TextEditingController(
                                                          text: '1');

                                                      return DataRow(
                                                          selected: controller
                                                              .selectedItems
                                                              .contains(controller
                                                              .waitingItemsList[
                                                          index]),
                                                          onSelectChanged:
                                                              (isSelected) {
                                                            final isAdding =
                                                                isSelected != null &&
                                                                    isSelected;
                                                            controller.itemIsAdding(
                                                                index,
                                                                controller
                                                                    .waitingItemsList[
                                                                index],
                                                                isAdding);
                                                          },
                                                          color: MaterialStateProperty
                                                              .resolveWith<Color>(
                                                                  (Set<MaterialState>
                                                              states) {
                                                                // Even rows will have a grey color.
                                                                if (index % 2 == 0)
                                                                  return Colors
                                                                      .grey.shade50;
                                                                return Colors.grey
                                                                    .shade300; // Use default value for other states and odd rows.
                                                              }),
                                                          cells: [
                                                            DataCell(Text(
                                                              ///رقم الصنف
                                                              controller
                                                                  .waitingItemsList[
                                                              index]
                                                                  .id
                                                                  .toString(),
                                                              style:
                                                              rowItemElementTextStyle(),
                                                            )),
                                                            DataCell(Text(
                                                              ///الاسم
                                                              controller
                                                                  .waitingItemsList[
                                                              index]
                                                                  .name
                                                                  .toString(),
                                                              style:
                                                              rowItemElementTextStyle(),
                                                            )),
                                                            DataCell(TextFormField(

                                                                inputFormatters:[
                                                                  LengthLimitingTextInputFormatter(8),
                                                                ],
                                                                enabled: controller.enabled,
                                                                controller: controller.waitingItemsList[index].quantityTextController,
                                                                onTap: () => controller.itemQuantityOnTap(index),
                                                                ///الكميه
                                                                style: TextStyle(
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(35)),
                                                                // inputFormatters: [
                                                                //   FilteringTextInputFormatter
                                                                //       .digitsOnly
                                                                // ],
                                                                onFieldSubmitted:(value)=>controller.itemQuantityOnSubmitted(value, index),
                                                                onChanged:(value)=>controller.itemQuantityOnChanged(value, index) ,
                                                                // initialValue: controller
                                                                //     .waitingItemsList[
                                                                // index]
                                                                //     .quantity
                                                                //     .toString(),
                                                                keyboardType:
                                                                TextInputType.number,
                                                                autofocus: false)),
                                                            DataCell(Text(
                                                              controller
                                                                  .waitingItemsList[
                                                              index]
                                                                  .price!
                                                                  .toStringAsFixed(3),
                                                              style:
                                                              rowItemElementTextStyle(),
                                                            )),/// السعر
                                                            DataCell(TextFormField(
                                                              enabled:
                                                              controller.enabled,

                                                              /// الخصم
                                                              keyboardType:
                                                              TextInputType
                                                                  .number,
                                                              onFieldSubmitted:
                                                                  (value) {
                                                                if (controller
                                                                    .waitingItemsList[
                                                                index]
                                                                    .discountTextController
                                                                    .text
                                                                    .isEmpty) {
                                                                  controller
                                                                      .waitingItemsList[
                                                                  index]
                                                                      .discountTextController
                                                                      .text = '0';
                                                                  controller
                                                                      .waitingItemsList[
                                                                  index]
                                                                      .discount = 0;
                                                                  controller
                                                                      .waitingItemsList[
                                                                  index]
                                                                      .value = controller
                                                                      .waitingItemsList[
                                                                  index]
                                                                      .quantity!
                                                                      .toDouble() *
                                                                      controller
                                                                          .waitingItemsList[
                                                                      index]
                                                                          .price!
                                                                          .toDouble() -
                                                                      controller
                                                                          .waitingItemsList[
                                                                      index]
                                                                          .discount!
                                                                          .toDouble();
                                                                  // controller.update();
                                                                  controller
                                                                      .calculateTotal();
                                                                }
                                                                controller.updateNetReceipt();

                                                              },
                                                              controller: controller
                                                                  .waitingItemsList[
                                                              index]
                                                                  .discountTextController,
                                                              onTap: () => controller
                                                                  .waitingItemsList[
                                                              index]
                                                                  .discountTextController
                                                                  .selection =
                                                                  TextSelection(
                                                                      baseOffset: 0,
                                                                      extentOffset: controller
                                                                          .waitingItemsList[
                                                                      index]
                                                                          .discountTextController
                                                                          .value
                                                                          .text
                                                                          .length),
                                                              onChanged: (value) {
                                                                controller
                                                                    .waitingItemsList[
                                                                index]
                                                                    .discount =
                                                                    double.parse(
                                                                        value);
                                                                controller
                                                                    .waitingItemsList[
                                                                index]
                                                                    .value = controller
                                                                    .waitingItemsList[
                                                                index]
                                                                    .quantity!
                                                                    .toDouble() *
                                                                    controller
                                                                        .waitingItemsList[
                                                                    index]
                                                                        .price!
                                                                        .toDouble() -
                                                                    controller
                                                                        .waitingItemsList[
                                                                    index]
                                                                        .discount!
                                                                        .toDouble();
                                                                // controller.update();
                                                                controller
                                                                    .calculateTotal();
                                                                controller.updateNetReceipt();

                                                              },
                                                            )),

                                                            DataCell(Text(controller

                                                            ///القيمه
                                                                .waitingItemsList[
                                                            index]
                                                                .value!
                                                                .toStringAsFixed(3))),
                                                            DataCell(TextFormField(

                                                                inputFormatters:[
                                                                  LengthLimitingTextInputFormatter(8),
                                                                ],                                                            enabled: controller
                                                                .enabled,
                                                                controller: controller
                                                                    .waitingItemsList[
                                                                index]
                                                                    .freeQuantityTextController,
                                                                onTap:
                                                                    () => controller.itemFreeQuantityOnTap(index),
                                                                onFieldSubmitted:
                                                                    (value)=>controller.itemFreeQuantityOnSubmitted(value, index),
                                                                onChanged:
                                                                    (value) =>controller.itemFreeQuantityOnChanged(value, index),
                                                                ///الكميه
                                                                style: TextStyle(
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(35)),
                                                                // inputFormatters: [
                                                                //   FilteringTextInputFormatter
                                                                //       .digitsOnly
                                                                // ],

                                                                // initialValue: controller
                                                                //     .waitingItemsList[
                                                                // index]
                                                                //     .quantity
                                                                //     .toString(),
                                                                keyboardType:
                                                                TextInputType.numberWithOptions(decimal: false),
                                                                autofocus: false)),

                                                          ]);
                                                    },
                                                  ).toList()),
                                            ),
                                          ),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.1,
                          ),
                          Container(
                            width: width,
                            padding: EdgeInsets.all(5),
                            child: Container(
                              width: width,
                              alignment: Alignment.center,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: GetBuilder<ReturnReceiptViewModel>(
                                  builder: (controller) => DataTable(
                                      dividerThickness: 2,
                                      dataRowHeight: height * 0.07,
                                      headingRowHeight: height * 0.07,
                                      columnSpacing: width * 0.02,
                                      headingRowColor:
                                      MaterialStateColor.resolveWith(
                                              (states) => Colors.blueGrey),
                                      columns: [
                                        DataColumn(
                                          label: Container(
                                            alignment: Alignment.center,
                                            color: controller.receiptAccount.currentBalance!>0?edgesSelectorAColor:edgesSelectorBColor,
                                            child: Text(
                                              'رص سابق',
                                              style: rowItemTextStyle(),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'ج الفاتورة',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'خصم',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'اضافة',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'ضريبة',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Container(
                                            alignment: Alignment.center,
                                            color: selectorColor,
                                            child: Text(
                                              'ص الفاتورة',
                                              style: rowItemTextStyle(),
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'س نقدي',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'الباقي',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Container(
                                            alignment: Alignment.center,

                                            color: controller.rest>=0?edgesSelectorAColor:edgesSelectorBColor,
                                            child: Text(
                                              'رص حالي',
                                              style: rowItemTextStyle(),
                                            ),
                                          ),
                                        ),
                                      ],
                                      rows: List<DataRow>.generate(
                                        1,
                                            (index) => DataRow(
                                            color: MaterialStateProperty
                                                .resolveWith<Color>(
                                                    (Set<MaterialState> states) {
                                                  // Even rows will have a grey color.
                                                  if (index % 2 == 0)
                                                    return Colors.grey.shade50;
                                                  return Colors.grey
                                                      .shade300; // Use default value for other states and odd rows.
                                                }),
                                            cells: [
                                              DataCell(Container(
                                                color: controller.receiptAccount.currentBalance!>0?edgesSelectorAColor:edgesSelectorBColor,
                                                child: Text(
                                                  ///الرصيد قبل الفاتورة
                                                  controller.balanceBefore
                                                      .toStringAsFixed(3),
                                                  style: rowItemTextStyle(),
                                                ),
                                              )),
                                              DataCell(Text(
                                                ///اجمالي الفاتورة
                                                controller.total.toStringAsFixed(3),
                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(TextFormField(
                                                keyboardType: TextInputType.number,
                                                onFieldSubmitted: (value) {
                                                  if (controller
                                                      .totalDiscountController
                                                      .text
                                                      .isEmpty) {
                                                    controller
                                                        .totalDiscountController
                                                        .text = '0';
                                                    controller.setTotalDiscount =
                                                        double.parse(value);
                                                  }
                                                  controller.updateNetReceipt();

                                                },
                                                enabled: controller.enabled,

                                                /// خصم
                                                controller: controller
                                                    .totalDiscountController,
                                                onTap: () => controller
                                                    .totalDiscountController
                                                    .selection =
                                                    TextSelection(
                                                        baseOffset: 0,
                                                        extentOffset: controller
                                                            .totalDiscountController
                                                            .value
                                                            .text
                                                            .length),
                                                onChanged: (value) {
                                                  controller.setTotalDiscount =
                                                      double.parse(value);
                                                  controller.updateNetReceipt();

                                                },

                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(TextFormField(
                                                keyboardType: TextInputType.number,

                                                onFieldSubmitted: (value) {
                                                  if (controller
                                                      .totalAdditionController
                                                      .text
                                                      .isEmpty) {
                                                    controller
                                                        .totalAdditionController
                                                        .text = '0';
                                                    controller.setAddition =
                                                        double.parse(value);
                                                  }
                                                  controller.updateNetReceipt();

                                                },
                                                controller: controller
                                                    .totalAdditionController,
                                                onTap: () => controller
                                                    .totalAdditionController
                                                    .selection =
                                                    TextSelection(
                                                        baseOffset: 0,
                                                        extentOffset: controller
                                                            .totalAdditionController
                                                            .value
                                                            .text
                                                            .length),
                                                enabled: controller.enabled,

                                                /// اضافي

                                                onChanged: (value) {
                                                  controller.setAddition =
                                                      double.parse(value);
                                                  controller.updateNetReceipt();


                                                },

                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(TextFormField(
                                                keyboardType: TextInputType.number,

                                                onFieldSubmitted: (value) {
                                                  if (controller
                                                      .totalTaxController
                                                      .text
                                                      .isEmpty) {
                                                    controller.totalTaxController
                                                        .text = '0';
                                                    controller.setTax =                                                    double.parse(value);
                                                    double.parse(value);

                                                  }
                                                  controller.updateNetReceipt();

                                                },
                                                controller:
                                                controller.totalTaxController,
                                                onTap: () => controller
                                                    .totalTaxController
                                                    .selection =
                                                    TextSelection(
                                                        baseOffset: 0,
                                                        extentOffset: controller
                                                            .totalTaxController
                                                            .value
                                                            .text
                                                            .length),
                                                enabled: controller.enabled,

                                                /// ضريبة
                                                onChanged: (value) {
                                                  controller.setTax =
                                                      double.parse(value);
                                                  controller.updateNetReceipt();

                                                },

                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                ///صافي
                                                controller.netReceipt.toStringAsFixed(3),
                                                style: TextStyle(
                                                    fontSize:
                                                    ScreenUtil().setSp(30),
                                                    backgroundColor:
                                                    selectorColor,
                                                    color: Colors.white),
                                              )),
                                              DataCell(TextFormField(
                                                keyboardType: TextInputType.number,

                                                onFieldSubmitted: (value) {
                                                  if (controller
                                                      .cashPaymentController
                                                      .text
                                                      .isEmpty) {
                                                    controller
                                                        .cashPaymentController
                                                        .text = '0';
                                                    controller.setCashPayment =
                                                        double.parse(value);
                                                  }
                                                  controller.updateNetReceipt();

                                                },
                                                controller: controller
                                                    .cashPaymentController,
                                                onTap: () => controller
                                                    .cashPaymentController
                                                    .selection =
                                                    TextSelection(
                                                        baseOffset: 0,
                                                        extentOffset: controller
                                                            .cashPaymentController
                                                            .value
                                                            .text
                                                            .length),

                                                enabled: controller.enabled,

                                                /// سداد نقدي
                                                onChanged: (value) {
                                                  controller.setCashPayment =
                                                      double.parse(value);
                                                  controller.updateNetReceipt();


                                                },

                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                ///الباقي
                                                controller.rest.toStringAsFixed(3),
                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(Container(
                                                color: controller.rest>=0?edgesSelectorAColor:edgesSelectorBColor,

                                                child: Text(
                                                  ///رصيد بعد الفاتورة
                                                  controller.balanceAfter
                                                      .toStringAsFixed(3)
                                                  ,
                                                  style: rowItemTextStyle(),
                                                ),
                                              )),
                                            ]),
                                      ).toList()),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

//
//
//
// Text(
// 'اجمالي الفاتورة',
// style: rowItemTextStyle(),
// ),
// Text(
// 'خصم',
// style: rowItemTextStyle(),
// ),
// Text(
// 'اضافة',
// style: rowItemTextStyle(),
// ),
// Text(
// 'ضريبه',
// style: rowItemTextStyle(),
// ),
// Text(
// 'سداد نقدي',
// style: rowItemTextStyle(),
// ),
// Text(
// 'سداد بنك',
// style: rowItemTextStyle(),
// ),
// Text(
// 'الباقي',
// style: rowItemTextStyle(),
// )

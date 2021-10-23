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
import 'package:skysoft/core/view_model/previous_receipts_view_model.dart';
import 'package:skysoft/core/view_model/receipt_view_model.dart';
import 'package:skysoft/models/account_model.dart';
import 'package:skysoft/models/receipt_model.dart';
import 'package:skysoft/view/home_view.dart';
import 'package:skysoft/view/previous_receipts_view.dart';
import 'package:skysoft/view/receipt_view.dart';
import 'package:skysoft/view/search_account_view.dart';
import 'package:skysoft/view/search_item_view.dart';
import 'package:sqflite/sqflite.dart';

class ReceiptDetailsView extends GetWidget<PreviousReceiptsViewModel> {
  ReceiptModel receiptModel;
  AccountModel account;

  ReceiptDetailsView({required this.receiptModel, required this.account});

  @override
  Widget build(BuildContext context) {
    Get.find<PreviousReceiptsViewModel>();
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
          return WillPopScope(
            onWillPop: () async {
              //  controller.enabled=true;
              // controller.waitingItemsList.clear();
              controller.resetAll();

              Get.back();
              return false;
            },
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
                              child: GetBuilder<PreviousReceiptsViewModel>(
                                builder: (controller) {
                                  controller.setAccount = account;
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 5),
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
                                              controller.account.name
                                                  .toString(),
                                              style: TextStyle(
                                                  fontFamily: 'Tajawal',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      ScreenUtil().setSp(30),
                                                  color: Colors.black54),
                                            ),
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
                                        controller.returnReceiptFlag
                                            ? controller.date
                                            : receiptModel.date.toString(),
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
                                        controller.returnReceiptFlag
                                            ? controller.time
                                            : receiptModel.time.toString(),
                                        style: rowItemTextStyle(),
                                      ),
                                      SizedBox(
                                        width: width * 0.1,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          controller.returnReceiptFlag
                                              ? 'فاتورة مردود'
                                              : (receiptModel.type == 'sales'
                                                  ? 'فاتورة مبيعات'
                                                  : 'فاتورة مردود'),
                                          style: TextStyle(
                                              color: Colors.limeAccent,
                                              fontFamily: 'Tajawal',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25),
                                        ),
                                      ),
                                    ],
                                  );
                                },
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  SizedBox(
                                    width: width * 0.03,
                                  ),
                                  GetBuilder<PreviousReceiptsViewModel>(
                                    builder: (controller) => Row(
                                      children: [
                                        Text(
                                          controller.returnReceiptFlag
                                              ? 'عدد القطع المردوده : '
                                              : 'عدد القطع : ',
                                          style: labelsInReceiptRowsStyle(),
                                        ),
                                        Text(
                                          (controller.itemsCount +
                                                  controller.freeItemsCount)
                                              .toString(),
                                          style: rowItemTextStyle(),
                                        ),
                                        SizedBox(
                                          width: width * 0.1,
                                        ),
                                        Text(
                                          !controller.returnReceiptFlag
                                              ? 'فاتورة سابقة'
                                              : 'فاتورة مردود جديده',
                                          style: labelsInReceiptRowsStyle(
                                              color: Colors.amber),
                                        ),
                                        SizedBox(
                                          width: width * 0.1,
                                        ),
                                        Text(
                                          'رقم الفاتورة   :  ',
                                          style: labelsInReceiptRowsStyle(),
                                        ),
                                        Text(
                                          controller.returnReceiptFlag
                                              ? controller.receiptNumber
                                                  .toString()
                                              : receiptModel.receiptId
                                                  .toString(),
                                          style: rowItemTextStyle(),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Container(
                            width: width * 0.98,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    receiptModel.type == 'sales'
                                        ? GetBuilder<PreviousReceiptsViewModel>(
                                            builder: (controller) =>
                                                GestureDetector(
                                                    onTap: () {
                                                      !controller
                                                              .returnReceiptFlag
                                                          ? Get.defaultDialog(
                                                              title:
                                                                  'نوع المرتجع',
                                                              content: Column(
                                                                children: [
                                                                  defaultButton(
                                                                      function:
                                                                          () async {
                                                                        controller
                                                                            .startReturnReceipt();
                                                                        controller.couldReturn?
                                                                        Get.back():(){};
                                                                      },
                                                                      width:
                                                                          width *
                                                                              0.4,
                                                                      height:
                                                                          height *
                                                                              0.08,
                                                                      text:
                                                                          'مرتجع جزئي'),
                                                                  SizedBox(
                                                                    height:
                                                                        height *
                                                                            0.02,
                                                                  ),
                                                                  defaultButton(
                                                                      function:
                                                                          () async {
                                                                        controller
                                                                            .startReturnReceipt();

                                                                        if (!controller
                                                                            .couldReturn) {
                                                                          return;
                                                                        }

                                                                        await controller
                                                                            .startFullReturn();
                                                                        //  Get.back();
                                                                        //    Duration(seconds: 5);
                                                                        //   controller.getReceipts();
                                                                        // controller.update();
                                                                        //   Get.to(PreviousReceiptsView());
                                                                      },
                                                                      width:
                                                                          width *
                                                                              0.4,
                                                                      height:
                                                                          height *
                                                                              0.08,
                                                                      text:
                                                                          'مرتجع الفاتورة بالكامل'),
                                                                  SizedBox(
                                                                    height:
                                                                        height *
                                                                            0.02,
                                                                  ),
                                                                  defaultButton(
                                                                      function: () {
                                                                        controller
                                                                            .startReturnReceipt();
                                                                        controller.couldReturn?

                                                                         controller
                                                                              .startFullReturnAndFillNewReceipt():print(controller.couldReturn);
                                                                      },
                                                                      width:
                                                                          width *
                                                                              0.4,
                                                                      height:
                                                                          height *
                                                                              0.11,
                                                                      text:
                                                                          'مرتجع الفاتورة\nوعمل فاتورة جديده'),
                                                                  SizedBox(
                                                                    height:
                                                                        height *
                                                                            0.02,
                                                                  ),
                                                                  defaultButton(
                                                                      function:
                                                                          () => Get
                                                                              .back(),
                                                                      width:
                                                                          width *
                                                                              0.4,
                                                                      height:
                                                                          height *
                                                                              0.08,
                                                                      text:
                                                                          'اغلاق'),
                                                                ],
                                                              ))
                                                          : controller
                                                                  .setReturnReceiptFlag =
                                                              !controller
                                                                  .returnReceiptFlag;
                                                      controller.update();
                                                      // !controller
                                                      //         .returnReceiptFlag
                                                      //     ? controller
                                                      //         .startReturnRe
                                                      //         ceipt()
                                                      //     : controller
                                                      //             .setReturnReceiptFlag =
                                                      //         !controller
                                                      //             .returnReceiptFlag;
                                                      // controller.update();
                                                    },
                                                    child: controller
                                                            .enableCalculateReceipt
                                                        ? Column(
                                                            children: [
                                                              Icon(
                                                                !controller
                                                                        .returnReceiptFlag
                                                                    ? Icons.redo
                                                                    : Icons
                                                                        .undo,
                                                                size: 35,
                                                                color: !controller
                                                                        .returnReceiptFlag
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors
                                                                        .red,
                                                              ),
                                                              Text(
                                                                controller
                                                                        .returnReceiptFlag
                                                                    ? 'تراجع'
                                                                    : 'فاتورة\nمرتجع',
                                                                style: labelsInReceiptRowsStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18),
                                                              )
                                                            ],
                                                          )
                                                        : SizedBox()),
                                          )
                                        : SizedBox(),
                                    GetBuilder<PreviousReceiptsViewModel>(
                                        builder: (controller) =>
                                            controller.returnReceiptFlag
                                                ? GestureDetector(
                                                    onTap: () {
                                                      controller
                                                              .enableCalculateReceipt
                                                          ? controller
                                                              .calculateNetReceipt()
                                                          : null;
                                                    },
                                                    child: Container(
                                                      width: width * 0.05,
                                                      child: Icon(
                                                        Icons.save_outlined,
                                                        size: 35,
                                                        color: controller
                                                                .enableCalculateReceipt
                                                            ? Colors.blue
                                                            : Colors.grey,
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox()),
                                    GetBuilder<PreviousReceiptsViewModel>(
                                        builder: (controller) =>
                                            GestureDetector(
                                              onTap: () {
                                                controller.receiptCalculated
                                                    ? controller.generatePDF()
                                                    : controller
                                                        .openExistReceipt(
                                                            receiptModel
                                                                .receiptId
                                                                .toString());
                                              },
                                              child: Container(
                                                width: width * 0.05,
                                                child: Icon(
                                                  Icons.receipt_long,
                                                  size: 35,
                                                  color: Colors.deepPurple,
                                                ),
                                              ),
                                            )),
                                    GetBuilder<PreviousReceiptsViewModel>(
                                      builder: (controller) =>
                                          controller.netReceipt != '0'
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
                                  height: height * 0.45,
                                  width: width * 0.92,
                                  child: GetBuilder<PreviousReceiptsViewModel>(
                                    builder: (controller) =>
                                        SingleChildScrollView(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Form(
                                          key: controller.tableFormKey,
                                          child: Container(
                                            width: width * 0.97,
                                            child: DataTable(
                                                showCheckboxColumn: true,
                                                dividerThickness: 1,
                                                dataRowHeight: height * 0.08,
                                                headingRowHeight: height * 0.07,
                                                columnSpacing: width * 0.02,
                                                headingRowColor:
                                                    MaterialStateColor
                                                        .resolveWith((states) =>
                                                            Colors
                                                                .red.shade400),
                                                columns: [
                                                  DataColumn(
                                                    label: Text(
                                                      'رقم',
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
                                                      'كمية',
                                                      style: rowItemTextStyle(),
                                                    ),
                                                  ),

                                                  DataColumn(
                                                    label: Text(
                                                      'سعر',
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
                                                      'قيمه',
                                                      style: rowItemTextStyle(),
                                                    ),
                                                  ),
                                                  DataColumn(
                                                    label: Text(
                                                      'ك مجانيه',
                                                      style: rowItemTextStyle(),
                                                    ),
                                                  ),

                                                  controller.returnReceiptFlag
                                                      ? DataColumn(
                                                          label: Text(
                                                            'متبقي',
                                                            style:
                                                                rowItemTextStyle(),
                                                          ),
                                                        )
                                                      : DataColumn(
                                                          label: SizedBox()),
                                                  controller.returnReceiptFlag
                                                      ? DataColumn(
                                                          label: Text(
                                                            'متبقي مجاني',
                                                            style:
                                                                rowItemTextStyle(),
                                                          ),
                                                        )
                                                      : DataColumn(
                                                          label: SizedBox()),
                                                ],
                                                rows: List<DataRow>.generate(
                                                  controller
                                                      .receiptItems.length,
                                                  (index) {
                                                    return DataRow(
                                                        // selected: controller
                                                        //     .selectedItems
                                                        //     .contains(controller
                                                        //     .waitingItemsList[
                                                        // index]),
                                                        // onSelectChanged:
                                                        //     (isSelected) {
                                                        //   final isAdding =
                                                        //       isSelected !=
                                                        //           null &&
                                                        //           isSelected;
                                                        //   controller.itemIsAdding(
                                                        //       index,
                                                        //       controller
                                                        //           .waitingItemsList[
                                                        //       index],
                                                        //       isAdding);
                                                        // },
                                                        color: MaterialStateProperty
                                                            .resolveWith<
                                                                Color>((Set<
                                                                    MaterialState>
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
                                                                .receiptItems[
                                                                    index]
                                                                .id
                                                                .toString(),
                                                            style:
                                                                rowItemElementTextStyle(),
                                                          )),
                                                          DataCell(Text(
                                                            ///الاسم
                                                            controller
                                                                .receiptItems[
                                                                    index]
                                                                .name
                                                                .toString(),
                                                            style:
                                                                rowItemElementTextStyle(),
                                                          )),
                                                          DataCell(controller
                                                                  .returnReceiptFlag
                                                              ? TextFormField(
                                                                  enabled: controller.enableCalculateReceipt &&
                                                                      controller
                                                                          .returnReceiptFlag,
                                                                  controller: controller
                                                                      .receiptItems[
                                                                          index]
                                                                      .quantityTextController,
                                                                  onTap: () => controller
                                                                      .itemQuantityOnTap(
                                                                          index),

                                                                  ///الكميه
                                                                  style: TextStyle(
                                                                      fontSize: ScreenUtil().setSp(
                                                                          35)),
                                                                  inputFormatters: [
                                                                    LengthLimitingTextInputFormatter(
                                                                        8),
                                                                  ],
                                                                  onFieldSubmitted: (value) =>
                                                                      controller.itemQuantityOnSubmitted(
                                                                          value, index),
                                                                  onChanged: (value) =>
                                                                      controller.itemQuantityOnChanged(
                                                                          value,
                                                                          index),
                                                                  // initialValue: controller
                                                                  //     .waitingItemsList[
                                                                  // index]
                                                                  //     .quantity
                                                                  //     .toString(),
                                                                  keyboardType:
                                                                      TextInputType.numberWithOptions(decimal: false),
                                                                  autofocus: false)
                                                              : Text(controller.receiptItems[index].quantity.toString())),

                                                          //     TextFormField(
                                                          //     enabled: controller.enabled,
                                                          //     controller: controller.waitingItemsList[index].quantityTextController,
                                                          //     onTap: () =>
                                                          //     controller.waitingItemsList[index].quantityTextController.selection =
                                                          //         TextSelection(
                                                          //             baseOffset:
                                                          //             0,
                                                          //             extentOffset: controller.waitingItemsList[index].quantityTextController
                                                          //                 .value
                                                          //                 .text
                                                          //                 .length),
                                                          //
                                                          //     ///الكميه
                                                          //     style: TextStyle(
                                                          //         fontSize: ScreenUtil()
                                                          //             .setSp(35)),
                                                          //     inputFormatters: [
                                                          //       FilteringTextInputFormatter
                                                          //           .digitsOnly
                                                          //     ],onFieldSubmitted:  (value){
                                                          //   if(controller.waitingItemsList[index].quantityTextController.text.isEmpty){
                                                          //     controller.waitingItemsList[index].quantityTextController.text='1';
                                                          //     controller.waitingItemsList[index].quantity=1;
                                                          //
                                                          //     controller
                                                          //         .waitingItemsList[
                                                          //     index]
                                                          //         .value = controller
                                                          //         .waitingItemsList[
                                                          //     index]
                                                          //         .quantity!
                                                          //         .toDouble() *
                                                          //         controller
                                                          //             .waitingItemsList[
                                                          //         index]
                                                          //             .price!
                                                          //             .toDouble();
                                                          //     controller
                                                          //         .calculateTotal();
                                                          //     controller
                                                          //         .updateItemCount();
                                                          //   }
                                                          // },
                                                          //     onChanged: (value) {
                                                          //       controller
                                                          //           .waitingItemsList[
                                                          //       index]
                                                          //           .quantity =
                                                          //           int.parse(
                                                          //               value);
                                                          //       controller
                                                          //           .waitingItemsList[
                                                          //       index]
                                                          //           .value = controller
                                                          //           .waitingItemsList[
                                                          //       index]
                                                          //           .quantity!
                                                          //           .toDouble() *
                                                          //           controller
                                                          //               .waitingItemsList[
                                                          //           index]
                                                          //               .price!
                                                          //               .toDouble();
                                                          //       controller
                                                          //           .calculateTotal();
                                                          //       controller
                                                          //           .updateItemCount();
                                                          //     },
                                                          //     // initialValue: controller
                                                          //     //     .waitingItemsList[
                                                          //     // index]
                                                          //     //     .quantity
                                                          //     //     .toString(),
                                                          //     keyboardType:
                                                          //     TextInputType.numberWithOptions(
                                                          //         decimal:
                                                          //         false),
                                                          //     autofocus: false)),
                                                          DataCell(Text(
                                                            controller
                                                                .receiptItems[
                                                                    index]
                                                                .price!
                                                                .toStringAsFixed(
                                                                    3),
                                                            style:
                                                                rowItemElementTextStyle(),
                                                          )),
                                                          DataCell(
                                                              TextFormField(
                                                                enabled: controller
                                                                    .enableCalculateReceipt &&
                                                                    controller
                                                                        .returnReceiptFlag,

                                                                /// الخصم
                                                                keyboardType:
                                                                TextInputType
                                                                    .number,
                                                                onFieldSubmitted:
                                                                    (value) {
                                                                  if (controller
                                                                      .receiptItems[
                                                                  index]
                                                                      .discountTextController
                                                                      .text
                                                                      .isEmpty) {
                                                                    controller
                                                                        .receiptItems[
                                                                    index]
                                                                        .discountTextController
                                                                        .text = '0';
                                                                    controller
                                                                        .receiptItems[
                                                                    index]
                                                                        .discount = 0;
                                                                    controller
                                                                        .receiptItems[
                                                                    index]
                                                                        .value = controller
                                                                        .receiptItems[
                                                                    index]
                                                                        .quantity!
                                                                        .toDouble() *
                                                                        controller
                                                                            .receiptItems[
                                                                        index]
                                                                            .price!
                                                                            .toDouble() -
                                                                        controller
                                                                            .receiptItems[
                                                                        index]
                                                                            .discount!
                                                                            .toDouble();
                                                                    // controller.update();
                                                                    controller
                                                                        .calculateTotal();
                                                                  }
                                                                  controller
                                                                      .updateNetReceipt();
                                                                },
                                                                controller: controller
                                                                    .receiptItems[
                                                                index]
                                                                    .discountTextController,
                                                                onTap: () => controller
                                                                    .receiptItems[
                                                                index]
                                                                    .discountTextController
                                                                    .selection =
                                                                    TextSelection(
                                                                        baseOffset:
                                                                        0,
                                                                        extentOffset: controller
                                                                            .receiptItems[
                                                                        index]
                                                                            .discountTextController
                                                                            .value
                                                                            .text
                                                                            .length),
                                                                onChanged: (value) {
                                                                  controller
                                                                      .receiptItems[
                                                                  index]
                                                                      .discount =
                                                                      double.parse(
                                                                          value);
                                                                  controller
                                                                      .receiptItems[
                                                                  index]
                                                                      .value = controller
                                                                      .receiptItems[
                                                                  index]
                                                                      .quantity!
                                                                      .toDouble() *
                                                                      controller
                                                                          .receiptItems[
                                                                      index]
                                                                          .price!
                                                                          .toDouble() -
                                                                      controller
                                                                          .receiptItems[
                                                                      index]
                                                                          .discount!
                                                                          .toDouble();
                                                                  // controller.update();
                                                                  controller
                                                                      .calculateTotal();
                                                                  controller
                                                                      .updateNetReceipt();
                                                                },
                                                              )),

                                                          /// القيمة
                                                          DataCell(Text(controller
                                                              .receiptItems[
                                                                  index]
                                                              .value!
                                                              .toStringAsFixed(
                                                                  3))),
                                                          DataCell(controller
                                                              .returnReceiptFlag
                                                              ? TextFormField(
                                                              enabled: controller.enableCalculateReceipt &&
                                                                  controller
                                                                      .returnReceiptFlag,
                                                              controller: controller
                                                                  .receiptItems[
                                                              index]
                                                                  .freeQuantityTextController,
                                                              onTap: () => controller
                                                                  .itemFreeQuantityOnTap(
                                                                  index),

                                                              ///الكمية المجانية
                                                              style: TextStyle(
                                                                  fontSize: ScreenUtil().setSp(
                                                                      35)),
                                                              inputFormatters: [
                                                                LengthLimitingTextInputFormatter(
                                                                    8),
                                                              ],
                                                              onFieldSubmitted: (value) =>
                                                                  controller.itemFreeQuantityOnSubmitted(
                                                                      value, index),
                                                              onChanged: (value) =>
                                                                  controller.itemFreeQuantityOnChanged(
                                                                      value,
                                                                      index),
                                                              // initialValue: controller
                                                              //     .waitingItemsList[
                                                              // index]
                                                              //     .quantity
                                                              //     .toString(),
                                                              keyboardType:
                                                              TextInputType.numberWithOptions(decimal: false),
                                                              autofocus: false)
                                                              : Text(controller.receiptItems[index].freeQuantity.toString())),


                                                          controller
                                                                  .returnReceiptFlag
                                                              ? DataCell(Text(
                                                                  ///متبقي لم يرد

                                                                  (controller.receiptItems[index].maxReturnQuantity! -
                                                                          double.parse(controller
                                                                              .receiptItems[
                                                                                  index]
                                                                              .quantity
                                                                              .toString()))
                                                                      .toStringAsFixed(
                                                                          3),
                                                                  style:
                                                                      rowItemElementTextStyle(),
                                                                ))
                                                              : DataCell(
                                                                  SizedBox()),
                                                          controller
                                                                  .returnReceiptFlag
                                                              ? DataCell(Text(
                                                                  ///متبقي مجاني

                                                                  (controller.receiptItems[index].maxFreeReturnQuantity! -
                                                                          double.parse(controller
                                                                              .receiptItems[
                                                                                  index]
                                                                              .freeQuantity
                                                                              .toString()))
                                                                      .toStringAsFixed(
                                                                          3),
                                                                  style:
                                                                      rowItemElementTextStyle(),
                                                                ))
                                                              : DataCell(
                                                                  SizedBox())
                                                          // TextFormField(
                                                          //   enabled:
                                                          //       controller.enabled,
                                                          //
                                                          //   /// الخصم
                                                          //   keyboardType:
                                                          //       TextInputType
                                                          //           .number,
                                                          //   onFieldSubmitted:
                                                          //       (value) {
                                                          //     if (controller
                                                          //         .waitingItemsList[
                                                          //             index]
                                                          //         .discountTextController
                                                          //         .text
                                                          //         .isEmpty) {
                                                          //       controller
                                                          //           .waitingItemsList[
                                                          //               index]
                                                          //           .discountTextController
                                                          //           .text = '0';
                                                          //       controller
                                                          //           .waitingItemsList[
                                                          //               index]
                                                          //           .discount = 0;
                                                          //       controller
                                                          //           .waitingItemsList[
                                                          //               index]
                                                          //           .value = controller
                                                          //                   .waitingItemsList[
                                                          //                       index]
                                                          //                   .quantity!
                                                          //                   .toDouble() *
                                                          //               controller
                                                          //                   .waitingItemsList[
                                                          //                       index]
                                                          //                   .price!
                                                          //                   .toDouble() -
                                                          //           controller
                                                          //               .waitingItemsList[
                                                          //                   index]
                                                          //               .discount!
                                                          //               .toDouble();
                                                          //       // controller.update();
                                                          //       controller
                                                          //           .calculateTotal();
                                                          //     }
                                                          //   },
                                                          //   controller: controller
                                                          //       .waitingItemsList[
                                                          //           index]
                                                          //       .discountTextController,
                                                          //   onTap: () => controller
                                                          //           .waitingItemsList[
                                                          //               index]
                                                          //           .discountTextController
                                                          //           .selection =
                                                          //       TextSelection(
                                                          //           baseOffset: 0,
                                                          //           extentOffset: controller
                                                          //               .waitingItemsList[
                                                          //                   index]
                                                          //               .discountTextController
                                                          //               .value
                                                          //               .text
                                                          //               .length),
                                                          //   onChanged: (value) {
                                                          //     controller
                                                          //             .waitingItemsList[
                                                          //                 index]
                                                          //             .discount =
                                                          //         double.parse(
                                                          //             value);
                                                          //     controller
                                                          //         .waitingItemsList[
                                                          //             index]
                                                          //         .value = controller
                                                          //                 .waitingItemsList[
                                                          //                     index]
                                                          //                 .quantity!
                                                          //                 .toDouble() *
                                                          //             controller
                                                          //                 .waitingItemsList[
                                                          //                     index]
                                                          //                 .price!
                                                          //                 .toDouble() -
                                                          //         controller
                                                          //             .waitingItemsList[
                                                          //                 index]
                                                          //             .discount!
                                                          //             .toDouble();
                                                          //     // controller.update();
                                                          //     controller
                                                          //         .calculateTotal();
                                                          //   },
                                                          // )),
                                                        ]);
                                                  },
                                                ).toList()),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.05,
                          ),
                          Container(
                            width: width,
                            padding: EdgeInsets.all(5),
                            child: Container(
                              width: width,
                              alignment: Alignment.center,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: GetBuilder<PreviousReceiptsViewModel>(
                                  builder: (controller) => Container(
                                    child: DataTable(
                                        dividerThickness: 2,
                                        dataRowHeight: height * 0.07,
                                        headingRowHeight: height * 0.07,
                                        columnSpacing: width * 0.02,
                                        headingRowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.blueGrey),
                                        columns: [
                                          DataColumn(
                                            label: !controller.returnReceiptFlag
                                                ? SizedBox()
                                                : Container(
                                                    alignment: Alignment.center,
                                                    color: account
                                                                .currentBalance! >
                                                            0
                                                        ? edgesSelectorAColor
                                                        : edgesSelectorBColor,
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
                                              color: selectorColor,
                                              child: Text(
                                                'ص الفاتورة',
                                                style: rowItemTextStyle(),
                                              ),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'سداد نقدي',
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
                                            label: !controller.returnReceiptFlag
                                                ? SizedBox()
                                                : Container(
                                                    alignment: Alignment.center,
                                                    color: controller.balanceAfter < 0
                                                        ? edgesSelectorBColor
                                                        : edgesSelectorAColor,
                                                    child: Text(
                                                      'رص الحالي',
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
                                                      (Set<MaterialState>
                                                          states) {
                                                // Even rows will have a grey color.
                                                if (index % 2 == 0)
                                                  return Colors.grey.shade50;
                                                return Colors.grey
                                                    .shade300; // Use default value for other states and odd rows.
                                              }),
                                              cells: [
                                                DataCell(!controller
                                                        .returnReceiptFlag
                                                    ? SizedBox()
                                                    : Container(
                                                        color: account
                                                                    .currentBalance! >
                                                                0
                                                            ? edgesSelectorAColor
                                                            : edgesSelectorBColor,
                                                        child: Text(
                                                          ///رص قبل
                                                          account
                                                              .currentBalance!
                                                              .toStringAsFixed(
                                                                  3),
                                                          style:
                                                              rowItemTextStyle(),
                                                        ),
                                                      )),
                                                DataCell(Text(
                                                  ///اجمالي الفاتورة
                                                  controller.returnReceiptFlag
                                                      ? controller.total
                                                          .toStringAsFixed(3)
                                                      : receiptModel.total!
                                                          .toStringAsFixed(3),
                                                  style:
                                                      rowItemElementTextStyle(),
                                                )),
                                                DataCell(!controller
                                                        .returnReceiptFlag
                                                    ? Text(
                                                        receiptModel.discount!
                                                            .toStringAsFixed(3),
                                                        style:
                                                            rowItemElementTextStyle(),
                                                      )
                                                    : TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        onFieldSubmitted:
                                                            (value) {
                                                          if (controller
                                                              .totalDiscountController
                                                              .text
                                                              .isEmpty) {
                                                            controller
                                                                .totalDiscountController
                                                                .text = '0';
                                                            controller
                                                                    .setTotalDiscount =
                                                                value;
                                                          }
                                                          controller
                                                              .updateNetReceipt();
                                                        },
                                                        enabled: controller
                                                            .enableCalculateReceipt,

                                                        /// خصم
                                                        controller: controller
                                                            .totalDiscountController,
                                                        onTap: () => controller
                                                                .totalDiscountController
                                                                .selection =
                                                            TextSelection(
                                                                baseOffset: 0,
                                                                extentOffset:
                                                                    controller
                                                                        .totalDiscountController
                                                                        .value
                                                                        .text
                                                                        .length),
                                                        onChanged: (value) {
                                                          controller
                                                                  .setTotalDiscount =
                                                              value.toString();
                                                          controller
                                                              .updateNetReceipt();
                                                        },

                                                        style:
                                                            rowItemElementTextStyle(),
                                                      )),
                                                // TextFormField(
                                                //   onFieldSubmitted: (value) {
                                                //     if (controller
                                                //         .totalDiscountController
                                                //         .text
                                                //         .isEmpty) {
                                                //       controller
                                                //           .totalDiscountController
                                                //           .text = '0';
                                                //       controller.setTotalDiscount =
                                                //           value;
                                                //     }
                                                //   },
                                                //   enabled: controller.enabled,
                                                //
                                                //   /// خصم
                                                //   controller: controller
                                                //       .totalDiscountController,
                                                //   onTap: () => controller
                                                //       .totalDiscountController
                                                //       .selection =
                                                //       TextSelection(
                                                //           baseOffset: 0,
                                                //           extentOffset: controller
                                                //               .totalDiscountController
                                                //               .value
                                                //               .text
                                                //               .length),
                                                //   onChanged: (value) {
                                                //     controller.setTotalDiscount =
                                                //         value.toString();
                                                //   },
                                                //
                                                //   style: rowItemElementTextStyle(),
                                                // )
                                                DataCell(!controller
                                                        .returnReceiptFlag
                                                    ? Text(
                                                        ///اضافي
                                                        receiptModel.addition!
                                                            .toStringAsFixed(3),
                                                        style:
                                                            rowItemElementTextStyle(),
                                                      )
                                                    : TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,

                                                        onFieldSubmitted:
                                                            (value) {
                                                          if (controller
                                                              .totalAdditionController
                                                              .text
                                                              .isEmpty) {
                                                            controller
                                                                .totalAdditionController
                                                                .text = '0';
                                                            controller
                                                                    .setAddition =
                                                                value;
                                                          }
                                                          controller
                                                              .updateNetReceipt();
                                                        },
                                                        controller: controller
                                                            .totalAdditionController,
                                                        onTap: () => controller
                                                                .totalAdditionController
                                                                .selection =
                                                            TextSelection(
                                                                baseOffset: 0,
                                                                extentOffset:
                                                                    controller
                                                                        .totalAdditionController
                                                                        .value
                                                                        .text
                                                                        .length),
                                                        enabled: controller
                                                            .enableCalculateReceipt,

                                                        /// اضافي

                                                        onChanged: (value) {
                                                          controller
                                                                  .setAddition =
                                                              value.toString();
                                                          controller
                                                              .updateNetReceipt();
                                                        },

                                                        style:
                                                            rowItemElementTextStyle(),
                                                      )),
                                                DataCell(!controller
                                                        .returnReceiptFlag
                                                    ? Text(
                                                        ///ضريبه
                                                        receiptModel.tax!
                                                            .toStringAsFixed(3),
                                                        style:
                                                            rowItemElementTextStyle(),
                                                      )
                                                    : TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,

                                                        onFieldSubmitted:
                                                            (value) {
                                                          if (controller
                                                              .totalTaxController
                                                              .text
                                                              .isEmpty) {
                                                            controller
                                                                .totalTaxController
                                                                .text = '0';
                                                            controller.setTax =
                                                                value;
                                                          }
                                                          controller
                                                              .updateNetReceipt();
                                                        },
                                                        controller: controller
                                                            .totalTaxController,
                                                        onTap: () => controller
                                                                .totalTaxController
                                                                .selection =
                                                            TextSelection(
                                                                baseOffset: 0,
                                                                extentOffset:
                                                                    controller
                                                                        .totalTaxController
                                                                        .value
                                                                        .text
                                                                        .length),
                                                        enabled: controller
                                                            .enableCalculateReceipt,

                                                        /// ضريبة
                                                        onChanged: (value) {
                                                          controller.setTax =
                                                              value.toString();
                                                          controller
                                                              .updateNetReceipt();
                                                        },

                                                        style:
                                                            rowItemElementTextStyle(),
                                                      )),
                                                DataCell(Text(
                                                  ///صافي
                                                  controller.returnReceiptFlag
                                                      ? controller.netReceipt
                                                          .toStringAsFixed(3)
                                                      : receiptModel.netReceipt!
                                                          .toStringAsFixed(3),
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(30),
                                                      backgroundColor:
                                                          selectorColor,
                                                      color: Colors.white),
                                                )),
                                                DataCell(!controller
                                                        .returnReceiptFlag
                                                    ? Text(
                                                        ///سداد
                                                        receiptModel
                                                            .cashPayment!
                                                            .toStringAsFixed(3),
                                                        style:
                                                            rowItemElementTextStyle(),
                                                      )
                                                    : TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,

                                                        onFieldSubmitted:
                                                            (value) {
                                                          if (controller
                                                              .cashPaymentController
                                                              .text
                                                              .isEmpty) {
                                                            controller
                                                                .cashPaymentController
                                                                .text = '0';
                                                            controller
                                                                    .setCashPayment =
                                                                double.parse(
                                                                    value);
                                                          }
                                                          controller
                                                              .updateNetReceipt();
                                                        },
                                                        controller: controller
                                                            .cashPaymentController,
                                                        onTap: () => controller
                                                                .cashPaymentController
                                                                .selection =
                                                            TextSelection(
                                                                baseOffset: 0,
                                                                extentOffset:
                                                                    controller
                                                                        .cashPaymentController
                                                                        .value
                                                                        .text
                                                                        .length),

                                                        enabled: controller
                                                            .enableCalculateReceipt,

                                                        /// سداد نقدي
                                                        onChanged: (value) {
                                                          controller
                                                                  .setCashPayment =
                                                              double.parse(
                                                                  value);
                                                          controller
                                                              .updateNetReceipt();
                                                        },

                                                        style:
                                                            rowItemElementTextStyle(),
                                                      )),
                                                DataCell(Text(
                                                  ///الباقي
                                                  controller.returnReceiptFlag
                                                      ? controller.rest
                                                          .toStringAsFixed(3)
                                                      : receiptModel.rest!
                                                          .toStringAsFixed(3),
                                                  style:
                                                      rowItemElementTextStyle(),
                                                )),
                                                DataCell(!controller
                                                        .returnReceiptFlag
                                                    ? SizedBox()
                                                    : Container(
                                                        color: controller.balanceAfter <
                                                                0
                                                            ? edgesSelectorBColor
                                                            : edgesSelectorAColor,
                                                        child: Text(
                                                          ///رصيد بعد الفاتورة
                                                          controller
                                                              .balanceAfter
                                                              .toStringAsFixed(
                                                                  3),
                                                          style:
                                                              rowItemTextStyle(),
                                                        ),
                                                      )),
                                              ]),
                                        ).toList()),
                                  ),
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

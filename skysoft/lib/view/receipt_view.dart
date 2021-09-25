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
import 'package:skysoft/view/home_view.dart';
import 'package:skysoft/view/search_account_view.dart';
import 'package:skysoft/view/search_item_view.dart';
import 'package:sqflite/sqflite.dart';

class ReceiptView extends GetWidget<ReceiptViewModel> {
  @override
  Widget build(BuildContext context) {
    Get.find<ReceiptViewModel>();
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
          return Scaffold(
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
                                      GetBuilder<ReceiptViewModel>(
                                        builder: (controller) => IconButton(
                                            onPressed: controller.enabled
                                                ? () {
                                                    Get.to(SearchAccountView());
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
                                  '${controller.date}',
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
                                  '${controller.time}',
                                  style: rowItemTextStyle(),
                                ),
                                SizedBox(
                                  width: width * 0.03,
                                ),
                                Align(
                                    alignment: Alignment.bottomLeft,
                                    child: GetBuilder<ReceiptViewModel>(
                                      builder:(controller)=> DropdownButton<String>(

                                  dropdownColor: Colors.blueGrey,
                                        icon: Icon(Icons.arrow_drop_down,color: Colors.limeAccent,),
                                        items: controller.receiptTypes,
                                        // onChanged: (value) {
                                        //  controller.receiptType=value;
                                        //   controller.update();
                                        // },
                                        value: controller.receiptType,
                                      ),
                                    )
                                    //Text(
                                    //   'فاتورة مبيعات',
                                    //   style: TextStyle(
                                    //       color: Colors.limeAccent,
                                    //       fontFamily: 'Tajawal',
                                    //       fontWeight: FontWeight.bold,
                                    //       fontSize: 25),
                                    // ),
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
                                GetBuilder<ReceiptViewModel>(
                                    builder: (controller2) {
                                  return Row(
                                    children: [
                                      Text(
                                        'عدد القطع : ',
                                        style: labelsInReceiptRowsStyle(),
                                      ),
                                      Text(
                                        controller2.itemsCount.toString(),
                                        style: rowItemTextStyle(),
                                      ),
                                      SizedBox(
                                        width: width * 0.3,
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
                                  GetBuilder<ReceiptViewModel>(
                                    builder: (controller) => GestureDetector(
                                        onTap: controller.enabled
                                            ? () => Get.dialog(SearchItemView())
                                            : null,
                                        child: Icon(
                                          Icons.add_box,
                                          size: 35,
                                          color: controller.enabled
                                              ? Colors.blue
                                              : Colors.grey,
                                        )),
                                  ),
                                  GetBuilder<ReceiptViewModel>(
                                    builder: (controller) => GestureDetector(
                                      onTap: controller.enabled
                                          ? () {
                                              controller.removeSelectedItems();
                                              controller.update();
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
                                  GetBuilder<ReceiptViewModel>(
                                    builder: (controller) => GestureDetector(
                                      onTap: controller.enabled
                                          ? () {
                                              controller.calculateNetReceipt();
                                            }
                                          : null,
                                      child: Container(
                                        width: width * 0.05,
                                        child: Icon(
                                          Icons.calculate,
                                          size: 35,
                                          color: controller.enabled
                                              ? Colors.orange
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GetBuilder<ReceiptViewModel>(
                                    builder: (controller) =>
                                        controller.netReceipt != '0'
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
                                  GetBuilder<ReceiptViewModel>(
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
                                height: height * 0.4,
                                width: width * 0.9,
                                child: GetBuilder<ReceiptViewModel>(
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
                                                      return controller.receiptType=='sales'? Colors.lightGreen:Colors.red;
                                                    }),
                                            columns: [
                                              DataColumn(
                                                label: Text(
                                                  'رقم الصنف',
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
                                                  'القيمه',
                                                  style: rowItemTextStyle(),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'الخصم',
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

                                                          enabled: controller
                                                              .enabled,
                                                          controller: controller
                                                              .waitingItemsList[
                                                                  index]
                                                              .quantityTextController,
                                                          onTap: () => controller
                                                                  .waitingItemsList[
                                                                      index]
                                                                  .quantityTextController
                                                                  .selection =
                                                              TextSelection(
                                                                  baseOffset: 0,
                                                                  extentOffset: controller
                                                                      .waitingItemsList[
                                                                          index]
                                                                      .quantityTextController
                                                                      .value
                                                                      .text
                                                                      .length),

                                                          ///الكميه
                                                          style: TextStyle(
                                                              fontSize: ScreenUtil()
                                                                  .setSp(35)),
                                                          inputFormatters: [
                                                            FilteringTextInputFormatter
                                                                .digitsOnly
                                                          ],
                                                          onFieldSubmitted:
                                                              (value) {
                                                            if (controller
                                                                .waitingItemsList[
                                                                    index]
                                                                .quantityTextController
                                                                .text
                                                                .isEmpty||controller
                                                                .waitingItemsList[
                                                            index]
                                                                .quantityTextController.text ==0.toString()) {
                                                              controller
                                                                  .waitingItemsList[
                                                                      index]
                                                                  .quantityTextController
                                                                  .text = '1';
                                                              controller
                                                                  .waitingItemsList[
                                                                      index]
                                                                  .quantity = 1;

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
                                                                      .toDouble();
                                                              controller
                                                                  .calculateTotal();
                                                              controller
                                                                  .updateItemCount();
                                                            }
                                                            controller.updateNetReceipt();

                                                              },
                                                          onChanged: (value) {
                                                            controller
                                                                    .waitingItemsList[
                                                                        index]
                                                                    .quantity =
                                                                int.parse(
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
                                                                    .toDouble();
                                                            controller
                                                                .calculateTotal();
                                                            controller.updateNetReceipt();
                                                            controller
                                                                .updateItemCount();
                                                          },
                                                          // initialValue: controller
                                                          //     .waitingItemsList[
                                                          // index]
                                                          //     .quantity
                                                          //     .toString(),
                                                          keyboardType:
                                                              TextInputType.numberWithOptions(decimal: false),
                                                          autofocus: false)),
                                                      DataCell(Text(
                                                        controller
                                                            .waitingItemsList[
                                                                index]
                                                            .price
                                                            .toString(),
                                                        style:
                                                            rowItemElementTextStyle(),
                                                      )),

                                                      /// السعر
                                                      DataCell(Text(controller

                                                          ///القيمه
                                                          .waitingItemsList[
                                                              index]
                                                          .value
                                                          .toString())),
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
                              child: GetBuilder<ReceiptViewModel>(
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
                                        label: Text(
                                          'الرصيد السابق',
                                          style: rowItemTextStyle(),
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
                                          color: Colors.lightGreen,
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
                                        label: Text(
                                          'الرصيد الحالي',
                                          style: rowItemTextStyle(),
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
                                            DataCell(Text(
                                              ///الرصيد قبل الفاتورة
                                              controller.balanceBefore
                                                  .toString(),
                                              style: rowItemElementTextStyle(),
                                            )),
                                            DataCell(Text(
                                              ///اجمالي الفاتورة
                                              controller.total.toString(),
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
                                                      value;
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
                                                    value.toString();
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
                                                      value;
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
                                                    value.toString();                                                            controller.updateNetReceipt();
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
                                                  controller.setTax = value;
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
                                                    value.toString();
                                                controller.updateNetReceipt();

                                              },

                                              style: rowItemElementTextStyle(),
                                            )),
                                            DataCell(Text(
                                              ///صافي
                                              controller.netReceipt.toString(),
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(30),
                                                  backgroundColor:
                                                      Colors.lightGreen,
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
                                                      value;
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
                                                    value.toString();                                                            controller.updateNetReceipt();
                                                controller.updateNetReceipt();


                                              },

                                              style: rowItemElementTextStyle(),
                                            )),
                                            DataCell(Text(
                                              ///الباقي
                                              controller.rest.toString(),
                                              style: rowItemElementTextStyle(),
                                            )),
                                            DataCell(Text(
                                              ///رصيد بعد الفاتورة
                                              controller.balanceAfter
                                                      .toString()
                                                  ,
                                              style: rowItemElementTextStyle(),
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

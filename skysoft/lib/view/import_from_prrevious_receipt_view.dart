import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:skysoft/core/%20services/database_helper.dart';
import 'package:skysoft/core/view_model/previous_receipts_view_model.dart';
import 'package:skysoft/core/view_model/receipt_view_model.dart';
import 'package:skysoft/view/receipt_details_view.dart';

import '../constants.dart';

class ImportFromPreviousReceiptsView
    extends GetWidget<PreviousReceiptsViewModel> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<PreviousReceiptsViewModel>(
        builder: (controller) => Container(
            width: screenWidth,
            height: screenHeight,
            child: LayoutBuilder(
              builder: (context, constrains) {
                double height = constrains.maxHeight;
                double width = constrains.maxWidth;
                return Scaffold(
                    backgroundColor: Colors.white,
                    body: SafeArea(
                      child: controller.loading
                          ? loadingScreen()
                          : Align(
                              alignment: Alignment.topCenter,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: height * 0.03,
                                      ),
                                      Container(
                                        width: width * 0.8,
                                        // padding: EdgeInsets.symmetric(horizontal: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.blueGrey.shade400),
                                        child: TextFormField(
                                          key: controller.searchKey2,
                                          controller:
                                              controller.searchController,
                                          onSaved: (value) {
                                            if (value != null) if (controller
                                                .searchController
                                                .text
                                                .isEmpty) {
                                              controller.getReceipts();
                                              // FocusManager.instance.primaryFocus!.unfocus() ;
                                            } else {
                                              print(value + 'valueeee');
                                              controller
                                                      .setSearchForReceiptWord =
                                                  value;
                                              controller.findReceipts();
                                            }
                                            //  }
                                          },
                                          onFieldSubmitted: (value) {
                                            if (controller.searchController.text
                                                .isEmpty) {
                                              controller.getReceipts();
                                              // FocusManager.instance.primaryFocus!.unfocus() ;
                                            } else {
                                              print(value + 'valueeee');
                                              controller
                                                      .setSearchForReceiptWord =
                                                  value;
                                              controller.findReceipts();
                                            }
                                            //  }
                                          },
                                          // onFieldSubmitted: (v){
                                          //
                                          //   controller.getReceipts();
                                          // },
                                          textAlign: TextAlign.right,
                                          style: labelsInReceiptRowsStyle(
                                              color: Colors.white,
                                              fontSize: 30),
                                          decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                iconSize: 25,
                                                color: Colors.white,
                                                icon: Text(
                                                  'ابحث',
                                                  style:
                                                      labelsInReceiptRowsStyle(
                                                          color: Colors.amber,
                                                          fontSize: 22),
                                                ),
                                                onPressed: () {
                                                  controller
                                                      .searchKey2.currentState!
                                                      .save();
                                                  FocusManager
                                                      .instance.primaryFocus!
                                                      .unfocus();
                                                },
                                              ),
                                              hintStyle: TextStyle(
                                                  fontFamily: 'Tajawal',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                              hintText: "بحث",
                                              prefixIcon: IconButton(
                                                iconSize: 25,
                                                color: Colors.white,
                                                icon: Icon(Icons.search),
                                                onPressed: () {
                                                  controller
                                                      .searchKey2.currentState!
                                                      .save();
                                                  FocusManager
                                                      .instance.primaryFocus!
                                                      .unfocus();
                                                },
                                              ),
                                              border: InputBorder.none),
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.03,
                                      ),
                                      Container(
                                        alignment: Alignment.topCenter,
                                        width: width,
                                        height: height * 0.8,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: controller
                                                    .allReceipts.isEmpty
                                                ? Center(
                                                    child: Text(
                                                      'لا يوجد نتائج',
                                                      style:
                                                          labelsInReceiptRowsStyle(
                                                              color: Colors
                                                                  .black54),
                                                    ),
                                                  )
                                                : DataTable(
                                                    dividerThickness: 1,
                                                    showCheckboxColumn: false,
                                                    dataRowHeight:
                                                        height * 0.09,
                                                    headingRowHeight:
                                                        height * 0.07,
                                                    columnSpacing:
                                                        width * 0.047,
                                                    headingRowColor:
                                                        MaterialStateColor
                                                            .resolveWith(
                                                                (states) => Colors
                                                                    .lightGreen),
                                                    columns: [
                                                      DataColumn(
                                                        label: Text(
                                                          'الرقم',
                                                          style:
                                                              rowItemTextStyle(),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'اسم العميل',
                                                          style:
                                                              rowItemTextStyle(),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'صافي الفاتورة',
                                                          style:
                                                              rowItemTextStyle(),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'التاريخ',
                                                          style:
                                                              rowItemTextStyle(),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'الوقت',
                                                          style:
                                                              rowItemTextStyle(),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'سداد',
                                                          style:
                                                              rowItemTextStyle(),
                                                        ),
                                                      ),
                                                      DataColumn(
                                                        label: Text(
                                                          'نوع الفاتورة',
                                                          style:
                                                              rowItemTextStyle(),
                                                        ),
                                                      ),
                                                    ],
                                                    rows:
                                                        List<DataRow>.generate(
                                                      controller
                                                          .allReceipts.length,
                                                      (index) => DataRow(
                                                          onSelectChanged:
                                                              (s) async {
                                                      await      controller.getReceiptItems(
                                                                int.parse(controller
                                                                    .allReceipts[
                                                                        index]
                                                                    .receiptId
                                                                    .toString()));


                                                            Get.back(
                                                                result: controller
                                                                    .receiptItems);


                                                              },
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
                                                              controller
                                                                  .allReceipts[
                                                                      index]
                                                                  .receiptId //رقم الفاتورة
                                                                  .toString(),
                                                              maxLines: 1,
                                                              style:
                                                                  rowItemElementTextStyle(),
                                                            )),
                                                            DataCell(Text(
                                                              controller.allReceipts
                                                                          .length ==
                                                                      controller
                                                                          .accountsInReceipts
                                                                          .length
                                                                  ? controller
                                                                      .accountsInReceipts[
                                                                          index]
                                                                      .name
                                                                      .toString()
                                                                  : ''
                                                              // اسم العميل
                                                              ,
                                                              style:
                                                                  rowItemElementTextStyle(),
                                                            )),
                                                            DataCell(Text(
                                                              controller
                                                                  .allReceipts[
                                                                      index]
                                                                  .netReceipt! //صافي الفاتورة
                                                                  .toStringAsFixed(
                                                                      3),
                                                              style:
                                                                  rowItemElementTextStyle(),
                                                            )),
                                                            DataCell(Text(
                                                              controller
                                                                      .allReceipts[
                                                                          index]
                                                                      .startDate // تاريخ الفاتورة

                                                                      .toString() +
                                                                  ' ',
                                                              style:
                                                                  rowItemElementTextStyle(),
                                                            )),
                                                            DataCell(Text(
                                                              controller
                                                                  .allReceipts[
                                                                      index]
                                                                  .saveTime // وقت الفاتورة
                                                                  .toString(),
                                                              style:
                                                                  rowItemElementTextStyle(),
                                                            )),
                                                            DataCell(Text(
                                                              controller
                                                                  .allReceipts[
                                                                      index]
                                                                  .cashPayment! // سداد الفاتورة
                                                                  .toStringAsFixed(
                                                                      3),
                                                              style:
                                                                  rowItemElementTextStyle(),
                                                            )),
                                                            DataCell(Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                controller.allReceipts[index]
                                                                            .type // نوع الفاتورة
                                                                            .toString() ==
                                                                        'sales'
                                                                    ? 'مبيعات'
                                                                    : 'مردود',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    rowItemElementTextStyle(),
                                                              ),
                                                            )),
                                                          ]),
                                                    ).toList(),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ));
              },
            )));
  }
}

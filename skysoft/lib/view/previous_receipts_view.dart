import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:skysoft/core/%20services/database_helper.dart';
import 'package:skysoft/core/view_model/previous_receipts_view_model.dart';
import 'package:skysoft/view/receipt_details_view.dart';

import '../constants.dart';

class PreviousReceiptsView extends GetWidget<PreviousReceiptsViewModel> {
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
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: height*0.03,),
                                // Container(
                                //   width: width*0.8,
                                //   // padding: EdgeInsets.symmetric(horizontal: 10),
                                //   decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(20),
                                //       color: Colors.blueGrey.shade400),
                                //   child: TextFormField(
                                //     onChanged: (value){
                                //       // controller.setSearchForReceiptWord=value;
                                //       // controller.getAllReceipts();
                                //     },
                                //     textAlign: TextAlign.right,
                                //     decoration: InputDecoration(
                                //         hintStyle: TextStyle(
                                //             fontFamily: 'Tajawal',
                                //             color: Colors.white,
                                //             fontWeight: FontWeight.bold),
                                //         hintText: "بحث",
                                //         prefixIcon: Icon(
                                //           Icons.search,
                                //           color: Colors.white,
                                //         ),
                                //         border: InputBorder.none),
                                //   ),
                                // ),
                                // SizedBox(height: height*0.03,),

                                SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                        dividerThickness: 1,
                                        showCheckboxColumn: false,
                                        dataRowHeight: height * 0.07,
                                        headingRowHeight: height * 0.07,
                                        columnSpacing: width * 0.04,
                                        headingRowColor:
                                            MaterialStateColor.resolveWith(
                                                (states) => Colors.lightGreen),
                                        columns: [
                                          DataColumn(
                                            label: Text(
                                              'الرقم',
                                              style: rowItemTextStyle(),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'اسم العميل',
                                              style: rowItemTextStyle(),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'صافي الفاتورة',
                                              style: rowItemTextStyle(),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'التاريخ',
                                              style: rowItemTextStyle(),
                                            ),
                                          ),    DataColumn(
                                            label: Text(
                                              'الوقت',
                                              style: rowItemTextStyle(),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'سداد',
                                              style: rowItemTextStyle(),
                                            ),
                                          ), DataColumn(
                                            label: Text(
                                              'نوع الفاتورة',
                                              style: rowItemTextStyle(),
                                            ),
                                          ),
                                        ],
                                        rows: List<DataRow>.generate(
                                          controller.allReceipts.length,
                                          (index) => DataRow(
                                              onSelectChanged:  (s) {
                                                controller.setReturnReceiptFlag=false;

                                                controller.getReceiptItems(
                                                        int.parse(controller
                                                            .allReceipts[index]
                                                            .receiptId
                                                            .toString()));
                                                     Get.to(
                                                        ReceiptDetailsView(
                                                            receiptModel: controller
                                                                .allReceipts[index],
                                                            account: controller
                                                                .accountsInReceipts[
                                                                    index]
                                                                ));
                                                  },
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
                                                  controller.allReceipts[index]
                                                      .receiptId //رقم الفاتورة
                                                      .toString(),
                                                  maxLines: 1,
                                                  style: rowItemElementTextStyle(),
                                                )),
                                                DataCell(Text(
                                                  controller
                                                      .accountsInReceipts[index].name
                                                      .toString()
                                                  // اسم العميل
                                                  ,
                                                  style: rowItemElementTextStyle(),
                                                )),
                                                DataCell(Text(
                                                  controller.allReceipts[index]
                                                      .netReceipt //صافي الفاتورة
                                                      .toString(),
                                                  style: rowItemElementTextStyle(),
                                                )),
                                                DataCell(Text(
                                                  controller.allReceipts[index]
                                                      .date // تاريخ الفاتورة
                                                      .toString(),
                                                  style: rowItemElementTextStyle(),
                                                )),   DataCell(Text(
                                                  controller.allReceipts[index]
                                                      .time // وقت الفاتورة
                                                      .toString(),
                                                  style: rowItemElementTextStyle(),
                                                )),
                                                DataCell(Text(
                                                  controller.allReceipts[index]
                                                      .cashPayment // سداد الفاتورة
                                                      .toString(),
                                                  style: rowItemElementTextStyle(),
                                                )), DataCell(Text(
                                                  controller.allReceipts[index]
                                                      .type // نوع الفاتورة
                                                      .toString()=='sales'?'مبيعات':'مردود',
                                                  style: rowItemElementTextStyle(),
                                                )),
                                              ]),
                                        ).toList()),
                                  ),
                                )
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

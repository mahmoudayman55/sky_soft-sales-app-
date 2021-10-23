import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:skysoft/constants.dart';
import 'package:get/get.dart';
import 'package:skysoft/core/%20services/database_helper.dart';
import 'package:skysoft/core/view_model/add_account_view_model.dart';
import 'package:skysoft/core/view_model/home_view_model.dart';
import 'package:skysoft/core/view_model/receipt_view_model.dart';
import 'package:skysoft/core/view_model/return_receipt_view_model.dart';
import 'package:skysoft/view/receipt_view.dart';
import 'package:skysoft/view/return_receipt_view.dart';
import 'package:sqflite/sqflite.dart';



class SearchAccountReturnReceiptView extends GetWidget<ReturnReceiptViewModel> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<ReturnReceiptViewModel>(
        builder: (controller) {
          return Container(
              width: screenWidth,
              height: screenHeight,
              child: LayoutBuilder(
                builder: (context, constrains) {
                  double height = constrains.maxHeight;
                  double width = constrains.maxWidth;
                  return Scaffold(
                      body: SafeArea(
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Container(
                              alignment: Alignment.topCenter,

                              child: SingleChildScrollView(child:    Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [

                                      Container(
                                        alignment: Alignment.center,
                                        width: width*0.8,
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Colors.blueGrey.shade400),
                                        child: TextFormField(
                                          textAlign: TextAlign.right,
                                          onChanged: (value){controller.accountSearchQuery=value.toString();
                                          controller.searchForAccount();
                                          },
                                          decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                  fontFamily: 'Tajawal',
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                              hintText: "بحث",
                                              prefixIcon: Icon(
                                                Icons.search,
                                                color: Colors.white,
                                              ),
                                              border: InputBorder.none),
                                        ),

                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.03,
                                  ),
                                  GetBuilder<ReturnReceiptViewModel>(
                                    builder:(controller){

                                      return SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: DataTable(
                                            showCheckboxColumn: false,

                                            dividerThickness: 1,
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
                                                  'الاسم',
                                                  style: rowItemTextStyle(),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'الباركود',
                                                  style: rowItemTextStyle(),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'كود العميل',
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
                                                  'الرصيد الحالي',
                                                  style: rowItemTextStyle(),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'اقصي مديونية',
                                                  style: rowItemTextStyle(),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'def Employ Acc ID',
                                                  style: rowItemTextStyle(),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'رقم السعر',
                                                  style: rowItemTextStyle(),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'ايام الانتظار',
                                                  style: rowItemTextStyle(),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'currencyId',
                                                  style:rowItemTextStyle(),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'رقم مركز التكلفة',
                                                  style: rowItemTextStyle(),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'رقم الفرع',
                                                  style: rowItemTextStyle(),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'رقم المستخدم',
                                                  style: rowItemTextStyle(),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'الدفع نقدا فقط',
                                                  style: rowItemTextStyle(),
                                                ),
                                              ),
                                              DataColumn(
                                                label: Text(
                                                  'متوقف',
                                                  style: rowItemTextStyle(),
                                                ),
                                              ),
                                            ],
                                            rows: List<DataRow>.generate(

                                              controller.accountSearchResultList.length,
                                                  (index) => DataRow(
                                                  onSelectChanged: (_) async {

                                                    await controller.setReceiptNumber();
                                                    controller.setReceiptAccount=controller.accountSearchResultList[index];
                                                    controller.setAccountSearchResultList=await DatabaseHelper.db.getAllAccounts();
                                                    Get.to(ReturnReceiptView());
                                                  //  Get.put(ReceiptView(),permanent: true);
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
                                                      controller
                                                          .accountSearchResultList[index].accId
                                                          .toString(),maxLines: 1,
                                                      style: rowItemElementTextStyle(),
                                                    )),
                                                    DataCell(Text(
                                                      controller
                                                          .accountSearchResultList[index].name
                                                          .toString(),
                                                      style: rowItemElementTextStyle(),
                                                    )),
                                                    DataCell(Text(
                                                      controller
                                                          .accountSearchResultList[index].barcode
                                                          .toString(),
                                                      style: rowItemElementTextStyle(),
                                                    )),
                                                    DataCell(Text(
                                                      controller.accountSearchResultList[index]
                                                          .employCode
                                                          .toString(),
                                                      style: rowItemElementTextStyle(),
                                                    )),
                                                    DataCell(Text(
                                                      controller.accountSearchResultList[index]
                                                          .employName
                                                          .toString(),
                                                      style: rowItemElementTextStyle(),
                                                    )),
                                                    DataCell(Text(
                                                      controller.accountSearchResultList[index]
                                                          .currentBalance
                                                          .toString(),
                                                      style: rowItemElementTextStyle(),
                                                    )),
                                                    DataCell(Text(
                                                      controller.accountSearchResultList[index]
                                                          .maxCredit
                                                          .toString(),
                                                      style: rowItemElementTextStyle(),
                                                    )),
                                                    DataCell(Text(
                                                      controller.accountSearchResultList[index]
                                                          .defEmployAccId
                                                          .toString(),
                                                      style: rowItemElementTextStyle(),
                                                    )),
                                                    DataCell(Text(
                                                      controller
                                                          .accountSearchResultList[index].priceId
                                                          .toString(),
                                                      style: rowItemElementTextStyle(),
                                                    )),
                                                    DataCell(Text(
                                                      controller.accountSearchResultList[index]
                                                          .waitDays
                                                          .toString(),
                                                      style: rowItemElementTextStyle(),
                                                    )),
                                                    DataCell(Text(
                                                      controller.accountSearchResultList[index]
                                                          .currencyId
                                                          .toString(),
                                                      style: rowItemElementTextStyle(),
                                                    )),
                                                    DataCell(Text(
                                                      controller.accountSearchResultList[index]
                                                          .costCenterId
                                                          .toString(),
                                                      style: rowItemElementTextStyle(),
                                                    )),
                                                    DataCell(Text(
                                                      controller.accountSearchResultList[index]
                                                          .branchId
                                                          .toString(),
                                                      style: rowItemElementTextStyle(),
                                                    )),
                                                    DataCell(Text(
                                                      controller
                                                          .accountSearchResultList[index].userId
                                                          .toString(),
                                                      style: rowItemElementTextStyle(),
                                                    )),
                                                    DataCell(Text(
                                                      controller.accountSearchResultList[index]
                                                          .payByCashOnly
                                                          .toString(),
                                                      style: rowItemElementTextStyle(),
                                                    )),
                                                    DataCell(Text(
                                                      controller
                                                          .accountSearchResultList[index].stopped
                                                          .toString(),
                                                      style: rowItemElementTextStyle(),
                                                    )),
                                                  ]),
                                            ).toList()),
                                      );
                                    },
                                  ),

                                ],
                              ) ,),
                            ),
                          ),
                        ),
                      )
                  );
                },
              ));
        });
  }
}

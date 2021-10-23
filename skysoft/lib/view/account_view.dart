import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:skysoft/constants.dart';
import 'package:get/get.dart';
import 'package:skysoft/core/%20services/database_helper.dart';
import 'package:skysoft/core/view_model/add_account_view_model.dart';
import 'package:skysoft/core/view_model/add_item_view_model.dart';
import 'package:skysoft/core/view_model/home_view_model.dart';
import 'package:skysoft/models/item_model.dart';
import 'package:skysoft/models/receipt_item_model.dart';
import 'package:skysoft/view/add_item_view.dart';
import 'package:skysoft/view/receipt_view.dart';
import 'package:sqflite/sqflite.dart';

import 'add_account_view.dart';

class AccountView extends GetWidget<AccountViewModel> {
  bool color = false;
  Color rowBackground = Colors.grey.shade300;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<AccountViewModel>(
      builder: (controller) => Container(
          width: screenWidth,
          height: screenHeight,
          child: LayoutBuilder(
            builder: (context, constrains) {
              double height = constrains.maxHeight;
              double width = constrains.maxWidth;
              return SafeArea(
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.white,
                  body: SingleChildScrollView(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey.shade400),
                              child: TextFormField(
                                onChanged: (value) {
                                  controller.setAccountSearchQuery = value;
                                  controller.searchForAccount();
                                },
                                textAlign: TextAlign.right,
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
                            SizedBox(
                              height: height * 0.02,
                            ),
                            // Container(
                            //   color: Colors.green,
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text(
                            //         'الرقم',
                            //         style: rowItemTextStyle(),
                            //       ),
                            //       SizedBox(
                            //           //**
                            //           ),
                            //       Text(
                            //         'الاسم',
                            //         style: rowItemTextStyle(),
                            //       ),
                            //       SizedBox(
                            //           //**
                            //           ),
                            //       Text(
                            //         'الكمية',
                            //         style: rowItemTextStyle(),
                            //       ),
                            //       SizedBox(
                            //           //**
                            //           ),
                            //       Text(
                            //         'سعر بيع الجملة',
                            //         style: rowItemTextStyle(),
                            //       ),
                            //       SizedBox(
                            //           //**
                            //           ),
                            //       Text(
                            //         'سعر البيع',
                            //         style: rowItemTextStyle(),
                            //       ),
                            //       SizedBox(
                            //           //**
                            //           ),
                            //       Text(
                            //         'متوسط سعر الشراء',
                            //         style: rowItemTextStyle(),
                            //       ),
                            //       SizedBox(
                            //           //**
                            //           ),
                            //       Text(
                            //         'اخر سعر شراء',
                            //         style: rowItemTextStyle(),
                            //       ),
                            //       SizedBox(
                            //           //**
                            //           ),
                            //       Text(
                            //         'باركود',
                            //         style: rowItemTextStyle(),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            Container(
                              width: width,
                              height: height*0.56,
                              child: SingleChildScrollView(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: DataTable(
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
                                            style: rowItemTextStyle(),
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
                                        controller.accountModelList.length,
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
                                                controller
                                                    .accountModelList[index].accId
                                                    .toString(),
                                                maxLines: 1,
                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                controller
                                                    .accountModelList[index].name
                                                    .toString(),
                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                controller.accountModelList[index]
                                                    .barcode
                                                    .toString(),
                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                controller.accountModelList[index]
                                                    .employCode
                                                    .toString(),
                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                controller.accountModelList[index]
                                                    .employName
                                                    .toString(),
                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                controller.accountModelList[index]
                                                    .currentBalance
                                                    .toString(),
                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                controller.accountModelList[index]
                                                    .maxCredit
                                                    .toString(),
                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                controller.accountModelList[index]
                                                    .defEmployAccId
                                                    .toString(),
                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                controller.accountModelList[index]
                                                    .priceId
                                                    .toString(),
                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                controller.accountModelList[index]
                                                    .waitDays
                                                    .toString(),
                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                controller.accountModelList[index]
                                                    .currencyId
                                                    .toString(),
                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                controller.accountModelList[index]
                                                    .costCenterId
                                                    .toString(),
                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                controller.accountModelList[index]
                                                    .branchId
                                                    .toString(),
                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                controller.accountModelList[index]
                                                    .userId
                                                    .toString(),
                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                controller.accountModelList[index]
                                                    .payByCashOnly
                                                    .toString(),
                                                style: rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                controller.accountModelList[index]
                                                    .stopped
                                                    .toString(),
                                                style: rowItemElementTextStyle(),
                                              )),
                                            ]),
                                      ).toList()),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: height * 0.03,
                            ),
                            Container(
                              width: width,
                              alignment: Alignment.center,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child:
                                GetBuilder<AccountViewModel>(
                                  builder: (controller) => DataTable(
                                      dividerThickness: 2,
                                      dataRowHeight: height * 0.07,
                                      headingRowHeight: height * 0.07,
                                      columnSpacing: width * 0.05,
                                      headingRowColor:
                                      MaterialStateColor.resolveWith(
                                              (states) =>
                                          Colors.blueGrey),
                                      columns: [
                                        DataColumn(
                                          label: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'اجمالي الارصده',
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
                                                    return Colors
                                                        .grey.shade50;
                                                  return Colors.grey
                                                      .shade300; // Use default value for other states and odd rows.
                                                }),
                                            cells: [
                                              DataCell(Container(
                                                child: Text(
                                                  ///اجمالي الاصاف
                                                controller.totalBalance
                                                      .toStringAsFixed(3),
                                                  style:
                                                  rowItemElementTextStyle(),
                                                ),
                                              )),

                                            ]),
                                      ).toList()),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                  floatingActionButton: SpeedDial(
                    animatedIcon: AnimatedIcons.menu_home,
                    backgroundColor: Colors.lightGreen,
                    children: [
                      SpeedDialChild(
                          onTap: () {
                            Get.dialog(AddAccountView());
                          },
                          backgroundColor: Colors.red,
                          label: 'اضافة حساب جديد',
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          )),
                      SpeedDialChild(
                          label: 'انشاء فاتورة جديده',
                          onTap: () => Get.to(ReceiptView()),
                          backgroundColor: Colors.cyan,
                          child: Icon(
                            Icons.receipt_long,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}

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
                                    hintText: "??????",
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
                            //         '??????????',
                            //         style: rowItemTextStyle(),
                            //       ),
                            //       SizedBox(
                            //           //**
                            //           ),
                            //       Text(
                            //         '??????????',
                            //         style: rowItemTextStyle(),
                            //       ),
                            //       SizedBox(
                            //           //**
                            //           ),
                            //       Text(
                            //         '????????????',
                            //         style: rowItemTextStyle(),
                            //       ),
                            //       SizedBox(
                            //           //**
                            //           ),
                            //       Text(
                            //         '?????? ?????? ????????????',
                            //         style: rowItemTextStyle(),
                            //       ),
                            //       SizedBox(
                            //           //**
                            //           ),
                            //       Text(
                            //         '?????? ??????????',
                            //         style: rowItemTextStyle(),
                            //       ),
                            //       SizedBox(
                            //           //**
                            //           ),
                            //       Text(
                            //         '?????????? ?????? ????????????',
                            //         style: rowItemTextStyle(),
                            //       ),
                            //       SizedBox(
                            //           //**
                            //           ),
                            //       Text(
                            //         '?????? ?????? ????????',
                            //         style: rowItemTextStyle(),
                            //       ),
                            //       SizedBox(
                            //           //**
                            //           ),
                            //       Text(
                            //         '????????????',
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
                                            '??????????',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            '??????????',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            '????????????????',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            '?????? ????????????',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            '?????? ????????????',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            '???????????? ????????????',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            '???????? ??????????????',
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
                                            '?????? ??????????',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            '???????? ????????????????',
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
                                            '?????? ???????? ??????????????',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            '?????? ??????????',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            '?????? ????????????????',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            '?????????? ???????? ??????',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            '??????????',
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
                                              '???????????? ??????????????',
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
                                                  ///???????????? ????????????
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
                          label: '?????????? ???????? ????????',
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          )),
                      SpeedDialChild(
                          label: '?????????? ???????????? ??????????',
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

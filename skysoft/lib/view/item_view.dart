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
import 'package:skysoft/core/view_model/add_item_view_model.dart';
import 'package:skysoft/core/view_model/home_view_model.dart';
import 'package:skysoft/models/item_model.dart';
import 'package:skysoft/view/add_item_view.dart';
import 'package:skysoft/view/receipt_view.dart';
import 'package:sqflite/sqflite.dart';

class ItemsView extends GetWidget<ItemsViewModel> {
  bool color = false;
  Color rowBackground = Colors.grey.shade300;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<ItemsViewModel>(
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
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              // padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey.shade400),
                              child: TextFormField(
                                onChanged: (value){
                                  controller.setItemSearchQuery=value;
                                  controller.searchForItem();
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
                                      columnSpacing: width * 0.02,
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
                                            '????????????',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),     DataColumn(
                                          label: Text(
                                            '????????????',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            '?????? ?????????? ??????????????',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            '?????? ??????????????',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            ' ?????????? ?????? ????????????',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            '?????? ?????? ????????',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            '????????????',
                                            style: rowItemTextStyle(),
                                          ),
                                        ),
                                      ],
                                      rows: List<DataRow>.generate(
                                        controller.itemModelList.length,
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
                                                    .itemModelList[
                                                index]
                                                    .itemId
                                                    .toString(),
                                                style:
                                                rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                controller
                                                    .itemModelList[
                                                index]
                                                    .itemName
                                                    .toString(),
                                                style:
                                                rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                controller
                                                    .itemModelList[
                                                index]
                                                    .conversionFactor ==
                                                    1
                                                    ? '${controller.itemModelList[index].itemQuantity} '
                                                    : '${(controller.itemModelList[index].itemQuantity! / controller.itemModelList[index].conversionFactor!.toDouble()).floor()} ' +
                                                    (controller.itemModelList[index].itemQuantity! %
                                                        controller
                                                            .itemModelList[index]
                                                            .conversionFactor!
                                                            .toDouble() ==
                                                        0
                                                        ? ''
                                                        : '?? ${controller.itemModelList[index].itemQuantity! % controller.itemModelList[index].conversionFactor!.toDouble()}'),
                                                style:
                                                rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                controller
                                                    .itemModelList[
                                                index]
                                                    .unitName
                                                    .toString(),
                                                style:
                                                rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                '${controller.itemModelList[index].wholesalePrice!   } ',
                                                style:
                                                rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                '${controller.itemModelList[index].sellingPrice!      } ',
                                                style:
                                                rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                '${controller.itemModelList[index].avgPurchasePrice!  } ',
                                                style:
                                                rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                '${controller.itemModelList[index].lastPurchasePrice! } ',
                                                style:
                                                rowItemElementTextStyle(),
                                              )),
                                              DataCell(Text(
                                                controller
                                                    .itemModelList[
                                                index]
                                                    .itemBarcode
                                                    .toString(),
                                                style:
                                                rowItemElementTextStyle(),
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
                                GetBuilder<ItemsViewModel>(
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
                                        DataColumn(
                                          label: Text(
                                            '???????????? ???????? ??????????????',
                                            style: rowItemTextStyle(),
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
                                                  controller
                                                      .itemModelList.length
                                                      .toStringAsFixed(3),
                                                  style:
                                                  rowItemElementTextStyle(),
                                                ),
                                              )),
                                              DataCell(Text(
                                                ///???????????? ???????? ??????????????
                                                controller
                                                    .allQuantity
                                                    .toStringAsFixed(3),
                                                style:
                                                rowItemElementTextStyle(),
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
                          onTap: () => Get.to(AddItemsView()),
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

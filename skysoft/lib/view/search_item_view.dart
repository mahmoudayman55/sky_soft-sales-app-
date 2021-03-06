import 'dart:io';
import 'package:flutter/scheduler.dart';

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
import 'package:skysoft/core/view_model/add_item_view_model.dart';
import 'package:skysoft/core/view_model/home_view_model.dart';
import 'package:skysoft/core/view_model/receipt_view_model.dart';
import 'package:skysoft/view/receipt_view.dart';
import 'package:sqflite/sqflite.dart';

class SearchItemView extends GetWidget<ReceiptViewModel> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    TextEditingController searchController = TextEditingController();
    return GetBuilder<ReceiptViewModel>(
        builder: (controller) => Container(
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
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    width: width * 0.8,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.blueGrey.shade400),
                                    child: TextFormField(
                                      textAlign: TextAlign.right,
                                      onChanged: (value) {
                                        controller.itemSearchQuery =
                                            value.toString();
                                        controller.searchForItem();
                                      },
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
                                ],
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: GetBuilder<ReceiptViewModel>(
                                    builder: (controller) {
                                      controller.searchForItem();
                                      return DataTable(
                                          showCheckboxColumn: false,
                                          dividerThickness: 1,
                                          dataRowHeight: height * 0.07,
                                          headingRowHeight: height * 0.07,
                                          columnSpacing: width * 0.02,
                                          headingRowColor:
                                              MaterialStateColor.resolveWith(
                                                  (states) =>
                                                      Colors.lightGreen),
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
                                            ),
                                            DataColumn(
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
                                            controller
                                                .itemsSearchResultList.length,
                                            (index) => DataRow(
                                                onSelectChanged: (_) {
                                                  controller.addToWaitingItems(
                                                      controller
                                                              .itemsSearchResultList[
                                                          index]);
                                                  controller.calculateTotal();
                                                  controller.updateNetReceipt();
                                                  Get.back();
                                                },
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
                                                  DataCell(Text(
                                                    controller
                                                        .itemsSearchResultList[
                                                            index]
                                                        .itemId
                                                        .toString(),
                                                    style:
                                                        rowItemElementTextStyle(),
                                                  )),
                                                  DataCell(Text(
                                                    controller
                                                        .itemsSearchResultList[
                                                            index]
                                                        .itemName
                                                        .toString(),
                                                    style:
                                                        rowItemElementTextStyle(),
                                                  )),
                                                  DataCell(Text(
                                                    controller
                                                                .itemsSearchResultList[
                                                                    index]
                                                                .conversionFactor ==
                                                            1
                                                        ? '${controller.itemsSearchResultList[index].itemQuantity} '
                                                        : '${(controller.itemsSearchResultList[index].itemQuantity! / controller.itemsSearchResultList[index].conversionFactor!.toDouble()).floor()} ' +
                                                            (controller.itemsSearchResultList[index].itemQuantity! %
                                                                        controller
                                                                            .itemsSearchResultList[index]
                                                                            .conversionFactor!
                                                                            .toDouble() ==
                                                                    0
                                                                ? ''
                                                                : '?? ${controller.itemsSearchResultList[index].itemQuantity! % controller.itemsSearchResultList[index].conversionFactor!.toDouble()}'),
                                                    style:
                                                        rowItemElementTextStyle(),
                                                  )),
                                                  DataCell(Text(
                                                    controller
                                                        .itemsSearchResultList[
                                                            index]
                                                        .unitName
                                                        .toString(),
                                                    style:
                                                        rowItemElementTextStyle(),
                                                  )),
                                                  DataCell(Text(
                                                    '${controller.itemsSearchResultList[index].wholesalePrice!   } ',
                                                    style:
                                                        rowItemElementTextStyle(),
                                                  )),
                                                  DataCell(Text(
                                                    '${controller.itemsSearchResultList[index].sellingPrice!      } ',
                                                    style:
                                                        rowItemElementTextStyle(),
                                                  )),
                                                  DataCell(Text(
                                                    '${controller.itemsSearchResultList[index].avgPurchasePrice!  } ',
                                                    style:
                                                        rowItemElementTextStyle(),
                                                  )),
                                                  DataCell(Text(
                                                    '${controller.itemsSearchResultList[index].lastPurchasePrice! } ',
                                                    style:
                                                        rowItemElementTextStyle(),
                                                  )),
                                                  DataCell(Text(
                                                    controller
                                                        .itemsSearchResultList[
                                                            index]
                                                        .itemBarcode
                                                        .toString(),
                                                    style:
                                                        rowItemElementTextStyle(),
                                                  )),
                                                ]),
                                          ).toList());
                                    },
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ));
              },
            )));
  }
}

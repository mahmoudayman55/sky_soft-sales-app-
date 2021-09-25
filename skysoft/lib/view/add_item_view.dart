import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:skysoft/constants.dart';
import 'package:skysoft/core/%20services/database_helper.dart';

import 'package:skysoft/core/view_model/add_item_view_model.dart';
import 'package:skysoft/models/item_model.dart';

class AddItemsView extends GetWidget<ItemsViewModel> {
var _formKey = GlobalKey<FormState>();
var fieldKey=GlobalKey<FormFieldState>();

@override
Widget build(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;
  return GetBuilder<ItemsViewModel>(
      builder: (controller) => Container(
              // width: screenWidth,
              // height: screenHeight,
              child: LayoutBuilder(
            builder: (context, constrains) {
              double height = constrains.maxHeight;
              double width = constrains.maxWidth;
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                    resizeToAvoidBottomInset: false,
                    backgroundColor: Colors.white,
                    body: SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'اضافة عنصر جديد',
                              style: labelsTextStyle,
                            ),
                            Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: TextFormField(
                                           onSaved: (value) {
                                              controller.itemName = value;
                                            },
                                            decoration: TextInputDecoration(
                                              'اسم العنصر',
                                              null,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.02,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: TextFormField(
                                           onSaved: (value) {
                                              controller.wholesalePrice =
                                                  double.parse(value!);
                                            },
                                            decoration: TextInputDecoration(
                                              'سعر بيع الجملة',
                                              null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.03,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              child: TextFormField(
                                               onSaved: (value) {
                                                  controller.itemQuantity =
                                                      int.parse(value!);
                                                },
                                                decoration: TextInputDecoration(
                                                  'الكمية',
                                                  null,
                                                ),
                                              ),
                                            )),
                                        SizedBox(
                                          width: width * 0.02,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: TextFormField(
                                           onSaved: (value) {
                                              controller.avgPurchasePrice =
                                                  double.parse(value!);
                                            },
                                            decoration: TextInputDecoration(
                                              'متوسط سعر الشراء',
                                              null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.03,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              child: TextFormField(
                                               onSaved: (value) {
                                                  controller.sellingPrice =
                                                      double.parse(value!);
                                                },
                                                decoration: TextInputDecoration(
                                                  'سعر البيع بالقطاعي',
                                                  null,
                                                ),
                                              ),
                                            )),
                                        SizedBox(
                                          width: width * 0.02,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: TextFormField(
                                           onSaved: (value) {
                                              controller.itemBarcode =
                                                  int.parse(value!);
                                            },
                                            decoration: TextInputDecoration(
                                              'باركود',
                                              null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.03,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              child: TextFormField(
                                               onSaved: (value) {
                                                  controller.lastPurchasePrice =
                                                      double.parse(value!);
                                                },
                                                decoration: TextInputDecoration(
                                                  'اخر سعر شراء',
                                                  null,
                                                ),
                                              ),
                                            )),
                                        SizedBox(
                                          width: width * 0.02,
                                        ),
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              child: TextFormField(
                                               onSaved: (value) {
                                                  controller.itemGroup = value;
                                                },
                                                decoration: TextInputDecoration(
                                                  'المجموعة',
                                                  null,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.03,
                                    ),
                                    defaultButton(
                                        function:(){
                                          _formKey.currentState!.save();
                                           controller.addNewItem(ItemModel(
                                            itemName: controller.itemName,
                                            itemGroup: controller.itemGroup,
                                            wholesalePrice:
                                            controller.wholesalePrice,
                                            sellingPrice:
                                            controller.sellingPrice,
                                            avgPurchasePrice:
                                            controller.avgPurchasePrice,
                                            lastPurchasePrice:
                                            controller.lastPurchasePrice,
                                            itemBarcode: controller.itemBarcode,
                                            itemQuantity:
                                            controller.itemQuantity));
                                          Get.back();
                                          controller.getAllItems();
                                        },

                                        width: width - 500,
                                        height: height + 200,
                                        background: Colors.green,
                                        fontSize: ScreenUtil().setSp(50),
                                        text: 'حفظ'),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    )),
              );
            },
          )));
}}

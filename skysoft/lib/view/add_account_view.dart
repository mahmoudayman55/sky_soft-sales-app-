import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:skysoft/constants.dart';
import 'package:skysoft/core/%20services/database_helper.dart';
import 'package:skysoft/core/view_model/add_account_view_model.dart';

import 'package:skysoft/core/view_model/add_item_view_model.dart';
import 'package:skysoft/models/account_model.dart';
import 'package:skysoft/models/item_model.dart';

class AddAccountView extends GetWidget<AccountViewModel> {
var _formKey = GlobalKey<FormState>();

@override
Widget build(BuildContext context) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;
  return GetBuilder<AccountViewModel>(
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
                              'اضافة حساب جديد',
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
                                            initialValue: 'محمد ايمن محمد احمد حسام',
                                           onSaved: (value) {
                                              controller.name = value;
                                            },
                                            decoration: TextInputDecoration(
                                              'اسم الحساب',
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
                                            initialValue: '35',
                                           onSaved: (value) {
                                              controller.barcode =
                                                  int.parse(value!);
                                            },
                                            decoration: TextInputDecoration(
                                              'الباركود',
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
                                                initialValue: 'dsafsadfaf',
                                               onSaved: (value) {
                                                  controller.employName = value;
                                                },
                                                decoration: TextInputDecoration(
                                                  'اسم العميل',
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
                                            initialValue: 'dsafafdsgf',
                                           onSaved: (value) {
                                              controller.employCode =
                                                  value;
                                            },
                                            decoration: TextInputDecoration(
                                              'كود العميل',
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
                                                initialValue: 'dsasadfadsfaf',
                                                onSaved: (value) {

                                                  controller.employName = value;
                                                },
                                                decoration: TextInputDecoration(
                                                  'اسم العميل',
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
                                            initialValue: 'asdfadsf',
                                            onSaved: (value) {
                                              controller.employCode =
                                                  value;
                                            },
                                            decoration: TextInputDecoration(
                                              'كود العميل',
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
                                                initialValue: '22',
                                               onSaved: (value) {
                                                  controller.waitDays =
                                                      int.parse(value!);
                                                },
                                                decoration: TextInputDecoration(
                                                  'ايام الانتظار',
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
                                            initialValue: 'dsafaadsfasdf',
                                           onSaved: (value) {
                                              controller.note =
                                                 value;
                                            },
                                            decoration: TextInputDecoration(
                                              'ملاحظات',
                                              null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ), SizedBox(
                                      height: height * 0.03,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              child: TextFormField(
                                                initialValue: '32',
                                                onSaved: (value) {
                                                  controller.currencyId =
                                                      int.parse(value!);
                                                },
                                                decoration: TextInputDecoration(
                                                  'currency Id',
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
                                            initialValue: '33',
                                            onSaved: (value) {
                                              controller.costCenterId =
                                                  int.parse(value!);
                                            },
                                            decoration: TextInputDecoration(
                                              'رقم مركز التكلفة',null
                                            ),
                                          ),
                                        ),
                                      ],
                                    ), SizedBox(
                                      height: height * 0.03,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              child: TextFormField(
                                                initialValue: '77',
                                                onSaved: (value) {
                                                  controller.branchId =
                                                      int.parse(value!);
                                                },
                                                decoration: TextInputDecoration(
                                                  'رقم الفرع',
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
                                            initialValue: '78',
                                            onSaved: (value) {
                                              controller.userId =
                                                 int.parse(value!);
                                            },
                                            decoration: TextInputDecoration(
                                              'رقم المستخدم',
                                              null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ), SizedBox(
                                      height: height * 0.03,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              child: TextFormField(
                                                initialValue: 'نعم',
                                                onSaved: (value) {
                                                  value=='نعم' ?
                                                  controller.payByCashOnly=1 :controller.payByCashOnly=0;
                                                },
                                                decoration: TextInputDecoration(
                                                  'الدفع نقدا فقط',
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
                                            initialValue: 'لا',
                                            onSaved: (value) {
                                              value=='نعم'? controller.stopped=1:
                                                  controller.stopped=0;
                                            },
                                            decoration: TextInputDecoration(
                                              'ايقاف',
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
                                                initialValue: '88',
                                               onSaved: (value) {
                                                  controller.defEmployAccId =
                                                      int.parse(value!);
                                                },
                                                decoration: TextInputDecoration(
                                                  'defEmployAccId',
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
                                                initialValue: '99',
                                               onSaved: (value) {
                                                  controller.priceId = int.parse(value!);
                                                },
                                                decoration: TextInputDecoration(
                                                  'رقم السعر',
                                                  null,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.03,
                                    ),Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Container(
                                              child: TextFormField(
                                                initialValue: '88',
                                                onSaved: (value) {
                                                  controller.maxCredit =
                                                      double.parse(value!);
                                                },
                                                decoration: TextInputDecoration(
                                                  'اقصي مديونية',
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
                                                initialValue: '99',
                                                onSaved: (value) {
                                                  controller.currentBalance = double.parse(value!);
                                                },
                                                decoration: TextInputDecoration(
                                                  'الرصيد الحالي',
                                                  null,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                    defaultButton(
                                        function:(){
                                          _formKey.currentState!.save();

                                           controller.addNewAccount(AccountModel(
                                             stopped: controller.stopped,
                                             payByCashOnly: controller.payByCashOnly,
                                             name: controller.name,
                                             barcode:  controller.barcode,
                                             branchId:  controller.branchId,
                                             costCenterId:  controller.costCenterId,
                                             currencyId:  controller.currencyId,
                                             currentBalance:  controller.currentBalance,
                                             defEmployAccId:  controller.defEmployAccId,
                                             employCode:  controller.employCode,
                                             employName: controller.employName,
                                             maxCredit: controller.maxCredit,
                                             note: controller.note,
                                             priceId: controller.priceId,
                                             userId: controller.userId,
                                             waitDays: controller.waitDays

                                           ));
                                          controller.getAllAccounts();
                                          Get.back();
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

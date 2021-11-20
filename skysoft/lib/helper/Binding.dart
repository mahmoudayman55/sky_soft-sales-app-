import 'package:get/get.dart';
import 'package:skysoft/core/view_model/add_account_view_model.dart';
import 'package:skysoft/core/view_model/add_item_view_model.dart';
import 'package:skysoft/core/view_model/constants_view_model.dart';
import 'package:skysoft/core/view_model/home_view_model.dart';
import 'package:skysoft/core/view_model/previous_receipts_view_model.dart';
import 'package:skysoft/core/view_model/receipt_view_model.dart';
import 'package:skysoft/core/view_model/return_receipt_view_model.dart';
class Binding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut(() => HomeViewModel(),fenix: true,);
    Get.lazyPut(() => ItemsViewModel(),fenix: true);
    Get.lazyPut(() => AccountViewModel(),fenix: true);
    Get.lazyPut(() => ReceiptViewModel(),fenix: true);
    Get.lazyPut(() => PreviousReceiptsViewModel(),fenix: true);
    Get.lazyPut(() => ReturnReceiptViewModel(),fenix: true);
    Get.lazyPut(() => ConstantsViewModel(),fenix: true);


  }
}
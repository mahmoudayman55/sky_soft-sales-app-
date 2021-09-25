import 'package:get/get.dart';
import 'package:skysoft/core/%20services/database_helper.dart';
import 'package:skysoft/core/view_model/previous_receipts_view_model.dart';
import 'package:skysoft/models/account_model.dart';
import 'package:skysoft/models/item_model.dart';
class HomeViewModel extends GetxController{
@override
  Future<void> onInit() async {
    // TODO: implement onInit
    DatabaseHelper.db.database;
  }
}
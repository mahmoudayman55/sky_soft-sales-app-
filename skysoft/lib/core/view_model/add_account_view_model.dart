import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skysoft/core/%20services/database_helper.dart';
import 'package:skysoft/models/account_model.dart';
import 'package:skysoft/models/item_model.dart';

class AccountViewModel extends GetxController {
  AccountViewModel() {
    addAccountsToMenu();
  }

  String? name, note, employCode, employName;
  double? currentBalance, maxCredit;
  int? defEmployAccId,
      priceId,
      waitDays,
      barcode,
      currencyId,
      costCenterId,
      branchId,
      userId,
      payByCashOnly,
      stopped;
  List<DropdownMenuItem<AccountModel>> accountsListItems = [];

  addAccountsToMenu() async {
    await getAllAccounts();
    _accountModelList.forEach((account) {
      accountsListItems.add(DropdownMenuItem<AccountModel>(
          value: account,
          child: Text(
            account.name.toString(),
            textAlign: TextAlign.start,
          )));
      print(account.name.toString());
    });
    calculateTotalBalance();
    update();
  }


  // accountsList() {
  //
  //   for (int i = 0; i < _accountModelList.length; i++) {
  //     print(_accountModelList[i].name.toString());
  //     accountsListItems.add(
  //         _accountModelList[i].name.toString(),
  //
  //     ) ;
  //     print(_accountModelList[i].name.toString());
  //
  //
  //   }
  //   update();
  //   print('doneeeeeeeeeeeeeeeeeeeee**9/*9//*///*/*//**/9*9/');
  //   return accountsListItems;
  // }
  String _accountSearchQuery='';

  String get accountSearchQuery => _accountSearchQuery;

  set setAccountSearchQuery(String value) {
    _accountSearchQuery = value;
  }

  searchForAccount() async {
    var dbHelper = DatabaseHelper.db;
    _accountModelList = _accountModelList.isEmpty
        ? await dbHelper.getAllAccounts()
        : await dbHelper.findAccounts(_accountSearchQuery);
    print(_accountModelList);
    calculateTotalBalance();
    update();
    print('items returned successfully');
  }

  addNewAccount(AccountModel account) async {
    var dbHelper = DatabaseHelper.db;
    await dbHelper.insertAccount(account);
    update();
    print('values inserted');
  }

  List<AccountModel> _accountModelList = [];

  List<AccountModel> get accountModelList => _accountModelList;
  double _totalBalance=0;

  double get totalBalance => _totalBalance;

  set setTotalBalance(double value) {
    _totalBalance = value;
  }

  calculateTotalBalance(){
  _totalBalance=0;
  _accountModelList.forEach((element) {_totalBalance+=element.currentBalance!;});
  update();
}
  getAllAccounts() async {
    var dbHelper = DatabaseHelper.db;
    _accountModelList = await dbHelper.getAllAccounts();
    print(_accountModelList);
    update();
    print('items returned successfully');
  }
}

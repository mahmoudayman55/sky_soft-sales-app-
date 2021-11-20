import 'dart:math';



import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:skysoft/constants.dart';
import 'package:skysoft/core/view_model/receipt_view_model.dart';
import 'package:skysoft/models/account_model.dart';
import 'package:get/get.dart';
import 'package:skysoft/models/item_model.dart';
import 'package:skysoft/models/receipt_item_model.dart';
import 'package:skysoft/models/receipt_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper db = DatabaseHelper._();
  Database? _database;

  Future<Database?> get database async {
    _database = await createDatabase();

    return _database;
  }

  createDatabase() async {
    String path = join(await getDatabasesPath(), 'skysoftv3.1.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int ver) async {
      ///create account table
      try {
        await db.execute('''
CREATE TABLE $accountTableName($columnAccountName TEXT, $columnAccountAccId INTEGER PRIMARY KEY, $columnAccountNote TEXT,
$columnAccountAccBarcode INTEGER,$columnAccountEmployCode TEXT, $columnAccountEmployName TEXT,
$columnAccountCurrentBalance REAL,$columnAccountMaxCredit REAL,
$columnAccountDefEmployId INTEGER,$columnAccountPriceId INTEGER,$columnAccountWaitDays INTEGER,
$columnAccountCurrencyId INTEGER, $columnAccountCostCenterId INTEGER, $columnAccountBranchId INTEGER,$columnAccountUserId INTEGER,
$columnAccountPayByCashOnly BOOLEAN,$columnAccountStopped BOOLEAN);
''');
        print('account tale created');
      } catch (e) {
        print(e);
      }
      try {
        await db.execute('''
  
  CREATE TABLE $itemTableName($columnItemName TEXT,$columnItemQuantity REAL,$columnItemGroup TEXT,$columnItemNumber INTEGER,$columnItemUnitName TEXT,$columnItemConversionFactor REAL,
  $columnItemWholesalePrice REAL,$columnItemSellingPrice REAL,$columnItemAvgPurchasePrice REAL,$columnItemLastPurchasePrice REAL,
  $columnItemId INTEGER PRIMARY KEY,$columnItemBarcode INTEGER)
  ''');
        print('items tale created');
      } catch (e) {
        print(e);
      }

      try {
        await db.execute(
            '''CREATE TABLE $receiptTableName($columnReceiptId INTEGER PRIMARY KEY AUTOINCREMENT, $columnReceiptStartDate TEXT,$columnReceiptStartTime TEXT,$columnReceiptSaveDate TEXT,$columnReceiptSaveTime TEXT,
          $columnReceiptTotal REAL, $columnReceiptDiscount REAL,$columnReceiptAddition REAL,
           $columnReceiptTax REAL, $columnReceiptCashPayment REAL,
           $columnReceiptBankPayment REAL,$columnReceiptNetReceipt REAL,$columnReceiptType TEXT, $columnReceiptRest REAL,$columnReceiptFAccountId INTEGER,
            FOREIGN KEY ($columnReceiptFAccountId) REFERENCES $accountTableName($columnAccountAccId) ON DELETE NO ACTION ON UPDATE NO ACTION )''');

        print('receipt tale created');
        print('data inserted');



        // deleteReceipt(999);
        // print('data deleted');



      } catch (e) {
        print(e);
      }

      try {
        await db.execute(
            '''CREATE TABLE $receiptItemTableName ($columnReceiptItemId INTEGER PRIMARY KEY, $columnReceiptItemName TEXT, $columnReceiptItemReturnableQuantity REAL,$columnReceiptItemFNumber INTEGER,
            $columnReceiptItemUnitName TEXT, $columnReceiptItemConversionFactor REAL,
            $columnReceiptItemFreeReturnableQuantity REAL,
  $columnReceiptItemPrice REAL, $columnReceiptItemQuantity REAL, $columnReceiptItemFreeQuantity REAL,
  $columnReceiptItemDiscount REAL,$columnReceiptFItemId INTEGER,$columnReceiptItemFReceiptId INTEGER,
  FOREIGN KEY ($columnReceiptItemFReceiptId) REFERENCES $receiptTableName($columnReceiptId) ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY ($columnReceiptFItemId) REFERENCES $itemTableName($columnItemId) ON DELETE NO ACTION ON UPDATE NO ACTION,
  FOREIGN KEY ($columnReceiptItemFNumber) REFERENCES $itemTableName($columnReceiptItemFNumber) ON DELETE NO ACTION ON UPDATE NO ACTION)''');
        print('receipt item tale created');
      } catch (e) {
        Get.snackbar('error', e.toString());
        print(e);
      }
    });
  }

  List<ItemModel> models = [
    ItemModel(itemQuantity: 24, itemBarcode: 69122, lastPurchasePrice: 99, avgPurchasePrice: 96, sellingPrice: 145, wholesalePrice: 52, itemNumber: 56985,conversionFactor:1 ,  unitName: 'قطعه',  itemGroup: 'اكسيسوارات', itemName: 'كيبورد'),
    ItemModel(itemQuantity: 24, itemBarcode: 69122, lastPurchasePrice: 99, avgPurchasePrice: 96, sellingPrice: 145, wholesalePrice: 52, itemNumber: 56985,conversionFactor:12 ,       unitName:'علبه' ,   itemGroup: 'اكسيسوارات', itemName: 'كيبورد'),
    ItemModel(itemQuantity: 24, itemBarcode: 69122, lastPurchasePrice: 99, avgPurchasePrice: 96, sellingPrice: 145, wholesalePrice: 52, itemNumber: 56985,conversionFactor: 48,       unitName:'كرتونة' ,   itemGroup: 'اكسيسوارات', itemName: 'كيبورد'),
    ItemModel(itemQuantity: 244, itemBarcode: 5212212, lastPurchasePrice: 99, avgPurchasePrice: 965, sellingPrice: 146, wholesalePrice: 63,  itemNumber:5632512144    , itemGroup: 'اكسيسوارات', itemName: 'شاشه'),
    ItemModel(itemQuantity: 45, itemBarcode: 524224, lastPurchasePrice: 45, avgPurchasePrice: 45, sellingPrice: 132, wholesalePrice: 47,     itemNumber:5632524644    , itemGroup: 'اكسيسوارات', itemName: 'سماعات'),
    ItemModel(itemQuantity: 45, itemBarcode: 522121, lastPurchasePrice: 45, avgPurchasePrice: 52, sellingPrice: 123, wholesalePrice: 32,     itemNumber:56322354544    , itemGroup: 'اكسيسوارات', itemName: 'لابتوب'),
    ItemModel(itemQuantity: 455, itemBarcode: 525568, lastPurchasePrice: 43, avgPurchasePrice: 10, sellingPrice: 178, wholesalePrice: 96,    itemNumber:5632315544    , itemGroup: 'اكسيسوارات', itemName: 'كابل باور'),
    ItemModel(itemQuantity: 458, itemBarcode: 5254, lastPurchasePrice: 17, avgPurchasePrice: 12, sellingPrice: 126, wholesalePrice: 47,      itemNumber:54562632544    , itemGroup: 'اكسيسوارات', itemName: 'طابعة'),
    ItemModel(itemQuantity: 1212, itemBarcode: 525451, lastPurchasePrice: 147, avgPurchasePrice: 15, sellingPrice: 127, wholesalePrice: 34,  itemNumber:563432544234    , itemGroup: 'اكسيسوارات', itemName: 'طابعة باركود'),
    ItemModel(itemQuantity: 456, itemBarcode: 525455, lastPurchasePrice: 36, avgPurchasePrice: 14, sellingPrice: 127, wholesalePrice: 14,    itemNumber:5633456734562544    , itemGroup: 'اكسيسوارات', itemName: 'ورق حراري'),
    ItemModel(itemQuantity: 877, itemBarcode: 521221, lastPurchasePrice: 97, avgPurchasePrice: 18, sellingPrice: 130, wholesalePrice: 120,   itemNumber:563456346372544    , itemGroup: 'اكسيسوارات', itemName: 'هارد ssd'),
    ItemModel(itemQuantity: 458, itemBarcode: 521556, lastPurchasePrice: 13, avgPurchasePrice: 19, sellingPrice: 178, wholesalePrice: 178,   itemNumber:5632525442344    , itemGroup: 'اكسيسوارات', itemName: 'هارد hdd'),
    ItemModel(itemQuantity: 69, itemBarcode: 52155611, lastPurchasePrice: 13, avgPurchasePrice: 13, sellingPrice: 19, wholesalePrice: 100,   itemNumber:56322354236544    , itemGroup: 'اكسيسوارات', itemName: 'راوتر'),
    ItemModel(itemQuantity: 48, itemBarcode: 521556115, lastPurchasePrice: 17, avgPurchasePrice: 14, sellingPrice: 55, wholesalePrice: 47,   itemNumber:5632235345544    , itemGroup: 'اكسيسوارات', itemName: 'ماوس باد'),
    ItemModel(itemQuantity: 12, itemBarcode: 5215558, lastPurchasePrice: 56, avgPurchasePrice: 155, sellingPrice: 5578, wholesalePrice: 4712,itemNumber:5632523423444    , itemGroup: 'اكسيسوارات', itemName: 'ماوس'),
  ];

  List<AccountModel> accModels = [
    AccountModel(name: 'حسن محمد', currentBalance: 52563),
    AccountModel(name: 'حسام ابراهيم', currentBalance: 52563),
    AccountModel(name: 'محمود يوسف', currentBalance: 52563),
    AccountModel(name: 'ابراهيم مجدي', currentBalance: 52563),
    AccountModel(name: 'يوسف وليد', currentBalance: 52563),
    AccountModel(name: 'رامي سمير', currentBalance: 52563),
    AccountModel(name: 'احمد مصطفي', currentBalance: 52563),
    AccountModel(name: 'سمير شكري', currentBalance: 52563),
    AccountModel(name: 'مجدي محمود', currentBalance: 52563),
    AccountModel(name: 'يوسف سامي', currentBalance: 52563),
    AccountModel(name: 'سليمان مصطفي', currentBalance: 52563),
    AccountModel(name: 'شكري عبد الرحمن', currentBalance: 52563),
    AccountModel(name: 'وليد شاكر', currentBalance: 52563),
    AccountModel(name: 'مصطفي محمد', currentBalance: 52563),
    AccountModel(name: 'كريم حسين', currentBalance: 52563),
  ];

  initItemsData() async {
    List<ItemModel> l = await getAllItems();
    if (l.isEmpty) {
      var dbClient = _database;
      models.forEach((element) async {
        if (dbClient != null)
          await dbClient.insert('$itemTableName', element.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace);
      });
    models.forEach((element) {
      print('********************************************************************************');
      print(element.unitName);
      print(element.itemNumber);
      print(element.conversionFactor);
      print('********************************************************************************');

    });
    }
    List<ReceiptModel> x=await getAllReceipts();
    if(x.isEmpty){
      // await Hive.openBox(constBoxName);
      // int startValue=constBox.get(startValueName);
      // await DatabaseHelper.db.insertReceipt(ReceiptModel(
      //     receiptId: startValue,
      //     fAccountId: 2,
      //     type: 'return',
      //     netReceipt: 500,
      //     bankPayment: 44,
      //     rest: 55,
      //     cashPayment: 45,
      //     tax: 78,
      //     addition: 54,
      //     discount: 89,
      //     total: 500,
      //     saveDate: '45',
      //     saveTime: '12',
      //     startDate: '15',
      //     startTime: '44'));
      //
      // await DatabaseHelper.db.deleteReceipt(startValue);
    }

  }

  initAccData() async {
    List<AccountModel> l = await getAllAccounts();
    if (l.isEmpty) {
      var dbClient = _database;
      accModels.forEach((element) async {
        if (dbClient != null)
          await dbClient.insert('$accountTableName', element.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace);
      });
      print("acc ins");
    }
  }

  insertReceiptItem(ReceiptItemModel model) async {
    var dbClient = _database;
    if (dbClient != null)
      await dbClient.insert('$receiptItemTableName', model.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
  }

  insertReceipt(ReceiptModel model) async {
    var dbClient = _database;
    if (dbClient != null)
      await dbClient.insert('$receiptTableName', model.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
  }

  insertItem(ItemModel model) async {
    var dbClient = _database;
    if (dbClient != null)
      await dbClient.insert('$itemTableName', model.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // updateItem(ItemModel item)async{
  //   var dbClient=await _database;
  //   await dbClient.update(itemTableName, item.toJson(),where: '$columnItemId = ?',whereArgs: [item.itemId]);
  // }

  Future<List<ItemModel>> getAllItems() async {
    var dbClient = await _database;
    if (dbClient != null) {
      List<Map<String, dynamic>> maps = await dbClient.query(itemTableName);

      return maps.isNotEmpty
          ? maps.map((item) {

            return ItemModel.fromJson(item);
          }).toList()
          : [];
    } else
      return [];
  }

  deleteItem(int itemID) async {
    var dbClient = await _database;
    if (dbClient != null)
      return await dbClient
          .delete(itemTableName, where: '$columnItemId=?', whereArgs: [itemID]);
  }

  deleteReceipt(int receiptID) async {
    var dbClient = await _database;
    if (dbClient != null)
      return await dbClient.delete(receiptTableName,
          where: '$columnReceiptId=?', whereArgs: [receiptID]);
  }

  insertAccount(AccountModel account) async {
    var dbClient = await _database;
    if (dbClient != null)
      await dbClient.insert('$accountTableName', account.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
  }

  updateAccBalance(double newBalance, int id) async {
    var dbClient = _database;
    if (dbClient != null)
      await dbClient.execute(
          'UPDATE $accountTableName SET $columnAccountCurrentBalance = $newBalance WHERE $columnAccountAccId = $id');
  }

  decreaseItemQuantity(double? soldQuantity, int? itemNumber) async {
    var dbClient = _database;
    if (dbClient != null)
      await dbClient.execute(
          'UPDATE $itemTableName SET $columnItemQuantity = $columnItemQuantity - $soldQuantity WHERE $columnItemNumber = $itemNumber');
  }

  decreaseItemReturnableQuantity(double? newReturnAbleQuantity, int? id) async {
    var dbClient = _database;
    if (dbClient != null) {
      print('99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999');
      print(newReturnAbleQuantity);
      print(id);
      print('99999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999');
//       List<Map<String, dynamic>> maps = await dbClient.query(
//           '''$receiptItemTableName WHERE $columnReceiptItemId==$id''');
//       ReceiptItemModel receiptItemModel =
//       maps.map((receipt) => ReceiptItemModel.fromJson(receipt)).toList()[0];
// print((receiptItemModel.receiptItemId!-1).toString()+'123dsf156sfd1463sgdf43sg15fd34sgf135132gsf32g1fdgfds123gfsd12');
      await dbClient.execute(
          'UPDATE $receiptItemTableName SET $columnReceiptItemReturnableQuantity = $newReturnAbleQuantity WHERE $columnReceiptItemId = ${id!}');
    }
  }
  decreaseItemFreeReturnableQuantity(double? newFreeReturnAbleQuantity, int? id) async {
    var dbClient = _database;
    if (dbClient != null) {
//       List<Map<String, dynamic>> maps = await dbClient.query(
//           '''$receiptItemTableName WHERE $columnReceiptItemId==$id''');
//       ReceiptItemModel receiptItemModel =
//       maps.map((receipt) => ReceiptItemModel.fromJson(receipt)).toList()[0];
// print((receiptItemModel.receiptItemId!-1).toString()+'123dsf156sfd1463sgdf43sg15fd34sgf135132gsf32g1fdgfds123gfsd12');
      await dbClient.execute(
          'UPDATE $receiptItemTableName SET $columnReceiptItemFreeReturnableQuantity = $newFreeReturnAbleQuantity WHERE $columnReceiptItemFNumber = $id');
    }
  }

  increaseItemQuantity(double? returnedQuantity, int? itemNumber) async {
    var dbClient = _database;
    if (dbClient != null)
      await dbClient.execute(
          'UPDATE $itemTableName SET $columnItemQuantity = $columnItemQuantity + $returnedQuantity WHERE $columnItemNumber = $itemNumber');
  }

  updateAccount(AccountModel account) async {
    var dbClient = _database;
    if (dbClient != null)
      await dbClient.update(accountTableName, account.toJson(),
          where: '$columnAccountAccId = ?', whereArgs: [account.accId]);
  }

  Future<List<AccountModel>> getAllAccounts() async {
    var dbClient = await _database;
    if (dbClient != null) {
      List<Map<String, dynamic>> maps = await dbClient.query(accountTableName);
      return maps.isNotEmpty
          ? maps.map((account) => AccountModel.fromJson(account)).toList()
          : [];
    } else
      return [];
  }



  Future<List<ReceiptModel>> getAllReceipts() async {
    var dbClient = await _database;
    if (dbClient != null) {
      List<Map<String, dynamic>> maps = await dbClient.query(receiptTableName);
      return maps.isNotEmpty
          ? maps.map((receipt) => ReceiptModel.fromJson(receipt)).toList()
          : [];
    } else
      return [];
  }

  Future<List<ReceiptItemModel>> findReceiptItems(int receiptId) async {
    var dbClient = await _database;
    if (dbClient != null) {
      List<Map<String, dynamic>> maps = await dbClient.query(
          '''$receiptItemTableName WHERE $columnReceiptItemFReceiptId==$receiptId''');
      return maps.isNotEmpty
          ? maps.map((receipt) => ReceiptItemModel.fromJson(receipt)).toList()
          : [];
    } else
      return [];
  }

  Future<List<AccountModel>> findAccounts(String searchWord) async {
    //l'%$searchWord%'
    var dbClient = await _database;
    if (dbClient != null) {
      List<Map<String, dynamic>> maps =
          await dbClient.query('''$accountTableName
   WHERE $columnAccountAccId LIKE '%$searchWord%'
    OR $columnAccountName LIKE '%$searchWord%'
    OR $columnAccountAccBarcode LIKE '%$searchWord%'
     ''');
      return maps.isNotEmpty
          ? maps.map((account) => AccountModel.fromJson(account)).toList()
          : [];
    } else
      return [];
  }
  // Future<List<ReceiptModel>> findReceiptJoin(String searchWord)async{
  //   List<ReceiptModel> results = [];
  //
  //   var dbClient = await _database;
  //
  //   if (dbClient != null){
  //     List<Map<String, dynamic>> map = await dbClient.rawQuery('''select $receiptTableName.$columnReceiptType,$accountTableName.$columnAccountName from $receiptTableName inner join $accountTableName on $columnAccountAccId=$columnReceiptFAccountId where $columnAccountName like $searchWord or $columnReceiptId like $searchWord ''');
  //     results = map.map((receipt) => ReceiptModel.fromJson(receipt)).toList();
  //     print(map);
  //     return results;
  //
  //   }
  //   else
  //
  //   return [];
  //
  //
  // }

  Future<List<ReceiptModel>> findReceipt(String searchWord) async {
    List<ReceiptModel> results = [];
    List<int?> accountsIDs = [];

    //l'%$searchWord%'
    List<ReceiptModel> allReceipts = await getAllReceipts();
    List<AccountModel> relatedAccounts = await findAccounts(searchWord);
    // String relatedAccountsIds='';
    relatedAccounts.forEach((element) {
      accountsIDs.add(element.accId);
    });
    print(accountsIDs.toString()+'asdasdasdgfasdgasdgasdgfas');
    var dbClient = await _database;
    if (dbClient != null) {
      List<Map<String, dynamic>> maps =
          await dbClient.query('''$receiptTableName
   WHERE $columnReceiptId LIKE '%$searchWord%'
     ''');
      //List<ReceiptModel>receipts=[];
      results = maps.map((account) => ReceiptModel.fromJson(account)).toList();
      print(results.length.toString()+' length');
      allReceipts.forEach((receipt) {
      for(int i=0;i<accountsIDs.length;i++){
          if (receipt.fAccountId == accountsIDs[i]) {
            if(results.contains(receipt)){
              continue;
            }
           else
           {
              results.add(receipt);
              print(receipt.receiptId.toString() +
                  '   ' +
                  accountsIDs[i].toString() +
                  ' ' +
                  'sadasdasda5454545454545454545454');
            }
          }
        }
      });
      print(results.length.toString()+' length');

      // relatedAccounts.forEach((account) {
      //   allReceipts.forEach((receipt) {
      //
      //     if(receipt.fAccountId==account.accId){
      //       if(!results.contains(receipt)){
      //         results.add(receipt);
      //       }
      //
      //     }
      //   });
      // });

      return results;
    } else
      return [];
  }


  Future<List<AccountModel>> findAccount(int? id) async {
    //l'%$searchWord%'
    var dbClient = await _database;
    if (dbClient != null) {
      List<Map<String, dynamic>> maps =
          await dbClient.query('''$accountTableName
   WHERE $columnAccountAccId == $id
     ''');
      List<AccountModel> accounts = maps.isNotEmpty
          ? maps.map((account) => AccountModel.fromJson(account)).toList()
          : [];
      print(accounts.length.toString() + '*//**/*/*//');
      return accounts;
    } else
      return [];
  }

  Future<List<ItemModel>> findItem(String searchWord) async {
    var dbClient = await _database;
    if (dbClient != null) {
      List<Map<String, dynamic>> maps = await dbClient
          .query('''$itemTableName WHERE $columnItemId LIKE '%$searchWord%'
    OR $columnItemName LIKE '%$searchWord%'
    OR $columnItemBarcode LIKE '%$searchWord%'
 ''');
      return maps.isNotEmpty
          ? maps.map((item) => ItemModel.fromJson(item)).toList()
          : [];
    } else
      return [];
  }

  Future<List<ItemModel>> findItemByBarcode(String searchWord) async {
    var dbClient = await _database;
    if (dbClient != null) {
      List<Map<String, dynamic>> maps =
          await dbClient.query('''$itemTableName WHERE 
     $columnItemBarcode = $searchWord
 ''');
      return maps.isNotEmpty
          ? maps.map((item) => ItemModel.fromJson(item)).toList()
          : [];
    } else
      return [];
  }
}

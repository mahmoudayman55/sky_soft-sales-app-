import 'package:skysoft/constants.dart';

class AccountModel {
  String? name,  note,  employCode, employName;
  double? currentBalance, maxCredit;
  int? defEmployAccId,
      priceId,
      barcode,
      waitDays,
      currencyId,
      costCenterId,
      branchId,
      userId,
      accId,
   payByCashOnly, stopped;



  AccountModel(
      {
      //string
      this.name,
      this.accId,
      this.note,
      this.barcode,
      this.employCode,
      this.employName,
      //double
      this.currentBalance,
      this.maxCredit,
      //int
      this.defEmployAccId,
      this.priceId,
      this.waitDays,
      this.currencyId,
      this.costCenterId,
      this.branchId,
      this.userId,
      //bool
       this.payByCashOnly,
       this.stopped});
toJson(){
  return{
//strings

 columnAccountName:name,
 columnAccountNote:note,
 columnAccountAccBarcode:barcode,
 columnAccountEmployCode:employCode,
 columnAccountEmployName:employName,

//double
  columnAccountCurrentBalance:currentBalance,
  columnAccountMaxCredit:maxCredit,

//int
  columnAccountDefEmployId:defEmployAccId,
  columnAccountPriceId:priceId,
  columnAccountWaitDays:waitDays,
  columnAccountCurrencyId:currencyId,
  columnAccountCostCenterId:costCenterId,
  columnAccountBranchId:branchId,
  columnAccountUserId:userId,

//boolean
  columnAccountPayByCashOnly:payByCashOnly,
  columnAccountStopped:stopped,
  };


}
  AccountModel.fromJson(Map<String,dynamic>map){

    //strings
    name=map[columnAccountName];
    accId=map[columnAccountAccId];
    note=map[columnAccountNote];
    barcode=map[columnAccountAccBarcode];
    employCode=map[columnAccountEmployCode];
    employName=map[columnAccountEmployName];

    //double
    currentBalance=map[columnAccountCurrentBalance];
    maxCredit=map[columnAccountMaxCredit];

    //int
    defEmployAccId=map[columnAccountDefEmployId];
    priceId=map[columnAccountPriceId];
    waitDays=map[columnAccountWaitDays];
    currencyId=map[columnAccountCurrencyId];
    costCenterId=map[columnAccountCostCenterId];
    branchId=map[columnAccountBranchId];
    userId=map[columnAccountUserId];

    //bool
    payByCashOnly=map[columnAccountPayByCashOnly];
    stopped=map[columnAccountStopped];


}

}

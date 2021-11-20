import '../constants.dart';

class ReceiptModel {

  int? receiptId, fAccountId;
  String? startDate,saveDate,startTime,saveTime,type,accountName;

  ReceiptModel(
  {   this.receiptId,
      this.fAccountId,
      this.startDate,
      this.saveDate,
      this.startTime,
      this.saveTime,
      this.total,
      this.discount,
      this.addition,
      this.tax,
      this.cashPayment,
      this.bankPayment,
      this.rest,
    this.accountName,
      this.netReceipt,
      this.type});

  double? total,
      discount,
      addition,
      tax,
      cashPayment,
      bankPayment,
      rest,
      netReceipt;

  toJson() {
    return {
      columnReceiptId: receiptId,
      columnReceiptType:type,
      columnReceiptStartDate: startDate,
      columnReceiptSaveDate: saveDate,
      columnReceiptStartTime: startTime,
      columnReceiptSaveTime: saveTime,
      columnReceiptTotal: total,
      columnReceiptDiscount: discount,
      columnReceiptAddition: addition,
      columnReceiptTax: tax,
      columnReceiptCashPayment: cashPayment,
      columnReceiptBankPayment: bankPayment,
      columnReceiptRest: rest,
      columnReceiptFAccountId: fAccountId,
      columnReceiptNetReceipt: netReceipt,


   //   columnAccountName:accountName
    };
  }

  ReceiptModel.fromJson(Map<String, dynamic> map) {
    receiptId = map[columnReceiptId];
    startDate = map[columnReceiptStartDate];
    saveDate = map[columnReceiptSaveDate];
    startTime = map[columnReceiptStartTime];
    saveTime = map[columnReceiptSaveTime];
    type = map[columnReceiptType];
    total = map[columnReceiptTotal];
    discount = map[columnReceiptDiscount];
    addition = map[columnReceiptAddition];
    tax = map[columnReceiptTax];
    cashPayment = map[columnReceiptCashPayment];
    bankPayment = map[columnReceiptBankPayment];
    rest = map[columnReceiptRest];
    fAccountId = map[columnReceiptFAccountId];
    netReceipt = map[columnReceiptNetReceipt];



  //  accountName=map[columnAccountName];
  }
}

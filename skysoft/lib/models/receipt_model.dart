import '../constants.dart';

class ReceiptModel {




  int? receiptId, fAccountId;
  String? date,time,type;

  ReceiptModel(
  {   this.receiptId,
      this.fAccountId,
      this.date,
      this.time,
      this.total,
      this.discount,
      this.addition,
      this.tax,
      this.cashPayment,
      this.bankPayment,
      this.rest,
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
      columnReceiptDate: date,
      columnReceiptTime: time,
      columnReceiptTotal: total,
      columnReceiptDiscount: discount,
      columnReceiptAddition: addition,
      columnReceiptTax: tax,
      columnReceiptCashPayment: cashPayment,
      columnReceiptBankPayment: bankPayment,
      columnReceiptRest: rest,
      columnReceiptFAccountId: fAccountId,
      columnReceiptNetReceipt: netReceipt,
    };
  }

  ReceiptModel.fromJson(Map<String, dynamic> map) {
    receiptId = map[columnReceiptId];
    date = map[columnReceiptDate];
    time = map[columnReceiptTime];
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
  }
}

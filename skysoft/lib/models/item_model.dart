import '../constants.dart';

class ItemModel {
  String? itemName, itemGroup,unitName;
  double? wholesalePrice, sellingPrice, avgPurchasePrice, lastPurchasePrice,itemQuantity=1,conversionFactor;
  int? itemId,itemBarcode,itemNumber;
  ItemModel(
      {

      this.itemName,//
      this.itemQuantity,//
      this.itemGroup,//
      this.wholesalePrice,//
      this.sellingPrice,
      this.avgPurchasePrice,
      this.lastPurchasePrice,
      this.conversionFactor=1,
      this.unitName='قطعة',
        this.itemNumber,

        this.itemBarcode});

setQuantityAndPrices(){
    this.itemQuantity=(this.itemQuantity!/this.conversionFactor!);
    sellingPrice=sellingPrice!*conversionFactor!;
    wholesalePrice    = wholesalePrice   ! *conversionFactor!;
    avgPurchasePrice=   avgPurchasePrice ! *conversionFactor!;
    lastPurchasePrice=  lastPurchasePrice! *conversionFactor!;
    print(itemQuantity.toString() +  '9999999999999999999999999999999999999999999999');
   // print((this.itemQuantity!/conversionFactor!));
  }

  toJson() {
    return {
      columnItemName: itemName,
      columnItemQuantity: itemQuantity,
    //!/conversionFactor!,
      columnItemGroup: itemGroup,
      columnItemUnitName:unitName,
      columnItemConversionFactor:conversionFactor,
      columnItemNumber:itemNumber,

      columnItemWholesalePrice: wholesalePrice     ,
      columnItemSellingPrice: sellingPrice       ,
      columnItemAvgPurchasePrice: avgPurchasePrice,
      columnItemLastPurchasePrice: lastPurchasePrice,
      columnItemBarcode: itemBarcode
    };

  }

  ItemModel.fromJson(Map<String,dynamic>map){
   itemName          =     map[ columnItemName              ];
   itemQuantity      =     map[ columnItemQuantity          ];
       // /  map[ columnItemConversionFactor];
   itemGroup         =     map[ columnItemGroup             ];
   wholesalePrice    =     map[ columnItemWholesalePrice    ]*  map[ columnItemConversionFactor];
   sellingPrice      =     map[ columnItemSellingPrice      ]*  map[ columnItemConversionFactor];
   avgPurchasePrice  =     map[ columnItemAvgPurchasePrice  ]*  map[ columnItemConversionFactor];
   lastPurchasePrice =     map[ columnItemLastPurchasePrice ]
   *  map[ columnItemConversionFactor];
   itemBarcode       =     map[ columnItemBarcode           ];
   itemId       =     map[ columnItemId           ];
   itemNumber       =     map[ columnItemNumber           ];
   conversionFactor       =     map[ columnItemConversionFactor];
   unitName      =     map[ columnItemUnitName           ];
// print(
//   'asdasdasdasdasdasdasdasdasd'
// );
 //  setQuantityAndPrices();


  }
}

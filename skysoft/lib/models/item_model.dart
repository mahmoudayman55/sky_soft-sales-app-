import '../constants.dart';

class ItemModel {
  String? itemName, itemGroup;
  double? wholesalePrice, sellingPrice, avgPurchasePrice, lastPurchasePrice;
  int? itemId,itemBarcode,itemQuantity=1;
  ItemModel(
      {this.itemName,//
      required this.itemQuantity,//
      this.itemGroup,//
      this.wholesalePrice,//
      this.sellingPrice,
      this.avgPurchasePrice,
      this.lastPurchasePrice,

      this.itemBarcode});

  toJson() {
    return {
      columnItemName: itemName,
      columnItemQuantity: itemQuantity,
      columnItemGroup: itemGroup,

      columnItemWholesalePrice: wholesalePrice,
      columnItemSellingPrice: sellingPrice,
      columnItemAvgPurchasePrice: avgPurchasePrice,
      columnItemLastPurchasePrice: lastPurchasePrice,


      columnItemBarcode: itemBarcode
    };
  }

  ItemModel.fromJson(Map<String,dynamic>map){
   itemName          =     map[ columnItemName              ];
   itemQuantity      =     map[ columnItemQuantity          ];
   itemGroup         =     map[ columnItemGroup             ];
   wholesalePrice    =     map[ columnItemWholesalePrice    ];
   sellingPrice      =     map[ columnItemSellingPrice      ];
   avgPurchasePrice  =     map[ columnItemAvgPurchasePrice  ];
   lastPurchasePrice =     map[ columnItemLastPurchasePrice ];
   itemBarcode       =     map[ columnItemBarcode           ];
   itemId       =     map[ columnItemId           ];



  }
}

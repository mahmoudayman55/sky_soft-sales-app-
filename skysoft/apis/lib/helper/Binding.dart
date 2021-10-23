import 'package:apis/core/view_models/devices_view_model.dart';
import 'package:apis/core/view_models/home_view_models.dart';
import 'package:get/get.dart';

class Binding extends Bindings{

  @override
  void dependencies() {
     Get.lazyPut(() => HomeViewModel(),fenix: true,);
     Get.lazyPut(() => DevicesViewModel(),fenix: true,);
    // Get.lazyPut(() => ItemsViewModel(),fenix: true);
    // Get.lazyPut(() => AccountViewModel(),fenix: true);
    // Get.lazyPut(() => ReceiptViewModel(),fenix: true);
    // Get.lazyPut(() => PreviousReceiptsViewModel(),fenix: true);


  }
}
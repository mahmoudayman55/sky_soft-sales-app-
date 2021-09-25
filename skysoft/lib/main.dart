import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skysoft/helper/Binding.dart';
import 'package:skysoft/view/add_item_view.dart';
import 'package:skysoft/view/home_view.dart';
import 'package:skysoft/view/item_view.dart';


//flutter run --release --no-sound-null-safety
//flutter run --no-sound-null-safety
//flutter build apk --no-sound-null-safety
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);
    runApp(MyApp());

}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(

      builder: () => GetMaterialApp(

        debugShowCheckedModeBanner: false,
        initialBinding: Binding(),
        home: HomeView(),
        theme: ThemeData(primarySwatch: Colors.blue),
      ),
    );
  }
}

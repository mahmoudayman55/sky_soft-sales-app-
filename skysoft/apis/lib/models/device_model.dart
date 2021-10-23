import 'package:apis/constants.dart';

class Device {
  String?icon, name,status;
  int? price,id;

  Device(this.icon,this.name,this.status,this.price);

  toJson(){
return {
  deviceName : name,
  devicePrice : price,
  deviceIcon : icon,
  deviceStatus : status

};
  }
}
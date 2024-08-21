import 'dart:developer';
import 'package:location/location.dart';

class OnOffGPS {
  static checkOnOffGPS() async {
    Location location = Location();
    bool ison = await location.serviceEnabled();
    if (!ison) {
      //if defvice is off
      bool isturnedon = await location.requestService();
      if (isturnedon) {
        log("GPS device is turned ON");
      } else {
        log("GPS Device is still OFF");
      }
    }
  }
}

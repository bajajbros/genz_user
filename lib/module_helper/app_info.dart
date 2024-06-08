import 'dart:developer';

import 'package:customer/module/direction_module.dart';
import 'package:flutter/cupertino.dart';

class AppInfo extends ChangeNotifier {
  Direction? userPickUpLocation, userDropOffLocation, driverLocation;
  bool navigate = false;

  void updatePickUpLocation(Direction userPickUp) {
    userPickUpLocation = userPickUp;
    notifyListeners();
  }

  void updateDropOffLocation( userDropOff) {
    userDropOffLocation = userDropOff;
    notifyListeners();
  }

  void updateDriverLocation(Direction driverLocation) {
    log('driver location updated');
    userDropOffLocation = driverLocation;
    notifyListeners();
  }

  void navigateWhenAccepted() {
    navigate = true;
    log('navigation gone from provider');
    notifyListeners();
  }
}

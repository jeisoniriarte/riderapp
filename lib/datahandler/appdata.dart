import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:riderapp/models/address.dart';

class AppData extends ChangeNotifier {
  Address pickUpLocation, dropOffLocation;

  void updatePickUpLocationAddress(Address pickUpAddress) {
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropOffAddress) {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}

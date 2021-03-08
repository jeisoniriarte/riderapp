import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:riderapp/Assistants/requestassistants.dart';
import 'package:riderapp/configmaps.dart';
import 'package:riderapp/datahandler/appdata.dart';
import 'package:riderapp/models/address.dart';
import 'package:riderapp/models/allusers.dart';
import 'package:riderapp/models/directdetails.dart';

class AssistantMethod {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    // String st1, st2, st3, st4;
    String st1, st2;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response = await RequestAssistant.getRequest(url);

    if (response != "Falló.") {
      placeAddress = response["results"][0]["formatted_address"];
      st1 = response["results"][0]["address_components"][0]["long_name"];
      st2 = response["results"][0]["address_components"][1]["long_name"];
      // st3 = response["results"][0]["address_components"][2]["long_name"];
      // st4 = response["results"][0]["address_components"][3]["long_name"];
      // placeAddress = st1 + ", " + st2 + ", " + st3 + ", " + st4;
      placeAddress = st1 + ", " + st2;

      Address userPickUpAddress = new Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }

    return placeAddress;
  }

  static Future<DirectionsDetails> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

    var res = await RequestAssistant.getRequest(directionUrl);

    if (res == "failed") {
      return null;
    }

    DirectionsDetails directionsDetails = DirectionsDetails();

    directionsDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];

    directionsDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
    directionsDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];

    directionsDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
    directionsDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];

    return directionsDetails;
  }

  static int calculateFares(DirectionsDetails directionsDetails) {
    //en terminos de Dólar
    double timeTraveledFare = (directionsDetails.durationValue / 60) * 0.20;
    double distancTraveledFare =
        (directionsDetails.durationValue / 1000) * 0.20;
    double totalFareAmount = timeTraveledFare + distancTraveledFare;

    //Moneda local
    //1$ = 44 UYU
    double totalLocalAmount = totalFareAmount * 44;

    return totalLocalAmount.truncate();
  }

  static void getCurrentOnlineUserInfo() async {
    // ignore: await_only_futures
    firebaseUser = await FirebaseAuth.instance.currentUser;
    String userId = firebaseUser.uid;
    DatabaseReference reference =
        FirebaseDatabase.instance.reference().child("users").child(userId);

    reference.once().then((DataSnapshot dataSnapShot) {
      if (dataSnapShot.value != null) {
        userCurrentInfo = Users.fromSnapshot(dataSnapShot);
      }
    });
  }
}

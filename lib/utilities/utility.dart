import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class Utility {
  static Utility utility;

  static Utility getInstance() {
    if (utility == null) {
      utility = Utility();
    }
    return utility;
  }

  showErrorAlertDialog(BuildContext context, String alertTitle, String alertMessage) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(alertTitle),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[Text(alertMessage)],
        ),
      ),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s) != null;
  }

  Future<bool> isInTheUk() async {
    try {
      var country = await getCountryName();
      return country == 'United Kingdom';
    } catch (e) {
      if (e.toString() == 'User denied permissions to access the device\'s location.') return false;
    }
    return false;
  }

  Future<String> getCountryName() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    return first.countryName;
  }
}

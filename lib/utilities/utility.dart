import 'package:betsquad/services/location_services.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

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
    Position position = await LocationServices.getCurrentLocation();
    Placemark place = await LocationServices.getAddressFromLatLng(position.latitude, position.longitude);
    return place != null && place.country == 'United Kingdom';
  }

  Future<String> getCountryName() async {
    print("get 3");

    Position position = await Geolocator.getLastKnownPosition();
    print(position);
    if (position == null) {
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    }
    print("pos:" + position.toString());
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("first");
    print(first);

    print("name");
    print(first.countryName);

    print("map");
    print(first.toMap());

    return first.countryName;
  }

  static String timeAgoSinceDate(DateTime date, {bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if (difference.inDays > 8) {
      return DateFormat('dd-MM-yyyy').format(date);
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }
}

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationServices {
  static Future<Position> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest,
        forceAndroidLocationManager:
        true);
    print(position);
    return position;
  }

  static Future<Placemark> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);
      print(placemarks);
      Placemark place = placemarks[0];
      return place;

    } catch (e) {
      print(e);
      return null;
    }
  }
}
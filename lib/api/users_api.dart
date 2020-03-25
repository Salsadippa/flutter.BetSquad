import 'package:betsquad/services/networking.dart';

class UsersApi {

  static Future<bool> usernameIsAvailable(String username) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var queryParameters = {
      'username': username,
    };
    var availableData = await networkHelper.getString(
        '/checkDuplicateUsername', queryParameters);
    return availableData == "available";
  }

  static Future searchForAddresses(String postcode) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.GOOGLE_APP_ENGINE);
    var queryParameters = {
      'postcode': postcode,
    };
    var results = await networkHelper.getJSON(
        '/findPostcode', queryParameters);
    return results;
  }

}

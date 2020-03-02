import 'package:betsquad/services/networking.dart';

class UsersApi {
  usernameIsAvailable(String username) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var queryParameters = {
      'username': username,
    };
    var availableData = await networkHelper.getString(
        '/checkDuplicateUsername', queryParameters);
    print(availableData);
    return availableData == "available";
  }
}

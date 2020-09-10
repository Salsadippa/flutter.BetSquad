import 'package:betsquad/services/networking.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersApi {

  static Future<bool> usernameIsAvailable(String username) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var queryParameters = {
      'username': username,
    };
    var availableData = await networkHelper.getString('/checkDuplicateUsername', queryParameters);
    return availableData == "available";
  }

  static Future searchForAddresses(String postcode) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.GOOGLE_APP_ENGINE);
    var queryParameters = {
      'postcode': postcode,
    };
    var results = await networkHelper.getJSON('/findPostcode', queryParameters);
    return results;
  }

  static Future getAllUsers() async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = await FirebaseAuth.instance.currentUser();
    var idToken = await user.getIdToken();
    Map allUsers = await networkHelper.getJSON('getAllUsers', {'idToken': idToken.token});
    return allUsers;
  }

  static Future<List> searchUsers(String query) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = await FirebaseAuth.instance.currentUser();
    var idToken = await user.getIdToken();
    var users = await networkHelper.getJSON('searchUsers', {'idToken': idToken.token, 'searchQuery': query});
    print(users);
    return users;
  }

  static Future sendFriendRequest(String friendId) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = await FirebaseAuth.instance.currentUser();
    var idToken = await user.getIdToken();
    var result = await networkHelper.getJSON('sendFriendRequest', {
      'idToken': idToken.token,
      'senderId': user.uid,
      'friendId': friendId,
    });
    return result;
  }

  static Future getFriendRequests() async{
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = await FirebaseAuth.instance.currentUser();
    var idToken = await user.getIdToken();
    var result = await networkHelper.getJSON('getFriendRequests', {
      'idToken': idToken.token,
      'senderId': user.uid,
    });
    return result;
  }

  static Future acceptFriendRequest(String friendId) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = await FirebaseAuth.instance.currentUser();
    var idToken = await user.getIdToken();
    var result = await networkHelper.getJSON('acceptFriendRequest', {
      'idToken': idToken.token,
      'senderId': user.uid,
      'friendId': friendId,
    });
    return result;
  }

}

import 'dart:convert';

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

  static Future declineFriendRequest(String friendId) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = await FirebaseAuth.instance.currentUser();
    var idToken = await user.getIdToken();
    var result = await networkHelper.getJSON('declineFriendRequest', {
      'idToken': idToken.token,
      'senderId': user.uid,
      'friendId': friendId,
    });
    return result;
  }

  static Future<Map> getSquadInfo(String squadId) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = await FirebaseAuth.instance.currentUser();
    var idToken = await user.getIdToken();
    var result = await networkHelper.getJSON('getSquadInfo', {
      'idToken': idToken.token,
      'squadId': squadId,
    });
    return result;
  }

  static Future<Map> setSquadInfo(String squadId, Map squad) async {
    print(squadId);
    print(squad);
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = await FirebaseAuth.instance.currentUser();
    var idToken = await user.getIdToken();
    var result = await networkHelper.getJSON('setSquadInfo', {
      'idToken': idToken.token,
      'senderId': user.uid,
      'squadId': squadId,
      'squad': json.encode(squad),
    });
    return result;
  }

  static Future<List> getFriends(List friendIds) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = await FirebaseAuth.instance.currentUser();
    var idToken = await user.getIdToken();
    var result = await networkHelper.getJSON('getFriends', {
      'idToken': idToken.token,
      'friendIds': json.encode(friendIds),
    });
    return result;
  }

  static Future<Map> checkLimitsLastUpdate() async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = await FirebaseAuth.instance.currentUser();
    var idToken = await user.getIdToken();
    var result = await networkHelper.getJSON('checkLimitsLastUpdate', {
      'idToken': idToken.token,
      'senderId': user.uid,
    });
    return result;
  }

  static Future<Map> checkUserHasAmlCheck() async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = await FirebaseAuth.instance.currentUser();
    var idToken = await user.getIdToken();
    var result = await networkHelper.getJSON('userHasAmlCheck', {
      'idToken': idToken.token,
      'senderId': user.uid,
    });
    return result;
  }

  static Future<Map> checkValidDeposit(double amount) async {
    print(amount);
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.GOOGLE_APP_ENGINE);
    var user = await FirebaseAuth.instance.currentUser();
    var idToken = await user.getIdToken();
    var result = await networkHelper.getJSON('despositAmountForUser', {
      'idToken': idToken.token,
      'userID': user.uid,
      'amount': amount.toString()
    });
    return result;
  }

  static Future<List> getUsersTransactions() async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = await FirebaseAuth.instance.currentUser();
    var idToken = await user.getIdToken();
    var result = await networkHelper.getJSON('getUsersTransactions', {
      'idToken': idToken.token,
      'senderId': user.uid,
    });
    return result;
  }

  static Future<Map> getProfileDetails() async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = await FirebaseAuth.instance.currentUser();
    var idToken = await user.getIdToken();
    var result = await networkHelper.getJSON('getProfileDetails', {
      'idToken': idToken.token,
      'senderId': user.uid,
    });
    return result;
  }

  static Future<Map> saveProfileDetails({String firstName, String lastName, String username, String email, String dob,
      String building, String street, String city, String county, String postcode, String phoneNumber}) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = await FirebaseAuth.instance.currentUser();
    var idToken = await user.getIdToken();
    var userDetails = {
      'idToken': idToken.token,
      'senderId': user.uid,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'dob': dob,
      'building': building,
      'street': street,
      'city': city,
      'county': county,
      'postcode':  postcode,
      'phoneNumber': phoneNumber
    };
    var result = await networkHelper.getJSON('saveProfileDetails', userDetails);
    return result;
  }

  static Future<Map> selfExclusion(int exclusionPeriod) async{
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = await FirebaseAuth.instance.currentUser();
    var idToken = await user.getIdToken();
    var userDetails = {
      'idToken': idToken.token,
      'email': user.email.replaceAll('.', ''),
      'exclusionPeriod': exclusionPeriod
    };
    var result = await networkHelper.getJSON('selfExclusion', userDetails);
    return result;
  }

}


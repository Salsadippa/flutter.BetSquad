import 'package:betsquad/services/networking.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatApi {

  static Future<Map> markChatAsRead({String chatId, String chatType}) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var queryParameters = {
      'senderId': FirebaseAuth.instance.currentUser.uid,
      'chatId': chatId,
      'chatType': chatType
    };
    var response = await networkHelper.getJSON('/markChatAsRead', queryParameters);
    // print(response);
    return response;
  }

  static Future<Map> newChatMessage({String chatId, String chatType, String message}) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var queryParameters = {
      'senderId': FirebaseAuth.instance.currentUser.uid,
      'chatId': chatId,
      'chatType': chatType,
      'chatMessage': message
    };
    var response = await networkHelper.getJSON('/newChatMessage', queryParameters);
    // print(response);
    return response;
  }

  static Future<Map> openChat({String talkingTo}) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var queryParameters = {
      'senderId': FirebaseAuth.instance.currentUser.uid,
      'talkingTo': talkingTo,
    };
    var response = await networkHelper.getJSON('/openChat', queryParameters);
    // print(response);
    return response;
  }

  static Future<Map> showChat({String chatId, String chatType}) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var queryParameters = {
      'senderId': FirebaseAuth.instance.currentUser.uid,
      'chatId': chatId,
      'chatType': chatType
    };
    var response = await networkHelper.getJSON('/showChat', queryParameters);
    // print(response);
    return response;
  }

  static Future<Map> deleteChat({String chatId, String chatType}) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var queryParameters = {
      'senderId': FirebaseAuth.instance.currentUser.uid,
      'chatId': chatId,
      'chatType': chatType
    };
    var response = await networkHelper.getJSON('/deleteChat', queryParameters);
    // print(response);
    return response;
  }

  static Future<Map> openSquadChat({String squadId}) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var queryParameters = {
      'senderId': FirebaseAuth.instance.currentUser.uid,
      'squadId': squadId,
    };
    var response = await networkHelper.getJSON('/openSquadChat', queryParameters);
    // print(response);
    return response;
  }

}


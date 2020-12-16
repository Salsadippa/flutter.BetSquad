import 'package:betsquad/services/networking.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatApi {

  static Future<Map> openChat({String talkingTo}) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var queryParameters = {
      'senderId': FirebaseAuth.instance.currentUser.uid,
      'talkingTo': talkingTo,
    };
    var response = await networkHelper.getJSON('/openChat', queryParameters);
    print(response);
    return response;
  }

  static Future<Map> openSquadChat({String squadId}) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var queryParameters = {
      'senderId': FirebaseAuth.instance.currentUser.uid,
      'squadId': squadId,
    };
    var response = await networkHelper.getJSON('/openSquadChat', queryParameters);
    print(response);
    return response;
  }

}


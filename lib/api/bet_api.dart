import 'dart:convert';
import 'package:betsquad/models/bet.dart';
import 'package:betsquad/services/firebase_services.dart';
import 'package:betsquad/services/networking.dart';
import 'package:betsquad/services/push_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BetApi {
  Future<Map> sendH2HBet(Bet bet) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = FirebaseAuth.instance.currentUser;
    var idToken = await user.getIdToken();
    Map<String, String> queryParameters = {
      'matchPath': '${bet.match.date}/${bet.match.homeTeamName}',
      'senderId': bet.from,
      'betTotal': bet.amount.toString(),
      'vsUserId': bet.vsUserID,
      'drawBet': bet.drawBet == BetOption.Positive
          ? 'true'
          : bet.drawBet == BetOption.Negative
              ? 'false'
              : 'neutral',
      'homeBet': bet.homeBet == BetOption.Positive ? 'true' : 'false',
      'awayBet': bet.awayBet == BetOption.Positive ? 'true' : 'false',
      'idToken': idToken
    };

    var response = await networkHelper.getJSON('/newH2HBet', queryParameters);
    return response;
  }

  Future<Map> sendNGSBet(Bet bet, List<dynamic> invitedUsers, List<dynamic> invitedSquads) async {
    List<Map<String, String>> invited = [];
    for (var user in invitedUsers) {
      invited.add({'username': user['username'], 'messagingToken': user['messagingToken'], 'uid': user['uid']});
    }
    var user = FirebaseAuth.instance.currentUser;
    var idToken = await user.getIdToken();

    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    Map<String, String> queryParameters = {
      'matchPath': '${bet.match.date}/${bet.match.homeTeamName}',
      'senderId': bet.from,
      'betTotal': (bet.amount * int.parse(bet.rollovers)).toStringAsFixed(2),
      'betAmount': bet.amount.toStringAsFixed(2),
      'invited': json.encode(invited),
      'maxRollovers': bet.rollovers,
      'idToken': idToken,
      'invitedSquads': json.encode(invitedSquads)
    };

    var response = await networkHelper.getJSON('/newNGSBet', queryParameters);

    if (response['result'] == 'success') {
      PushNotificationsManager().firebaseMessaging.subscribeToTopic(response['betId']);
    }

    return response;
  }

  Future<Map> additionalNGSInvites(Bet bet, List invitedUsers, List invitedSquads) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = FirebaseAuth.instance.currentUser;
    var idToken = await user.getIdToken();
    Map<String, String> queryParameters = {
      'senderId': user.uid,
      'betId': bet.id,
      'invitedUsers': json.encode(invitedUsers),
      'invitedSquads': json.encode(invitedSquads),
      'matchPath': '${bet.match.date}/${bet.match.homeTeamName}',
      'idToken': idToken
    };

    print(queryParameters);
    var response = await networkHelper.getJSON('/additionalNGSInvites', queryParameters);
    return response;
  }

  Future<Map> acceptH2HBet(Bet bet) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = FirebaseAuth.instance.currentUser;
    var idToken = await user.getIdToken();
    Map<String, String> queryParameters = {
      'senderId': bet.from,
      'betId': bet.id,
      'homeTeamName': bet.match.homeTeamName,
      'awayTeamName': bet.match.awayTeamName,
      'opponentBetId': bet.opponentId,
      'idToken': idToken
    };

    var response = await networkHelper.getJSON('/acceptH2HBet', queryParameters);
    return response;
  }

  Future<Map> declineH2HBet(Bet bet) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = FirebaseAuth.instance.currentUser;
    var idToken = await user.getIdToken();
    Map<String, String> queryParameters = {
      'senderId': bet.from,
      'betId': bet.id,
      'opponentBetId': bet.opponentId,
      'homeTeamName': bet.match.homeTeamName,
      'awayTeamName': bet.match.awayTeamName,
      'idToken': idToken
    };
    print(queryParameters);
    var response = await networkHelper.getJSON('/declineH2HBet', queryParameters);
    print(response);
    return response;
  }

  Future<Map> acceptNGSBet(Bet bet) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = FirebaseAuth.instance.currentUser;
    var idToken = await user.getIdToken();
    print(bet.amount);
    print(bet.rollovers);
    Map<String, String> queryParameters = {
      'senderId': user.uid,
      'betId': bet.id,
      'betTotal': (bet.amount * int.parse(bet.rollovers)).toStringAsFixed(2),
      'rollovers': bet.rollovers,
      'from': bet.from,
      'homeTeamName': bet.match.homeTeamName,
      'awayTeamName': bet.match.awayTeamName,
      'idToken': idToken
    };

    print(queryParameters);

    var response = await networkHelper.getJSON('/acceptNGSBet', queryParameters);

    if (response['result'] == 'success') {
      PushNotificationsManager().firebaseMessaging.subscribeToTopic(response['betId']);
    }

    return response;
  }

  Future<Map> declineNGSBet(Bet bet) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    var user = FirebaseAuth.instance.currentUser;
    var idToken = await user.getIdToken();
    Map<String, String> queryParameters = {'senderId': user.uid, 'betId': bet.id, 'idToken': idToken};

    var response = await networkHelper.getJSON('/declineNGSBet', queryParameters);
    return response;
  }

  Future<Map> withdrawNGSBet(Bet bet) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    User currentUser = await FirebaseServices().currentUser();
    String token = await currentUser.getIdToken();

    Map<String, String> queryParameters = {'senderId': currentUser.uid, 'betID': bet.id, 'idToken': token};

    var response = await networkHelper.getJSON('/withdrawNGSBet', queryParameters);
    return response;
  }

  Future<Map> withdrawH2HBet(Bet bet) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    User currentUser = await FirebaseServices().currentUser();
    String token = await currentUser.getIdToken();

    Map<String, String> queryParameters = {
      'userID': currentUser.uid,
      'betID': bet.id,
      'matchID': '${bet.match.date}/${bet.match.homeTeamName}',
      'opponentID': bet.opponentId,
      'betAmount': bet.amount.toString(),
      'detail': '${bet.match.homeTeamName} vs ${bet.match.awayTeamName}',
      'idToken': token
    };

    print(queryParameters);

    var response = await networkHelper.getJSON('/withdrawBet', queryParameters);
    return response;
  }
}

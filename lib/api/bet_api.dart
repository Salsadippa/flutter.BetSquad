import 'dart:convert';
import 'package:betsquad/models/bet.dart';
import 'package:betsquad/services/firebase_services.dart';
import 'package:betsquad/services/networking.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BetApi {

  Future<Map> sendH2HBet(Bet bet) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    Map<String,String> queryParameters = {
      'matchPath': '${bet.match.date}/${bet.match.homeTeamName}',
      'senderId': bet.from,
      'betTotal': bet.amount.toString(),
      'vsUserId': bet.vsUserID,
      'drawBet': bet.drawBet == BetOption.Positive ? 'true' : bet.drawBet == BetOption.Negative ? 'false' : 'neutral',
      'homeBet': bet.homeBet == BetOption.Positive ? 'true' : 'false',
      'awayBet': bet.awayBet == BetOption.Positive ? 'true' : 'false',
    };
    print(queryParameters);

    var response = await networkHelper.getJSON('/newH2HBet', queryParameters);
    print(response);
    return response;
  }

  Future<Map> sendNGSBet(Bet bet, List<dynamic> invitedUsers) async {
    List<Map<String,String>> invited = [];
    for (var user in invitedUsers){
      invited.add({'username': user['username'], 'messagingToken': user['messagingToken'], 'uid':
      user['uid']});
    }
    print(json.encode(invited));
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    Map<String,String> queryParameters = {
      'matchPath': '${bet.match.date}/${bet.match.homeTeamName}',
      'senderId': bet.from,
      'betTotal': (bet.amount * int.parse(bet.rollovers)).toStringAsFixed(2),
      'invited': json.encode(invited),
      'maxRollovers': bet.rollovers
    };
    print(queryParameters);

    var response = await networkHelper.getJSON('/newNGSBet', queryParameters);
    print(response);
    return response;
  }

  Future<Map> acceptH2HBet(Bet bet) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    Map<String,String> queryParameters = {
      'senderId': bet.from,
      'betId': bet.id,
      'homeTeamName': bet.match.homeTeamName,
      'awayTeamName': bet.match.awayTeamName
    };

    var response = await networkHelper.getJSON('/acceptH2HBet', queryParameters);
    return response;
  }

  Future<Map> declineH2HBet(Bet bet) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    Map<String,String> queryParameters = {
      'senderId': bet.from,
      'betId': bet.id,
      'opponentBetId': bet.opponentId,
      'homeTeamName': bet.match.homeTeamName,
      'awayTeamName': bet.match.awayTeamName,
    };

    var response = await networkHelper.getJSON('/declineH2HBet', queryParameters);
    return response;
  }

  Future<Map> acceptNGSBet(Bet bet) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    FirebaseUser currentUser = await FirebaseServices().currentUser();

    Map<String,String> queryParameters = {
      'senderId': currentUser.uid,
      'betId': bet.id,
      'betTotal': bet.amount.toString(),
      'rollovers': bet.rollovers,
      'from': bet.from,
      'homeTeamName': bet.match.homeTeamName,
      'awayTeamName': bet.match.awayTeamName
    };

    var response = await networkHelper.getJSON('/acceptNGSBet', queryParameters);
    return response;
  }

  Future<Map> declineNGSBet(Bet bet) async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.CLOUD_FUNCTIONS);
    FirebaseUser currentUser = await FirebaseServices().currentUser();

    Map<String,String> queryParameters = {
      'senderId': currentUser.uid,
      'betId': bet.id,
    };

    var response = await networkHelper.getJSON('/declineNGSBet', queryParameters);
    return response;
  }

}

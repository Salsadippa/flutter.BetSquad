import 'package:betsquad/models/bet.dart';
import 'package:betsquad/services/networking.dart';

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

}

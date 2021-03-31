import 'package:betsquad/services/networking.dart';
import 'package:betsquad/services/local_database.dart';

class MatchApi {

  getMatches() async {
    NetworkHelper networkHelper = NetworkHelper(BASE_URL.GOOGLE_APP_ENGINE);
    var matches = await networkHelper.getJSON('/matches', {});
    return matches;
  }

}

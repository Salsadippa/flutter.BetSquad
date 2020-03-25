import 'package:flutter/cupertino.dart';
import 'package:betsquad/models/match.dart';

class MatchData extends ChangeNotifier {
  Match selectedMatch;

  void updateSelectedMatch(Match match){
    selectedMatch = match;
    notifyListeners();
  }

}
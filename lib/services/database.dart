import 'package:betsquad/models/bet.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:betsquad/models/match.dart';

class DatabaseService {
  DatabaseReference databaseReference;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  DatabaseService() {
    databaseReference = FirebaseDatabase.instance.reference();
  }

  Future<Match> getMatch(String matchPath) async {
    var m = await databaseReference.child('sm_matches').child(matchPath).once();
    var mVal = m.value;
    var match = Match.fromFirebaseDict(mVal);
    match.homeShirtColor = await getTeamColours(match.homeTeamName);
    match.awayShirtColor = await getTeamColours(match.awayTeamName);
    return match;
  }

  Future<String> getTeamColours(String teamName) async {
    var colours = await databaseReference.child('team_colours').child(teamName).child('colour').once();
    return colours.value ?? '#FFFFFF';
  }

  dynamic getUserBetHistory() async {
    Future<Map> getBet(String betId, String value) async {
      var b = await databaseReference.child('bets').child(betId).once();
      var bet = b.value;

      if (bet == null) {
        return null;
      }

      if (bet != null && bet['mode'] != 'custom' && bet['matchID'] != null) {
        var match = await getMatch(bet['matchID']);
        bet['match'] = match;
      }

      bet['id'] = betId;
      bet['userStatus'] = value;

      return bet;
    }

    var futures = <Future>[];
    Map<dynamic, dynamic> betIdList;
    User currentUser = getCurrentUser();
    await databaseReference.child('users').child(currentUser.uid).child('bets').once().then((DataSnapshot value) {
      betIdList = value.value;
      if (betIdList != null) {
        betIdList.forEach((key, value) async {
          futures.add(getBet(key, value));
        });
      }
    });

    if (futures.length == 0) {
      List<Bet> open = [], recent = [], closed = [];
      return [open, recent, closed];
    }

    var bets = await Future.wait(futures);
    bets.sort((a, b) => a['created'] > b['created']
        ? -1
        : a['created'] == b['created']
            ? 0
            : 1);
    List<Bet> open = [], recent = [], closed = [];
    var sevenDaysAgo = DateTime.now().subtract(Duration(days: 7)).millisecondsSinceEpoch;
    for (var i = 0; i < bets.length; i++) {
      var bet = bets[i];
      if (['ongoing', 'sent', 'received', 'reversal', 'requested', 'open'].contains(bet['status']) &&
          bet['userStatus'] != 'declined') {
        open.add(Bet.fromMap(bet));
      } else if (['won', 'lost', 'requested reversal', 'reversed'].contains(bet['status']) ||
          (bet['status'] == 'closed' && (bet['userStatus'] == 'won' || bet['userStatus'] == 'lost'))) {
        var created = bet['created'];
        if (created > sevenDaysAgo) {
          recent.add(Bet.fromMap(bet));
        } else {
          closed.add(Bet.fromMap(bet));
        }
      } else {
        closed.add(Bet.fromMap(bet));
      }
    }
    return [open, recent, closed];
  }

  User getCurrentUser() {
    User user = _firebaseAuth.currentUser;
    return user;
  }

  Future<String> getUserProfilePicture(String uid) async {
    String img;
    await databaseReference.child('users').child(uid).child('image').once().then((value) => img = value.value);
    return img;
  }

  Future<String> getUserUsername(String uid) async {
    String username;
    await databaseReference.child('users').child(uid).child('username').once().then((value) => username = value.value);
    return username;
  }

  Future<void> updateMessagingToken(String messagingToken) async {
    User currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || messagingToken == null) return;
    print(messagingToken);
    return await databaseReference.child('users').child(currentUser.uid).child('messagingToken').set(messagingToken);
  }
}

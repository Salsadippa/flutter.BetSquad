import 'dart:core';
import 'match.dart';

enum BetOption { Positive, Neutral, Negative }

class Bet {
  Match match;
  double amount, holding;
//  bool rolloversEnabled;
  String name, vsUserID, vsUsername, status, id, opponentId, mode, from,
//      rollovers,
      userStatus;
  int createdAt, priority, numTickets;
  Map<dynamic, dynamic> accepted, assignments, invited, winners, invitedSquads;
  BetOption drawBet, homeBet, awayBet;

  Bet(
      {this.match,
      this.amount,
      this.holding,
      this.homeBet,
      this.awayBet,
      this.drawBet,
//      this.rolloversEnabled,
      this.name,
      this.vsUserID,
      this.vsUsername,
      this.status,
      this.id,
      this.opponentId,
      this.mode,
      this.from,
//      this.rollovers,
      this.userStatus,
      this.createdAt,
      this.priority,
      this.numTickets,
      this.invited,
      this.accepted,
      this.assignments,
      this.winners,
      this.invitedSquads});

  factory Bet.fromMap(Map<dynamic, dynamic> json) {
    return Bet(
        id: json['id'],
        invitedSquads: json['invitedSquads'],
        mode: json['mode'],
        amount: json['amount'] != null ? double.parse(json['amount'].toString()) : 0.0,
        holding: json['holding'] != null ? double.parse(json['holding'].toString()) : 0.0,
//        rolloversEnabled: json['rolloversEnabled'],
        name: json['name'],
        vsUserID: json['vs'],
        vsUsername: json['vsUsername'],
        status: json['status'],
        opponentId: json['opponentId'],
        from: json['from'],
//        rollovers: json['rollovers'],
        userStatus: json['userStatus'],
        createdAt: json['created'],
        numTickets: json['numTickets'],
        accepted: json['accepted'] ?? {},
        assignments: json['currentAssignments'] ?? {},
        winners: json['winners'] ?? {},
        invited: json['invited'] ?? {},
        match: json['match'],
        awayBet: json['awayBet'] == true
            ? BetOption.Positive
            : json['awayBet'] == false ? BetOption.Negative : BetOption.Neutral,
        homeBet: json['homeBet'] == true
            ? BetOption.Positive
            : json['homeBet'] == false ? BetOption.Negative : BetOption.Neutral,
        drawBet: json['drawBet'] == "true"
            ? BetOption.Positive
            : json['drawBet'] == "false" ? BetOption.Negative : BetOption.Neutral);
  }

  @override
  String toString() {
    return '${this.mode}, ${this.amount}, ${this.match}';
  }
}

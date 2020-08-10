import 'dart:core';
import 'match.dart';

enum BetOption { Positive, Neutral, Negative }

class Bet {
  Match match;
  double amount, holding;
  bool rolloversEnabled;
  String name, vsUserID, vsUsername, status, id, opponentId, mode, from, rollovers, userStatus;
  int createdAt, priority, numTickets;
  Map<dynamic, dynamic> invited, accepted, assignments;
  BetOption drawBet, homeBet, awayBet;

  Bet(
      {this.match,
      this.amount,
      this.holding,
      this.homeBet = BetOption.Neutral,
      this.awayBet = BetOption.Neutral,
      this.drawBet = BetOption.Neutral,
      this.rolloversEnabled,
      this.name,
      this.vsUserID,
      this.vsUsername,
      this.status,
      this.id,
      this.opponentId,
      this.mode,
      this.from,
      this.rollovers,
      this.userStatus,
      this.createdAt,
      this.priority,
      this.numTickets,
      this.invited,
      this.accepted,
      this.assignments});

  factory Bet.fromMap(Map<dynamic, dynamic> json) => Bet(
      id: json['id'],
      mode: json['mode'],
      amount: json['amount'] != null ? double.parse(json['amount'].toString()) : 0.0,
      holding: json['holding'] != null ? double.parse(json['holding'].toString()) : 0.0,
      rolloversEnabled: json['rolloversEnabled'],
      name: json['name'],
      vsUserID: json['vs'],
      vsUsername: json['vsUsername'],
      status: json['status'],
      opponentId: '',
      from: json['from'],
      rollovers: json['rollovers'],
      userStatus: json['userStatus'],
      createdAt: json['created'],
      numTickets: json['numTickets'],
      accepted: json['accepted'] ?? {},
      invited: json['invited'] ?? {},
      match: json['match']);

  @override
  String toString() {
    return '${this.mode}, ${this.amount}, ${this.match}';
  }
}

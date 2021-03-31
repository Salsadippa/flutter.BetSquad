import 'package:betsquad/models/event.dart';

class Card implements Event {
  final int id, minute, playerId, matchId;
  final String cardType, player, side;
  final eventType = 'card';

  Card({this.id, this.minute, this.playerId, this.matchId, this.cardType, this.player, this.side});

  factory Card.fromMap(Map<String, dynamic> json) => Card(
      id: json['id'],
      minute: json['minute'],
      playerId: json['playerId'],
      matchId: json['matchId'],
      cardType: json['cardType'],
      player: json['player'],
      side: json['side']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'minute': minute,
      'playerId': playerId,
      'matchId': matchId,
      'cardType': cardType,
      'player': player,
      'side': side
    };
  }

  @override
  String toString() {
    return 'Card{id: $matchId/$player/$minute}';
  }
}

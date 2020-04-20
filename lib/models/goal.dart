import 'package:betsquad/models/event.dart';

class Goal implements Event{
  final int id, minute, playerId, matchId;
  final String type, scoringPlayer, side;
  final eventType = 'goal';

  Goal({this.id, this.minute, this.playerId, this.matchId, this.type, this.scoringPlayer, this.side});

  factory Goal.fromMap(Map<String, dynamic> json) => Goal(
      id: json['id'],
      minute: json['minute'],
      playerId: json['playerId'],
      matchId: json['matchId'],
      type: json['type'],
      scoringPlayer: json['scoringPlayer'],
      side: json['side']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'minute': minute,
      'playerId': playerId,
      'matchId': matchId,
      'type': type,
      'scoringPlayer': scoringPlayer,
      'side': side
    };
  }

  @override
  String toString() {
    return 'Goal{id: $matchId/$scoringPlayer/$minute}';
  }
}

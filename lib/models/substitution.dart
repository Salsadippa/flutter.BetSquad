import 'package:betsquad/models/event.dart';

class Substitution implements Event {
  final int id, minute, playerInId, playerOutId, matchId;
  final String playerIn, playerOut, side;
  final eventType = 'sub';

  Substitution(
      {this.id, this.minute, this.playerInId, this.playerOutId, this.matchId, this.playerIn, this.playerOut, this
          .side});

  factory Substitution.fromMap(Map<String, dynamic> json) => Substitution(
      id: json['id'],
      minute: json['minute'],
      playerInId: json['playerInId'],
      playerOutId: json['playerOutId'],
      playerIn: json['playerIn'],
      playerOut: json['playerOut'],
      matchId: json['matchId'],
      side: json['side']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'minute': minute,
      'playerInId': playerInId,
      'playerOutId': playerOutId,
      'playerIn': playerIn,
      'playerOut': playerOut,
      'matchId': matchId,
      'side': side
    };
  }

  @override
  String toString() {
    return 'Sub{id: $matchId/$playerIn/$playerOut/$minute}';
  }
}

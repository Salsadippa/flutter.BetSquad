abstract class Event {

  final int id, matchId, minute;
  final String side;
  final eventType = '';

  Event(this.id, this.matchId, this.minute, this.side);

}
class Match {
  final String awayShirtColor,
      homeShirtColor,
      competitionName,
      date,
      homeTeamName,
      awayTeamName,
      round,
      startTimestamp,
      venue;
  final int id,
      awayGoals,
      homeGoals,
      awayPenalties,
      homePenalties,
      competitionId,
      currentState,
      minute,
      nextState,
      lastPolled;

  Match({
    this.awayShirtColor,
    this.homeShirtColor,
    this.competitionName,
    this.date,
    this.homeTeamName,
    this.awayTeamName,
    this.id,
    this.round,
    this.startTimestamp,
    this.venue,
    this.awayGoals,
    this.homeGoals,
    this.awayPenalties,
    this.homePenalties,
    this.competitionId,
    this.currentState,
    this.minute,
    this.nextState,
    this.lastPolled,
  });

  factory Match.fromMap(Map<String, dynamic> json) =>
      Match(
          id: json['id'],
          awayShirtColor: json['awayShirtColor'],
          homeShirtColor: json['homeShirtColor'],
          competitionName: json['competitionName'],
          date: json['date'],
          homeTeamName: json['homeTeamName'],
          awayTeamName: json['awayTeamName'],
          round: json['round'],
          startTimestamp: json['startTimestamp'].toString(),
          venue: json['venue'],
          awayGoals: json['awayGoals'],
          homeGoals: json['homeGoals'],
          awayPenalties: json['awayPenalties'],
          homePenalties: json['homePenalties'],
          competitionId: json['competitionId'],
          currentState: json['currentState'],
          minute: json['minute'],
          nextState: json['nextState'],
          lastPolled: json['lastPolled']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'awayShirtColor': awayShirtColor,
      'homeShirtColor': homeShirtColor,
      'competitionName': competitionName,
      'date': date,
      'homeTeamName': homeTeamName,
      'awayTeamName': awayTeamName,
      'round': round,
      'venue': venue,
      'awayGoals': awayGoals,
      'homeGoals': homeGoals,
      'awayPenalties': awayPenalties,
      'homePenalties': homePenalties,
      'competitionId': competitionId,
      'currentState': currentState,
      'minute': minute,
      'nextState': nextState,
      'lastPolled': lastPolled,
      'startTimestamp': startTimestamp
    };
  }

  @override
  String toString() {
    return 'Match{id: $date/$homeTeamName, awayTeam: $awayTeamName, homeGoals: $homeGoals, awayGoals: $awayGoals}';
  }
}
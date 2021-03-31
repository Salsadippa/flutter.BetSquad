import 'dart:async';
import 'dart:io';
import 'package:betsquad/models/card.dart';
import 'package:betsquad/models/goal.dart';
import 'package:betsquad/models/substitution.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import "package:collection/collection.dart";
import 'package:betsquad/models/match.dart';
import 'package:betsquad/models/event.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Betsquad.db");
    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db
          .execute("CREATE TABLE Matches(id INTEGER PRIMARY KEY NOT NULL, awayShirtColor TEXT, homeShirtColor TEXT, "
              "competitionName TEXT, date TEXT, homeTeamName TEXT, awayTeamName TEXT, round TEXT, venue TEXT, "
              "awayGoals INTEGER, homeGoals INTEGER, awayPenalties INTEGER, homePenalties INTEGER, competitionId "
              "INTEGER, currentState INTEGER, minute INTEGER, nextState INTEGER, lastPolled INTEGER, startTimestamp "
              "INTEGER, stage TEXT, stats TEXT, homeLineup TEXT, awayLineup TEXT, homeTeamId INTEGER, awayTeamId "
              "INTEGER)");
      await db.execute(
          "CREATE TABLE Goals(id INTEGER PRIMARY KEY NOT NULL, type TEXT, minute INTEGER, playerId INTEGER, scoringPlayer TEXT, side TEXT, matchId INTEGER)");
      await db.execute(
          "CREATE TABLE Substitutions(id INTEGER PRIMARY KEY NOT NULL, minute INTEGER, playerIn TEXT, playerInId INTEGER, playerOut TEXT, playerOutId INTEGER, side TEXT, matchId INTEGER)");
      await db.execute(
          "CREATE TABLE Cards(id INTEGER PRIMARY KEY NOT NULL, cardType TEXT, minute INTEGER, player TEXT, playerId INTEGER, side TEXT, matchId INTEGER)");
    });
  }

  insertMatch(Match newMatch) async {
    final db = await database;
    var raw = await db.insert('Matches', newMatch.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  insertGoal(Goal newGoal) async {
    final db = await database;
    var raw = await db.insert('Goals', newGoal.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  insertCard(Card newCard) async {
    final db = await database;
    var raw = await db.insert('Cards', newCard.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  insertSub(Substitution newSub) async {
    final db = await database;
    var raw = await db.insert('Substitutions', newSub.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  updateMatch(Match newMatch) async {
    final db = await database;
    var res = await db.update("Matches", newMatch.toMap(), where: "id = ?", whereArgs: [newMatch.id]);
    return res;
  }

  Future<Map<String, List<Match>>> getAllMatches() async {
    final db = await database;
    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('Matches');
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<Match> matches = List.generate(maps.length, (i) {
      return Match(
          id: maps[i]['id'],
          awayShirtColor: maps[i]['awayShirtColor'],
          homeShirtColor: maps[i]['homeShirtColor'],
          awayGoals: maps[i]['awayGoals'],
          awayPenalties: maps[i]['awayPenalties'],
          awayTeamName: maps[i]['awayTeamName'],
          competitionId: maps[i]['competitionId'],
          competitionName: maps[i]['competitionName'],
          currentState: maps[i]['currentState'],
          date: maps[i]['date'],
          homeGoals: maps[i]['homeGoals'],
          homePenalties: maps[i]['homePenalties'],
          homeTeamName: maps[i]['homeTeamName'],
          lastPolled: maps[i]['lastPolled'],
          minute: maps[i]['minute'],
          nextState: maps[i]['nextState'],
          round: maps[i]['round'],
          startTimestamp: maps[i]['startTimestamp'].toString(),
          venue: maps[i]['venue']);
    });
    return groupBy(matches, (Match match) => match.competitionName);
  }

  Future<Map<String, List<Match>>> getMatchesOnDate(DateTime date) async {
    final db = await database;
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    var res = await db.rawQuery("SELECT * FROM Matches WHERE date = ?", [formattedDate]);
    List<Match> list = res.isNotEmpty ? res.toList().map((m) => Match.fromMap(m)).toList() : null;
    return list != null ? groupBy(list, (Match match) => match.competitionName) : {};
  }

  deleteMatch(int id) async {
    final db = await database;
    return db.delete('Matches', where: 'id = ?', whereArgs: [id]);
  }

  deleteAllMatchesAndData() async {
    final db = await database;
    db.rawDelete('Delete from Matches');
    db.rawDelete('Delete from Goals');
    db.rawDelete('Delete from Cards');
    db.rawDelete('Delete from Substitutions');
  }

  Future<List<Event>> _getCards(int matchId) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM Cards WHERE matchId = ?", [matchId]);
    return res.isNotEmpty ? res.toList().map((c) => Card.fromMap(c)).toList() : null;
  }

  Future<List<Event>> _getGoals(int matchId) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM Goals WHERE matchId = ?", [matchId]);
    return res.isNotEmpty ? res.toList().map((g) => Goal.fromMap(g)).toList() : null;
  }

  Future<List<Event>> _getSubs(int matchId) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM Substitutions WHERE matchId = ?", [matchId]);
    return res.isNotEmpty ? res.toList().map((s) => Substitution.fromMap(s)).toList() : null;
  }

  Future<List<Event>> getAllEvents(int matchId) async {
    var values = await Future.wait([_getSubs(matchId), _getCards(matchId), _getGoals(matchId)]);
    List<Event> events = [];
    for (var i = 0; i < 3; i++) {
      if (values[i] != null)
        events.addAll([...values[i]]);
    }
    return events;
  }
}

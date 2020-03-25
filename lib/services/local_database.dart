import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import "package:collection/collection.dart";
import 'package:betsquad/models/match.dart';

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
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE Matches(id INTEGER PRIMARY KEY, awayShirtColor TEXT, homeShirtColor TEXT, competitionName TEXT, date TEXT, homeTeamName TEXT, awayTeamName TEXT, round TEXT, venue TEXT, awayGoals INTEGER, homeGoals INTEGER, awayPenalties INTEGER, homePenalties INTEGER, competitionId INTEGER, currentState INTEGER, minute INTEGER, nextState INTEGER, lastPolled INTEGER, startTimestamp INTEGER)");
    });
  }

  insertMatch(Match newMatch) async {
    final db = await database;
    var raw = await db.insert('Matches', newMatch.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return raw;
  }

  updateMatch(Match newMatch) async {
    final db = await database;
    var res = await db.update("Matches", newMatch.toMap(),
        where: "id = ?", whereArgs: [newMatch.id]);
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
    print("getting matches on " + formattedDate);
    var res = await db
        .rawQuery("SELECT * FROM Matches WHERE date = ?", [formattedDate]);
    print(res.length);
    List<Match> list = res.isNotEmpty
        ? res.toList().map((m) => Match.fromMap(m)).toList()
        : null;
    return list != null
        ? groupBy(list, (Match match) => match.competitionName)
        : {};
  }

  deleteMatch(int id) async {
    final db = await database;
    return db.delete('Matches', where: 'id = ?', whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete('Delete from Matches');
  }
}



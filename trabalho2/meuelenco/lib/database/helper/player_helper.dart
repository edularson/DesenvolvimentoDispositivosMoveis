import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/player_model.dart'; 

class PlayerHelper {
  static final PlayerHelper _instance = PlayerHelper.internal();
  factory PlayerHelper() => _instance;
  PlayerHelper.internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    } else {
      _db = await initDb();
      return _db!;
    }
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "playersDB.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newVersion) async {
      await db.execute(
          "CREATE TABLE $playerTable($idColumn INTEGER PRIMARY KEY, "
          "$nameColumn TEXT, "
          "$ageColumn INTEGER, "
          "$positionColumn TEXT, "
          "$nationalityColumn TEXT, "
          "$clubColumn TEXT, "
          "$shirtNumberColumn INTEGER, "
          "$dominantFootColumn TEXT, "
          "$marketValueColumn TEXT, "
          "$imgColumn TEXT, "
          "$ratingColumn REAL)"); 
    });
  }

  Future<Player> savePlayer(Player player) async {
    Database dbPlayer = await db;
    player.id = await dbPlayer.insert(playerTable, player.toMap());
    return player;
  }

  Future<Player?> getPlayer(int id) async {
    Database dbPlayer = await db;
    List<Map<String, dynamic>> maps = await dbPlayer.query(
      playerTable,
      columns: [ 
        idColumn, nameColumn, ageColumn, positionColumn,
        nationalityColumn, clubColumn, shirtNumberColumn,
        dominantFootColumn, marketValueColumn, imgColumn,
        ratingColumn 
      ],
      where: "$idColumn = ?",
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Player.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<Player?> getPlayerByName(String name) async {
    Database dbPlayer = await db;
    List<Map<String, dynamic>> maps = await dbPlayer.query(
      playerTable,
      columns: [ 
        idColumn, nameColumn, ageColumn, positionColumn,
        nationalityColumn, clubColumn, shirtNumberColumn,
        dominantFootColumn, marketValueColumn, imgColumn,
        ratingColumn 
      ],
      where: "$nameColumn = ?",
      whereArgs: [name],
    );
    if (maps.isNotEmpty) {
      return Player.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<Player>> getAllPlayers() async {
    Database dbPlayer = await db;
    List<Map<String, dynamic>> listMap = await dbPlayer.query(playerTable);
    List<Player> listPlayer = [];
    for (Map<String, dynamic> m in listMap) {
      listPlayer.add(Player.fromMap(m));
    }
    return listPlayer;
  }

  Future<int> deletePlayer(int id) async {
    Database dbPlayer = await db;
    return await dbPlayer.delete(
      playerTable,
      where: "$idColumn = ?",
      whereArgs: [id],
    );
  }

  Future<int> updatePlayer(Player player) async {
    Database dbPlayer = await db;
    return await dbPlayer.update(
      playerTable,
      player.toMap(),
      where: "$idColumn = ?",
      whereArgs: [player.id],
    );
  }

  Future close() async {
    Database dbPlayer = await db;
    dbPlayer.close();
  }
}
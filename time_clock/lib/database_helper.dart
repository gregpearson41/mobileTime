import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:time_clock/time_entry.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String documentsPath = await getDatabasesPath();
    String path = join(documentsPath, 'time_clock.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE time_entries(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clock_in_time TEXT,
        clock_out_time TEXT NULL
      )
      '''
    );
  }

  Future<int> insertTimeEntry(TimeEntry entry) async {
    final db = await database;
    return await db.insert('time_entries', entry.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<TimeEntry>> getTimeEntries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('time_entries');
    return List.generate(maps.length, (i) {
      return TimeEntry.fromMap(maps[i]);
    });
  }

  Future<int> updateTimeEntry(TimeEntry entry) async {
    final db = await database;
    return await db.update(
      'time_entries',
      {
        'clock_in_time': entry.clockInTime.toIso8601String(),
        'clock_out_time': entry.clockOutTime?.toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [entry.id],
    );
  }

  Future<int> deleteTimeEntry(int id) async {
    final db = await database;
    return await db.delete(
      'time_entries',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
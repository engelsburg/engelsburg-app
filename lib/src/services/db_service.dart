import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;

  static Future init() async {
    _db = await openDatabase(join(await getDatabasesPath(), 'data.db'),
        version: 1, onCreate: (db, v) {
      //Create all tables
      return db.execute(
          "CREATE TABLE IF NOT EXISTS articles(id INTEGER PRIMARY KEY, date INTEGER, link TEXT, title TEXT, content TEXT, mediaUrl TEXT, blurHash TEXT)");
    });
  }

  static void insert(
    DatabaseModel model, {
    ConflictAlgorithm? conflictAlgorithm,
  }) {
    _db!.insert(
      model.tableName(),
      model.toMap(),
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  static Future<List<T>> get<T extends DatabaseModel>(
    DatabaseModel model, {
    Paging? paging,
    String? orderBy,
    String? where,
    List<Object>? whereArgs,
  }) async {
    return (await _db!.query(
      model.tableName(),
      limit: paging == null ? null : paging.size,
      offset: paging == null ? null : paging.page * paging.size,
      orderBy: orderBy,
      where: where,
      whereArgs: whereArgs,
    ))
        .map((e) => model.parse(e) as T)
        .toList();
  }

  static void update(
    DatabaseModel model, {
    String? where,
    List<Object>? whereArgs,
  }) {
    _db!.update(model.tableName(), model.toMap(),
        where: where, whereArgs: whereArgs);
  }
}

abstract class DatabaseModel {
  Map<String, dynamic> toMap();

  DatabaseModel parse(Map<String, dynamic> json);

  String tableName();
}

class Paging {
  //Start -> 0 (First page)
  int _page;
  //Start -> 1
  int _size;

  Paging(this._page, this._size);

  int get page => _page;
  int get size => _size;
}

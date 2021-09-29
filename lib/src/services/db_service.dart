import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;

  static Future init() async {
    _db = await openDatabase(join(await getDatabasesPath(), 'data.db'),
        version: 1, onCreate: (db, v) {
      //Create all tables
      return db.execute(
          "CREATE TABLE IF NOT EXISTS articles(articleId INTEGER PRIMARY KEY, date INTEGER, link TEXT, title TEXT, content TEXT, contentHash TEXT, mediaUrl TEXT, blurHash TEXT, saved INTEGER)");
    });
  }

  static void insert(
    DatabaseModel model, {
    ConflictAlgorithm? conflictAlgorithm = ConflictAlgorithm.ignore,
  }) {
    _db!.insert(
      model.tableName(),
      model.toMap(),
      conflictAlgorithm: conflictAlgorithm,
    );
  }

  static Future<List<D>> getAll<D extends DatabaseModel>(
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
        .map((e) => model.parse(e) as D)
        .toList();
  }

  static Future<D?> get<D extends DatabaseModel>(
    DatabaseModel model, {
    Paging? paging,
    String? orderBy,
    String? where,
    List<Object>? whereArgs,
  }) async {
    final ret = (await _db!.query(
      model.tableName(),
      limit: paging == null ? null : paging.size,
      offset: paging == null ? null : paging.page * paging.size,
      orderBy: orderBy,
      where: where,
      whereArgs: whereArgs,
    ))
        .map((e) => model.parse(e) as D);

    return ret.isEmpty ? null : ret.first;
  }

  static void update(
    DatabaseModel model, {
    String? where,
    List<Object>? whereArgs,
    ConflictAlgorithm conflictAlgorithm = ConflictAlgorithm.replace,
  }) {
    _db!.update(model.tableName(), model.toMap(),
        where: where,
        whereArgs: whereArgs,
        conflictAlgorithm: conflictAlgorithm);
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

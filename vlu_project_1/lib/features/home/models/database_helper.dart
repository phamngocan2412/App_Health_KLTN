// ignore_for_file: no_leading_underscores_for_local_identifiers, avoid_print

import 'dart:async';
import 'package:sqflite/sqflite.dart';
import '../models/task.dart';

class DBHelper {
  Database? _db;
  final int _version = 8;
  final String _tableName = 'tasks';

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initDb();
      return _db;
    } else {
      return _db;
    }
  }

  Future<Database?> initDb() async {
    try {
      String _path = '${await getDatabasesPath()}tasks.db';
      _db = await openDatabase(_path,
          version: _version, onCreate: _onCreate, onUpgrade: _onUpgrade);

      print('----Database khởi tạo----');
    } catch (e) {
      print('----initDb phương thức lỗi = $e----');
    }
    return _db;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $_tableName(id INTEGER PRIMARY KEY,title TEXT,note TEXT,date TEXT,startTime TEXT,remind INTEGER,repeat TEXT,color INTEGER,isCompleted INTEGER);');
  }

  _onUpgrade(Database db, int oldversion, int newversion) {
    print('----Cập nhật----');
  }
  

  Future<int> insert(Task? task) async {
    Database? mydb = await db;
    print('----Insert----');

    return await mydb!.insert(_tableName, task!.toMap());
  }

  Future<int> delete(int id) async {
    Database? mydb = await db;
    print('----Delete----');

    return await mydb!.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    Database? mydb = await db;
    print('---Delete all---');
    return await mydb!.delete(_tableName);
  }



  Future<List<Map<String, Object?>>> query() async {
    Database? mydb = await db;
    print('----Query----');
    return await mydb!.query(_tableName);
  }

  Future<int> update(Task task) async {
    Database? mydb = await db;
    print('----Update----');
    
    return await mydb!.update(
      _tableName,
      task.toMap(), 
      where: 'id = ?', 
      whereArgs: [task.id], 
    );
  }



  Future<List<Map<String, Object?>>> queryByRepeat(String repeat) async {
    Database? mydb = await db;
    print('----Query by Repeat----');
    return await mydb!.query(
      _tableName,
      where: 'repeat = ?',
      whereArgs: [repeat],
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:local_database/models/student.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DbHelper{
  static DbHelper _dbHelper;
  static Database _db;

  DbHelper.internal();

  factory DbHelper(){
    if(_dbHelper == null) {
      _dbHelper = DbHelper.internal();
      return _dbHelper;
    }else {
      return _dbHelper;
    }
  }
  
  Future<Database> _getDb() async{
    if(_db == null) {
      _db = await initializeDb();
      return _db;
    }else {
      return _db;
    }
  }

  Future<Database> initializeDb() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path,"student.db");
    var db = openDatabase(dbPath,version: 1,onCreate: createDb);
    return db;
  }

  FutureOr<void> createDb(Database db, int version) async{
    await db.execute("CREATE TABLE student(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, isActive INTEGER)");
  }

  Future<int> insert(Student student) async{
    var db = await _getDb();
    var result = await db.insert("student", student.toMap());
    return result;
  }

  Future<List<Map>>getStudents() async{
    var db = await _getDb();
    var result = await db.query("student",orderBy: "name ASC");
    return result;
  }
  
  Future<int> update(Student student) async{
    var db = await _getDb();
    var result = await db.update("student", student.toMap(),where: "id=?",whereArgs: [student.id]);
    return result;
  }

  Future<int> delete(int id) async{
    var db = await _getDb();
    var result = await db.delete("student", where: "id = ?", whereArgs: [id]);
    return result;
  }
  
  Future<int> deleteTable() async{
    var db = await _getDb();
    var result = db.delete("student");
    return result;
  }
}
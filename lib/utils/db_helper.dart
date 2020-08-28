import 'dart:async';
import 'dart:io';

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
    var db = join(directory.path,"student.db");
    openDatabase(db,version: 1,onCreate: createDb);
  }

  FutureOr<void> createDb(Database db, int version) {
  }
}
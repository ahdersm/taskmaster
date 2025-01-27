import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskmaster/models/comman_methods.dart';
import 'package:taskmaster/models/storeitem.dart';
import 'package:taskmaster/models/task.dart';

class DatabaseService{
  Database? _database;
  String dbFile = "master_db.db";
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  Future<Database> get database async{
    if(_database != null){
      return _database!;
    }
    _database = await getDatabase();
    return _database!;
  }

  Future<Database> getDatabase() async{
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, dbFile);
    final database = await openDatabase(
      databasePath,
      version: 12,
      onCreate: create,
      singleInstance: true,
    );
    return database;
  }

  Future<void> create(Database database, int version) async {
    await TaskProvider().databaseCreate(database);
    await CommanMethodsProvider().databaseCreate(database);
    await StoreItemsProvider().databaseCreate(database);
  }

  static void delete() async{
    final databaseDirPath = await getDatabasesPath();
    databaseFactory.deleteDatabase(join(databaseDirPath, "master_db.db"));
  }
}
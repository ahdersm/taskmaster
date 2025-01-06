import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService{
  static final DatabaseService instance = DatabaseService._constructor();
  
  final String _tasksTableName = "tasks";

  DatabaseService._constructor()

  Future<Database> getDatabase() async{
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_tasksTableName (
        
        )
        '''
          
        );
      },
    );
  }
}
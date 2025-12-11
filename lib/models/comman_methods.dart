import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskmaster/models/task.dart';
import 'package:taskmaster/services/database_service.dart';

///   Everything in thie file is to keep consistent across the
///   application so there is not much that needs to be changed
const String tableName = 'CommandMethods';
const String idField = 'id';
const String dateCheckedField = 'DateChecked';
const String pointsField= 'points';


class CommanMethods{
  static const double appbarheight = 55;

  static const Color backgroundcolor = Color.fromARGB(255, 214, 228, 245);
  static const Color barcolor = Color.fromARGB(255, 123, 183, 209);
  static const Color tilecolor = Color.fromARGB(255, 164, 201, 223);
  static const Color selectorcolor = Color.fromARGB(255, 29, 100, 200);
  static const Color buttoncolor = Color.fromARGB(255, 74, 160, 196);

  final CommanMethodsProvider _cmp = CommanMethodsProvider();
  
  int? id;
  DateTime? _lastreset;
  int? _points;


  Map<String, dynamic> toMap(){
    Map<String, Object?> map = <String, dynamic>{
      dateCheckedField: _lastreset!.millisecondsSinceEpoch,
      pointsField : _points
    };
    if(id != null){
      map[idField] = id;
    }
    return map;
  }

  fromMap(Map<dynamic, dynamic>map){
    id = map[idField] as int?;
    _lastreset = DateTime.fromMillisecondsSinceEpoch(map[dateCheckedField]);
    _points = map[pointsField] ?? 0;
  }

  addPoints(int points) async{
    if(_points == null){
      _points == 0;
    }
    _points = _points! + points;
    await _cmp.updateSettings(this);
  }

  removePoints(int points) async {
    _points = _points! - points;
    await _cmp.updateSettings(this);
  }

  Future<int> getDBPoints() async {
    await _cmp.getSettings(this);
    return this._points!;
  }

  int getPoints(){
    return this._points!;
  }

  void getSettings() async{
    await _cmp.getSettings(this);
  }

  

  checkLastClear() async{
    if(_lastreset == null){
      if(await _cmp.checkSettings()){
        await _cmp.getSettings(this);
      }
      else{
        _lastreset = DateTime.now();
        await _cmp.createSettings(this.toMap());
        await _cmp.getSettings(this);
      }
    }
    if(_lastreset != null && _lastreset!.day == DateTime.now().day){
      return;
    }
    TaskProvider tprovider = TaskProvider();
    List<Task>? tasks = await tprovider.getAllTasks();
    if(tasks == null || tasks.isEmpty){
      return;
    }
    for(Task task in tasks){
      task.complete = false;
      tprovider.updateTask(task);
    }
    _lastreset = DateTime.now();
  }
}

class CommanMethodsProvider{
  
  
  Future<void> databaseCreate(Database database) async {
    await database.execute('''create table $tableName (
    $idField integer primary key autoincrement,
    $dateCheckedField integer,
    $pointsField integer
    )''');
  }

  Future<void> createSettings(Map<String, dynamic>map) async {
    final db = await DatabaseService.instance.database;
    await db.insert(tableName, map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> checkSettings() async {
    final db = await DatabaseService.instance.database;
    var result = await db.rawQuery('SELECT EXISTS(SELECT 1 FROM $tableName WHERE id=="1")');
    int? exists = Sqflite.firstIntValue(result);
    return exists == 1;
  }

  Future<CommanMethods?> getSettings(CommanMethods settings) async {
    final db = await DatabaseService.instance.database;
    List<Map> map = await db.query(tableName, 
      columns: [
        idField,
        dateCheckedField,
        pointsField,
      ],
      where: '$idField = ?',
      whereArgs: [1]
    );
    if(map.isNotEmpty){
      return settings.fromMap(map.first);
    }
    return null;
  }

  Future<int> updateSettings(CommanMethods settings) async {
    final db = await DatabaseService.instance.database;
    return await db.update(tableName, settings.toMap(),
      where: '$idField = ?',
      whereArgs: [settings.id]
    );
  }
}

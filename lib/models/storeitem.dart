import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskmaster/services/database_service.dart';

const String tableName = 'storeitems';

const String idField = 'id';
const String nameField = 'name';
const String descriptionfield = 'description';
const String costField = 'cost';
const String boughtField  = 'bought';

class StoreItem {
  int? id;
  String? name;
  String? description;
  int? cost;
  List<DateTime> boughtlist = [];

  Map<String, dynamic> toMap(){
    String datetimes = '';
    for(DateTime datetime in boughtlist){
      if(datetimes != ''){
        datetimes += ';';
      }
      datetimes += datetime.millisecondsSinceEpoch.toString();
    }
    Map<String, Object?> map = <String, dynamic>{
      nameField: name,
      descriptionfield: description,
      costField: cost,
      boughtField: datetimes
    };
    if(id != null){
      map[idField] = id;
    }
    return map;
  }

  StoreItem();

  StoreItem.fromMap(Map<dynamic, dynamic>map){
    if(map[boughtField] != null && map[boughtField] != ""){
      String completesstring = map[boughtField] as String;
      List<String> listcompletes = completesstring.split(";");
      for(String complete in listcompletes){
        boughtlist.add(DateTime.fromMillisecondsSinceEpoch(int.parse(complete)));
      }
    }
    else{
      boughtlist = [];
    }
    id = map[idField] as int;
    name = map[nameField] as String;
    description = map[descriptionfield] as String;
    cost = map[costField] as int;
  }

  void newstoreitem({String? name, String? description, int? cost}) {
    this.name = name;
    this.description = description;
    this.cost = cost;
  }

}

class StoreItemsProvider{
  Future<void> databaseCreate(Database database) async {
    await database.execute('''create table $tableName (
    $idField integer primary key autoincrement,
    $nameField String,
    $descriptionfield String,
    $costField integer,
    $boughtField String
    )''');
  }

  Future<void> createItem(StoreItem item) async {
    final db = await DatabaseService.instance.database;
    await db.insert(tableName, item.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<StoreItem>?> getItems() async {
    final db = await DatabaseService.instance.database;
    List<StoreItem> items = [];
    List<Map> maps = await db.query(tableName,
      columns:[
        idField,
        nameField,
        descriptionfield,
        costField,
      ],
    );
    if(maps.isEmpty){
      return null;
    }
    for(Map map in maps){
      items.add(StoreItem.fromMap(map));
    }
    return items;
  }

  Future<StoreItem?> getItem(StoreItem item) async {
    final db = await DatabaseService.instance.database;
    List<Map> map = await db.query(tableName, 
      columns: [
        idField,
        nameField,
        descriptionfield,
        costField,
      ],
      where: '$idField = ?',
      whereArgs: [item.id]
    );
    if(map.isNotEmpty){
      return StoreItem.fromMap(map.first);
    }
    return null;
  }

  Future<int> updateSettings(StoreItem item) async {
    final db = await DatabaseService.instance.database;
    return await db.update(tableName, item.toMap(),
      where: '$idField = ?',
      whereArgs: [item.id]
    );
  }
}
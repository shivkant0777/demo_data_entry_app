import 'package:demo_data_entry_app/src/models/item.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static  DatabaseHelper? _databaseHelper;    // Singleton DatabaseHelper
  static  Database? _database;                // Singleton Database

  String testTable = 'test_table';
  String colId = 'id';
  String colName = 'name';
  String colStatus = 'status';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper!;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'test.db';
    var todosDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return todosDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $testTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colStatus INTEGER DEFAULT 1)');
  }

  Future<List<Map<String, dynamic>>> getMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $testTable order by $colTitle ASC');
    var result = await db.query(testTable, orderBy: '$colId DESC' );
    return result;
  }
  Future<int> insertItem(Item item) async {
    Database db = await this.database;
    var result = await db.insert(testTable, item.toMap());
    return result;
  }

  Future<int> updateItem(Item item) async {
    var db = await this.database;
    var result = await db.update(testTable, item.toMap(), where: '$colId = ?', whereArgs: [item.id]);
    return result;
  }

  Future<int> deleteItem(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $testTable WHERE $colId = $id');
    return result;
  }


  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $testTable');
    int result = Sqflite.firstIntValue(x) ?? 0;
    return result;
  }

  Future<List<Item>> getItemList() async {

    var todoMapList = await getMapList();
    int count = todoMapList.length;
    List<Item> itemList = <Item>[];
    List<Item> itemList1 = <Item>[];
    List<Item> itemList2 = <Item>[];
    for (int i = 0; i < count; i++) {
      if(Item.fromMap(todoMapList[i]).status == 1) {
        itemList1.add(Item.fromMap(todoMapList[i]));
      }
      else{
        itemList2.add(Item.fromMap(todoMapList[i]));
      }

    }
    itemList.addAll(itemList1);
    itemList.addAll(itemList2);

    return itemList;
  }

}
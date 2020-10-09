import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{

  // define database name
  static final _databaseName = 'note_keeper_database.db';
  // define database version
  static final _databaseVersion = 1;

  // define table name
  static final table = 'notes';

  // define column fields
  static final noteId = 'noteId';
  static final noteTitle = 'noteTitle';
  static final noteContent = 'noteContent';

  // create database instance
  static Database _database;
  DatabaseHelper.privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  // get database
  Future<Database> get database async{
    if(_database != null) return _database;
    _database = await _initDatabase();
    return _database;

  }

  // define database path
  _initDatabase() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // create table in database
  Future _onCreate(Database db, int version) async{
    await db.execute(
      '''
      CREATE TABLE $table(
        $noteId INTEGER PRIMARY KEY,
        $noteTitle TEXT NOT NULL,
        $noteContent TEXT NOT NULL
      )
      '''
    );
  }

  // insert data into table
  Future<int> insert(Map<String, dynamic> row) async{
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // select all data from table
  Future<List<Map<String, dynamic>>> selectAll() async{
    Database db = await instance.database;
    return await db.query(table);
  }

  // select specific data
  Future<List<Map<String, dynamic>>> selectSpecific(String noteTitle) async{
    Database db = await instance.database;
    // var res = await db.query(table, where: "noteTitle = ?", whereArgs: [noteTitle]);
    var res = await db.rawQuery('SELECT * FROM $table WHERE noteTitle = ?', [noteTitle]);
    return res;
  }

  // delete specific data
  Future<int> deleteData(int id) async{
    Database db = await instance.database;
    var res = await db.delete(table, where: 'noteId = ?', whereArgs: [id]);
    return res;
  }

  // update data
  Future<int> update (int id, String updateTitle, String updateContent) async{
    Database db = await instance.database;
    var res = await db.update(table, {"$noteTitle": updateTitle, "$noteContent": updateContent}, where: "$noteId = ?", whereArgs: [id] );
    return res;
  }

}
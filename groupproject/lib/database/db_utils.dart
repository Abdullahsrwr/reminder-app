import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBUtils{
  static Future init() async{
    //set up the database
    var database = openDatabase(
      path.join(await getDatabasesPath(), 'tasks.db'),
      onCreate: (db, version){
        db.execute(
            'CREATE TABLE task_list(id INTEGER PRIMARY KEY, name TEXT, desc TEXT)'
        );
      },
      version: 1,
    );

    print("Created DB $database");
    return database;
  }
}
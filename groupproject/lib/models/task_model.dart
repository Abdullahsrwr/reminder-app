import 'package:sqflite/sqflite.dart';
import 'task.dart';
import '../database/db_utils.dart';
import 'dart:async';
import '../database/firebase_manager.dart';

class TaskModel {
  Future<int> insertTask(Task task) async {
    final db = await DBUtils.init();
    addToFireDB(task);
    return db.insert('task_list', task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future getAllTasks() async {
    fireTaskList = [];
    final db = await DBUtils.init();
    final List<Map<String, dynamic>> maps = await db.query('task_list');
    List result = [];
    for (int i = 0; i < maps.length; i++) {
      result.add(Task.fromMap(maps[i]));
    }
    return print(result);
  }

  Future deleteAllTasks() async {
    final db = await DBUtils.init();
    return db.delete('task_list');
  }

  Future deleteTask(int id) async {
    final db = await DBUtils.init();
    return db.delete('task_list', where: 'id = ?', whereArgs: [id]);
  }
}

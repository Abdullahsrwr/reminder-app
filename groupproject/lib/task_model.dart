import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'task.dart';
import 'db_utils.dart';
import 'dart:async';

class TaskModel{
  Future<int> insertTask (Task task) async{
    final db = await DBUtils.init();
    return db.insert(
      'task_list',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future getAllTasks() async {
    //This needs to be present in any queries, updates, etc.
    //you do with your database
    final db = await DBUtils.init();
    final List<Map<String, dynamic>> maps = await db.query('task_list');
    List result = [];
    for (int i = 0; i < maps.length; i++) {
      result.add(Task.fromMap(maps[i]));
    }
    return print(result);
  }
}
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';


class TaskFireBase extends StatefulWidget {
  TaskFireBase({Key? key, this.task});
  Task? task;
  
  @override
  State<TaskFireBase> createState() => _TaskFireBaseState();
}
List<Task> fireTaskList = [];

class _TaskFireBaseState extends State<TaskFireBase> {
  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}

Future addToFireDB(Task task) async {
  print("Adding to firestore: " + task.toString());
  await FirebaseFirestore.instance.collection('tasks').doc().set(task.toMapFB());
}

Future removeAllFireDB() async {
  
  print("Removing all firestore tasks");

  var taskInstances =
      await FirebaseFirestore.instance.collection('tasks').get();
  for (var doc in taskInstances.docs) {
    await doc.reference.delete();
  }
  fireTaskList = [];
}

Future fillFireTaskList() async {
  QuerySnapshot query =
      await FirebaseFirestore.instance.collection('tasks').get();
  var taskList = query.docs.map((doc) => doc.data()).toList();
  int i = 0;
  List<Task> result = [];
  taskList.forEach((element) { 
    Map<String, dynamic> tempMap = element as Map<String,dynamic>;
    fireTaskList.add(Task(id: i, eventName: tempMap['name'], eventDesc: tempMap['desc'], date: tempMap['date']));
    i = i + 1;
  });
}

Future getFireTasks() async {
  QuerySnapshot query =
      await FirebaseFirestore.instance.collection('tasks').get();
  var taskList = query.docs.map((doc) => doc.data()).toList();
  int i = 0;
  List<Task> result = [];
  taskList.forEach((element) { 
    Map<String, dynamic> tempMap = element as Map<String,dynamic>;
    result.add(Task(id: i, eventName: tempMap['name'], eventDesc: tempMap['desc'], date: tempMap['date']));
    i = i + 1;
  });
  return result;

  // return print(await FirebaseFirestore.instance.collection('tasks').get());
}

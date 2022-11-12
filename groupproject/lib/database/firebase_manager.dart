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

class _TaskFireBaseState extends State<TaskFireBase> {
  @override
  Widget build(BuildContext context) {
    return Text("");
  }
}

Future addToFireDB(Task task) async {
  print("Adding to firestore: " + task.toString());
  await FirebaseFirestore.instance.collection('tasks').doc().set(task.toMap());
}

Future removeAllFireDB() async {
  print("Removing all firestore tasks");

  var taskInstances =
      await FirebaseFirestore.instance.collection('tasks').get();
  for (var doc in taskInstances.docs) {
    await doc.reference.delete();
  }
}

Future getFireTasks() async {
  QuerySnapshot query =
      await FirebaseFirestore.instance.collection('tasks').get();
  var taskList = query.docs.map((doc) => doc.data()).toList();
  print(taskList);
  // return print(await FirebaseFirestore.instance.collection('tasks').get());
}

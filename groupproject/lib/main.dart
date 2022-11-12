import 'package:flutter/material.dart';
import 'package:groupproject/database/db_utils.dart';
import 'controller/notifications.dart';
import 'controller/add.dart';
import 'views/locations.dart';
import 'models/task_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'database/firebase_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    DBUtils.init();
    Firebase.initializeApp();
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Error intializing Firebase");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            print("Successfully connected to Firebase");

            return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.delete_forever),
                    onPressed: () {
                      Notifications().cancelAllNotifications();
                      removeAllFireDB();
                      TaskModel().deleteAllTasks();
                    },
                  ),
                ],
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _showPendingNotifications,
                      child: Text(
                        "View Task List",
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _askDialog();
                      });
                },
                tooltip: 'Add task',
                child: const Icon(Icons.add),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Future _showPendingNotifications() async {
    var pendingNotificationRequests =
        await Notifications().getPendingNotificationRequests();

    print("Pending Notifications:");
    for (var pendNot in pendingNotificationRequests) {
      print("${pendNot.id} / ${pendNot.title} / ${pendNot.body}");
    }
    print("Tasks in Cloud Firestore:");
    getFireTasks();

    print("Tasks in Database:");
    TaskModel().getAllTasks();
  }

  _askDialog() {
    return AlertDialog(
      title: Text('Task Type'),
      content: Text('Would you like to associate a location with your task?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LocationPage(
                        title: 'Add Task with Location',
                      )),
            );
          },
          child: Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddNoti(
                        title: 'Add Task',
                      )),
            );
          },
          child: Text('No'),
        ),
      ],
    );
  }
}

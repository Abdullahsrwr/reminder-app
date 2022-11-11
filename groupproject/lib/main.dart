import 'package:flutter/material.dart';
import 'package:groupproject/db_utils.dart';
import 'notifications.dart';
import 'add.dart';
import 'locations.dart';
import 'task_model.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              Notifications().cancelAllNotifications();
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
  }

  Future _showPendingNotifications() async {
    var pendingNotificationRequests =
        await Notifications().getPendingNotificationRequests();

    print("Pending Notifications:");
    for (var pendNot in pendingNotificationRequests) {
      print("${pendNot.id} / ${pendNot.title} / ${pendNot.body}");
    }

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

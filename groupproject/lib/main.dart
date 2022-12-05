import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:groupproject/database/db_utils.dart';
import 'package:groupproject/views/mapView.dart';
import 'controller/notifications.dart';
import 'controller/add.dart';
import 'models/task.dart';
import 'controller/locations.dart';
import 'models/task_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'database/firebase_manager.dart';
import 'controller/task_table.dart';
import 'package:groupproject/controller/task_chart.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'views/mapmarker.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DBUtils.init();
  await Firebase.initializeApp();
  await fillFireTaskList();
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
  late MapController _mapController;
  bool havePermission = false;
  List<Task> firebaseList = [];
  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    askLocation();
  }

  askLocation() async {
    await Geolocator.isLocationServiceEnabled().then((value) => null);
    await Geolocator.requestPermission().then((value) => null);
    await Geolocator.checkPermission().then((LocationPermission permission) {
      print("Check Location Permission: $permission");
    });
    await Geolocator.isLocationServiceEnabled()
        .then((value) => havePermission = value);
    if (havePermission == false) {
      await askLocation();
    }
  }

  @override
  Widget build(BuildContext context) {
    firebaseList = [];
    for (var i = 0; i < fireTaskList.length; i++) {
      firebaseList.add(fireTaskList[i]);
    }
    print(firebaseList);
    setState(() {});
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(Icons.refresh)),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => showTable(
                          title: 'Schedule',
                          data: firebaseList,
                        )),
              );
            },
            icon: Icon(Icons.calendar_month),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => showChart(
                          title: 'The Week Ahead',
                          data: firebaseList,
                        )),
              );
            },
            icon: Icon(Icons.bar_chart),
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              await Notifications().cancelAllNotifications();
              await removeAllFireDB();
              await TaskModel().deleteAllTasks();
              await fillFireTaskList();
              await Future.delayed(Duration(seconds: 1), () {
                setState(() {});
              });
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(4),
        itemCount: firebaseList.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
              background: Container(color: Color.fromARGB(255, 43, 255, 0)),
              secondaryBackground:
                  Container(color: Color.fromARGB(255, 255, 0, 0)),
              key: UniqueKey(),
              onDismissed: (DismissDirection direction) async {
                if (direction == DismissDirection.endToStart) {
                  await getFireTasks();
                  await fillFireTaskList();
                  await removeSelectedFireDB(fireTaskList[index]);
                  await Notifications()
                      .cancelNotification(firebaseList[index].id!);
                  await TaskModel().deleteTask(firebaseList[index].id!);

                  setState(() {});
                } else if (direction == DismissDirection.startToEnd) {
                  if (firebaseList[index].streetName != null) {
                    setState(() {});
                    locationData = [
                      firebaseList[index].streetNumber! +
                          " " +
                          firebaseList[index].streetName! +
                          ", " +
                          firebaseList[index].city! +
                          ", " +
                          firebaseList[index].province!
                    ];
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MapPage(title: 'Task Map')),
                    );
                  } else {
                    setState(() {});
                  }
                }
              },
              child: ListTile(
                leading: firebaseList[index].streetName == null
                    ? Icon(Icons.no_transfer_rounded)
                    : Icon(Icons.mode_of_travel_rounded),
                title: Text(firebaseList[index].eventName!),
                subtitle: Text(firebaseList[index].eventDesc!),
                trailing: Text(DateFormat('EEE, M/d/y (hh:mm)').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        firebaseList[index].date!))),
                onTap: () {},
              ));
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(firebaseList.length);
          for (int i = 0; i < firebaseList.length; i++) {
            print(firebaseList[i]);
          }

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
            Navigator.pushReplacement(
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
            Navigator.pushReplacement(
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

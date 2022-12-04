import 'dart:math';

import 'package:flutter/material.dart';
import 'package:groupproject/database/db_utils.dart';
import 'controller/notifications.dart';
import 'controller/add.dart';
import 'views/locations.dart';
import 'models/task_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'database/firebase_manager.dart';
import 'controller/task_table.dart';

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
  bool first = true;
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
            if (first = true){
              Future.delayed(Duration(seconds: 1), (){
                fillFireTaskList();
                first = false;
              });
            }
            
            _showPendingNotifications();

            return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
                actions: [
                  IconButton(onPressed:

                   (){
                    setState(() {});
                    }
                   , 
                  icon: Icon(Icons.refresh)),

                  IconButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => showTable(
                            title: 'Schedule',
                            data: fireTaskList,
                          )),
                        );
                    },
                    icon: Icon(Icons.calendar_month),
                  ),
                   
                  IconButton(
                    icon: const Icon(Icons.delete_forever),
                    onPressed: () {
                      Notifications().cancelAllNotifications();
                      removeAllFireDB();
                      TaskModel().deleteAllTasks();
                      Future.delayed(Duration(seconds: 1), (){
                        setState(() {});
                      });
                    },
                  ),
                ],
              ),
              body: 
                ListView.separated(
                  padding: const EdgeInsets.all(4),
                  itemCount: fireTaskList.length,
                  itemBuilder: (BuildContext context, int index){
                    return Container(
                      height: 90,
                      child:
                       Text(
                        "\n" + "\t"*5 + "Task: " + fireTaskList[index].eventName.toString() + "\n" + "\t"*5 + "Details: " + fireTaskList[index].eventDesc.toString()
                       , style:const TextStyle(fontSize: 18, fontFamily: 'Times New Roman' ),),
                      color: Colors.lightBlue[100],
                      

                    );
                  }, separatorBuilder: (BuildContext context, int index)=>const Divider(),
                ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  
                    print (fireTaskList.length);
                    for (int i=0; i<fireTaskList.length; i++){
                      print (fireTaskList[i]);
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

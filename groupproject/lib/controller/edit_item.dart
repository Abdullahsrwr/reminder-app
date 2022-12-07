import 'package:flutter/material.dart';
import 'package:groupproject/database/firebase_manager.dart';
import 'package:groupproject/main.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'notifications.dart';
import '../models/task.dart';
import '../models/task_model.dart';
import '../database/db_utils.dart';

import 'package:flutter_i18n/flutter_i18n.dart';

class EditPage extends StatefulWidget {
  const EditPage({
    Key? key,
    required this.title,
    required this.eventDate,
    required this.body,
    required this.streetNumber,
    required this.streetName,
    required this.city,
    required this.province,
  }) : super(key: key);

  final String title;
  final DateTime eventDate;
  final String body;
  final String streetNumber;
  final String streetName;
  final String city;
  final String province;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  // TODO: implement widget
  EditPage get widget => super.widget;
  final _formKey = GlobalKey<FormState>();

  final _notifications = Notifications();

  DateTime eventDate = DateTime.now();
  String title = '';
  String? body = '';
  String? payload = '';
  String? streetNumber = '';
  String? streetName = '';
  String? city = '';
  String? province = '';
  int? index;
  bool saved = false;

  @override
  Widget build(BuildContext context) {
    tz.initializeTimeZones();
    _notifications.init();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Builder(
          builder: _formBuilder,
        ),
      ),
    );
  }

  Widget _formBuilder(context) {
    saved = false;
    DateTime rightNow = DateTime.now();
    eventDate = widget.eventDate;
    title = widget.title;
    body = widget.body;
    streetNumber = widget.streetNumber;
    streetName = widget.streetName;
    city = widget.city;
    province = widget.province;
    return Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(FlutterI18n.translate(context, "add_task_field.task"),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 5)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: title,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        labelText: "",
                      ),
                      onChanged: (value) {
                        title = value;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(FlutterI18n.translate(context, "add_task_field.desc"),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 5)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: body,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        labelText: "",
                      ),
                      onChanged: (value) {
                        body = value;
                      },
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 5)),
              Row(
                children: [
                  Text(
                      FlutterI18n.translate(
                          context, "add_task_field.street_num"),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 5)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: streetNumber,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        labelText: "",
                      ),
                      onChanged: (value) {
                        streetNumber = value;
                      },
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 5)),
              Row(
                children: [
                  Text(FlutterI18n.translate(context, "add_task_field.street"),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 5)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: streetName,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        labelText: "",
                      ),
                      onChanged: (value) {
                        streetName = value;
                      },
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 5)),
              Row(
                children: [
                  Text(FlutterI18n.translate(context, "add_task_field.city"),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 5)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: city,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        labelText: "",
                      ),
                      onChanged: (value) {
                        city = value;
                      },
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 5)),
              Row(
                children: [
                  Text(
                      FlutterI18n.translate(context, "add_task_field.province"),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 5)),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: province,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        labelText: "",
                      ),
                      onChanged: (value) {
                        province = value;
                      },
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.only(bottom: 5)),
              Row(
                children: [
                  Text(FlutterI18n.translate(context, "add_task_field.date"),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color.fromARGB(250, 250, 250, 255),
                        backgroundColor: Color.fromARGB(250, 250, 250, 255),
                        elevation: 0,
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          firstDate: rightNow,
                          lastDate: DateTime(2100),
                          initialDate: rightNow,
                        ).then((value) {
                          setState(() {
                            eventDate = DateTime(
                              value!.year,
                              value.month,
                              value.day,
                              eventDate.hour,
                              eventDate.minute,
                              eventDate.second,
                            );
                          });
                        });
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                    Text(_toDateString(eventDate),
                        style: TextStyle(
                          fontSize: 15,
                        )),
                  ],
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: 5)),
              Row(
                children: [
                  Text(FlutterI18n.translate(context, "add_task_field.time"),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color.fromARGB(250, 250, 250, 255),
                        backgroundColor: Color.fromARGB(250, 250, 250, 255),
                        elevation: 0,
                      ),
                      onPressed: () {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay(
                              hour: rightNow.hour, minute: rightNow.minute),
                        ).then((value) {
                          setState(() {
                            eventDate = DateTime(
                              eventDate.year,
                              eventDate.month,
                              eventDate.day,
                              value!.hour,
                              value.minute,
                            );
                          });
                        });
                      },
                      child: Icon(
                        Icons.alarm,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                    Text(_toTimeString(eventDate),
                        style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _notificationLater();
                    },
                    child: Text(
                      FlutterI18n.translate(context, "add_task_field.save"),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (saved == true) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MyHomePage(title: "InaBit")));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(FlutterI18n.translate(
                                context, "dialogue.snackBarSave")),
                          ),
                        );
                      }
                    },
                    child: Text(
                      FlutterI18n.translate(context, "add_task_field.back"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Future _notificationLater() async {
    int duration = eventDate.difference(DateTime.now()).inSeconds;
    if (duration < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(FlutterI18n.translate(context, "dialogue.snackBarPassed")),
        ),
      );
      return;
    } else {
      saved = true;
      var when = tz.TZDateTime.now(tz.local).add(Duration(seconds: duration));
      await fillFireTaskList();
      index = fireTaskList.length;

      Task newTask = Task(
          id: index,
          eventName: title,
          eventDesc: body,
          date: eventDate.millisecondsSinceEpoch,
          streetNumber: streetNumber,
          streetName: streetName,
          city: city,
          province: province);
      TaskModel().insertTask(newTask);
      fireTaskList.add(newTask);

      await _notifications.sendNotificationLater(title!, body!, payload!, when);
      String translatedDate =
          FlutterI18n.translate(context, "dialogue.snackBarTime");
      var snackBar = SnackBar(
        content: Text(
          "$translatedDate $eventDate",
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  String _twoDigits(int value) {
    if (value < 10) {
      return '0$value';
    } else {
      return '$value';
    }
  }

  String _toDateString(DateTime date) {
    return '${date.year}/${_twoDigits(date.month)}/${_twoDigits(date.day)}';
  }

  String _toTimeString(DateTime date) {
    return '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
  }

  getAllTasks() async {
    final db = await DBUtils.init();
    final List<Map<String, dynamic>> maps = await db.query('task_list');
    List result = [];
    for (int i = 0; i < maps.length; i++) {
      result.add(Task.fromMap(maps[i]));
    }
    index = result.length - 1;
  }
}

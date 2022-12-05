import 'package:flutter/material.dart';
import 'package:groupproject/database/firebase_manager.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'notifications.dart';
import '../models/task.dart';
import '../models/task_model.dart';
import '../database/db_utils.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final _formKey = GlobalKey<FormState>();

  final _notifications = Notifications();

  DateTime _eventDate = DateTime.now();
  String? title = '';
  String? body = '';
  String? payload = '';
  String? streetNumber = '';
  String? streetName = '';
  String? city = '';
  String? province = '';
  int? index;

  @override
  Widget build(BuildContext context) {
    tz.initializeTimeZones();
    _notifications.init();

    return Scaffold(
      appBar: AppBar(
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
    DateTime rightNow = DateTime.now();
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Task:'),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
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
              Text('Description:'),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "",
                  ),
                  onChanged: (value) {
                    body = value;
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Street Number:'),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "",
                  ),
                  onChanged: (value) {
                    streetNumber = value;
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Street Name:'),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "",
                  ),
                  onChanged: (value) {
                    streetName = value;
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('City:'),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "",
                  ),
                  onChanged: (value) {
                    city = value;
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('Province:'),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "",
                  ),
                  onChanged: (value) {
                    province = value;
                  },
                ),
              ),
            ],
          ),
          Container(
            child: Row(
              children: [
                ElevatedButton(
                  child: Text('Date'),
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      firstDate: rightNow,
                      lastDate: DateTime(2100),
                      initialDate: rightNow,
                    ).then((value) {
                      setState(() {
                        _eventDate = DateTime(
                          value!.year,
                          value.month,
                          value.day,
                          _eventDate.hour,
                          _eventDate.minute,
                          _eventDate.second,
                        );
                      });
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                ),
                Text(_toDateString(_eventDate)),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                          hour: rightNow.hour, minute: rightNow.minute),
                    ).then((value) {
                      setState(() {
                        _eventDate = DateTime(
                          _eventDate.year,
                          _eventDate.month,
                          _eventDate.day,
                          value!.hour,
                          value.minute,
                        );
                      });
                    });
                  },
                  child: Text('Time'),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                ),
                Text(_toTimeString(_eventDate)),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _notificationLater,
                child: Text(
                  "Save",
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Go Back",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future _notificationLater() async {
    int duration = _eventDate.difference(DateTime.now()).inSeconds;
    if (duration < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Date and Time has already passed'),
        ),
      );
      return;
    } else {
      var when = tz.TZDateTime.now(tz.local).add(Duration(seconds: duration));
      await fillFireTaskList();
      index = fireTaskList.length;

      Task newTask = Task(
          id: index,
          eventName: title,
          eventDesc: body,
          date: _eventDate.millisecondsSinceEpoch,
          streetNumber: streetNumber,
          streetName: streetName,
          city: city,
          province: province);
      TaskModel().insertTask(newTask);
      fireTaskList.add(newTask);

      await _notifications.sendNotificationLater(title!, body!, payload!, when);

      var snackBar = SnackBar(
        content: Text(
          "Reminder Notification Will Be Sent At $_eventDate",
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

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'notifications.dart';

class ScheduledEvent {
  String? name;
  DateTime? dateTime;

  ScheduledEvent({this.name, this.dateTime});

  String toString() {
    return '$name ($dateTime)';
  }
}

class ScheduleEventPage extends StatefulWidget {
  final String title;

  ScheduleEventPage({Key? key, required this.title}) : super(key: key);

  @override
  _ScheduleEventPageState createState() => _ScheduleEventPageState();
}

class _ScheduleEventPageState extends State<ScheduleEventPage> {
  final _formKey = GlobalKey<FormState>();

  final _notifications = Notifications();

  DateTime _eventDate = DateTime.now();
  String _eventName = '';
  String? title;
  String? body;
  String? payload;

  @override
  Widget build(BuildContext context) {
    DateTime rightNow = DateTime.now();
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(onChanged: (String value) {
            setState(() {
              _eventName = value;
              title = _eventName;
              body = _eventName;
              payload = _eventName;
            });
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ElevatedButton(
                child: Text('Choose'),
                onPressed: () {
                  showDatePicker(
                    context: context,
                    firstDate: rightNow,
                    lastDate: DateTime(2100),
                    initialDate: rightNow,
                  ).then((value) {
                    setState(() {
                      // overwrite year/month/day with new values
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(_toDateString(_eventDate)),
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
            ElevatedButton(
              onPressed: () {
                showTimePicker(
                  context: context,
                  initialTime:
                      TimeOfDay(hour: rightNow.hour, minute: rightNow.minute),
                ).then((value) {
                  setState(() {
                    // overwrite hours/minutes with new values, keep date the same
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
              child: Text('Select'),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(_toTimeString(_eventDate)),
            ),
          ]),
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  int duration =
                      _eventDate.difference(DateTime.now()).inSeconds;
                  await _notificationLater(duration);
                },
                child: Text('Save')),
          ),
        ],
      ),
    );
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

  Future _notificationLater(int duration) async {
    var when = tz.TZDateTime.now(tz.local).add(Duration(seconds: duration));

    await _notifications.sendNotificationLater(title!, body!, payload!, when);

    var snackBar = const SnackBar(
      content: Text(
        "Notification in 3 seconds",
        style: TextStyle(fontSize: 30),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

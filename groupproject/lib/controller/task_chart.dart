import 'package:flutter/material.dart';
import 'package:groupproject/database/firebase_manager.dart';
import 'package:groupproject/models/task.dart';
import 'package:charts_flutter_new/flutter.dart' as charts;

class showChart extends StatefulWidget {
  const showChart({Key? key, required this.title, required this.data})
      : super(key: key);

  final String title;
  final List<Task> data;

  @override
  State<showChart> createState() => _showChartState();
}

class _showChartState extends State<showChart> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final taskDataList = [
      new taskData((getTasksPerDay(fireTaskList)[0]), "Today"),
      new taskData((getTasksPerDay(fireTaskList)[1]),
          weekdays[((DateTime.now().weekday + 1) - 1) % 7]),
      new taskData((getTasksPerDay(fireTaskList)[2]),
          weekdays[((DateTime.now().weekday + 2) - 1) % 7]),
      new taskData((getTasksPerDay(fireTaskList)[3]),
          weekdays[((DateTime.now().weekday + 3) - 1) % 7]),
      new taskData((getTasksPerDay(fireTaskList)[4]),
          weekdays[((DateTime.now().weekday + 4) - 1) % 7]),
      new taskData((getTasksPerDay(fireTaskList)[5]),
          weekdays[((DateTime.now().weekday + 5) - 1) % 7]),
      new taskData((getTasksPerDay(fireTaskList)[6]),
          weekdays[((DateTime.now().weekday + 6) - 1) % 7]),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SizedBox(
            height: 500,
            child: charts.BarChart(vertical: true, [
              charts.Series(
                  id: "Tasks per day",
                  domainFn: (task, _) => task.dayName,
                  measureFn: (task, _) => task.numPerDay,
                  data: taskDataList)
            ])),
      ),
    );
  }

  List<int> getTasksPerDay(List<Task> data) {
    List<int> temp = [0, 0, 0, 0, 0, 0, 0];
    fireTaskList.forEach((element) {
      int seconds = element.date!.toInt();
      DateTime? date = DateTime.fromMillisecondsSinceEpoch(seconds);
      if (DateTime.now().day + 0 == date.day) {
        temp[0] = temp[0] + 1;
      } else if (DateTime.now().day + 1 == date.day) {
        temp[1] = temp[1] + 1;
      } else if (DateTime.now().day + 2 == date.day) {
        temp[2] = temp[2] + 1;
      } else if (DateTime.now().day + 3 == date.day) {
        temp[3] = temp[3] + 1;
      } else if (DateTime.now().day + 4 == date.day) {
        temp[4] = temp[4] + 1;
      } else if (DateTime.now().day + 5 == date.day) {
        temp[5] = temp[5] + 1;
      } else if (DateTime.now().day + 6 == date.day) {
        temp[6] = temp[6] + 1;
      }
    });
    return temp;
  }
}

class taskData {
  int numPerDay;
  String dayName;

  taskData(this.numPerDay, this.dayName);
}

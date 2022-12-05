import 'package:flutter/material.dart';
import 'package:groupproject/database/firebase_manager.dart';
import 'package:groupproject/models/task.dart';

class showTable extends StatefulWidget {
  const showTable({Key? key, required this.title, required this.data})
      : super(key: key);

  final String title;
  final List<Task> data;

  @override
  State<showTable> createState() => _showTableState();
}

class _showTableState extends State<showTable> {
  final _formKey = GlobalKey<FormState>();
  var weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: [],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(label: Text("Today")),
              DataColumn(
                  label:
                      Text(weekdays[((DateTime.now().weekday + 1) - 1) % 7])),
              DataColumn(
                  label:
                      Text(weekdays[((DateTime.now().weekday + 2) - 1) % 7])),
              DataColumn(
                  label:
                      Text(weekdays[((DateTime.now().weekday + 3) - 1) % 7])),
              DataColumn(
                  label:
                      Text(weekdays[((DateTime.now().weekday + 4) - 1) % 7])),
              DataColumn(
                  label:
                      Text(weekdays[((DateTime.now().weekday + 5) - 1) % 7])),
              DataColumn(
                  label:
                      Text(weekdays[((DateTime.now().weekday + 6) - 1) % 7])),
            ],
            rows: buildRows(),
          ),
        ));
  }

  buildRows() {
    var dataRows = <DataRow>[];

    fireTaskList.forEach((element) {
      String? title = element.eventName;
      int seconds = element.date!.toInt();

      DateTime? date = DateTime.fromMillisecondsSinceEpoch(seconds);
      print(date);
      var months = [
        'Jan',
        'Feb',
        'March',
        'April',
        'May',
        'June',
        'July',
        'Aug',
        'Sept',
        'Oct',
        'Nov',
        'Dec'
      ];
      print(DateTime.now().day + 1 == date.day);

      dataRows.add(DataRow(cells: <DataCell>[
        DataCell(Text(dayFinder(date, 0, element).toString())),
        DataCell(Text(dayFinder(date, 1, element).toString())),
        DataCell(Text(dayFinder(date, 2, element).toString())),
        DataCell(Text(dayFinder(date, 3, element).toString())),
        DataCell(Text(dayFinder(date, 4, element).toString())),
        DataCell(Text(dayFinder(date, 5, element).toString())),
        DataCell(Text(dayFinder(date, 6, element).toString())),
      ]));
    });
    return dataRows;
  }

  String? dayFinder(DateTime d, int daysAway, Task t) {
    if (DateTime.now().day + daysAway == d.day) {
      return t.eventName;
    } else {
      return "";
    }
  }
}

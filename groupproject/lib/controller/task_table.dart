import 'package:flutter/material.dart';
import 'package:groupproject/database/firebase_manager.dart';
import 'package:groupproject/models/task.dart';

class showTable extends StatefulWidget {
  const showTable({Key? key, required this.title, required this.data}) : super(key: key);

  final String title;
  final List<Task> data;

  @override
  State<showTable> createState() => _showTableState();
}



class _showTableState extends State<showTable>{
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
                        
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [],
      ),
      
      body: DataTable(
        
        columns: [
          DataColumn(
            label: Text("Task Name")
            ),
          DataColumn(
            label: Text("Day")
            )
        ],
        rows: 
        buildRows()
          
        ,
      ),
    );
   
  }
  

  buildRows(){
    
    var dataRows = <DataRow>[];

    
    fireTaskList.forEach((element) {
      String? title = element.eventName;
      int seconds = element.date!.toInt();
      
      DateTime? date = DateTime.fromMillisecondsSinceEpoch(seconds);
      print (date);
      var months = ['Jan', 'Feb', 'March', 'April', 'May', 'June', 'July', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];
      

      dataRows.add(
        DataRow(
          cells: <DataCell>[
            DataCell(
              Text(title.toString())
              ),
            DataCell(
              Text(months[date.month-1] + " " + date.day.toString())
            )
          ]
        ));
     });
     return dataRows;
  }

}

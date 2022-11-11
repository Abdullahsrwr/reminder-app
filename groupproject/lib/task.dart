import 'package:flutter/material.dart';


class Task{
  int? id;
  String? eventName;
  String? eventDesc;

  Task({this.id, this.eventName, this.eventDesc});

  Map<String, Object?> toMap(){
    return{
      'id': this.id,
      'name' : this.eventName,
      'desc' : this.eventDesc
    };
  }

  Task.fromMap(Map map){
    this.id = map['id'];
    this.eventName = map['name'];
    this.eventDesc = map['desc'];
  }

  
  String toString() {
    return 'Task[id: $id], name: $eventName , description: $eventDesc';
  }
}
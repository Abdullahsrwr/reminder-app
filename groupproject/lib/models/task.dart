import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task{
  int? id;
  String? eventName;
  String? eventDesc;
  int? date; // millisecondsSinceEpoch from DateTime
  DocumentReference? reference;

  Task({this.id, this.eventName, this.eventDesc, this.date});

  Map<String, Object?> toMap(){
    return{
      'id': this.id,
      'name' : this.eventName,
      'desc' : this.eventDesc,
    };
  }

  Task.fromMap(Map map, {this.reference}){
    this.id = map['id'];
    this.eventName = map['name'];
    this.eventDesc = map['desc'];
    this.date = map['date'];
  }

  Map<String, Object?> toMapFB(){
    return{
      'id': this.id,
      'name' : this.eventName,
      'desc' : this.eventDesc,
      'date' : this.date
    };
  }

 

  
  String toString() {
    return 'Task[id: $id], name: $eventName , description: $eventDesc, date: $date';
  }
}
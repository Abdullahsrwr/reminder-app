import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Task{
  int? id;
  String? eventName;
  String? eventDesc;
  DocumentReference? reference;

  Task({this.id, this.eventName, this.eventDesc});

  Map<String, Object?> toMap(){
    return{
      'id': this.id,
      'name' : this.eventName,
      'desc' : this.eventDesc
    };
  }

  Task.fromMap(Map map, {this.reference}){
    this.id = map['id'];
    this.eventName = map['name'];
    this.eventDesc = map['desc'];
  }

  
  String toString() {
    return 'Task[id: $id], name: $eventName , description: $eventDesc';
  }
}
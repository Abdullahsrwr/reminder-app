import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  int? id;
  String? eventName;
  String? eventDesc;
  int? date; // millisecondsSinceEpoch from DateTime
  DocumentReference? reference;
  String? streetNumber;
  String? streetName;
  String? city;
  String? province;

  Task(
      {this.id,
      this.eventName,
      this.eventDesc,
      this.date,
      this.streetNumber,
      this.streetName,
      this.city,
      this.province});

  Map<String, Object?> toMap() {
    return {
      'id': this.id,
      'name': this.eventName,
      'desc': this.eventDesc,
    };
  }

  Task.fromMap(Map map, {this.reference}) {
    this.id = map['id'];
    this.eventName = map['name'];
    this.eventDesc = map['desc'];
    this.date = map['date'];
    this.streetNumber = map['streetNumber'];
    this.streetName = map['streetName'];
    this.city = map['city'];
    this.province = map['province'];
  }

  Map<String, Object?> toMapFB() {
    return {
      'id': this.id,
      'name': this.eventName,
      'desc': this.eventDesc,
      'date': this.date,
      'streetNumber': this.streetNumber,
      'streetName': this.streetName,
      'city': this.city,
      'province': this.province,
    };
  }

  String toString() {
    return 'Task[id: $id], name: $eventName , description: $eventDesc, date: $date streetNumber: $streetNumber, streetName: $streetName, city: $city, province: $province';
  }
}

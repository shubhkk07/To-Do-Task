import 'package:flutter/material.dart';

class Note {
  final String title;
  final String description;
  final DateTime date;
  final String time;
  final String id;

  Note({this.title, this.description, this.date, this.time, this.id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'description': description,
      'title': title,
      'date': date,
      'time': time,
    };
  }

  factory Note.fromMap(Map<String,dynamic> map) {
    return Note(
      title:map['title'],
      description:map['decription'],
      date: DateTime.parse(map['date']),
      time: map['time'],
      id: map['id']
    );
  }
}

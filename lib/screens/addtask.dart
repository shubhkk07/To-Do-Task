import 'package:flutter/material.dart';
import 'package:newproject/authentication/auth_service.dart';
import 'package:newproject/models/notes.dart';
import 'package:newproject/services/locator.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:date_time_picker/date_time_picker.dart';

import 'package:intl/intl.dart';

import 'homepage.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController _tittle;
  TextEditingController _description;
  TextEditingController _timeController;

 
  String lsHour = TimeOfDay.now().hour.toString().padLeft(2, '0');
  String lsMinute = TimeOfDay.now().minute.toString().padLeft(2, '0');

  GlobalKey<FormState> _key = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _tittle = TextEditingController();
    _description = TextEditingController();
    _timeController = TextEditingController(text: '$lsHour:$lsMinute');
  }


  int id = 1;



  String tittle, description;
  String time = DateTime.now().hour.toString() + ':' + DateTime.now().minute.toString();

  DateTime date = DateTime.now();

  String titleValidation(String title){
    if(tittle == null){
      return "Title can't be empty";
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formatDate = DateFormat("dd MMM, yyyy");
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.33,
                decoration: BoxDecoration(
                    color: Colors.amber[200],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30))),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 30,
                    left: 20,
                    right: 100,
                  ),
                  child: Column(children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Add a Task',
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Form(
                        key: _key,
                        child: TextFormField(
                          style: TextStyle(fontSize: 24),
                          decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle: TextStyle(fontSize: 22)),
                          controller: _tittle,
                          validator: titleValidation,
                          onChanged: (val) {
                            tittle = val;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0, right: 150),
                      child: DateTimeField(
                        readOnly: true,
                        style: TextStyle(fontSize: 24),
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.date_range_rounded),
                            labelText: 'Date',
                            labelStyle: TextStyle(fontSize: 22)),
                        initialValue: DateTime.now(),
                        format: _formatDate,
                        
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                            context: context,
                            firstDate:
                                DateTime.now().subtract(Duration(days: 30)),
                            initialDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 30)),
                          );
                        },
                        onChanged: (val) {
                          setState(() {
                            date = val;
                          });
                        },
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 20, right: 80),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 80.0, top: 30),
                    child: DateTimePicker(
                        type: DateTimePickerType.time,
                        controller: _timeController,
                        style: TextStyle(fontSize: 24),
                        decoration: InputDecoration(
                            labelText: 'Time',
                            labelStyle: TextStyle(fontSize: 22)),
                        onChanged: (val) {
                          setState(() {
                            time = val;
                          });
                        }),
                  ),
                  TextFormField(
                      maxLines: 2,
                      controller: _description,
                      style: TextStyle(fontSize: 24),
                      decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(fontSize: 22)),
                      onChanged: (val) {
                        description = val;
                      }),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, left: 45),
                    child: Container(
                      height: 60,
                      width: 200,
                      child: RaisedButton(
                        onPressed: () async {
                          if(_key.currentState.validate()){
                          final note = Note(
                              title: this.tittle,
                              description: this.description,
                              date: this.date,
                              time: this.time,
                              id: this.id);
                          await getIt.get<AuthService>().addPost(note);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        }
                        
                        },
                        child: Text(
                          'Add task',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

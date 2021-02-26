import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:newproject/authentication/auth_service.dart';
import 'package:newproject/models/notes.dart';
import 'package:newproject/screens/addtask.dart';

import 'package:newproject/services/locator.dart';
import 'package:table_calendar/table_calendar.dart';

import '../login.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  moveToaddTask() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddTask()));
  }

  List colors = [Color(0xFFffd9cc), Color(0xFFcfd2e3), Color(0xFFffef8a)];

  CalendarController controller = CalendarController();
  String docId;
  Map<DateTime, List<dynamic>> _events;
  CalendarController calcontr = CalendarController();

  Color colorGenerator() {
    return colors[Random().nextInt(3)];
  }

  @override
  void initState() {
    super.initState();
    _events = {};
  }

  Map<DateTime, List<dynamic>> _groupEvents(List allEvents) {
    Map<DateTime, List<dynamic>> data = {};
    allEvents.forEach((event) {
      if (event["date"] != null) {
        DateTime dt = event['date'].toDate();
        DateTime date = DateTime.utc(dt.year, dt.month, dt.day, 12);
        print(date);
        if (data[date] == null) data[date] = [];
        data[date].add(event);
      }
    });
    return data;
  }

  Future<bool> _onBackPressed(){
    return showDialog(
      context: context,
      builder:(context)=> AlertDialog(
        title:Text('Do you really want to exit the app'),
        actions:[
          FlatButton(child: Text('No'),onPressed:()=>Navigator.pop(context,false),),
          FlatButton(child: Text('Yes'),onPressed:()=>Navigator.of(context).pop(true),)
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Color(0xffFFF9EC),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                padding: EdgeInsets.only(top: 55, left: 8, right: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Today',
                            style: TextStyle(
                                fontSize: 45, fontWeight: FontWeight.bold)),
                        Align(
                            alignment: Alignment.topRight,
                            child: MaterialButton(
                              shape: StadiumBorder(),
                              padding: EdgeInsets.only(
                                  left: 18, right: 18, top: 12, bottom: 12),
                              onPressed: () => moveToaddTask(),
                              child: Text(
                                ' Add Task',
                                style:
                                    TextStyle(fontSize: 25, color: Colors.white),
                              ),
                              color: Color(0xFF309397),
                            )),
                      ],
                    ),
                    Text("Let's have a Productive Day",
                        style: TextStyle(
                            fontSize: 18, color: Colors.black.withOpacity(0.52))),
                  ],
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: RefreshIndicator(
                  onRefresh:getIt.get<AuthService>().retrievePost,
                  child: FutureBuilder(
                    future: getIt.get<AuthService>().retrievePost(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        
                        List events = snapshot.data;
                        if (events == null) {
                          print('events is empty');
                        }
                        if (events != null) {
                          _events = _groupEvents(events);
                        }

                        DateTime initialDate = calcontr.selectedDay ??
                            DateTime.utc(DateTime.now().year, DateTime.now().month,
                                DateTime.now().day, 12);

                        final _selectedEvents = _events[initialDate] ?? [];

                        return Column(
                          children: [
                            TableCalendar(
                              events: _events,
                              calendarController: calcontr,
                              availableCalendarFormats: {
                                CalendarFormat.week: "week",
                                CalendarFormat.month: "month"
                              },
                              initialCalendarFormat: CalendarFormat.week,
                              initialSelectedDay: initialDate,
                              onDaySelected: (date, events, _) {
                                setState(() {});
                              },
                            ),
                            _selectedEvents.isEmpty
                                ? ListTile(
                                  title: Text(
                                    'No events for today',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 24),
                                  ),
                                )
                                : SingleChildScrollView(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxHeight: 600, maxWidth: 380),
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        padding: EdgeInsets.only(top: 30),
                                        itemCount: _selectedEvents.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          final task = _selectedEvents[index];
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(bottom: 18.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  height: 36,
                                                  width: 80,
                                                  child: Text(
                                                    task["time"],
                                                    style: TextStyle(fontSize: 22),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        color: colorGenerator(),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                40)),
                                                    child: ListTile(
                                                      trailing: IconButton(
                                                        icon: Icon(Icons.delete),
                                                        onPressed: (){getIt.get<AuthService>().deletePost(task["id"]);}
                                                      ),
                                                        title: Text(task["title"]),
                                                        subtitle:
                                                            task["description"] !=
                                                                    null
                                                                ? Text(task[
                                                                    "description"])
                                                                : null),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                          ],
                        );
                      } else {
                        return Center(
                            child: CircularProgressIndicator());
                      }
                    },
                  ),
                ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
            tooltip: 'Logout',
            child: Icon(Icons.logout),
            onPressed: () {
              getIt.get<AuthService>().signout();
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => LoginPage()));
            }),
      ),
    );
  }
}

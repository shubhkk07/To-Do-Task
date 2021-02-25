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

  CalendarController controller = CalendarController();

  Map<DateTime, List<dynamic>> _events;
  CalendarController calcontr = CalendarController();
  List<Note> abc;

  @override
  void initState() {
    super.initState();
    _events = {};
    abc = [];
  }

  Map<DateTime, List<dynamic>> _groupEvents(List allEvents) {
    Map<DateTime, List<dynamic>> data = {};
    allEvents.forEach((event) {
      if(event["date"] != null){
      DateTime dt = event['date'].toDate();
      DateTime date =
          DateTime.utc(dt.year, dt.month, dt.day, 12);
      print(date);
      if (data[date] == null) data[date] = [];
      data[date].add(event);
      }
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFF9EC),
      body: Stack(
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
              padding: EdgeInsets.only(top: 180),
              child: FutureBuilder(
                future: getIt.get<AuthService>().retrievePost(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List events =
                        snapshot.data; //yaha kuch nhi uthaa rhaaaa
                    if (events == null) {
                      print('events is empty');
                    }
                    if (events != null) {
                      _events = _groupEvents(events);
                    }

                    DateTime initialDate = calcontr.selectedDay ??
                        DateTime.utc(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day, 12);

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
                        _selectedEvents == null
                            ? ListTile(
                                title: Text('no events for today'),
                              )
                            : ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxHeight: 500, maxWidth: 400),
                                child: ListView.builder(
                                  itemCount: _selectedEvents.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final task = _selectedEvents[index];
                                    return ListTile(
                                      title: Text(task["title"]),
                                    );
                                  },
                                ),
                              ),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator()
                    );
                  }
                },
              ))
        ],
        overflow: Overflow.visible,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Logout',
        child: Icon(Icons.logout),
        onPressed:(){ 
          getIt.get<AuthService>().signout();
          Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginPage()));
          }
      ),
    );
  }
}

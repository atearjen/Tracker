//  Copyright (c) 2019 Aleksander Woźniak
//  Licensed under Apache License v2.0

import 'package:date_utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Example holidays
final Map<DateTime, List> _holidays = {
  DateTime(2019, 1, 1): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tracker Calendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Tracker Calendar'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  DateTime _selectedDay;
  Map<DateTime, List> _events;
  Map<DateTime, List> _visibleEvents;
  Map<DateTime, List> _visibleHolidays;
  List _selectedEvents;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _events = {
//      _selectedDay.subtract(Duration(days: 30)): ['Event A0', 'Event B0', 'Event C0'],
//      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
//      _selectedDay.subtract(Duration(days: 20)): ['Event A2', 'Event B2', 'Event C2', 'Event D2'],
//      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
//      _selectedDay.subtract(Duration(days: 10)): ['Event A4', 'Event B4', 'Event C4'],
//      _selectedDay.subtract(Duration(days: 4)): ['Event A5', 'Event B5', 'Event C5'],
//      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
//      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
       // _selectedDay.add(Duration(days: 0)): ['Facebook Time: 45', 'Instagram Time: 50', 'Mood Score: 8'],
//      _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
//      _selectedDay.add(Duration(days: 7)): ['Event A10', 'Event B10', 'Event C10'],
//      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
//      _selectedDay.add(Duration(days: 17)): ['Event A12', 'Event B12', 'Event C12', 'Event D12'],
//      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
//      _selectedDay.add(Duration(days: 26)): ['Event A14', 'Event B14', 'Event C14'],
    };

    _selectedEvents = _events[_selectedDay] ?? [];
    _visibleEvents = _events;
    _visibleHolidays = _holidays;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _controller.forward();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedDay = day;
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    setState(() {
      _visibleEvents = Map.fromEntries(
        _events.entries.where(
              (entry) =>
          entry.key.isAfter(first.subtract(const Duration(days: 1))) &&
              entry.key.isBefore(last.add(const Duration(days: 1))),
        ),
      );

      _visibleHolidays = Map.fromEntries(
        _holidays.entries.where(
              (entry) =>
          entry.key.isAfter(first.subtract(const Duration(days: 1))) &&
              entry.key.isBefore(last.add(const Duration(days: 1))),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // Switch out 2 lines below to play with TableCalendar's settings
          //-----------------------
          _buildTableCalendar(),
          RaisedButton(
            child: Text("Add Today's Log"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecondRoute()),
                );
              // Navigate to second route when tapped.
              },
          ),
          // _buildTableCalendarWithBuilders(),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }


  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar()  {
//    final SharedPreferences prefs =  SharedPreferences.getInstance();
    return TableCalendar(
      locale: 'en_US',
      events: _visibleEvents,
      holidays: _visibleHolidays,
      initialCalendarFormat: CalendarFormat.week,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.monday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
        CalendarFormat.twoWeeks: '2 weeks',
        CalendarFormat.week: 'Week',
      },
      calendarStyle: CalendarStyle(
       selectedColor: Colors.deepOrange[400],
        markersColor: Colors.brown[700],
        todayColor: Colors.deepOrange[200],
//        color = getColor();
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: Colors.deepOrange[400],
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

//  Widget getColor() {
//    SharedPreferences prefs =  SharedPreferences.getInstance();
//
//    return color
//  }
  // More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'pl_PL',
      events: _visibleEvents,
      holidays: _visibleHolidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: Colors.blue[800]),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color: Colors.blue[600]),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_controller),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _controller.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Utils.isSameDay(date, _selectedDay)
            ? Colors.brown[500]
            : Utils.isSameDay(date, DateTime.now()) ? Colors.brown[300] : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.8),
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ListTile(
          title: Text(event.toString()),
          onTap: () => print('$event tapped!'),
        ),
      ))
          .toList(),
    );
  }
}

class SecondRoute extends StatefulWidget {
  @override
  _SecondRouteState createState() => new _SecondRouteState();
}


class _SecondRouteState extends State<SecondRoute> {
  TextEditingController facebookTime = new TextEditingController();
  TextEditingController instagramTime = new TextEditingController();
  TextEditingController moodScore = new TextEditingController();

  bool checkValue = false;

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    getInformation();
  }
  getInformation() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = sharedPreferences.getBool("check");
      if (checkValue != null) {
        if (checkValue) {
          facebookTime.text = sharedPreferences.getString("facebook");
          instagramTime.text = sharedPreferences.getString("instagram");
        } else {
          facebookTime.clear();
          instagramTime.clear();
          sharedPreferences.clear();
        }
      } else {
        checkValue = false;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white12,
      ),
      body: new SingleChildScrollView(
        child: _body(),
        scrollDirection: Axis.vertical,
      ),
    );
  }
  _onChanged(bool value) async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      checkValue = value;
      sharedPreferences.setString("facebook", facebookTime.text);
      sharedPreferences.setString("instagram", instagramTime.text);
      sharedPreferences.setString("mood", moodScore.text);
//      sharedPreferences.commit();
      getInformation();
    });
  }
//  String getColor()  {
//    sharedPreferences = SharedPreferences.getInstance();
//    String mood = sharedPreferences.getString("moodscore");
//    return mood;
//  }

  Widget _body() {
    return new Container(
      padding: EdgeInsets.only(right: 20.0, left: 20.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          new TextField(
            controller: facebookTime,
            decoration: new InputDecoration(labelText: "Facebook Time (in minutes)", hintText: "50"),
            keyboardType: TextInputType.number,
            //controller: userCtrl,
//                decoration: InputDecoration(
//                    hintText: "45",
//                    contentPadding: const EdgeInsets.all(20)),
            style: TextStyle(
              color: Colors.grey[850],
              fontSize: 20.0,
              fontFamily: "WorkSans",
            ),
          ),

          TextField(
            controller: instagramTime,
            decoration: new InputDecoration(labelText: "Instagram Time (in minutes)", hintText: "45"),
            keyboardType: TextInputType.number,
            //controller: userCtrl,
//                decoration: InputDecoration(
//                    hintText: "60",
//                    contentPadding: const EdgeInsets.all(20)),
            style: TextStyle(
              color: Colors.grey[850],
              fontSize: 20.0,
              fontFamily: "WorkSans",
            ),

          ),
          new TextField(
            controller: moodScore,

            decoration: new InputDecoration(labelText: "Mood Score out of 10", hintText: "9 :)"),
            keyboardType: TextInputType.number,
            //controller: userCtrl,
//                decoration: InputDecoration(
//                    hintText: "60",
//                    contentPadding: const EdgeInsets.all(20)),
            style: TextStyle(
              color: Colors.grey[850],
              fontSize: 20.0,
              fontFamily: "WorkSans",
            ),
          ),
          new RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
              ),
          new RaisedButton(
                onPressed: () {
                  _onChanged(checkValue);

                  Navigator.pop(context);
                },
                  // go back but submit
                child: Text("Submit")
              ),

        ],
      ),
    );
  }

}

//class SecondRoute extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Daily Tracker Form"),
//      ),
//      body: Center(
//          child: Column(
//            children: <Widget>[
//
//              TextField(
//                controller: facebookTime,
//                decoration: new InputDecoration(labelText: "Facebook Time (in minutes)", hintText: "50"),
//                keyboardType: TextInputType.number,
//                //controller: userCtrl,
////                decoration: InputDecoration(
////                    hintText: "45",
////                    contentPadding: const EdgeInsets.all(20)),
//                style: TextStyle(
//                  color: Colors.grey[850],
//                  fontSize: 20.0,
//                  fontFamily: "WorkSans",
//                ),
//              ),
//
//              TextField(
//                controller: instagramTime,
//                decoration: new InputDecoration(labelText: "Instagram Time (in minutes)", hintText: "45"),
//                keyboardType: TextInputType.number,
//                //controller: userCtrl,
////                decoration: InputDecoration(
////                    hintText: "60",
////                    contentPadding: const EdgeInsets.all(20)),
//                style: TextStyle(
//                  color: Colors.grey[850],
//                  fontSize: 20.0,
//                  fontFamily: "WorkSans",
//                ),
//
//              ),
//              TextField(
//                controller: moodScore,
//                decoration: new InputDecoration(labelText: "Mood Score out of 10", hintText: "9 :)"),
//                keyboardType: TextInputType.number,
//                //controller: userCtrl,
////                decoration: InputDecoration(
////                    hintText: "60",
////                    contentPadding: const EdgeInsets.all(20)),
//                style: TextStyle(
//                  color: Colors.grey[850],
//                  fontSize: 20.0,
//                  fontFamily: "WorkSans",
//                ),
//
//              ),
//              RaisedButton(
//                onPressed: () {
//                  Navigator.pop(context);
//                },
//                child: Text("Cancel"),
//              ),
//              RaisedButton(
//                onPressed: () {
//
//                  Navigator.pop(context);
//                },
//                  // go back but submit
//                child: Text("Submit")
//              ),
//              Expanded(
//                child: FittedBox(
//                  fit: BoxFit.contain, // otherwise the logo will be tiny
////                  child: const FlutterLogo(),
//                ),
//              ),
//            ],
//          )
//
//        )
//      );
//  }
//
//}
import 'package:flutter/material.dart';
import 'package:time/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:time/timesheetoperations.dart' as tsop;
import 'package:flutter_typeahead/flutter_typeahead.dart';


getActivitiesAsList() async {
  var activities = await tsop.getActivities();
  return activities;
}

class BackendService {
  static Future getSuggestions(String query) async {
    // await Future.delayed(Duration(seconds: 1));

    var activities = await getActivitiesAsList();
    var activitieslist = List<String>.from(activities);

    activitieslist
        .retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return activitieslist;
  }
}

var numberOfTimers = 0;

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();

  String _selectedCity;
  var mrTimesheet;

  // void makeAlarm(int alarmnumber, String activitytype, String docname) async {
  //   const androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //       'your channel id', 'your channel name', 'your channel description',
  //       icon: 'ic_stat_name',
  //       playSound: false,
  //       priority: Priority.high,
  //       importance: Importance.max,
  //       ongoing: true,
  //       autoCancel: false);

  //   const platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);

  //   await flutterLocalNotificationsPlugin.show(
  //       alarmnumber, activitytype, docname, platformChannelSpecifics,
  //       payload: 'this is the payload');
  // }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(labelText: 'Activity'),
                controller: this._typeAheadController,
              ),
              suggestionsCallback: (pattern) async {
                return await BackendService.getSuggestions(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                this._typeAheadController.text = suggestion;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please select an Activity';
                } else {
                  return null;
                }
              },
              onSaved: (value) => null,
            ),
            ElevatedButton(
              child: Text('Create'),
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  var res =
                      await tsop.createTimesheet(_typeAheadController.text);
                  mrTimesheet = res['data']['name'];
                  // print(res);
                  var activityname =
                      res['data']['time_logs'][0]['activity_type'];

                  // makeAlarm(numberOfTimers, activityname, mrTimesheet);
                  print(numberOfTimers);
                  numberOfTimers++;
                }
              },
            ),
            ElevatedButton(
              child: Text('Get'),
              onPressed: () async {
                var result =
                    await tsop.getSpecificTimesheetDocument(mrTimesheet);
                // print(result);
              },
            ),
            ElevatedButton(
              child: Text('Stop'),
              onPressed: () {
                // print(mrTimesheet);
                tsop.stopTimesheet(mrTimesheet);
              },
            ),
            ElevatedButton(
              child: Text('Get Running'),
              onPressed: () {
                // print(mrTimesheet);
                tsop.getRunningTimesheetsAsNameList();
              },
            ),
            // firsttryfuture()
            // Text(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        FloatingActionButton(
          child: Icon(Icons.star),
          onPressed: () {
            // getTimesheetDocument();
          },
          heroTag: null,
        ),
        SizedBox(
          width: 10,
        ),
        FloatingActionButton(
          child: Icon(Icons.ac_unit),
          onPressed: () {
            // getTimesheetDocument();
          },
          heroTag: null,
        ),
        SizedBox(
          width: 10,
        ),
        FloatingActionButton(
          child: Icon(Icons.games),
          onPressed: () {
            // getTimesheetDocument();
          },
          heroTag: null,
        ),
        SizedBox(
          width: 10,
        ),
        FloatingActionButton(
          child: Icon(Icons.accessibility),
          onPressed: () {
            // makeAlarm();
          },
          heroTag: null,
        ),
        SizedBox(
          width: 10,
        ),
      ]),
    );
  }
}

FutureBuilder firsttryfuture() {
  return (FutureBuilder(
    future: tsop.getSpecificTimesheetDocument("TS-2020-00117"),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Text(snapshot.data['data']['time_logs'][0].toString());
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }
      return CircularProgressIndicator();
    },
  ));
}
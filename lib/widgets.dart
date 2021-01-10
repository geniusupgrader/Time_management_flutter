import 'package:flutter/material.dart';
import 'package:time/main.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:time/timesheetoperations.dart' as tsop;
import 'package:http/http.dart' as http;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:time/data.dart';

// getthing() async {
//   var data = await tsop.getActivities();
//   return data;
// }


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

  void makeAlarm(int alarmnumber, String activitytype, String docname) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        icon: 'ic_stat_name',
        playSound: false,
        priority: Priority.high,
        importance: Importance.max,
        ongoing: true,
        autoCancel: false);

    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        alarmnumber, activitytype, docname, platformChannelSpecifics,
        payload: 'this is the payload');
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
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

              // List data;
              // getthing() async {
              //   data = await tsop.getActivities();
              //   // print(data);
              //   var activitieslist = List<dynamic>.from(data);
              //   print(activitieslist.contains(value));

              //   if (value.isEmpty) {
              //     return 'Please select an Activity';
              //   } else if (!(activitieslist.contains(value))) {
              //     print("hallo");
              //     return 'Please select existing Activity';
              //   } else {
              //     return null;
              //   }
              // }
              // getthing();
            },
            onSaved: (value) => _selectedCity = value,
          ),
          ElevatedButton(
            child: Text('Create'),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                var res = await tsop.createTimesheet(_typeAheadController.text);
                mrTimesheet = res['data']['name'];
                // print(res);
                var activityname = res['data']['time_logs'][0]['activity_type'];
                                
                makeAlarm(numberOfTimers, activityname, mrTimesheet);
                print(numberOfTimers);
                numberOfTimers++;
              }
            },
          ),
          ElevatedButton(
            child: Text('Get'),
            onPressed: () async {
              var result = await tsop.getSpecificTimesheetDocument(mrTimesheet);
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

class ListViews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Map'),
          ),
          ListTile(
            leading: Icon(Icons.photo_album),
            title: Text('Album'),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Phone'),
          ),
        ],
      ),
    );
  }
}

class VeryGoodList extends StatefulWidget {
  @override
  VeryGoodListState createState() => new VeryGoodListState();
}

class VeryGoodListState extends State<VeryGoodList> {
  List data;

  // calcdauer() {}

  getthing() async {
    var data2 = await tsop.getRunningTimesheetDocuments();
    this.setState(() {
      data = data2;
    });
    return "Success!";
  }

  @override
  void initState() {
    this.getthing();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
              child: new ListTile(
            title: Text(data[index]['data']['time_logs'][0]['activity_type']),
            subtitle: Text(data[index]['data']['name']),
            isThreeLine: true,
            dense: true,
            onLongPress: () async{
              // print(data[index]['data']['name']);
              tsop.stopTimesheet(data[index]['data']['name']);
              await flutterLocalNotificationsPlugin.cancel(index);
              print(index);
              numberOfTimers--;
            },
          ));
        },
      ),
    );
  }
}

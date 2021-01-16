// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:time/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:time/timesheetoperations.dart' as tsop;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:time/data.dart';

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
              onSaved: (value) => _selectedCity = value,
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

                  makeAlarm(numberOfTimers, activityname, mrTimesheet);
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
    super.initState();
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
            onLongPress: () async {
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

class ActivityList extends StatefulWidget {
  @override
  ActivityListState createState() => new ActivityListState();
}

class ActivityListState extends State<ActivityList> {
  // List data;
  List<String> filteredList;
  List<String> fulllist;

  bool started = false;
  bool runningtimesheet = false;

  Future _myfutur;
  // Future _myfutur2;

  int indexdefault = 0;
  String activitydefault = "0";

  void togglebutton(runningtimesheet) {
    runningtimesheet = !runningtimesheet;
  }

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    started = true;
    _myfutur = getActivitiesfuture();
    // _myfutur2 = getRunningTimesheetfuture(indexdefault, activitydefault);
  }

  getActivitiesfuture() async {
    var data2 = await tsop.getActivities();
    fulllist = List.from(data2);
    return fulllist;
  }

  getRunningTimesheetfuture(index, activity) async {
    List data = await tsop.getAllRunningTimesheetDocumentfromActivity(activity);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _myfutur,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return new Scaffold(
              body: new Column(
                children: <Widget>[
                  new TextField(
                    controller: controller,
                    // onSubmitted: (text) {
                    //   fulllist.add("neger");
                    //   controller.clear();
                    //   setState(() {});
                    // },
                    onChanged: onItemChanged,
                  ),
                  new Expanded(
                    child: new ListView.builder(
                      itemCount: filteredList == null ? 0 : filteredList.length,
                      itemBuilder: (BuildContext context, int index) =>
                          buildbody(context, index, filteredList),
                    ),
                  )
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  onItemChanged(String value) async {
    setState(() {
      filteredList = fulllist
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  Widget getButton(runningtimesheet, timesheet, activity) {
    if (runningtimesheet) {
      return IconButton(
        icon: Icon(Icons.play_circle_outline),
        color: Colors.green,
        iconSize: 50,
        tooltip: 'StartTimer',
        onPressed: () {
          setState(() {
            tsop.stopTimesheet(timesheet[0]);
            runningtimesheet = false;
          });
        },
      );
    } else {
      return IconButton(
        icon: Icon(Icons.play_circle_outline),
        // color: Colors.green,
        iconSize: 50,
        tooltip: 'StartTimer',
        onPressed: () async{
          await tsop.createTimesheet(activity);
          setState(() {
            runningtimesheet = true;
          });
        },
      );
    }
  }

  Widget buildbody(BuildContext ctxt, int index, filteredlist) {
    return FutureBuilder(
        future: getRunningTimesheetfuture(index, filteredlist[index]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data.isEmpty) {
                runningtimesheet = false;
              } else {
                runningtimesheet = true;
              }
            }
            return new Card(
                child: new ListTile(
              title: Text(filteredList[index].toString()),
              subtitle: Text(runningtimesheet.toString()),
              isThreeLine: true,
              dense: true,
              trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                getButton(runningtimesheet, snapshot.data, filteredlist[index])
              ]),
              onTap: () {},
              // onLongPress: () async {
              //   // print(data[index]['data']['name']);
              //   tsop.stopTimesheet(data[index]['data']['name']);
              //   await flutterLocalNotificationsPlugin.cancel(index);
              //   print(index);
              //   numberOfTimers--;
              // },
            ));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

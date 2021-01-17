import 'package:flutter/material.dart';
import 'package:time/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:time/timesheetoperations.dart' as tsop;

class ActivityList extends StatefulWidget {
  @override
  ActivityListState createState() => new ActivityListState();
}

class ActivityListState extends State<ActivityList> {
  // List data;
  List<String> filteredList = [];
  List<String> fulllist = [];
  List<String> sortedlist = [];

List data;

  bool runningtimesheet = false;

  Future _myfutur2;
  // Future _myfutur2;

  int indexdefault = 0;
  String activitydefault = "0";

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _myfutur2 = getActivitiesfuturewhole();
  }


  getActivitiesfuturewhole() async {
    var data2 = await tsop.getActivities();
    fulllist = List.from(data2);
    filteredList = fulllist;

// first get all running timesheets
    var allrunningtimesheets = await tsop.getRunningTimesheetsAsNameList();
    // print(uiae);

flutterLocalNotificationsPlugin.cancelAll();
// flutterLocalNotificationsPlugin.cancel(index);

// find the Activity_type:
    for (var entry in allrunningtimesheets) {
      var res = await tsop.getSpecificTimesheetDocument(entry);
      // and when it is there...
      if (res['data']['time_logs'][0].containsKey('activity_type')) {
        // put it in an temporary list
        sortedlist.add(res['data']['time_logs'][0]['activity_type']);
      }
    }
    // outside the for loop, move all entries in sortedlist to above
    // print("sortedlist");
    // print(sortedlist);
    // print("sortedlist,reversed");
    // print(sortedlist.reversed);

var revsero = sortedlist.reversed.toList();
// print(revsero);

    for (var entry in sortedlist) {
      // print("sortedlist.indexOf(entry)");
      // print(sortedlist.indexOf(entry));
      // print("resero.indexOf(entry)");
      // print(revsero.indexOf(entry));
      // print("entrty");
      // print(entry);
      // print("last");
      // print(sortedlist.indexOf(sortedlist.last));

makeAlarm(revsero.indexOf(entry), entry, "dtrn");

      filteredList.remove(entry);
      filteredList.insert(0, entry);
    }
    // empty the sortedlist for the next call somewhen
    sortedlist = [];

    // return the main list, which is used in the build method
    return filteredList;
  }

  Future<Null> _handleRefresh() async {
    setState(() {
      _myfutur2 = getActivitiesfuturewhole();
    });
  }

  getRunningTimesheetfuture(index, activity) async {
    data = await tsop.getAllRunningTimesheetDocumentfromActivity(activity);
    return data;
  }

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

    List<ActiveNotification> activeNotifications =
        await FlutterLocalNotificationsPlugin()
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            .getActiveNotifications();

    bool notificationthere = false;
    for (var notification in activeNotifications) {
      if (notification.id == alarmnumber) {
        notificationthere = true;
      }
    }

    if (!notificationthere) {
      print("make Alarm!");
      await flutterLocalNotificationsPlugin.show(
          alarmnumber, activitytype, docname, platformChannelSpecifics,
          payload: 'this is the payload');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _myfutur2,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return new Scaffold(
              body: new Column(
                children: <Widget>[
                  new TextField(
                    controller: controller,
                    // onSubmitted: (text) { },
                    onChanged: onItemChanged,
                  ),
                  new Expanded(
                      flex: 1,
                      child: RefreshIndicator(
                          child: new ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                filteredList == null ? 0 : filteredList.length,
                            itemBuilder: (BuildContext context, int index) =>
                                buildbody(context, index, filteredList),
                          ),
                          onRefresh: _handleRefresh))
                ],
              ),
            );
          } else {
            return LinearProgressIndicator();
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

  Widget buildbody(BuildContext ctxt, int index, List filteredlist) {
    return FutureBuilder(
        future: getRunningTimesheetfuture(index, filteredlist[index]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              if (snapshot.data.isEmpty) {
                runningtimesheet = false;
                // flutterLocalNotificationsPlugin.cancel(index);
              } else {
                runningtimesheet = true;

              }
            }
            return new Card(
                child: new ListTile(
              title: Text(filteredList[index].toString(),
                  style: TextStyle(fontSize: 18)),
              // subtitle: Text(runningtimesheet.toString()),
              isThreeLine: false,
              dense: false,
              trailing: new Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    getButton(index, runningtimesheet, snapshot.data, filteredlist[index])
                  ]),
              onTap: () {},
              onLongPress: () async {},
            ));
          } else {
            return LinearProgressIndicator();
          }
        });
  }

  Widget getButton(index, runningtimesheet, timesheet, activity) {
    if (runningtimesheet) {
      return new IconButton(
        icon: Icon(Icons.play_circle_outline),
        color: Colors.green,
        iconSize: 50,
        padding: EdgeInsets.all(0),
        tooltip: 'StartTimer',
        onPressed: () async {
          // print(timesheet[0]);
          await tsop.stopTimesheet(timesheet[0]);
          // print(index);
          setState(() {
            runningtimesheet = false;
            _myfutur2 = getActivitiesfuturewhole();
          flutterLocalNotificationsPlugin.cancel(index);

          });
        },
      );
    } else {
      return new IconButton(
        icon: Icon(Icons.play_circle_outline),
        // color: Colors.green,
        iconSize: 50,
        padding: EdgeInsets.all(0),
        tooltip: 'StartTimer',
        onPressed: () async {
                //           print("index");
                // print(index);
                // print("snapshot.data[0].toString()");
                // print(data.toString());
                // print("filteredList[index]");
                // print(filteredList[index]);

                          // makeAlarm(index, filteredList[index], data.toString());
// print("activity");
// print(activity);
// print("filteredList");
// print(filteredList);
          tsop.createTimesheet(activity);
          setState(() {
            runningtimesheet = true;
            _myfutur2 = getActivitiesfuturewhole();
          });
        },
      );
    }
  }
}

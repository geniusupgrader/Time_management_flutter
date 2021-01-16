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
  List<String> filteredList;
  List<String> fulllist;

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
    getActivitiesfuture();
    _myfutur = getActivitiesfuture();
  }

  getActivitiesfuture() async {
    var data2 = await tsop.getActivities();
    fulllist = List.from(data2);
    filteredList = fulllist;
    return fulllist;
  }

  Future<Null> _handleRefresh() async {
    await tsop.getActivities();
    setState(() {});
  }

  getRunningTimesheetfuture(index, activity) async {
    List data = await tsop.getAllRunningTimesheetDocumentfromActivity(activity);
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
                      flex: 1,
                      child: RefreshIndicator(
                          child: new ListView.builder(
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

  Widget getButton(index, runningtimesheet, timesheet, activity) {
    if (runningtimesheet) {
      return IconButton(
        icon: Icon(Icons.play_circle_outline),
        color: Colors.green,
        iconSize: 50,
        tooltip: 'StartTimer',
        onPressed: () async {
          await flutterLocalNotificationsPlugin.cancel(index);
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
        onPressed: () async {
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
                flutterLocalNotificationsPlugin.cancel(index);
              } else {
                runningtimesheet = true;
                // print(index);

                makeAlarm(
                    index, filteredList[index], snapshot.data[0].toString());
              }
            }
            return new Card(
                child: new ListTile(
              title: Text(filteredList[index].toString()),
              subtitle: Text(runningtimesheet.toString()),
              isThreeLine: true,
              dense: true,
              trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                getButton(
                    index, runningtimesheet, snapshot.data, filteredlist[index])
              ]),
              onTap: () {},
              onLongPress: () async {},
            ));
          } else {
            return LinearProgressIndicator();
          }
        });
  }
}

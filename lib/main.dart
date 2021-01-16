import 'package:flutter/material.dart';
import 'package:time/widgets.dart' as wid;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
// ------------- Initializations for Notifications (Only Android for now) ----------------
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_stat_name');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  });
// ------------- Initializations for Notifications (Only Android for now) ----------------

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DefaultTabControllerWithAppbar(),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class DefaultTabControllerWithAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text("TimeSheet"),
            bottom: TabBar(tabs: [
              Tab(text: 'Control Timesheet'),
              // Tab(text: 'Active Timers'),
              Tab(text: 'Activities'),
              Tab(text: 'test'),
              // Tab(text: 'Old')
            ]),
          ),
          body: TabBarView(children: [
            wid.MyCustomForm(),
            // wid.VeryGoodList(),
            wid.ActivityList(),
            MyApp2(),
            // wid.ListSearch(),
            // MyHomePage( title: "hallo", ),
            // wid.firsttryfuture(),
          ])),
    );
  }
}








class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            MyListTile(title: 'First'),
            MyListTile(title: 'Second'),
            MyListTile(title: 'Third'),
          ],
        ),
      ),
    );
  }
}

class MyListTile extends StatefulWidget {
  final String title;

  MyListTile({this.title});

  @override
  _MyListTileState createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  int status = 0;

  get tileColor {
    switch(status) {
      case 0: {
        return Colors.white;
      }
      case 1: {
        return Colors.green;
      }
      default: {
        return Colors.red;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: tileColor,
      child: ListTile(
        title: Text(widget.title),
        subtitle: Text('Status: $status'),
        onTap: () => setState(() {
          status++;
        }),
      ),
    );
  }
}






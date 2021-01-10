import 'package:flutter/material.dart';
import 'package:time/widgets.dart' as wid;
import 'package:time/timesheetoperations.dart' as tsop;
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
            title: Text("Tabs dtrn"),
            bottom: TabBar(tabs: [
              Tab(text: 'Control Timesheet'),
              Tab(text: 'Active Timers'),
              Tab(text: 'Old')
            ]),
          ),
          body: TabBarView(children: [
            wid.MyCustomForm(),
            wid.VeryGoodList(),
            MyHomePage( title: "hallo", ),
            // wid.firsttryfuture(),
          ])),
    );
  }
}

// -------------------- Old Application --------------------------

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            wid.MyCustomForm(),
            // wid.firsttryfuture(),
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
// -------------------- Old Application --------------------------

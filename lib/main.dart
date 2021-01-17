import 'package:flutter/material.dart';
import 'package:time/widgets.dart' as wid;
import 'package:time/altercode.dart' as alt;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:universal_io/io.dart';




final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


void main() async {



print(Platform.operatingSystem);

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
      // home: DefaultTabControllerWithAppbar(),
      home: MyHomePage(title: "Time"),
      // home: MyApp3(),
      // home: UserList(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: wid.ActivityList(),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DefaultTabControllerWithAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
          appBar: AppBar(
            title: Text("TimeSheet"),
            bottom: TabBar(tabs: [
              // Tab(text: 'Control Timesheet'),
              // Tab(text: 'Active Timers'),
              Tab(text: 'Activities'),
              // Tab(text: 'test'),
              // Tab(text: 'Old')
            ]),
          ),
          body: TabBarView(children: [
            // alt.MyCustomForm(),
            // wid.VeryGoodList(),
            wid.ActivityList(),
            // MyApp2(),
            // wid.ListSearch(),
            // MyHomePage( title: "hallo", ),
            // wid.firsttryfuture(),
          ])),
    );
  }
}





class MyApp3 extends StatefulWidget {
  @override
  _MyApp3State createState() => _MyApp3State();
}

class _MyApp3State extends State<MyApp3> {
  List<int> ids = [];
  initState() {
    super.initState();
    for (var i = 0; i < 100; i++) {
      ids.add(i);
    }
    new Future.delayed(Duration(seconds: 3)).then((_) {
      setState(() {
        ids[4] = 1000;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
          itemCount: ids.length,
          itemBuilder: (context, idx) {
            return ListTile(title: Text('${ids[idx]}'));
          },
        ),
      ),
    );
  }
}
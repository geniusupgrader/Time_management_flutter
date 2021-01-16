import 'package:flutter/material.dart';
import 'package:time/widgets.dart' as wid;
import 'package:time/altercode.dart' as alt;
import 'dart:convert';
import 'package:http/http.dart' as http;
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





class UserList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserListState();
  }
}

class _UserListState extends State<UserList> {
  final String apiUrl = "https://randomuser.me/api/?results=10";

  List<dynamic> _users = [];

  void fetchUsers() async {
    var result = await http.get(apiUrl);
    setState(() {
      _users = json.decode(result.body)['results'];
    });
  }

  String _name(dynamic user) {
    return user['name']['title'] +
        " " +
        user['name']['first'] +
        " " +
        user['name']['last'];
  }

  String _location(dynamic user) {
    return user['location']['country'];
  }

  String _age(Map<dynamic, dynamic> user) {
    return "Age: " + user['dob']['age'].toString();
  }

  Widget _buildList() {
    return _users.length != 0
        ? RefreshIndicator(
            child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: _users.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  _users[index]['picture']['large'])),
                          title: Text(_name(_users[index])),
                          subtitle: Text(_location(_users[index])),
                          trailing: Text(_age(_users[index])),
                        )
                      ],
                    ),
                  );
                }),
            onRefresh: _getData,
          )
        : Center(child: CircularProgressIndicator());
  }

  Future<void> _getData() async {
    setState(() {
      fetchUsers();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: Container(
        child: _buildList(),
      ),
    );
  }
}












    class MyApp3 extends StatefulWidget {
      @override
      State<StatefulWidget> createState() => MyApp3State();
    }

    class MyApp3State extends State<MyApp3> {
      List<int> items = List.generate(16, (i) => i);

      Future<Null> _handleRefresh() async {
        await Future.delayed(Duration(seconds: 5), () {
          print('refresh');
          setState(() {
            items.clear();
            items = List.generate(40, (i) => i);
          });
        });
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Refresh"),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: RefreshIndicator(
                  child: ListView.builder(
                    itemCount: items.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("Index$index"),
                      );
                    },
                  ),
                  onRefresh: _handleRefresh,
                ),
              )
            ],
          ),
        );
      }
    }








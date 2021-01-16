import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future getSpecificTimesheetDocument(String timesheetDocument) async {
  Map<String, String> tokenautentication = {
    'Authorization': "token d7ab76ea1eeda3d:1605c9b72447646"
  };
  var respond = await http.get(
      'https://erpnext.roros.duckdns.org/api/resource/Timesheet/' +
          timesheetDocument,
      headers: tokenautentication);
  Map<String, dynamic> res = jsonDecode(respond.body);
  return res;
}



Future getAllRunningTimesheetDocumentfromActivity(activity) async {
  // assuming every timesheet has exactly one entry in time_logs table
  // List all Timesheets which have are in Draft state

  Map<String, String> tokenautentication = {
    'Authorization': "token d7ab76ea1eeda3d:1605c9b72447646"
  };

  var stringi = """?filters=[["status", "=", "Draft"]]""";

  var respond = await http.get(
      'https://erpnext.roros.duckdns.org/api/resource/Timesheet' + stringi,
      headers: tokenautentication);

  Map<String, dynamic> res = jsonDecode(respond.body);
  var res2 = res['data'];

// now filter where first table has to_time
  var aslist = [];

  for (var i = 0; i < res2.length; i++) {
    // print(res2[i]['name']);
    var doc = await getSpecificTimesheetDocument(res2[i]['name']);
    // check if doc has 'to_time' field (in first row of time_logs):
    // print(doc['data']['time_logs'][0].containsKey('to_time'));
    // print(doc);
    if (doc['data']['time_logs'][0].containsKey('to_time')) {
      // if yes, then it was already finished
    } else {
      // if no, then check if the activity machtes
      if (doc['data']['time_logs'][0]['activity_type'] == activity) {
      // then add the name to the list RunningTimesheets
      aslist.add(res2[i]['name']);
    }
  }
}
  return aslist;
}



Future getRunningTimesheetsAsNameList() async {
  // assuming every timesheet has exactly one entry in time_logs table
  // List all Timesheets which have are in Draft state

  Map<String, String> tokenautentication = {
    'Authorization': "token d7ab76ea1eeda3d:1605c9b72447646"
  };

  var stringi = """?filters=[["status", "=", "Draft"]]""";

  var respond = await http.get(
      'https://erpnext.roros.duckdns.org/api/resource/Timesheet' + stringi,
      headers: tokenautentication);

  Map<String, dynamic> res = jsonDecode(respond.body);
  var res2 = res['data'];

// now filter where first table has to_time
  var aslist = [];

  for (var i = 0; i < res2.length; i++) {
    // print(res2[i]['name']);
    var doc = await getSpecificTimesheetDocument(res2[i]['name']);
    // check if doc has 'to_time' field (in first row of time_logs):
    // print(doc['data']['time_logs'][0].containsKey('to_time'));
    if (doc['data']['time_logs'][0].containsKey('to_time')) {
      // if yes, then it was already finished
    } else {
      // if no, then add the name to the list RunningTimesheets
      aslist.add(res2[i]['name']);
    }
  }
  // print("from getRunningTimesheetsAsList");
  // print(aslist.toString());

  return aslist;
}

Future getRunningTimesheetDocuments() async {
  List nan = await getRunningTimesheetsAsNameList();

  List uiae = [];

  for (var i = 0; i < nan.length; i++) {
    var doc = await getSpecificTimesheetDocument(nan[i]);
    uiae.add(doc);
  }
  return uiae;
}

Future getActivities() async {
  Map<String, String> tokenautentication = {
    'Authorization': "token d7ab76ea1eeda3d:1605c9b72447646"
  };
  var respond = await http.get(
      'https://erpnext.roros.duckdns.org/api/resource/Activity%20Type',
      headers: tokenautentication);
  var res = jsonDecode(respond.body);
  res = res['data'];
  var aslist = [];
  for (var i = 0; i < res.length; i++) {
    // print(res[i]['name']);
    aslist.add(res[i]['name']);
  }
  // print(aslist);
  return aslist;
}

Future createTimesheet(String activityName) async {
  Map<String, String> tokenautentication = {
    'Authorization': "token d7ab76ea1eeda3d:1605c9b72447646"
  };
  var now = new DateTime.now();

  var postrequestString = {
    'time_logs': [
      {'activity_type': activityName, 'from_time': now.toString()},
    ],
    'employee': 'HR-EMP-00001'
  };
  var postrequestJson = jsonEncode(postrequestString);
  var respond = await http.post(
      'https://erpnext.roros.duckdns.org/api/resource/Timesheet',
      headers: tokenautentication,
      body: postrequestJson);
  var res = jsonDecode(respond.body);

  return res;
}

Future stopTimesheet(String timesheetname) async {
  Map<String, String> tokenautentication = {
    'Authorization': "token d7ab76ea1eeda3d:1605c9b72447646"
  };

  // first get the time_logs table:
  var timesheetdoc = await getSpecificTimesheetDocument(timesheetname);
  // print(timesheetdoc);
  var now = new DateTime.now().toString();
  // print("timesheetdoc");
  // print(timesheetdoc);
  timesheetdoc['data']['time_logs'][0]['to_time'] = now;
  // print("New timesheetdoc");
  // print(timesheetdoc);
  // log(timesheetdoc.toString());

  var postrequestJson2 = jsonEncode(timesheetdoc['data']);
  // print("postrequestJson2");
  // log(postrequestJson2.toString());
  var respond = await http.put(
      'https://erpnext.roros.duckdns.org/api/resource/Timesheet/' +
          timesheetname,
      headers: tokenautentication,
      body: postrequestJson2);
  var res = jsonDecode(respond.body);
  // print(res);
  // print("res");
  // log(res.toString());
  return res;
}

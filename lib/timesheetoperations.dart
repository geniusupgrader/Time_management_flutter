import 'dart:convert';
import 'package:http/http.dart' as http;

Future getTimesheetDocument(String timesheetDocument) async {
  Map<String, String> tokenautentication = {
    'Authorization': "token d7ab76ea1eeda3d:1605c9b72447646"
  };
  var respond = await http.get(
      'https://erpnext.roros.duckdns.org/api/resource/Timesheet/' +
          timesheetDocument,
      headers: tokenautentication);
  var res = jsonDecode(respond.body);

  print(res);
  // print('howdy, ${res['data']['name']}');
  // var dtrn = res['data']['name'];
  return res;
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
  for (var i=0; i < res.length; i++){
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
  // print(now);

  var postrequestString = {
    'time_logs': [
      {'activity_type': activityName, 'from_time': now.toString()},
      // {'activity_type': activityName, 'from_time': '2021-01-02 10:20:02.0'},
    ]
  };
  var postrequestJson = jsonEncode(postrequestString);
  var respond = await http.post(
      'https://erpnext.roros.duckdns.org/api/resource/Timesheet',
      headers: tokenautentication,
      body: postrequestJson);
  var res = jsonDecode(respond.body);

  // print(respond.statusCode);
  // print(respond.reasonPhrase);
  // print(res);
  return res;
}

Future stopTimesheet(String timesheetname) async {
  Map<String, String> tokenautentication = {
    'Authorization': "token d7ab76ea1eeda3d:1605c9b72447646"
  };
  var now = new DateTime.now();

  var postrequestString = {
    'time_logs': [
      {'to_time': now.toString()}
    ]
  };
  var postrequestJson = jsonEncode(postrequestString);
  var respond = await http.put(
      'https://erpnext.roros.duckdns.org/api/resource/Timesheet/' +
          timesheetname,
      headers: tokenautentication,
      body: postrequestJson);
  var res = jsonDecode(respond.body);
  print(res);
  // print(respond.reasonPhrase);
  return res;
}

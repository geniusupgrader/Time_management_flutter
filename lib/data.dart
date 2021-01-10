import 'package:time/timesheetoperations.dart' as tsop;

getActivitiesAsList() async {
  var activities = await tsop.getActivities();
  return activities;
}

class BackendService {
  static Future getSuggestions(String query) async {
    // await Future.delayed(Duration(seconds: 1));

    var activities = await getActivitiesAsList();
    var activitieslist = List<String>.from(activities);

    activitieslist
        .retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return activitieslist;
  }
}

import 'dart:math';
import 'package:time/timesheetoperations.dart' as tsop;

getres() async {
  var arar = await tsop.getActivities();
  // print(arar);
  return arar;
}

class BackendService {
  static Future getSuggestions(String query) async {
    // await Future.delayed(Duration(seconds: 1));

    var cities2 = await getres();
    print(cities2);
    print(cities2.runtimeType);

    // var strings = cities2.Cast<String>().ToList();
    var strings = List<String>.from(cities2);
    print(strings);
    print(strings.runtimeType);

    // print(cities2);
    // var cities3 = cities2.toString();

    // List<String> matches = List();
    // matches.addAll(cities);

    strings.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));

    return strings;

// return ["hallo", "tag", "auch"];

    // return List.generate(3, (index) {
    //   return {'name': query + index.toString(), 'price': Random().nextInt(100)};
    // });
  }
}

class CitiesService {
  var cities2 = getres();

  static final List<String> cities = [
    'Beirut',
    'Damascus',
    'San Fransisco',
    'Rome',
    'Los Angeles',
    'Madrid',
    'Bali',
    'Barcelona',
    'Paris',
    'Bucharest',
    'New York City',
    'Philadelphia',
    'Sydney',
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = List();
    matches.addAll(cities);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));

    return matches;
  }
}

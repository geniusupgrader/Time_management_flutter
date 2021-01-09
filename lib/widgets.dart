import 'dart:async';
import 'package:flutter/material.dart';
import 'package:time/timesheetoperations.dart' as tsop;
import 'package:flutter_typeahead/flutter_typeahead.dart';

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  var mrTimesheet;

  TextEditingController emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Enter Activity:',
          ),
          TextFormField(
            controller: emailController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some Activity';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ElevatedButton(
              child: Text('Create Timesheet Document'),
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  // print(_formKey.currentState.validate());
                  // print(emailController.text);
                  var res = tsop.createTimesheet(emailController.text);
                  mrTimesheet = "";

                  getres() async {
                    // print(await res);
                    mrTimesheet = await res;
                    mrTimesheet = mrTimesheet['data']['name'];
                    print("created Timesheet with name:");
                    print(mrTimesheet);
                  }

                  getres();
                  // Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                }
              },
            ),
          ),
          ElevatedButton(
            child: Text('Get Timesheet'),
            onPressed: () {
              var result = tsop.getTimesheetDocument(mrTimesheet);
              Future<void> getres() async {
                // print(await res);
                mrTimesheet = await result;
                // print(mrTimesheet);
                // var mrTimesheet2 = jsonDecode(mrTimesheet);
                mrTimesheet = mrTimesheet['data']['name'];
                // print("get Timesheet. The name is:");
                // print(mrTimesheet);
              }

              getres();
            },
          ),
          ElevatedButton(
            child: Text('Stop Timesheet'),
            onPressed: () {
              // print(mrTimesheet);
              tsop.stopTimesheet(mrTimesheet);
            },
          ),
        ],
      ),
    );
  }
}

class ActivityForm extends StatefulWidget {
  @override
  ActivityFormState createState() {
    return ActivityFormState();
  }
}

class ActivityFormState extends State<ActivityForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  String _selectedCity;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: this._formKey,
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: Column(
          children: <Widget>[
            Text('What is your favorite city?'),
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                  controller: this._typeAheadController,
                  decoration: InputDecoration(labelText: 'City')),
              suggestionsCallback: (pattern) {
                // return CitiesService.getSuggestions(pattern);
                return ["hallo", "pisse", "neger"];
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  title: Text(suggestion),
                );
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                this._typeAheadController.text = suggestion;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please select a city';
                }
              },
              onSaved: (value) => this._selectedCity = value,
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              child: Text('Submit'),
              onPressed: () {
                if (this._formKey.currentState.validate()) {
                  this._formKey.currentState.save();
                  Scaffold.of(context).showSnackBar(SnackBar(
                      content:
                          Text('Your Favorite City is ${this._selectedCity}')));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}

FutureBuilder firsttryfuture() {
  return (FutureBuilder(
    future: tsop.getTimesheetDocument("TS-2020-00117"),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        print(snapshot.data);
        return Text(snapshot.data);
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }
      return CircularProgressIndicator();
    },
  ));
}






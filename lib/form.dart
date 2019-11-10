import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TutorForm extends StatefulWidget {
  final DocumentSnapshot document;
  TutorForm({Key key, this.document}) : super(key: key);
  @override
  TutorFormState createState() => new TutorFormState();
}

class TutorFormState extends State<TutorForm> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FormInformation info = new FormInformation();

  List<String> _hours = <String>['', '0.5', '1', '1.5', '2', '2.5', '3'];
  String _currentTime = '';

  void initState() {
    super.initState();
  }

  final TextEditingController _controller = new TextEditingController();
  Future _getDate(BuildContext context, String selectedDateString) async {
    var firstDate = new DateTime(1900);
    var lastDate = new DateTime.now();
    var selectedDate;
    try {
      selectedDate = new DateFormat.yMd().parseStrict(selectedDateString);
    } catch (e) {
      selectedDate = lastDate;
    }
    if (selectedDate.isAfter(lastDate) || selectedDate.isBefore(firstDate)) {
      selectedDate = DateTime.now();
    }
    var date = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: firstDate,
        lastDate: lastDate,
    );
    if (date == null) return;
    setState(() {
      _controller.text = new DateFormat.yMd().format(date);
    });
  }

  void _submitForm() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(backgroundColor: Colors.red, content: new Text('Please answer all the questions before submitting')));
    } else {
      form.save();
      print('Name: ${info.name}');
      print('Student: ${info.student}');
      print('Date: ${info.date}');
      print('Time: ${info.time}');
      print('Work: ${info.work}');
      Navigator.of(context).pushReplacementNamed('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
        appBar: PreferredSize (
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: new Text (
            'Tutor Timesheet',
            style: new TextStyle(
              color: const Color(0xFFFFFFFF),
              fontSize: 28.0,
            ),
          ),
        ),
      ),
      body: new Form(
        key: _formKey,
        autovalidate: true,
        child: new ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            new Container (
              padding: EdgeInsets.only(bottom: 25.0),
              child:TextFormField(
                decoration: InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'Name',
                  labelText: 'Your Name',
                ),
                validator: (val) => val.isEmpty ? 'Please enter your name' : null,
                onSaved: (val) => info.name = val,
              ),
            ),
            new Container (
              padding: EdgeInsets.only(bottom: 25.0),
              child:TextFormField(
                decoration: new InputDecoration(
                  icon: const Icon(Icons.people),
                  hintText: widget.document['name'],
                  labelText: 'Students Name',
                ),
                validator: (val) => val.isEmpty ? 'Please enter the student\'s name' : null,
                onSaved: (val) => info.student = val,
              ),
            ),
            new Container (
              padding: EdgeInsets.only(bottom: 25.0),
              child: Row(children: <Widget>[
                new Expanded(
                  child: new TextFormField(
                    decoration: new InputDecoration(
                      icon: const Icon(Icons.calendar_today),
                      hintText: 'Date',
                      labelText: 'Date of the Session',
                    ),
                    controller: _controller,
                    keyboardType: TextInputType.datetime,
                    validator: (val) => val.isEmpty ? 'Please enter a date' : null,
                    onSaved: (val) => info.date = val,
                  )),
                new IconButton(
                  icon: new Icon(Icons.more_horiz),
                  tooltip: 'Choose date',
                  onPressed: () => _getDate(context, _controller.text),
                )
              ]),
            ),
            new Container (
              padding: EdgeInsets.only(bottom: 25.0),
              child: FormField (
                builder: (FormFieldState<String> state) {
                  return InputDecorator(
                    decoration: new InputDecoration(
                      icon: const Icon(Icons.access_time),
                      labelText: 'Total Tutoring Hours',
                      errorText: state.hasError ? state.errorText : null,
                    ),
                    isEmpty: _currentTime == '',
                    child: new DropdownButtonHideUnderline(
                      child: new DropdownButton <String> (
                        hint: new Text(
                          'Choose',
                        ),
                        value: _currentTime,
                        onChanged: (String time) {
                          setState(() {
                            info.time = time;
                            _currentTime = time;
                          });
                        },
                        items: _hours.map((String hour) {
                          return new DropdownMenuItem<String>(
                            value: hour,
                            child: new Text(hour),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
                validator: (val) => _currentTime == '' ? 'Please select an amount' : null,
              ),
            ),
            new Container (
              padding: EdgeInsets.only(bottom: 25.0),
              child: new TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: new InputDecoration(
                  icon: const Icon(Icons.school),
                  hintText: 'Your Answer',
                  labelText: 'What Did You Work On',
                ),
                validator: (val) => val.isEmpty ? 'Please enter what you worked on' : null,
                onSaved: (val) => info.work = val,
              ),
            ),
            new Container(
              padding: const EdgeInsets.only(top: 20.0),
              child: new RaisedButton(
                child: const Text('Submit'),
                color: Theme.of(context).primaryColorDark,
                textColor: Colors.white,
                onPressed: () => _submitForm(),
              )
            ),
          ],
        ),
      ),
    );
  }
}
class FormInformation {
  String name;
  String student;
  String date;
  String time;
  String work;
}
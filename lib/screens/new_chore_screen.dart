import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:doit_app/api/api.dart';

DateFormat _format = DateFormat("EEE, MMM d, yyyy");

class NewChoreWidget extends StatefulWidget {

  final Api _api;

  NewChoreWidget(this._api);

  @override
  _NewChoreWidgetState createState() => _NewChoreWidgetState();
}

class _NewChoreWidgetState extends State<NewChoreWidget> {

  String _frequencyValue;
  int _frequencyAmount = 3;
  String _frequencyType = "days";
  String _choreName = "";
  String _choreDetails = "";
  DateTime _startDate = DateTime.now();
  final _frequencyAmountController = TextEditingController();

  @override
  void initState() {
    _frequencyAmountController.text = _frequencyAmount.toString();
    _frequencyAmountController.addListener(() => setState(() {
      _frequencyAmount = int.parse(_frequencyAmountController.text);
    }));
  }

  @override
  void dispose() {
    _frequencyAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Chore"),
      ),
      body: Builder(builder: _getBody),
    );
  }

  Future<void> _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context, 
        initialDate: _startDate, 
        firstDate: _startDate.subtract(Duration(days: 365)), 
        lastDate: _startDate.add(Duration(days: 365)),
    );

    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _saveChore() async {
    await widget._api.createChore(
        _choreName,
        _choreDetails,
        _frequencyAmount,
        _frequencyType,
        _startDate,
    );
    Navigator.of(context).pop();
  }

  List<Widget> _getFormWidgets(BuildContext context) {
    var widgets = [

      Container(height: 20),
      TextField(
        autofocus: true,
        onChanged: (value) => setState(() { _choreName = value; }),
        decoration: InputDecoration(
          hintText: "Name",
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
        ),
      ),
      Container(height: 20),
      TextField(
        autofocus: true,
        maxLines: 5,
        onChanged: (value) => setState(() { _choreDetails = value; }),
        decoration: InputDecoration(
          hintText: "Details",
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
        ),
      ),
      Container(height: 20),
      DropdownButton<String>(
        isExpanded: true,
        hint: Text("Frequency"),
        value: _frequencyValue,
        items: [
          DropdownMenuItem<String>(value: "Daily", child: Text("Daily")),
          DropdownMenuItem<String>(value: "Weekly", child: Text("Weekly")),
          DropdownMenuItem<String>(value: "Monthly", child: Text("Monthly")),
          DropdownMenuItem<String>(value: "Yearly", child: Text("Yearly")),
          DropdownMenuItem<String>(value: "Custom", child: Text("Custom")),
        ],
        onChanged: (value) {
          setState(() {
            _frequencyValue = value;
            switch (_frequencyValue) {
              case "Daily":
                _frequencyAmount = 1;
                _frequencyType = "days";
                break;
              case "Weekly":
                _frequencyAmount = 1;
                _frequencyType = "weeks";
                break;
              case "Monthly":
                _frequencyAmount = 1;
                _frequencyType = "months";
                break;
              case "Yearly":
                _frequencyAmount = 1;
                _frequencyType = "years";
                break;
              case "Custom":
                _frequencyAmount = 3;
                _frequencyType = "days";
                break;
              default:
                break;
            }
          });
        },
      ),
    ];
    if (_frequencyValue == "Custom") {
      _frequencyAmountController.text = _frequencyAmount.toString();
      widgets.addAll([
        Container(height: 20),
        DropdownButton<String>(
          isExpanded: true,
          hint: Text("Frequency Type"),
          value: _frequencyType,
          onChanged: (value) => setState(() {
            _frequencyType = value;
          }),
          items: [
            DropdownMenuItem<String>(value: "days", child: Text("Days")),
            DropdownMenuItem<String>(value: "weeks", child: Text("Weeks")),
            DropdownMenuItem<String>(value: "months", child: Text("Months")),
            DropdownMenuItem<String>(value: "years", child: Text("Years")),
          ],
        ),
        Container(height: 20),
        TextField(
          keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
          decoration: InputDecoration(labelText: "Frequency"),
          controller: _frequencyAmountController,
        ),
      ]);
    }
    widgets.addAll([
      Container(height: 20),
      RaisedButton(child: Text("Start Date ${_format.format(_startDate)}"), onPressed: _selectDate),
      Container(height: 40),
      RaisedButton(child: Text("Save"), onPressed: _saveChore),
    ]);
    return widgets;
  }

  Widget _getBody(BuildContext context) => Center(
    child: Container(
      padding: EdgeInsets.only(left: 30, right: 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getFormWidgets(context),
        ),
      ),
    ),
  );
}
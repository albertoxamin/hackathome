import 'package:anylivery/models/company.dart';
import 'package:anylivery/models/good.dart';
import 'package:flutter/material.dart';
import 'package:anylivery/services/api.dart';
import 'package:location/location.dart';

// Create a Form widget.
class NewGoodForm extends StatefulWidget {
  final Company company;
  NewGoodForm({Key key, @required this.company}) : super(key: key);
  @override
  NewGoodFormState createState() {
    return NewGoodFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class NewGoodFormState extends State<NewGoodForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<NewGoodFormState>.
  final _formKey = GlobalKey<FormState>();

  String name, description, picture = 'https://picsum.photos/200';
  Volume volume = Volume(10, 10, 10);

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Text('Aggiungi merce'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              Center(
                child: Container(
                  child: CircleAvatar(
                    backgroundImage: NetworkImage("https://picsum.photos/200"),
                  ),
                  width: 150,
                  height: 150,
                ),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Nome prodotto'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Il nome non può essere vuoto';
                  }
                  return null;
                },
                onSaved: (String value) {
                  name = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Descrizione Prodotto'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'La descrizione non può essere vuota';
                  }
                  return null;
                },
                onSaved: (String value) {
                  description = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () async {
                    if (this._formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      await API.createGood(widget.company.id, name, description,
                          picture, volume);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Aggiungi prodotto'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

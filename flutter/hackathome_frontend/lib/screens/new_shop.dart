import 'package:flutter/material.dart';
import 'package:anylivery/services/api.dart';
import 'package:location/location.dart';

// Create a Form widget.
class NewShopForm extends StatefulWidget {
  @override
  NewShopFormState createState() {
    return NewShopFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class NewShopFormState extends State<NewShopForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<NewShopFormState>.
  final _formKey = GlobalKey<FormState>();

  String name, description, logo = 'https://picsum.photos/200';

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return MaterialApp(
      title: 'Nuovo negozio',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Nuovo negozio'),
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
                      backgroundImage:
                          NetworkImage("https://picsum.photos/200"),
                    ),
                    width: 150,
                    height: 150,
                  ),
                ),
                TextFormField(
                  key: Key('name'),
                  decoration: InputDecoration(labelText: 'Nome negozio'),
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
                  key: Key('description'),
                  decoration: InputDecoration(labelText: 'Descrizione'),
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
                        // Validate returns true if the form is valid, or false
                        // otherwise.
                        Location location = new Location();

                        bool _serviceEnabled;
                        PermissionStatus _permissionGranted;
                        LocationData _locationData;

                        _serviceEnabled = await location.serviceEnabled();
                        if (!_serviceEnabled) {
                          _serviceEnabled = await location.requestService();
                          if (!_serviceEnabled) {
                            return;
                          }
                        }

                        _permissionGranted = await location.hasPermission();
                        if (_permissionGranted == PermissionStatus.denied) {
                          _permissionGranted =
                              await location.requestPermission();
                          if (_permissionGranted != PermissionStatus.granted) {
                            return;
                          }
                        }

                        _locationData = await location.getLocation();
                        await API.createCompany(name, description, logo,
                            _locationData.latitude, _locationData.longitude);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Crea Negozio'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:anylivery/models/user.dart';
import 'package:anylivery/values/values.dart';
import 'package:flutter/material.dart';
import 'package:anylivery/services/api.dart';
import 'package:location/location.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var user;
  void logout() {
    API.logout();
    Navigator.of(context).popAndPushNamed('/');
  }

  @override
  void initState() {
    _getProfile();
    super.initState();
  }

  void _getProfile() async {
    var usr = await API.getMe();
    setState(() {
      user = User.fromJson(usr);
    });
  }

  void getLocation() async {
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
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    var usr =
        await API.setHome(_locationData.latitude, _locationData.longitude);
    print(usr);
    setState(() {
      user = usr;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 99,
                height: 99,
                margin: EdgeInsets.only(top: 41, right: 138),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        (user != null) ? user.picture : "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fthumbs.dreamstime.com%2Ft%2Fdefault-avatar-profile-icon-default-avatar-profile-icon-grey-photo-placeholder-illustrations-vectors-105356015.jpg&f=1&nofb=1",
                      ),
                      radius: 75,
                    ),
                    Positioned(
                      top: 61,
                      right: 0,
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(128, 0, 0, 0),
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          "assets/images/group.png",
                          fit: BoxFit.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 27),
              child: Text(
                (user != null) ? "${user.name} ${user.surname}" : "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontFamily: "Helvetica Neue",
                  fontWeight: FontWeight.w400,
                  fontSize: 28,
                  letterSpacing: -0.168,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 43),
              child: Text(
                (user != null) ? "${user.homeLocation.lat} ${user.homeLocation.lon}" : "",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: AppColors.primaryText,
                  fontFamily: "Helvetica Neue",
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  letterSpacing: -0.096,
                ),
              ),
            ),
            RaisedButton.icon(
                onPressed: getLocation,
                icon: Icon(Icons.home),
                label: Text("Cambia Posizione")),
            RaisedButton.icon(
                onPressed: () => {print('new store')},
                icon: Icon(Icons.store),
                label: Text("Apri un negozio")),
            RaisedButton(
              onPressed: logout,
              child: Text("Esci"),
            )
          ],
        ),
      ),
    );
  }
}

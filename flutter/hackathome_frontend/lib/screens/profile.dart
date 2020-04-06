import 'package:anylivery/values/values.dart';
import 'package:flutter/material.dart';
import 'package:anylivery/services/api.dart';

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
    print(usr);
    print(usr['name']);
    print(usr['surname']);
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
                            (user != null)?user['picture']:"",
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
                (user != null) ? "${user['name']} ${user['surname']}" : "",
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
                "Posizione consegna non impostata",
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
                onPressed: () => {print("chenge loc")},
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

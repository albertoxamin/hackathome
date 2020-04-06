import 'package:anylivery/values/values.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:anylivery/services/api.dart';
import 'package:anylivery/services/api.dart';
import 'dart:convert' show jsonDecode;

import '../services/api.dart';

class LoginWidget extends StatefulWidget {
  @override
  LoginState createState() => new LoginState();
}

class LoginState extends State<LoginWidget> {
  doLogin() async {
    // Present the dialog to the user
    final result = await FlutterWebAuth.authenticate(
        url: API.getAuthUrl(), callbackUrlScheme: "foobar");
    final token = Uri.parse(result).queryParameters['code'];
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('token', json.encode(token));
    Navigator.of(context).popAndPushNamed('/home');
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 126,
              margin: EdgeInsets.only(top: 94),
              child: Image.asset(
                "assets/images/artboard-1.png",
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: FlatButton(
                padding: EdgeInsets.all(0),
                onPressed: () => doLogin(),
                child: Container(
                  width: 193,
                  height: 48,
                  margin: EdgeInsets.only(top: 146),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Positioned(
                        left: 4,
                        right: 4,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.secondaryElement,
                            boxShadow: [
                              Shadows.secondaryShadow,
                            ],
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                          child: Container(),
                        ),
                      ),
                      Positioned(
                        left: 5,
                        right: 13,
                        child: Row(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: AppColors.primaryElement,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(1)),
                              ),
                              child: Container(),
                            ),
                            Spacer(),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Sign in with Google",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: AppColors.secondaryText,
                                  fontFamily: "Roboto",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: 0.21875,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 15,
                        child: Image.asset(
                          "assets/images/logo-googleg-48dp.png",
                          fit: BoxFit.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Spacer(),
            Container(
              height: 15,
              margin: EdgeInsets.only(left: 54, right: 46, bottom: 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Privacy Policy",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontFamily: "Helvetica Neue",
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        letterSpacing: -0.072,
                      ),
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "Terms of Service",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontFamily: "Helvetica Neue",
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        letterSpacing: -0.072,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

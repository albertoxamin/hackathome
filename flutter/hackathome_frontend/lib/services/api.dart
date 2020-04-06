import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class API {
  static final String _url = 'https://hackathome.xamin.it';
  static getAuthUrl() {
    return _url + '/auth/google';
  }

  static var token;

  static isLoggedIn() async {
    await _getToken();
    print(token);
    return (token != null);
  }

  static logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.clear();
  }

  static getMe() async {
    var response = await getData('/user/me');
    return jsonDecode(response.body);
  }

  static _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString('token').replaceAll('"', '');
  }

  static authData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(fullUrl,
        body: jsonEncode(data), headers: _setHeaders());
  }

  static getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http.get(fullUrl, headers: _setHeaders());
  }

  static _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      };
}

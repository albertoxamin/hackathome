import 'dart:convert';
import 'package:anylivery/models/good.dart';
import 'package:anylivery/models/order.dart';
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

  static getMyStores() async {
    var response = await getData('/company/my');
    List<dynamic> list = jsonDecode(response.body);
    return list;
  }
  static getStores() async {
    var response = await getData('/company');
    List<dynamic> list = jsonDecode(response.body);
    return list;
  }

  static getCompanyGoods(id) async {
    var response = await getData('/company/$id/good');
    List<dynamic> list = jsonDecode(response.body);
    return list;
  }

  static getCompanyOrders(id) async {
    var response = await getData('/company/$id/order');
    List<dynamic> list = jsonDecode(response.body);
    return list;
  }

  static getMe() async {
    var response = await getData('/user/me');
    return jsonDecode(response.body);
  }

  static planDelivery(
      String companyId, DateTime date, List<String> orders) async {
    var response = await postData(
        {'date': date.toIso8601String(), 'orders': orders},
        '/company/$companyId/delivery');
    dynamic obj = jsonDecode(response.body);
    return obj['orders'];
  }

  static createCompany(
      String name, String description, String logo, num lat, num lon) async {
    var response = await postData(
        {
          'name':name,
          'description':description,
          'logo':logo,
          'location':{
            'lat':lat,
            'lon':lon
          }
        },
        '/company/my');
    return jsonDecode(response.body);
  }
  static createGood(String compId,
      String name, String description, String picture, Volume vol) async {
    var response = await postData(
        {
          'name':name,
          'description':description,
          'picture':picture,
          'volume':vol.toJson()
        },
        '/company/$compId/good');
    return jsonDecode(response.body);
  }

  static sendOrder(
      String companyId, List<dynamic> goods) async {
    print("qua arriva");
    var response = await postData(
        {'companyId': companyId, 'goods': goods},
        '/order');
    dynamic obj = jsonDecode(response.body);
    return obj['orders'];
  }

  static setHome(var lat, var lon) async {
    var response = await postData({
      'homeLocation': {'lat': lat, 'lon': lon}
    }, '/user/me');
    return jsonDecode(response.body);
  }

  static _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (localStorage.containsKey('token'))
      token = localStorage.getString('token').replaceAll('"', '');
  }

  static postData(data, apiUrl) async {
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

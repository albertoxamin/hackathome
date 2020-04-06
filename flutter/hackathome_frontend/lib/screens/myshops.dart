import 'package:anylivery/models/company.dart';
import 'package:anylivery/screens/shop_detail.dart';
import 'package:flutter/material.dart';
import 'package:anylivery/services/api.dart';

class MyShops extends StatefulWidget {
  MyShops({Key key}) : super(key: key);

  @override
  _MyShopsState createState() => _MyShopsState();
}

class _MyShopsState extends State<MyShops> {
  List<Company> shops = [];
  @override
  void initState() {
    super.initState();
    fetchBackend();
  }

  void fetchBackend() async {
    List<dynamic> list = await API.getMyStores();
    List<Company> s = [];
    for (var c in list) {
      s.add(Company.fromJson(c));
    }
    setState(() {
      shops = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: shops.length,
      itemBuilder: (BuildContext context, int position) {
        return getRow(position);
      },
    );
  }

  Widget getRow(int i) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Hero(tag: shops[i].logo, child: CircleAvatar(
              backgroundImage: NetworkImage(shops[i].logo),
            ),),
            SizedBox(width: 20,),
            Text(shops[i].name),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShopDetailScreen(company: shops[i], isOwner: true,),
          ),
        );
      },
    );
  }
}

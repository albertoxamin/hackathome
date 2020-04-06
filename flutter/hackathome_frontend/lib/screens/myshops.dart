import 'package:anylivery/models/company.dart';
import 'package:anylivery/screens/shop_detail.dart';
import 'package:flutter/material.dart';
import 'package:anylivery/services/api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MyShops extends StatefulWidget {
  MyShops({Key key}) : super(key: key);

  _MyShopsState state = new _MyShopsState();

  @override
  _MyShopsState createState() => state;
}

class _MyShopsState extends State<MyShops> {
  List<Company> MyShops = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    MyShops = [];
    fetchBackend();
  }

  void fetchBackend() async {
    List<dynamic> list =
        (true ? await API.getMyStores() : await API.getStores());
    List<Company> s = [];
    for (var c in list) {
      s.add(Company.fromJson(c));
    }
    setState(() {
      MyShops = s;
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
      appBar: AppBar(
        title: (true)
            ? Text("Miei Negozi")
            : Text("Negozi nelle vicinanze"),
      ),
      body: (loaded)
          ? ListView.builder(
              itemCount: MyShops.length,
              itemBuilder: (BuildContext context, int position) {
                return getRow(position);
              },
            )
          : SpinKitRing(
              color: Colors.blueAccent,
              size: 50.0,
            ),
    ));
  }

  Widget getRow(int i) {
    return GestureDetector(
      child: ListTile(
        leading: Hero(
          tag: MyShops[i].id,
          child: CircleAvatar(
            backgroundImage: NetworkImage(MyShops[i].logo),
          ),
        ),
        title: Text(MyShops[i].name),
        subtitle: Text(MyShops[i].description),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShopDetailScreen(
              company: MyShops[i],
              isOwner: true,
            ),
          ),
        );
      },
    );
  }
}

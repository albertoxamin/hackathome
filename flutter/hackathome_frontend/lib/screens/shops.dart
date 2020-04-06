import 'package:anylivery/models/company.dart';
import 'package:anylivery/screens/shop_detail.dart';
import 'package:flutter/material.dart';
import 'package:anylivery/services/api.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Shops extends StatefulWidget {
  Shops({Key key}) : super(key: key);

  _ShopsState state = new _ShopsState();

  @override
  _ShopsState createState() => state;
}

class _ShopsState extends State<Shops> {
  List<Company> Shops = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    Shops = [];
    fetchBackend();
  }

  void fetchBackend() async {
    List<dynamic> list =
        (false ? await API.getMyStores() : await API.getStores());
    List<Company> s = [];
    for (var c in list) {
      s.add(Company.fromJson(c));
    }
    setState(() {
      Shops = s;
      loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
      appBar: AppBar(
        title: (false)
            ? Text("Miei Negozi")
            : Text("Negozi nelle vicinanze"),
      ),
      body: (loaded)
          ? ListView.builder(
              itemCount: Shops.length,
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
          tag: Shops[i].logo,
          child: CircleAvatar(
            backgroundImage: NetworkImage(Shops[i].logo),
          ),
        ),
        title: Text(Shops[i].name),
        subtitle: Text(Shops[i].description),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShopDetailScreen(
              company: Shops[i],
              isOwner: false,
            ),
          ),
        );
      },
    );
  }
}

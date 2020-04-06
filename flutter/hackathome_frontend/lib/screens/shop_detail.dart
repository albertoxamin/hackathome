import 'package:anylivery/models/good.dart';
import 'package:anylivery/screens/company_orders_screen.dart';
import 'package:anylivery/services/api.dart';
import 'package:flutter/material.dart';
import 'package:anylivery/models/company.dart';

class ShopDetailScreen extends StatefulWidget {
  // Declare a field that holds the Todo.
  final Company company;
  final bool isOwner;

  // In the constructor, require a Todo.
  ShopDetailScreen({Key key, @required this.company, @required this.isOwner})
      : super(key: key);
  @override
  _ShopDetailState createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetailScreen> {
  List<Good> goods = [];

  @override
  void initState() {
    super.initState();
    fetchBackend();
  }

  void fetchBackend() async {
    List<dynamic> list = await API.getCompanyGoods(widget.company.id);
    List<Good> s = [];
    for (var c in list) {
      s.add(Good.fromJson(c));
    }
    setState(() {
      goods = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Hero(
              tag: widget.company.logo,
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.company.logo),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Text(widget.company.name),
          ],
        ),
        actions: <Widget>[
          widget.isOwner ? IconButton(icon: Icon(Icons.shopping_basket), onPressed: (){
            Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompanyOrdersScreen(company: widget.company, isOwner: true,),
          ),
        );
          }) : Container(width: 0, height: 0,)
        ],
      ),
      floatingActionButton: (widget.isOwner)
          ? FloatingActionButton.extended(onPressed: () => {}, label: Text("Aggiungi merce"))
          : Container(width: 0, height: 0,),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: goods.length + 1,
            itemBuilder: (BuildContext context, int position) {
              return getRow(position);
            },
          )),
    );
  }

  Widget getRow(int i) {
    if (i == 0) {
      return Column(
        children: <Widget>[
          Image.network("https://image.maps.ls.hereapi.com/mia/1.6/mapview?apiKey=7K7d_HphcjV8P69RwYuJ2zOUpeYB95ESYfjkkS24Us4&c=${widget.company.location}&z=13"),
          Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                widget.company.description,
                textAlign: TextAlign.center,
              )),
        ],
      );
    }
    i = i - 1;
    return GestureDetector(
      child: ListTile(title: Text(goods[i].name), subtitle: Text(goods[i].description), trailing: Text(goods[i].price.toString())),
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ShopDetailScreen(company: goods[i]),
        //   ),
        // );
      },
    );
  }
}

import 'package:anylivery/models/good.dart';
import 'package:anylivery/models/order.dart';
import 'package:anylivery/services/api.dart';
import 'package:flutter/material.dart';
import 'package:anylivery/models/company.dart';

class CompanyOrdersScreen extends StatefulWidget {
  // Declare a field that holds the Todo.
  final Company company;
  final bool isOwner;

  // In the constructor, require a Todo.
  CompanyOrdersScreen({Key key, @required this.company, @required this.isOwner})
      : super(key: key);
  @override
  _CompanyOrdersState createState() => _CompanyOrdersState();
}

class _CompanyOrdersState extends State<CompanyOrdersScreen> {
  List<Order> goods = [];

  @override
  void initState() {
    super.initState();
    fetchBackend();
  }

  void fetchBackend() async {
    List<dynamic> list = await API.getCompanyOrders(widget.company.id);
    List<Order> s = [];
    for (var c in list) {
      s.add(Order.fromJson(c));
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
            Text("Ordini"),
          ],
        ),
        // actions: <Widget>[
        //   widget.isOwner ? IconButton(icon: Icon(Icons.shopping_basket), onPressed: (){}) : Container(width: 0, height: 0,)
        // ],
      ),
      // floatingActionButton: (widget.isOwner)
      //     ? FloatingActionButton.extended(onPressed: () => {}, label: Text("Aggiungi merce"))
      //     : Container(width: 0, height: 0,),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: goods.length,
            itemBuilder: (BuildContext context, int position) {
              return getRow(position);
            },
          )),
    );
  }

  Widget getRow(int i) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(goods[i].customer.picture),)
            Text("Cliente: ${goods[i].customer.name}"),
            Text("${goods[i].goods.length} Pezzi"),
          ],
        ),
      ),
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => CompanyOrdersScreen(company: goods[i]),
        //   ),
        // );
      },
    );
  }
}

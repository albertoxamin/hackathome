import 'package:anylivery/models/good.dart';
import 'package:anylivery/models/order.dart';
import 'package:anylivery/screens/company_orders_screen.dart';
import 'package:anylivery/services/api.dart';
import 'package:flutter/material.dart';
import 'package:anylivery/models/company.dart';
import 'package:date_format/date_format.dart';

class ShippingScreen extends StatefulWidget {
  // Declare a field that holds the Todo.
  final List<Order> orders;
  final DateTime shippingDate;
  final Company company;

  // In the constructor, require a Todo.
  ShippingScreen(
      {Key key,
      @required this.orders,
      @required this.shippingDate,
      @required this.company})
      : super(key: key);
  @override
  _ShippingState createState() => _ShippingState();
}

class _ShippingState extends State<ShippingScreen> {
  List<Order> shipped = [];

  @override
  void initState() {
    print("init");
    fetchBackend();
    super.initState();
  }

  void fetchBackend() async {
    var ord = widget.orders.map((x) => x.id).toList();
    print(await API.getMe());
    List<dynamic> res =
        await API.planDelivery(widget.company.id, widget.shippingDate, ord);
    List<Order> s = [];
    for (var c in res) {
      s.add(Order.fromJson(c));
    }
    print(s.length);
    setState(() {
      shipped = s;
    });
  }

  mapUrl() {
    String url =
        "https://image.maps.ls.hereapi.com/mia/1.6/routing?apiKey=7K7d_HphcjV8P69RwYuJ2zOUpeYB95ESYfjkkS24Us4";

    url += "&waypoint0=" + widget.company.location.toString();
    for (var i = 0; i < widget.orders.length; i++) {
      url += "&waypoint${i + 1}=" +
          widget.orders[i].customer.homeLocation.toString();
      url += "&poix${i}=" + widget.orders[i].customer.homeLocation.toString();
    }
    return url;
  }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Text("Spedizione"),
            ],
          ),
          actions: <Widget>[
            // widget.isOwner ? IconButton(icon: Icon(Icons.shopping_basket), onPressed: (){
            //   Navigator.push(
            // context,
            // MaterialPageRoute(
            //   builder: (context) => CompanyOrdersScreen(company: widget.company, isOwner: true,),
            // ),
            //  );
            // }) : Container(width: 0, height: 0,)
          ],
        ),
        // floatingActionButton: (widget.isOwner)
        //     ? FloatingActionButton.extended(onPressed: () => {}, label: Text("Aggiungi merce"))
        //     : Container(width: 0, height: 0,),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: 2 + shipped.length,
            itemBuilder: (BuildContext context, int position) {
              return getRow(position);
            },
          ),
        ));
  }

  getRow(i) {
    if (i == 0) return Image.network(mapUrl());
    if (i == 1)
      return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.company.logo),
        ),
        title: Text(widget.company.name),
        subtitle: Text(widget.company.location.toString()),
        trailing: Text(widget.shippingDate.toString()),
      );
    i -= 2;
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(shipped[i].customer.picture),
      ),
      title: Text("#" + shipped[i].id),
      subtitle: Text(shipped[i].customer.homeLocation.toString()),
      trailing:
          Text(formatDate(shipped[i].executionDate, [HH, ':', nn, ':', ss])),
    );
  }
}

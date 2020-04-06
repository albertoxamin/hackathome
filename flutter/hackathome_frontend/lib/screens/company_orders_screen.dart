import 'package:anylivery/components/order_tile.dart';
import 'package:anylivery/models/good.dart';
import 'package:anylivery/models/order.dart';
import 'package:anylivery/screens/shipping.dart';
import 'package:anylivery/services/api.dart';
import 'package:flutter/material.dart';
import 'package:anylivery/models/company.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

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
  List<Order> orders = [];
  List<Order> ordersToShip = [];

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
      orders = s;
    });
  }

  void addOrder(order) {
    if (!ordersToShip.contains(order))
      ordersToShip.add(order);
    else
      ordersToShip.remove(order);
    setState(() {});
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
      floatingActionButton: (ordersToShip.length > 0)
          ? FloatingActionButton.extended(
              onPressed: () => {
                DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: DateTime.now(), onConfirm: (date) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShippingScreen(
                        orders: ordersToShip,
                        shippingDate: date,
                        company: widget.company,
                      ),
                    ),
                  );
                }, currentTime: DateTime.now(), locale: LocaleType.it)
              },
              label: Text("Pianifica Spedizione"),
              icon: Column(
                children: [
                  Text(
                    "${ordersToShip.length}",
                    textAlign: TextAlign.center,
                  ),
                  Icon(Icons.local_shipping),
                ],
                crossAxisAlignment: CrossAxisAlignment.center,
              ),
            )
          : Container(
              width: 0,
              height: 0,
            ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (BuildContext context, int position) {
              return getRow(position);
            },
          )),
    );
  }

  Widget getRow(int i) {
    return OrderTile(
      order: orders[i],
      selected: ordersToShip.contains(orders[i]),
      deliveryCb: () => addOrder(orders[i]),
    );
  }
}

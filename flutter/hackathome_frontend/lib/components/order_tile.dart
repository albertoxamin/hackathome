import 'package:flutter/material.dart';
import 'package:anylivery/models/order.dart';

class OrderTile extends StatefulWidget {
  final Order order;
  final Function deliveryCb;
  final bool selected;

  // In the constructor, require a Todo.
  OrderTile({Key key, @required this.order, @required this.deliveryCb, @required this.selected})
      : super(key: key);

  @override
  _OrderTileState createState() => new _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  getItems(Order order) {
    List<Widget> res = [];
    for (var orderqt in order.goods) {
      res.add(Text("${orderqt.item.name} x${orderqt.quantity}"));
    }
    if (!widget.selected)
      res.add(RaisedButton.icon(
          onPressed: widget.deliveryCb,
          icon: Icon(Icons.local_shipping),
          label: Text("Aggiungi a spedizione")));
    else 
      res.add(RaisedButton.icon(
            color: Colors.redAccent,
            textColor: Colors.white,
            onPressed: widget.deliveryCb,
            icon: Icon(Icons.delete),
            label: Text("Rimuovi da spedizione")));
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ExpansionTile(
          // selected: _selected,
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.order.customer.picture),
          ),
          title: Text("Cliente: ${widget.order.customer.name}"),
          subtitle: Text(
              "Ordine #${widget.order.id}\nRichiesto il ${widget.order.date.toString()}\nDa consegnare presso ${widget.order.customer.homeLocation}"),
          children: getItems(widget.order),
          // onLongPress: select // what should I put here,
        )
      ]),
    );
  }
}

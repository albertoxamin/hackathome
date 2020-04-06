import 'package:flutter/material.dart';
import 'package:anylivery/models/good.dart';

class GoodTile extends StatefulWidget {
  final Good good;
  final Function addCb;
  final Function removeCb;
  final bool isOnCart;

  // In the constructor, require a Todo.
  GoodTile(
      {Key key,
      @required this.good,
      @required this.addCb,
      @required this.removeCb,
      @required this.isOnCart})
      : super(key: key);

  @override
  _GoodTileState createState() => new _GoodTileState();
}

class _GoodTileState extends State<GoodTile> {
  getItems(Good good) {
    List<Widget> res = [];
    if (good.stockQty != null)
      res.add(Text("Disponibili: ${good.stockQty}"));
    if (good.volume != null)
      res.add(Text("Dimensioni: ${good.volume}"));
    if (!widget.isOnCart)
      res.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton.icon(
              onPressed: widget.addCb,
              icon: Icon(Icons.add_shopping_cart),
              label: Text("+1"))
          ],
        ),
      ));
    else
      res.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton.icon(
              onPressed: widget.addCb,
              icon: Icon(Icons.add_shopping_cart),
              label: Text("+1")),
            SizedBox(width: 20,),
            RaisedButton.icon(
                color: Colors.redAccent,
                textColor: Colors.white,
                onPressed: widget.removeCb,
                icon: Icon(Icons.remove_shopping_cart),
                label: Text("-1")),
          ],
        ),
      ));
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ExpansionTile(
          // isOnCart: _selected,
          leading: (widget.good.picture != null)? CircleAvatar(
            backgroundImage: NetworkImage(widget.good.picture),
          ):null,
          title: Text(widget.good.name),
          subtitle: Text(widget.good.description),
          trailing: (widget.good.price != null) ? Text(widget.good.price.toString() + " €") : Container(width: 0,),
          children: getItems(widget.good),
          // onLongPress: select // what should I put here,
        )
      ]),
    );
  }
}

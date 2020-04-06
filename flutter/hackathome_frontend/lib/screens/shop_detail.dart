import 'package:anylivery/components/good_tile.dart';
import 'package:anylivery/models/good.dart';
import 'package:anylivery/models/order.dart';
import 'package:anylivery/screens/company_orders_screen.dart';
import 'package:anylivery/screens/new_good.dart';
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
  List<OrderQty> cart = [];

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

  void addToCart(Good good) {
    var i = cart.indexWhere((x) => x.item == good);
    if (i != -1)
      cart[i].quantity++;
    else
      cart.add(new OrderQty(good, 1));
    setState(() {});
  }

  void removeFromCart(Good good) {
    var i = cart.indexWhere((x) => x.item == good);
    if (i != -1) {
      cart[i].quantity--;
      if (cart[i].quantity <= 0) cart.removeAt(i);
    }
    setState(() {});
  }

  bool isInCart(Good good) {
    return (cart.indexWhere((x) => x.item == good) != -1);
  }

  int getTotal() {
    int tot = 0;
    for (var item in cart) {
      tot += item.quantity;
    }
    return tot;
  }

  void placeOrder() async {
    var res = await API.sendOrder(
        widget.company.id,
        cart
            .map((oq) => {'quantity': oq.quantity, 'item': oq.item.id})
            .toList());
    Navigator.of(context).pop();
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
          widget.isOwner
              ? IconButton(
                  icon: Icon(Icons.shopping_basket),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CompanyOrdersScreen(
                          company: widget.company,
                          isOwner: true,
                        ),
                      ),
                    );
                  })
              : Container(
                  width: 0,
                  height: 0,
                )
        ],
      ),
      floatingActionButton: (widget.isOwner)
          ? FloatingActionButton.extended(
              onPressed: () => {
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewGoodForm(company: widget.company,)
                      ),
                    )
              }, label: Text("Aggiungi merce"))
          : (cart.length > 0)
              ? FloatingActionButton.extended(
                  onPressed: placeOrder,
                  label: Text("Ordina"),
                  icon: Column(
                    children: [
                      Text(
                        "${getTotal()}",
                        textAlign: TextAlign.center,
                      ),
                      Icon(Icons.shopping_cart),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                )
              : Container(
                  width: 0,
                  height: 0,
                ),
      body: Padding(
          padding: EdgeInsets.only(right: 16.0, left: 16.0),
          child: ListView.builder(
            itemCount: goods.length + 2,
            itemBuilder: (BuildContext context, int position) {
              return getRow(position);
            },
          )),
    );
  }

  Widget getRow(int i) {
    if (i == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Image.network(
            "https://image.maps.ls.hereapi.com/mia/1.6/mapview?apiKey=7K7d_HphcjV8P69RwYuJ2zOUpeYB95ESYfjkkS24Us4&c=${widget.company.location}&z=13",
            fit: BoxFit.cover,
          ),
          Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(
                widget.company.description,
                textAlign: TextAlign.center,
              )),
        ],
      );
    }
    i = i - 1;
    if (i < goods.length)
      return GoodTile(
        good: goods[i],
        isOnCart: isInCart(goods[i]),
        addCb: () => addToCart(goods[i]),
        removeCb: () => removeFromCart(goods[i]),
        ownerView: widget.isOwner,
      );
    else
      return SizedBox(
        height: 100,
      );
  }
}

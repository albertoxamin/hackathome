import 'package:anylivery/models/good.dart';
import 'package:anylivery/models/user.dart';

class OrderQty {
  int quantity;
  Good item;

  OrderQty.fromJson(Map<String, dynamic> json)
      : quantity = json['quantity'],
        item = Good.fromJson(json['item']);

  Map<String, dynamic> toJson() =>
      {"quantity": quantity, "item": item.toJson()};
}

class Order {
  User customer;
  List<dynamic> goods;

  static goodsList(json) {
    List<dynamic> list = json;
    List<OrderQty> s = [];
    for (var c in list) {
      s.add(OrderQty.fromJson(c));
    }
    return s;
  }

  Order.fromJson(Map<String, dynamic> json)
      : goods = goodsList(json['goods']),
        customer = User.fromJson(json['customer']);

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "name": name,
  //       "description": description,
  //       "logo": logo,
  //       "location": goods.toJson()
  //     };
}

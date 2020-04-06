import 'package:anylivery/models/good.dart';
import 'package:anylivery/models/user.dart';

class OrderQty {
  int quantity;
  Good item;

  OrderQty.fromJson(Map<String, dynamic> json)
      : quantity = json['quantity'],
        item = (json['item'].runtimeType != String) ? Good.fromJson(json['item']): null;

  Map<String, dynamic> toJson() =>
      {"quantity": quantity, "item": item.toJson()};
}

class Order {
  User customer;
  List<dynamic> goods;
  DateTime date;
  DateTime executionDate;
  String id;

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
        customer = User.fromJson(json['customer']),
        id = json['id'] ?? json['_id'],
        date = DateTime.parse(json['date']),
        executionDate = json['executionDate']!= null? DateTime.parse(json['executionDate']): DateTime(0);

  // Map<String, dynamic> toJson() => {
  //       "id": id,
  //       "name": name,
  //       "description": description,
  //       "logo": logo,
  //       "location": goods.toJson()
  //     };
}

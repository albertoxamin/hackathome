class Volume {
  num width;
  num depth;
  num height;

  Volume.fromJson(Map<String, dynamic> json)
      : width = json['width'],
        depth = json['depth'],
        height = json['height'];

  Map<String, dynamic> toJson() => {
        "width": width,
        "depth": depth,
        "height": height
      };

  @override
  String toString() {
    return "$width x $depth x $height";
  }
}

class Good {
  String name;
  int stockQty;
  num price;
  String picture;
  String description;
  String id;
  Volume volume;

  Good.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? json['_id'],
        description = json['description'],
        picture = json['picture'],
        stockQty = json['stockQty'],
        price = json['price'],
        volume = Volume.fromJson(json['volume']),
        name = json['name'];

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "picture": picture,
        "price": price,
        "stockQty": stockQty,
        "volume": volume.toJson()
      };
}

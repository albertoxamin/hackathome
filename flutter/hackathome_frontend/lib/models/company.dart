import 'loc.dart';

class Company {
  String name;
  Loc location;
  String logo;
  String description;
  String id;

  Company.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        description = json['description'],
        logo = json['logo'],
        location = Loc.fromJson(json['location']),
        name = json['name'];

  Map<String, dynamic> toJson() => {
      "id":id,
      "name":name,
      "description":description,
      "logo":logo,
      "location":location.toJson()
  };
}

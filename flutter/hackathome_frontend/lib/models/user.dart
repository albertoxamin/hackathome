import 'loc.dart';

class User {
  String name;
  Loc homeLocation;
  String picture;
  String surname;
  String id;

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        surname = json['surname'],
        picture = json['picture'],
        homeLocation = Loc.fromJson(json['homeLocation']),
        name = json['name'];

  Map<String, dynamic> toJson() => {
      "id":id,
      "name":name,
      "surname":surname,
      "picture":picture,
      "homeLocation":homeLocation.toJson()
  };
}

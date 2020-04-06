class Loc {
  double lat;
  double lon;

  Loc.fromJson(Map<String, dynamic> json)
    : lat = json['lat'],
      lon = json['lon'];

    Map<String, dynamic> toJson() =>
    {
      'lat' : lat,
      'lon': lon,
    };
}

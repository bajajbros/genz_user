import 'dart:convert';

PrevSearches prevSearchesFromMap(String str) => PrevSearches.fromMap(json.decode(str));

String prevSearchesToMap(PrevSearches data) => json.encode(data.toMap());

class PrevSearches {
    PrevSearches({
        required this.previous,
    });

    List<Previous> previous;
factory PrevSearches.fromMap(Map<String, dynamic> json) => PrevSearches(
    previous: json["previous"] != null
        ? List<Previous>.from(json["previous"].map((x) => Previous.fromMap(x)))
        : [],
);

    Map<String, dynamic> toMap() => {
        "previous": List<dynamic>.from(previous.map((x) => x.toMap())),
    };
}

class Previous {
    Previous({
        required this.toLocation,
        required this.id,
    });

    ToLocation toLocation;
    String id;

    factory Previous.fromMap(Map<String, dynamic> json) => Previous(
        toLocation: ToLocation.fromMap(json["toLocation"]),
        id: json["_id"],
    );

    Map<String, dynamic> toMap() => {
        "toLocation": toLocation.toMap(),
        "_id": id,
    };
}

class ToLocation {
    ToLocation({
        required this.coordinates,
        required this.name,
    });

    List<double> coordinates;
    String name;

    factory ToLocation.fromMap(Map<String, dynamic> json) => ToLocation(
        coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
        "name": name,
    };
}
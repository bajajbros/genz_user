import 'dart:convert';

OfficeBanner officeBannerFromMap(String str) => OfficeBanner.fromMap(json.decode(str));

String officeBannerToMap(OfficeBanner data) => json.encode(data.toMap());

class OfficeBanner {
    OfficeBanner({
        required this.data,
    });

    Data data;

    factory OfficeBanner.fromMap(Map<String, dynamic> json) => OfficeBanner(
        data: Data.fromMap(json["data"]),
    );

    Map<String, dynamic> toMap() => {
        "data": data.toMap(),
    };
}

class Data {
    Data({
        required this.status,
        required this.id,
        required this.link,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    bool status;
    String id;
    String link;
    DateTime createdAt;
    DateTime updatedAt;
    int v;

    factory Data.fromMap(Map<String, dynamic> json) => Data(
        status: json["status"],
        id: json["_id"],
        link: json["link"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toMap() => {
        "status": status,
        "_id": id,
        "link": link,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}

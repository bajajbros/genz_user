import 'dart:convert';

Profile profileFromMap(String str) => Profile.fromMap(json.decode(str));

String profileToMap(Profile data) => json.encode(data.toMap());

class Profile {
  Profile({
    required this.profile,
  });

  ProfileClass profile;

  factory Profile.fromMap(Map<String, dynamic> json) => Profile(
        profile: ProfileClass.fromMap(json["profile"]),
      );

  Map<String, dynamic> toMap() => {
        "profile": profile.toMap(),
      };
}

class ProfileClass {
  ProfileClass({
    required this.name,
    required this.freeRides,
    required this.id,
    required this.email,
    required this.phone,
    required this.signinMethod,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });
  String name;
  FreeRides freeRides;
  String id;
  String email;
  String phone;
  String signinMethod;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  factory ProfileClass.fromMap(Map<String, dynamic> json) => ProfileClass(
        freeRides: FreeRides.fromMap(json["freeRides"]),
        id: json["_id"] ?? "",
        email: json["email"] ?? "",
        phone: json["phone"] ?? "",
        signinMethod: json["signinMethod"] ?? "",
        createdAt: DateTime.parse(json["createdAt"] ?? ""),
        updatedAt: DateTime.parse(json["updatedAt"] ?? ""),
        v: json["__v"], name: json["name"] ??"",
      );

  Map<String, dynamic> toMap() => {
        "freeRides": freeRides.toMap(),
        "_id": id,
        "email": email,
        "phone": phone,
        "signinMethod": signinMethod,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "name":name
      };
}

class FreeRides {
  FreeRides({
    required this.km,
    required this.rides,
    required this.expire,
  });

  int km;
  int rides;
  DateTime expire;

  factory FreeRides.fromMap(Map<String, dynamic> json) => FreeRides(
        km: json["km"],
        rides: json["rides"],
        expire: DateTime.parse(json["expire"]),
      );

  Map<String, dynamic> toMap() => {
        "km": km,
        "rides": rides,
        "expire": expire.toIso8601String(),
      };
}

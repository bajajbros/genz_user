// To parse this JSON data, do
//
//     final availableDriversModel = availableDriversModelFromMap(jsonString);
import 'dart:convert';

AvailableDriversModel availableDriversModelFromMap(String str) => AvailableDriversModel.fromMap(json.decode(str));

String availableDriversModelToMap(AvailableDriversModel data) => json.encode(data.toMap());

class AvailableDriversModel {
    AvailableDriversModel({
        required this.fromLocation,
        required this.toLocation,
        required this.id,
        required this.drivers,
        required this.user,
        required this.rideType,
        required this.otp,
        required this.distance,
        required this.fare,
        required this.discountPercentage,
        required this.discountKm,
        required this.discountAmount,
        required this.finalFare,
        required this.status,
        required this.paymentStatus,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    final Location fromLocation;
    final Location toLocation;
    final String id;
    final List<String> drivers;
    final User user;
    final String rideType;
    final String otp;
    final double distance;
    final double fare;
     var discountPercentage;
     var discountKm;
     var discountAmount;
     var finalFare;
     String status;
    final String paymentStatus;
    final DateTime createdAt;
    final DateTime updatedAt;
    final int v;

    factory AvailableDriversModel.fromMap(Map<String, dynamic> json) => AvailableDriversModel(
        fromLocation: Location.fromMap(json["fromLocation"]),
        toLocation: Location.fromMap(json["toLocation"]),
        id: json["_id"],
        drivers: List<String>.from(json["drivers"].map((x) => x)),
        user: User.fromMap(json["user"]),
        rideType: json["rideType"],
        otp: json["otp"],
        distance: json["distance"]?.toDouble(),
        fare: json["fare"]?.toDouble(),
        discountPercentage: json["discountPercentage"],
        discountKm: json["discountKM"],
        discountAmount: json["discountAmount"],
        finalFare: json["finalFare"]?.toDouble(),
        status: json["status"],
        paymentStatus: json["paymentStatus"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toMap() => {
        "fromLocation": fromLocation.toMap(),
        "toLocation": toLocation.toMap(),
        "_id": id,
        "drivers": List<dynamic>.from(drivers.map((x) => x)),
        "user": user.toMap(),
        "rideType": rideType,
        "otp": otp,
        "distance": distance,
        "fare": fare,
        "discountPercentage": discountPercentage,
        "discountKM": discountKm,
        "discountAmount": discountAmount,
        "finalFare": finalFare,
        "status": status,
        "paymentStatus": paymentStatus,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
    };
}

class Location {
    Location({
        required this.coordinates,
        required this.name,
    });

    final List<double> coordinates;
    final String name;

    factory Location.fromMap(Map<String, dynamic> json) => Location(
        coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
        name: json["name"],
    );

    Map<String, dynamic> toMap() => {
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
        "name": name,
    };
}

class User {
    User({
        required this.freeRides,
        required this.id,
        required this.email,
        required this.phone,
        required this.signinMethod,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
        required this.name,
    });

    final FreeRides freeRides;
    final String id;
    final String email;
    final String phone;
    final String signinMethod;
    final DateTime createdAt;
    final DateTime updatedAt;
    final int v;
    final String name;

    factory User.fromMap(Map<String, dynamic> json) => User(
        freeRides: FreeRides.fromMap(json["freeRides"]),
        id: json["_id"],
        email: json["email"],
        phone: json["phone"],
        signinMethod: json["signinMethod"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]??""),
        v: json["__v"],
        name: json["name"]??"",
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
        "name": name,
    };
}

class FreeRides {
    FreeRides({
        required this.km,
        required this.rides,
        required this.expire,
        required this.updated,
    });

    final int km;
    final int rides;
    final DateTime expire;
    final dynamic updated;

    factory FreeRides.fromMap(Map<String, dynamic> json) => FreeRides(
        km: json["km"],
        rides: json["rides"],
        expire: DateTime.parse(json["expire"]),
        updated:json["updated"]==null?"": DateTime.parse(json["updated"]),
    );

    Map<String, dynamic> toMap() => {
        "km": km,
        "rides": rides,
        "expire": expire.toIso8601String(),
        "updated": updated.toIso8601String(),
    };
}
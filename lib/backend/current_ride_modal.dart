// To parse this JSON data, do
//
//     final currentRide = currentRideFromMap(jsonString);

import 'dart:convert';

CurrentRide currentRideFromMap(String str) =>
    CurrentRide.fromMap(json.decode(str));

// String currentRideToMap(CurrentRide data) => json.encode(data.to());

class CurrentRide {
  CurrentRide({
    required this.ride,
  });

  final Ride ride;

  factory CurrentRide.fromMap(Map<String, dynamic> json) => CurrentRide(
        ride: Ride.fromMap(json["ride"]),
      );

  Map<String, dynamic> toMap() => {
        "ride": ride.toMap(),
      };
}

class Ride {
  Ride( {
    required this.discountType,
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
    required this.driver,
  });

  final FromLocationClass fromLocation;
  final FromLocationClass toLocation;
  final String id;
  final List<dynamic> drivers;
  final String user;
  final String rideType;
  final String otp;
  final double distance;
  final double fare;
  final int discountPercentage;
  final int discountKm;
  final int discountAmount;
  final double finalFare;
  final String status;
  final String paymentStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String discountType;
  final int v;
  final Driver driver;

  factory Ride.fromMap(Map<String, dynamic> json) => Ride(
    // discountType: json["discountType"] ??"",
        fromLocation: FromLocationClass.fromMap(json["fromLocation"]),
        toLocation: FromLocationClass.fromMap(json["toLocation"]),
        id: json["_id"],
        drivers: List<dynamic>.from(json["drivers"].map((x) => x)),
        user: json["user"],
        rideType: json["rideType"],
        otp: json["otp"],
        distance: json["distance"]?.toDouble(),
        fare: json["fare"]?.toDouble(),
        discountPercentage: json["discountPercentage"],
        discountKm: json["discountKM"],
        discountAmount: json["discountAmount"],
        discountType: json["discountType"]??"",
        finalFare: json["finalFare"]?.toDouble(),
        status: json["status"],
        paymentStatus: json["paymentStatus"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        driver: Driver.fromMap(json["driver"]),
      );

  Map<String, dynamic> toMap() => {
        "fromLocation": fromLocation.toMap(),
        "toLocation": toLocation.toMap(),
        "_id": id,
        "drivers": List<dynamic>.from(drivers.map((x) => x)),
        "user": user,
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
        "driver": driver.toMap(),
      };
}

class Driver {
  Driver({
    required this.location,
    required this.carDetails,
    required this.documentVerification,
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.profileUrl,
    required this.status,
    required this.isVerified,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.reason,
    required this.passwordChangedAt,
  });

  final Location location;
  final CarDetails carDetails;
  final DocumentVerification documentVerification;
  final String id;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String profileUrl;
  final String status;
  final bool isVerified;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final String reason;
  final DateTime passwordChangedAt;

  factory Driver.fromMap(Map<String, dynamic> json) => Driver(
        location: Location.fromMap(json["location"]),
        carDetails: CarDetails.fromMap(json["carDetails"]),
        documentVerification:
            DocumentVerification.fromMap(json["documentVerification"]),
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        gender: json["gender"],
        profileUrl: json["profileUrl"],
        status: json["status"],
        isVerified: json["isVerified"],
        isAvailable: json["isAvailable"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        reason: json["reason"],
        passwordChangedAt: DateTime.parse(json["passwordChangedAt"]),
      );

  Map<String, dynamic> toMap() => {
        "location": location.toMap(),
        "carDetails": carDetails.toMap(),
        "documentVerification": documentVerification.toMap(),
        "_id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "gender": gender,
        "profileUrl": profileUrl,
        "status": status,
        "isVerified": isVerified,
        "isAvailable": isAvailable,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "reason": reason,
        "passwordChangedAt": passwordChangedAt.toIso8601String(),
      };
}

class CarDetails {
  CarDetails({
    required this.carModel,
    required this.carNumber,
    required this.carColour,
  });

  final String carModel;
  final String carNumber;
  final String carColour;

  factory CarDetails.fromMap(Map<String, dynamic> json) => CarDetails(
        carModel: json["carModel"],
        carNumber: json["carNumber"],
        carColour: json["carColour"],
      );

  Map<String, dynamic> toMap() => {
        "carModel": carModel,
        "carNumber": carNumber,
        "carColour": carColour,
      };
}

class DocumentVerification {
  DocumentVerification({
    required this.drivingLicense,
    required this.panCard,
    required this.registrationCertificate,
  });

  final DrivingLicense drivingLicense;
  final DrivingLicense panCard;
  final DrivingLicense registrationCertificate;

  factory DocumentVerification.fromMap(Map<String, dynamic> json) =>
      DocumentVerification(
        drivingLicense: DrivingLicense.fromMap(json["drivingLicense"]),
        panCard: DrivingLicense.fromMap(json["panCard"]),
        registrationCertificate:
            DrivingLicense.fromMap(json["registrationCertificate"]),
      );

  Map<String, dynamic> toMap() => {
        "drivingLicense": drivingLicense.toMap(),
        "panCard": panCard.toMap(),
        "registrationCertificate": registrationCertificate.toMap(),
      };
}

class DrivingLicense {
  DrivingLicense({
    required this.url,
  });

  final String url;

  factory DrivingLicense.fromMap(Map<String, dynamic> json) => DrivingLicense(
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "url": url,
      };
}

class Location {
  Location({
    required this.coordinates,
    required this.type,
  });

  final List<double> coordinates;
  final String type;

  factory Location.fromMap(Map<String, dynamic> json) => Location(
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
        type: json["type"],
      );

  Map<String, dynamic> toMap() => {
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
        "type": type,
      };
}

class FromLocationClass {
  FromLocationClass({
    required this.coordinates,
    required this.name,
  });

  final List<double> coordinates;
  final String name;

  factory FromLocationClass.fromMap(Map<String, dynamic> json) =>
      FromLocationClass(
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
        "name": name,
      };
}

import 'dart:convert';

PreviousRides prevRidesFromMap(String str) => PreviousRides.fromJson(json.decode(str));

String prevRidesToMap(PreviousRides data) => json.encode(data.toJson());
class PreviousRides {
  List<Previous>? previous;

  PreviousRides({this.previous});

  PreviousRides.fromJson(Map<String, dynamic> json) {
    if (json['previous'] != null) {
      previous = <Previous>[];
      json['previous'].forEach((v) {
        previous!.add(Previous.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (previous != null) {
      data['previous'] = previous!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Previous {
  FromLocation? fromLocation;
  FromLocation? toLocation;
  String? sId;
  List<String>? drivers;
  String? user;
  String? rideType;
  String? otp;
  double? distance;
  double? fare;
  int? discountPercentage;
  var discountKM;
  var discountAmount;
  var finalFare;
  String? status;
  String? paymentStatus;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Previous(
      {this.fromLocation,
      this.toLocation,
      this.sId,
      this.drivers,
      this.user,
      this.rideType,
      this.otp,
      this.distance,
      this.fare,
      this.discountPercentage,
      this.discountKM,
      this.discountAmount,
      this.finalFare,
      this.status,
      this.paymentStatus,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Previous.fromJson(Map<String, dynamic> json) {
    fromLocation = json['fromLocation'] != null
        ? FromLocation.fromJson(json['fromLocation'])
        : null;
    toLocation = json['toLocation'] != null
        ? FromLocation.fromJson(json['toLocation'])
        : null;
    sId = json['_id'];
    drivers = json['drivers'].cast<String>();
    user = json['user'];
    rideType = json['rideType'];
    otp = json['otp'];
    distance = json['distance'];
    fare = json['fare'];
    discountPercentage = json['discountPercentage'];
    discountKM = json['discountKM'];
    discountAmount = json['discountAmount'];
    finalFare = json['finalFare'];
    status = json['status'];
    paymentStatus = json['paymentStatus'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (fromLocation != null) {
      data['fromLocation'] = fromLocation!.toJson();
    }
    if (toLocation != null) {
      data['toLocation'] = toLocation!.toJson();
    }
    data['_id'] = sId;
    data['drivers'] = drivers;
    data['user'] = user;
    data['rideType'] = rideType;
    data['otp'] = otp;
    data['distance'] = distance;
    data['fare'] = fare;
    data['discountPercentage'] = discountPercentage;
    data['discountKM'] = discountKM;
    data['discountAmount'] = discountAmount;
    data['finalFare'] = finalFare;
    data['status'] = status;
    data['paymentStatus'] = paymentStatus;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class FromLocation {
  List<double>? coordinates;
  String? name;

  FromLocation({this.coordinates, this.name});

  FromLocation.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coordinates'] = coordinates;
    data['name'] = name;
    return data;
  }
}
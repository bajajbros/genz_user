import 'dart:convert';

LiveRide liveRideFromJson(String str) => LiveRide.fromJson(json.decode(str));

String liveRideToJson(LiveRide data) => json.encode(data.toJson());

class LiveRide {
  Driver? driver;
  RideDetails? rideDetails;

  LiveRide({required this.driver, required this.rideDetails});

  LiveRide.fromJson(Map<String, dynamic> json) {
    driver = json['driver'] != null ? Driver.fromJson(json['driver']) : null;
    rideDetails = json['rideDetails'] != null
        ? RideDetails.fromJson(json['rideDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (driver != null) {
      data['driver'] = driver!.toJson();
    }
    if (rideDetails != null) {
      data['rideDetails'] = rideDetails!.toJson();
    }
    return data;
  }
}

class Driver {
  Location? location;
  CarDetails? carDetails;
  DocumentVerification? documentVerification;
  String? sId;
  String? name;
  String? email;
  String? phone;
  String? gender;
  String? profileUrl;
  String? status;
  bool? isVerified;
  bool? isAvailable;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? reason;
  String? passwordChangedAt;

  Driver(
      {this.location,
      this.carDetails,
      this.documentVerification,
      this.sId,
      this.name,
      this.email,
      this.phone,
      this.gender,
      this.profileUrl,
      this.status,
      this.isVerified,
      this.isAvailable,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.reason,
      this.passwordChangedAt});

  Driver.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    carDetails = json['carDetails'] != null
        ? CarDetails.fromJson(json['carDetails'])
        : null;
    documentVerification = json['documentVerification'] != null
        ? DocumentVerification.fromJson(json['documentVerification'])
        : null;
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    gender = json['gender'];
    profileUrl = json['profileUrl'];
    status = json['status'];
    isVerified = json['isVerified'];
    isAvailable = json['isAvailable'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    reason = json['reason'];
    passwordChangedAt = json['passwordChangedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (location != null) {
      data['location'] = location!.toJson();
    }
    if (carDetails != null) {
      data['carDetails'] = carDetails!.toJson();
    }
    if (documentVerification != null) {
      data['documentVerification'] = documentVerification!.toJson();
    }
    data['_id'] = sId;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['gender'] = gender;
    data['profileUrl'] = profileUrl;
    data['status'] = status;
    data['isVerified'] = isVerified;
    data['isAvailable'] = isAvailable;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['reason'] = reason;
    data['passwordChangedAt'] = passwordChangedAt;
    return data;
  }
}

class Location {
  List<double>? coordinates;
  String? type;

  Location({required this.coordinates, required this.type});

  Location.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['coordinates'] = coordinates;
    data['type'] = type;
    return data;
  }
}

class CarDetails {
  String? carModel;
  String? carNumber;
  String? carColour;

  CarDetails(
      {required this.carModel,
      required this.carNumber,
      required this.carColour});

  CarDetails.fromJson(Map<String, dynamic> json) {
    carModel = json['carModel'];
    carNumber = json['carNumber'];
    carColour = json['carColour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['carModel'] = carModel;
    data['carNumber'] = carNumber;
    data['carColour'] = carColour;
    return data;
  }
}

class DocumentVerification {
  DrivingLicense? drivingLicense;
  DrivingLicense? panCard;
  DrivingLicense? registrationCertificate;

  DocumentVerification(
      {required this.drivingLicense,
      required this.panCard,
      required this.registrationCertificate});

  DocumentVerification.fromJson(Map<String, dynamic> json) {
    drivingLicense = json['drivingLicense'] != null
        ? DrivingLicense.fromJson(json['drivingLicense'])
        : null;
    panCard = json['panCard'] != null
        ? DrivingLicense.fromJson(json['panCard'])
        : null;
    registrationCertificate = json['registrationCertificate'] != null
        ? DrivingLicense.fromJson(json['registrationCertificate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (drivingLicense != null) {
      data['drivingLicense'] = drivingLicense!.toJson();
    }
    if (panCard != null) {
      data['panCard'] = panCard!.toJson();
    }
    if (registrationCertificate != null) {
      data['registrationCertificate'] = registrationCertificate!.toJson();
    }
    return data;
  }
}

class DrivingLicense {
  String? url;

  DrivingLicense({required this.url});

  DrivingLicense.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    return data;
  }
}

class RideDetails {
  FromLocation? fromLocation;
  FromLocation? toLocation;
  String? sId;
  List<void>? drivers;
  String? user;
  String? rideType;
  String? otp;
  double? distance;
  double? fare;
  var discountPercentage;
  var discountKM;
  var discountAmount;
  var finalFare;
  String? status;
  String? paymentStatus;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? driver;

  RideDetails(
      {required this.fromLocation,
      required this.toLocation,
      required this.sId,
      required this.drivers,
      required this.user,
      required this.rideType,
      required this.otp,
      required this.distance,
      required this.fare,
      required this.discountPercentage,
      required this.discountKM,
      required this.discountAmount,
      required this.finalFare,
      required this.status,
      required this.paymentStatus,
      required this.createdAt,
      required this.updatedAt,
      required this.iV,
      required this.driver});

  RideDetails.fromJson(Map<String, dynamic> json) {
    fromLocation = json['fromLocation'] != null
        ? FromLocation.fromJson(json['fromLocation'])
        : null;
    toLocation = json['toLocation'] != null
        ? FromLocation.fromJson(json['toLocation'])
        : null;
    sId = json['_id'];
    // if (json['drivers'] != null) {
    //   drivers = <Null>[];
    //   json['drivers'].forEach((v) {
    //     drivers!.add(v.fromJson(v));
    //   });
    // }
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
    driver = json['driver'];
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
    if (drivers != null) {
      // data['drivers'] = drivers!.map((v) => v.toJson()).toList();
    }
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
    data['driver'] = driver;
    return data;
  }
}

class FromLocation {
  List<double>? coordinates;
  String? name;

  FromLocation({required this.coordinates, required this.name});

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

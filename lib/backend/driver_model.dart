class Driver {
  String? id;
  String? name;
  String? email;
  String? password;
  Location? location;
  String? phone;
  String? gender;
  String? status;
  bool? isWorking;
  bool? isAvailable;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  Distance? dist;

  Driver(
      {required String this.id,
     required this.name,
    required  this.email,
     required this.password,
     required this.location,
     required this.phone,
     required this.gender,
     required this.status,
     required this.isWorking,
     required this.isAvailable,
     required this.createdAt,
     required this.updatedAt,
      this.v,
     required this.dist});

  Driver.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    location = json['location'] != null
        ? Location.fromJson(json['location'])
        : null;
    phone = json['phone'];
    gender = json['gender'];
    status = json['status'];
    isWorking = json['isWorking'];
    isAvailable = json['isAvailable'];
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
    v = json['__v'];
    dist = json['dist'] != null ? Distance.fromJson(json['dist']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['phone'] = phone;
    data['gender'] = gender;
    data['status'] = status;
    data['isWorking'] = isWorking;
    data['isAvailable'] = isAvailable;
    data['createdAt'] = createdAt!.toIso8601String();
    data['updatedAt'] = updatedAt!.toIso8601String();
    data['__v'] = v;
    if (dist != null) {
      data['dist'] = dist!.toJson();
    }
    return data;
  }
}

class Location {
  List<double>? coordinates;
  String? type;

  Location({this.coordinates, this.type});

  Location.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
  }
  Map<String, dynamic> toJson() {
  return {
    "coordinates": [coordinates![0], coordinates![1]],
    "type": type
  };
}

}

class Distance {
  double? calculated;
  Location? location;

  Distance({this.calculated, this.location});

  Distance.fromJson(Map<String, dynamic> json) {
    calculated = json['calculated'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['calculated'] = calculated;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    return data;
  }
}

class DriverModel {
  String? success;
  String? error;
  String? message;
  List<DriverData>? data;

  DriverModel({this.success, this.error, this.message, this.data});

  DriverModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <DriverData>[];
      json['data'].forEach((v) {
        data!.add(DriverData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DriverData {
  String? id;
  String? nom;
  String? prenom;
  String? phone;
  String? email;
  String? online;
  String? photo;
  String? latitude;
  String? longitude;
  String? idVehicule;
  String? brand;
  String? model;
  String? color;
  String? numberplate;
  String? passenger;
  String? typeVehicule;
  String? distance;
  String? moyenne;
  String? totalCompletedRide;

  DriverData(
      {this.id,
      this.nom,
      this.prenom,
      this.phone,
      this.email,
      this.online,
      this.photo,
      this.latitude,
      this.longitude,
      this.idVehicule,
      this.brand,
      this.model,
      this.color,
      this.numberplate,
      this.passenger,
      this.typeVehicule,
      this.distance,
      this.moyenne,
      this.totalCompletedRide});

  DriverData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    nom = json['nom'].toString();
    prenom = json['prenom'].toString();
    phone = json['phone'].toString();
    email = json['email'].toString();
    online = json['online'].toString();
    photo = json['photo'].toString();
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    idVehicule = json['idVehicule'].toString();
    brand = json['brand'].toString();
    model = json['model'].toString();
    color = json['color'].toString();
    numberplate = json['numberplate'].toString();
    passenger = json['passenger'].toString();
    typeVehicule = json['typeVehicule'].toString();
    distance = json['distance'].toString();
    moyenne = json['moyenne'].toString();
    totalCompletedRide = json['total_completed_ride'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['phone'] = phone;
    data['email'] = email;
    data['online'] = online;
    data['photo'] = photo;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['idVehicule'] = idVehicule;
    data['brand'] = brand;
    data['model'] = model;
    data['color'] = color;
    data['numberplate'] = numberplate;
    data['passenger'] = passenger;
    data['typeVehicule'] = typeVehicule;
    data['distance'] = distance;
    data['moyenne'] = moyenne;
    data['total_completed_ride'] = totalCompletedRide;
    return data;
  }
}

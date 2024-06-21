// To parse this JSON data, do
//
//     final vehicleRegisterModel = vehicleRegisterModelFromJson(jsonString);

import 'dart:convert';

VehicleRegisterModel vehicleRegisterModelFromJson(String str) => VehicleRegisterModel.fromJson(json.decode(str));

String vehicleRegisterModelToJson(VehicleRegisterModel data) => json.encode(data.toJson());

class VehicleRegisterModel {
  VehicleRegisterModel({
    required this.success,
    this.error,
    required this.message,
    required this.data,
  });

  String success;
  dynamic error;
  String message;
  Data data;

  factory VehicleRegisterModel.fromJson(Map<String, dynamic> json) => VehicleRegisterModel(
        success: json["success"].toString(),
        error: json["error"].toString(),
        message: json["message"].toString(),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "error": error,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.id,
    required this.brand,
    required this.model,
    required this.carMake,
    required this.milage,
    required this.km,
    required this.color,
    required this.numberplate,
    required this.passenger,
    required this.idConducteur,
    required this.statut,
    required this.creer,
    required this.modifier,
    required this.updatedAt,
    required this.deletedAt,
    required this.idTypeVehicule,
  });

  String id;
  String brand;
  String model;
  String carMake;
  String milage;
  String km;
  String color;
  String numberplate;
  String passenger;
  String idConducteur;
  String statut;
  DateTime creer;
  DateTime modifier;
  DateTime updatedAt;
  dynamic deletedAt;
  String idTypeVehicule;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"].toString(),
        brand: json["brand"].toString(),
        model: json["model"].toString(),
        carMake: json["car_make"].toString(),
        milage: json["milage"].toString(),
        km: json["km"].toString(),
        color: json["color"].toString(),
        numberplate: json["numberplate"].toString(),
        passenger: json["passenger"].toString(),
        idConducteur: json["id_conducteur"].toString(),
        statut: json["statut"].toString(),
        creer: DateTime.parse(json["creer"]),
        modifier: DateTime.parse(json["modifier"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        idTypeVehicule: json["id_type_vehicule"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "brand": brand,
        "model": model,
        "car_make": carMake,
        "milage": milage,
        "km": km,
        "color": color,
        "numberplate": numberplate,
        "passenger": passenger,
        "id_conducteur": idConducteur,
        "statut": statut,
        "creer": creer.toIso8601String(),
        "modifier": modifier.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "id_type_vehicule": idTypeVehicule,
      };
}

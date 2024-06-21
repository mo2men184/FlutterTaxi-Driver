class GetVehicleDataModel {
  String? success;
  String? error;
  String? message;
  VehicleData? vehicleData;

  GetVehicleDataModel({this.success, this.error, this.message, this.vehicleData});

  GetVehicleDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString();
    error = json['error'].toString();
    message = json['message'].toString();
    vehicleData = json['data'] != null ? VehicleData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (vehicleData != null) {
      data['data'] = vehicleData!.toJson();
    }
    return data;
  }
}

class VehicleData {
  String? id;
  String? brand;
  String? model;
  String? carMake;
  String? milage;
  String? km;
  String? color;
  String? numberplate;
  String? passenger;
  String? idConducteur;
  String? statut;
  String? creer;
  String? modifier;
  String? updatedAt;
  String? deletedAt;
  String? idTypeVehicule;
  String? deliveryCharges;
  String? minimumDeliveryCharges;
  String? minimumDeliveryChargesWithin;

  VehicleData(
      {this.id,
      this.brand,
      this.model,
      this.carMake,
      this.milage,
      this.km,
      this.color,
      this.numberplate,
      this.passenger,
      this.idConducteur,
      this.statut,
      this.creer,
      this.modifier,
      this.updatedAt,
      this.deletedAt,
      this.idTypeVehicule,
      this.deliveryCharges,
      this.minimumDeliveryCharges,
      this.minimumDeliveryChargesWithin});

  VehicleData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    brand = json['brand'].toString();
    model = json['model'].toString();
    carMake = json['car_make'].toString();
    milage = json['milage'].toString();
    km = json['km'].toString();
    color = json['color'].toString();
    numberplate = json['numberplate'].toString();
    passenger = json['passenger'].toString();
    idConducteur = json['id_conducteur'].toString();
    statut = json['statut'].toString();
    creer = json['creer'].toString();
    modifier = json['modifier'].toString();
    updatedAt = json['updated_at'].toString();
    deletedAt = json['deleted_at'].toString();
    idTypeVehicule = json['id_type_vehicule'].toString();
    deliveryCharges = json['delivery_charges_per_km'].toString() ?? '0.0';
    minimumDeliveryCharges = json['minimum_delivery_charges'].toString() ?? '0.0';
    minimumDeliveryChargesWithin = json['minimum_delivery_charges_within_km'].toString() ?? '0.0';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['brand'] = brand;
    data['model'] = model;
    data['car_make'] = carMake;
    data['milage'] = milage;
    data['km'] = km;
    data['color'] = color;
    data['numberplate'] = numberplate;
    data['passenger'] = passenger;
    data['id_conducteur'] = idConducteur;
    data['statut'] = statut;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['id_type_vehicule'] = idTypeVehicule;
    data['delivery_charges_per_km'] = deliveryCharges;
    data['minimum_delivery_charges'] = minimumDeliveryCharges;
    data['minimum_delivery_charges_within_km'] = minimumDeliveryChargesWithin;
    return data;
  }
}

import 'package:rugbydriver/model/tax_model.dart';

class RideModel {
  String? success;
  String? error;
  String? message;
  List<RideData>? data;

  RideModel({this.success, this.error, this.message, this.data});

  RideModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    error = json['error'];
    message = json['message'];
    if (json['data'] != null) {
      data = <RideData>[];
      json['data'].forEach((v) {
        data!.add(RideData.fromJson(v));
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

class RideData {
  String? id;
  String? idUserApp;
  String? distanceUnit;
  String? departName;
  String? destinationName;
  String? latitudeDepart;
  String? longitudeDepart;
  String? latitudeArrivee;
  String? longitudeArrivee;
  String? numberPoeple;
  String? place;
  String? statut;
  String? idConducteur;
  String? creer;
  String? trajet;
  String? feelSafeDriver;
  String? nom;
  String? prenom;
  List<Stops>? stops;
  String? distance;
  String? phone;
  String? photoPath;
  String? nomConducteur;
  String? prenomConducteur;
  String? driverPhone;
  String? dateRetour;
  String? heureRetour;
  String? statutRound;
  String? montant;
  String? duree;
  String? userId;
  String? statutPaiement;
  String? payment;
  String? paymentImage;
  String? tripObjective;
  String? ageChildren1;
  String? ageChildren2;
  String? ageChildren3;
  String? moyenne;
  String? moyenneDriver;
  String? idVehicule;
  String? brand;
  String? model;
  String? carMake;
  String? milage;
  String? km;
  String? color;
  String? numberplate;
  String? passenger;
  String? discount;
  String? tipAmount;
  String? otp;
  String? rideType;
  String? existingUserId;
  String? adminCommission;
  UserInfo? userInfo;
  List<TaxModel>? taxModel;

  RideData({
    this.id,
    this.idUserApp,
    this.distanceUnit,
    this.departName,
    this.destinationName,
    this.latitudeDepart,
    this.longitudeDepart,
    this.latitudeArrivee,
    this.longitudeArrivee,
    this.numberPoeple,
    this.place,
    this.statut,
    this.idConducteur,
    this.creer,
    this.trajet,
    this.feelSafeDriver,
    this.nom,
    this.prenom,
    this.distance,
    this.phone,
    this.photoPath,
    this.nomConducteur,
    this.prenomConducteur,
    this.driverPhone,
    this.dateRetour,
    this.heureRetour,
    this.statutRound,
    this.montant,
    this.duree,
    this.userId,
    this.statutPaiement,
    this.payment,
    this.paymentImage,
    this.tripObjective,
    this.ageChildren1,
    this.ageChildren2,
    this.ageChildren3,
    this.moyenne,
    this.moyenneDriver,
    this.idVehicule,
    this.brand,
    this.model,
    this.carMake,
    this.milage,
    this.km,
    this.color,
    this.numberplate,
    this.passenger,
    this.discount,
    this.tipAmount,
    this.stops,
    this.otp,
    this.taxModel,
    this.rideType,
    this.userInfo,
    this.existingUserId,
    this.adminCommission,
  });

  RideData.fromJson(Map<String, dynamic> json) {
    List<TaxModel>? taxList = [];
    if (json['tax'] != null) {
      taxList = <TaxModel>[];
      json['tax'].forEach((v) {
        taxList!.add(TaxModel.fromJson(v));
      });
    }
    id = json['id'].toString();
    idUserApp = json['id_user_app'].toString();
    distanceUnit = json['distance_unit'].toString();
    departName = json['depart_name'].toString();
    destinationName = json['destination_name'].toString();
    latitudeDepart = json['latitude_depart'].toString();
    longitudeDepart = json['longitude_depart'].toString();
    latitudeArrivee = json['latitude_arrivee'].toString();
    longitudeArrivee = json['longitude_arrivee'].toString();
    numberPoeple = json['number_poeple'].toString();
    place = json['place'].toString();
    statut = json['statut'].toString();
    if (json['stops'] != null && json['stops'] != []) {
      stops = <Stops>[];
      json['stops'].forEach((v) {
        stops!.add(Stops.fromJson(v));
      });
    } else {
      stops = [];
    }
    if (json['user_info'] != null) {
      userInfo = UserInfo.fromJson(json['user_info']);
    }
    idConducteur = json['id_conducteur'].toString();
    creer = json['creer'].toString();
    trajet = json['trajet'].toString();
    feelSafeDriver = json['feel_safe_driver'].toString();
    nom = json['nom'].toString();
    prenom = json['prenom'].toString();
    distance = json['distance'].toString();
    phone = json['phone'].toString();
    photoPath = json['photo_path'].toString();
    nomConducteur = json['nomConducteur'].toString();
    prenomConducteur = json['prenomConducteur'].toString();
    driverPhone = json['driverPhone'].toString();
    dateRetour = json['date_retour'].toString();
    heureRetour = json['heure_retour'].toString();
    statutRound = json['statut_round'].toString();
    montant = json['montant'].toString();
    duree = json['duree'].toString();
    userId = json['userId'].toString();
    statutPaiement = json['statut_paiement'].toString();
    payment = json['payment'].toString();
    paymentImage = json['payment_image'].toString();
    tripObjective = json['trip_objective'].toString();
    ageChildren1 = json['age_children1'].toString();
    ageChildren2 = json['age_children2'].toString();
    ageChildren3 = json['age_children3'].toString();
    driverPhone = json['driver_phone'].toString();
    moyenne = json['moyenne'].toString();
    moyenneDriver = json['moyenne_driver'].toString();
    idVehicule = json['idVehicule'].toString();
    brand = json['brand'].toString();
    model = json['model'].toString();
    carMake = json['car_make'].toString();
    milage = json['milage'].toString();
    km = json['km'].toString();
    color = json['color'].toString();
    numberplate = json['numberplate'].toString();
    passenger = json['passenger'].toString();
    discount = json['discount'].toString();
    tipAmount = json['tip_amount'].toString();
    otp = json['otp'].toString();
    rideType = json['ride_type'].toString();
    existingUserId = json['existing_user_id'].toString();
    adminCommission = json['admin_commission'].toString();

    taxModel = taxList;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['id_user_app'] = idUserApp;
    data['distance_unit'] = distanceUnit;
    data['depart_name'] = departName;
    data['destination_name'] = destinationName;
    data['latitude_depart'] = latitudeDepart;
    data['longitude_depart'] = longitudeDepart;
    data['latitude_arrivee'] = latitudeArrivee;
    data['longitude_arrivee'] = longitudeArrivee;
    data['number_poeple'] = numberPoeple;
    data['place'] = place;
    data['statut'] = statut;
    data['id_conducteur'] = idConducteur;
    data['creer'] = creer;
    data['trajet'] = trajet;
    data['feel_safe_driver'] = feelSafeDriver;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['distance'] = distance;
    data['phone'] = phone;
    data['photo_path'] = photoPath;
    data['nomConducteur'] = nomConducteur;
    data['prenomConducteur'] = prenomConducteur;
    data['driverPhone'] = driverPhone;
    data['date_retour'] = dateRetour;
    data['heure_retour'] = heureRetour;
    data['statut_round'] = statutRound;
    data['montant'] = montant;
    data['duree'] = duree;
    data['userId'] = userId;
    data['statut_paiement'] = statutPaiement;
    data['payment'] = payment;
    data['payment_image'] = paymentImage;
    data['trip_objective'] = tripObjective;
    data['age_children1'] = ageChildren1;
    data['age_children2'] = ageChildren2;
    data['age_children3'] = ageChildren3;
    data['driver_phone'] = driverPhone;
    data['moyenne'] = moyenne;
    data['moyenne_driver'] = moyenneDriver;
    data['idVehicule'] = idVehicule;
    data['brand'] = brand;
    data['model'] = model;
    data['car_make'] = carMake;
    data['milage'] = milage;
    data['km'] = km;
    data['color'] = color;
    data['numberplate'] = numberplate;
    data['passenger'] = passenger;
    data['discount'] = discount;
    data['tip_amount'] = tipAmount;
    data['otp'] = otp;
    data['ride_type'] = rideType;
    data['existing_user_id'] = existingUserId;
    data['admin_commission'] = adminCommission;
    if (userInfo != null) {
      data['user_info'] = userInfo!.toJson();
    }
    if (stops!.isNotEmpty) {
      data['stops'] = stops!.map((v) => v.toJson()).toList();
    } else {
      data['stops'] = [];
    }
    data['tax'] =
        taxModel != null ? taxModel!.map((v) => v.toJson()).toList() : null;
    return data;
  }
}

class Stops {
  String? latitude;
  String? location;
  String? longitude;

  Stops({this.latitude, this.location, this.longitude});

  Stops.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'].toString();
    location = json['location'].toString();
    longitude = json['longitude'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['location'] = location;
    data['longitude'] = longitude;
    return data;
  }
}

class UserInfo {
  String? name;
  String? email;
  String? phone;

  UserInfo({this.name, this.email, this.phone});

  UserInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}

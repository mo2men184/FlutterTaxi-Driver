import 'package:rugbydriver/model/ride_model.dart';
import 'package:rugbydriver/model/tax_model.dart';

class TruncationModel {
  String? success;
  String? error;
  String? message;
  List<TansactionData>? data;
  String? totalEarnings;

  TruncationModel(
      {this.success, this.error, this.message, this.data, this.totalEarnings});

  TruncationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString();
    error = json['error'].toString();
    message = json['message'].toString();
    if (json['data'] != null) {
      data = <TansactionData>[];
      json['data'].forEach((v) {
        data!.add(TansactionData.fromJson(v));
      });
    }
    totalEarnings = json['total_earnings'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total_earnings'] = totalEarnings;
    return data;
  }
}

class TansactionData {
  String? id;
  String? montant;
  String? tipAmount;
  String? distanceUnit;
  String? discount;
  String? adminCommission;
  String? idUserApp;
  String? departName;
  String? destinationName;
  String? creer;
  String? idPaymentMethod;
  String? libelle;
  String? amount;
  String? userName;
  String? userPhoto;
  String? userPhotoPath;
  String? payment;
  String? nom;
  String? prenom;
  List<Stops>? stops;
  String? distance;
  String? phone;
  String? photoPath;
  String? nomConducteur;
  String? prenomConducteur;
  String? numberPoeple;
  List<TaxModel>? taxModel;
  String? dateRetour;
  String? duree;
  String? moyenne;
  String? moyenneDriver;
  UserInfo? userInfo;
  String? rideType;
  String? existingUserId;

  TansactionData({
    this.id,
    this.montant,
    this.taxModel,
    this.tipAmount,
    this.discount,
    this.adminCommission,
    this.idUserApp,
    this.departName,
    this.destinationName,
    this.creer,
    this.idPaymentMethod,
    this.libelle,
    this.amount,
    this.userName,
    this.userPhoto,
    this.payment,
    this.userPhotoPath,
    this.nom,
    this.prenom,
    this.distance,
    this.phone,
    this.photoPath,
    this.userInfo,
    this.nomConducteur,
    this.prenomConducteur,
    this.stops,
    this.numberPoeple,
    this.duree,
    this.distanceUnit,
    this.dateRetour,
    this.moyenne,
    this.moyenneDriver,
    this.rideType,
    this.existingUserId,
  });

  TansactionData.fromJson(Map<String, dynamic> json) {
    List<TaxModel>? taxList = [];
    if (json['tax'] != null &&
        json['tax'] != [] &&
        json['tax'].toString().isNotEmpty) {
      taxList = <TaxModel>[];
      json['tax'].forEach((v) {
        taxList!.add(TaxModel.fromJson(v));
      });
    }
    id = json['id'].toString();
    montant = json['montant'].toString();
    taxModel = taxList;
    tipAmount = json['tip_amount'].toString();
    discount = json['discount'].toString();
    adminCommission = json['admin_commission'].toString();
    idUserApp = json['id_user_app'].toString();
    departName = json['depart_name'].toString();
    destinationName = json['destination_name'].toString();
    creer = json['creer'].toString();
    idPaymentMethod = json['id_payment_method'].toString();
    libelle = json['libelle'].toString();
    amount = json['amount'].toString();
    userName = json['user_name'].toString();
    userPhoto = json['user_photo'].toString();
    userPhotoPath = json['user_photo_path'].toString();
    payment = json['payment'].toString();
    nom = json['nom'].toString();
    prenom = json['prenom'].toString();
    distance = json['distance'].toString();
    phone = json['phone'].toString();
    numberPoeple = json['number_poeple'].toString();
    photoPath = json['photo_path'].toString();
    duree = json['duree'].toString();
    distanceUnit = json['distance_unit'].toString();
    dateRetour = json['date_retour'].toString();
    moyenne = json['moyenne'].toString();
    moyenneDriver = json['moyenne_driver'].toString();
    existingUserId = json['existing_user_id'].toString();
    rideType = json['ride_type'].toString();
    if (json['user_info'] != null) {
      userInfo = UserInfo.fromJson(json['user_info']);
    }
    if (json['stops'] != null &&
        json['stops'] != [] &&
        json[stops].toString().isNotEmpty) {
      stops = <Stops>[];
      json['stops'].forEach((v) {
        stops!.add(Stops.fromJson(v));
      });
    } else {
      stops = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['montant'] = montant;
    data['tax'] =
        taxModel != null ? taxModel!.map((v) => v.toJson()).toList() : null;
    data['tip_amount'] = tipAmount;
    data['discount'] = discount;
    data['admin_commission'] = adminCommission;
    data['id_user_app'] = idUserApp;
    data['depart_name'] = departName;
    data['destination_name'] = destinationName;
    data['creer'] = creer;
    data['id_payment_method'] = idPaymentMethod;
    data['libelle'] = libelle;
    data['payment'] = payment;
    data['amount'] = amount;
    data['user_name'] = userName;
    data['user_photo'] = userPhoto;
    data['user_photo_path'] = userPhotoPath;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['distance'] = distance;
    data['phone'] = phone;
    data['photo_path'] = photoPath;
    data['number_poeple'] = numberPoeple;
    data['duree'] = duree;
    data['distance_unit'] = distanceUnit;
    data['date_retour'] = dateRetour;
    data['moyenne'] = moyenne;
    data['moyenne_driver'] = moyenneDriver;
    data['existing_user_id'] = existingUserId;
    data['ride_type'] = rideType;
    if (userInfo != null) {
      data['user_info'] = userInfo!.toJson();
    }
    if (stops!.isNotEmpty) {
      data['stops'] = stops!.map((v) => v.toJson()).toList();
    } else {
      data['stops'] = [];
    }
    return data;
  }
}

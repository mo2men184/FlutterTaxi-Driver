import 'package:rugbydriver/model/ride_model.dart';
import 'package:rugbydriver/model/tax_model.dart';

class RideDetailsModel {
  String? success;
  String? error;
  String? message;
  RideDetailsdata? rideDetailsdata;

  RideDetailsModel(
      {this.success, this.error, this.message, this.rideDetailsdata});

  RideDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString();
    error = json['error'].toString();
    message = json['message'].toString();
    rideDetailsdata =
        json['data'] != null ? RideDetailsdata.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    data['message'] = message;
    if (rideDetailsdata != null) {
      data['data'] = rideDetailsdata!.toJson();
    }
    return data;
  }
}

class RideDetailsdata {
  String? id;
  String? idUserApp;
  String? departName;
  String? destinationName;
  String? latitudeDepart;
  String? longitudeDepart;
  String? latitudeArrivee;
  String? longitudeArrivee;
  String? place;
  String? numberPoeple;
  String? distance;
  String? duree;
  String? montant;
  String? tipAmount;
  String? discount;
  String? transactionId;
  String? trajet;
  String? statut;
  String? statutPaiement;
  String? idConducteur;
  String? idPaymentMethod;
  String? creer;
  String? modifier;
  String? dateRetour;
  String? heureRetour;
  String? statutRound;
  String? statutCourse;
  String? idConducteurAccepter;
  String? tripObjective;
  String? tripCategory;
  String? ageChildren1;
  String? ageChildren2;
  String? ageChildren3;
  String? feelSafe;
  String? feelSafeDriver;
  String? carDriverConfirmed;
  dynamic deletedAt;
  dynamic updatedAt;
  List<TaxModel>? taxModel;
  String? existingUserId;
  UserInfo? userInfo;

  RideDetailsdata(
      {this.id,
      this.idUserApp,
      this.departName,
      this.destinationName,
      this.latitudeDepart,
      this.longitudeDepart,
      this.latitudeArrivee,
      this.longitudeArrivee,
      this.place,
      this.numberPoeple,
      this.distance,
      this.duree,
      this.montant,
      this.tipAmount,
      this.discount,
      this.transactionId,
      this.trajet,
      this.statut,
      this.statutPaiement,
      this.idConducteur,
      this.idPaymentMethod,
      this.creer,
      this.modifier,
      this.dateRetour,
      this.heureRetour,
      this.statutRound,
      this.statutCourse,
      this.idConducteurAccepter,
      this.tripObjective,
      this.tripCategory,
      this.ageChildren1,
      this.ageChildren2,
      this.ageChildren3,
      this.feelSafe,
      this.feelSafeDriver,
      this.carDriverConfirmed,
      this.deletedAt,
      this.taxModel,
      this.userInfo,
      this.existingUserId,
      this.updatedAt});

  RideDetailsdata.fromJson(Map<String, dynamic> json) {
    List<TaxModel>? taxList = [];
    if (json['tax'] != null) {
      taxList = <TaxModel>[];
      json['tax'].forEach((v) {
        taxList!.add(TaxModel.fromJson(v));
      });
    }
    id = json['id'].toString();
    idUserApp = json['id_user_app'].toString();
    departName = json['depart_name'].toString();
    destinationName = json['destination_name'].toString();
    latitudeDepart = json['latitude_depart'].toString();
    longitudeDepart = json['longitude_depart'].toString();
    latitudeArrivee = json['latitude_arrivee'].toString();
    longitudeArrivee = json['longitude_arrivee'].toString();
    place = json['place'].toString();
    numberPoeple = json['number_poeple'].toString();
    distance = json['distance'].toString();
    duree = json['duree'].toString();
    montant = json['montant'].toString();
    tipAmount = json['tip_amount'].toString();
    discount = json['discount'].toString();
    transactionId = json['transaction_id'].toString();
    trajet = json['trajet'].toString();
    statut = json['statut'].toString();
    statutPaiement = json['statut_paiement'].toString();
    idConducteur = json['id_conducteur'].toString();
    idPaymentMethod = json['id_payment_method'].toString();
    creer = json['creer'].toString();
    modifier = json['modifier'].toString();
    dateRetour = json['date_retour'].toString();
    heureRetour = json['heure_retour'].toString();
    statutRound = json['statut_round'].toString();
    statutCourse = json['statut_course'].toString();
    idConducteurAccepter = json['id_conducteur_accepter'].toString();
    tripObjective = json['trip_objective'].toString();
    tripCategory = json['trip_category'].toString();
    ageChildren1 = json['age_children1'].toString();
    ageChildren2 = json['age_children2'].toString();
    ageChildren3 = json['age_children3'].toString();
    feelSafe = json['feel_safe'].toString();
    feelSafeDriver = json['feel_safe_driver'].toString();
    carDriverConfirmed = json['car_driver_confirmed'].toString();
    deletedAt = json['deleted_at'];
    updatedAt = json['updated_at'];
    taxModel = taxList;
    existingUserId = json['existing_user_id'].toString();
    if (json['user_info'] != null) {
      userInfo = UserInfo.fromJson(json['user_info']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['id_user_app'] = idUserApp;
    data['depart_name'] = departName;
    data['destination_name'] = destinationName;
    data['latitude_depart'] = latitudeDepart;
    data['longitude_depart'] = longitudeDepart;
    data['latitude_arrivee'] = latitudeArrivee;
    data['longitude_arrivee'] = longitudeArrivee;
    data['place'] = place;
    data['number_poeple'] = numberPoeple;
    data['distance'] = distance;
    data['duree'] = duree;
    data['montant'] = montant;
    data['tip_amount'] = tipAmount;
    data['discount'] = discount;
    data['transaction_id'] = transactionId;
    data['trajet'] = trajet;
    data['statut'] = statut;
    data['statut_paiement'] = statutPaiement;
    data['id_conducteur'] = idConducteur;
    data['id_payment_method'] = idPaymentMethod;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['date_retour'] = dateRetour;
    data['heure_retour'] = heureRetour;
    data['statut_round'] = statutRound;
    data['statut_course'] = statutCourse;
    data['id_conducteur_accepter'] = idConducteurAccepter;
    data['trip_objective'] = tripObjective;
    data['trip_category'] = tripCategory;
    data['age_children1'] = ageChildren1;
    data['age_children2'] = ageChildren2;
    data['age_children3'] = ageChildren3;
    data['feel_safe'] = feelSafe;
    data['feel_safe_driver'] = feelSafeDriver;
    data['car_driver_confirmed'] = carDriverConfirmed;
    data['deleted_at'] = deletedAt;
    data['updated_at'] = updatedAt;
    data['tax'] =
        taxModel != null ? taxModel!.map((v) => v.toJson()).toList() : null;
    data['existing_user_id'] = existingUserId;
    if (userInfo != null) {
      data['user_info'] = userInfo!.toJson();
    }
    return data;
  }
}

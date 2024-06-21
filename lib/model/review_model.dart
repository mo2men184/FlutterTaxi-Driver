class ReviewModel {
  String? success;
  String? error;
  Data? data;

  ReviewModel({this.success, this.error, this.data});

  ReviewModel.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString();
    error = json['error'].toString();
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? id;
  String? rideId;
  String? niveauDriver;
  String? idConducteur;
  String? idUserApp;
  String? statut;
  String? creer;
  String? modifier;
  String? comment;

  Data({this.id, this.rideId, this.niveauDriver, this.idConducteur, this.idUserApp, this.statut, this.creer, this.modifier, this.comment});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    rideId = json['ride_id'].toString();
    niveauDriver = json['niveau_driver'].toString();
    idConducteur = json['id_conducteur'].toString();
    idUserApp = json['id_user_app'].toString();
    statut = json['statut'].toString();
    creer = json['creer'].toString();
    modifier = json['modifier'].toString();
    comment = json['comment'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ride_id'] = rideId;
    data['niveau_driver'] = niveauDriver;
    data['id_conducteur'] = idConducteur;
    data['id_user_app'] = idUserApp;
    data['statut'] = statut;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['comment'] = comment;
    return data;
  }
}

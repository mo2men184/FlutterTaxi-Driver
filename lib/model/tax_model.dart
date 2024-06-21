class TaxModel {
  String? id;
  String? libelle;
  String? value;
  String? type;
  String? country;
  String? statut;

  TaxModel({this.country, this.statut, this.value, this.id, this.type, this.libelle});

  TaxModel.fromJson(Map<String, dynamic> json) {
    country = json['country'].toString();
    statut = json['statut'].toString();
    value = json['value'].toString();
    id = json['id'].toString();
    type = json['type'].toString();
    libelle = json['libelle'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country'] = country;
    data['statut'] = statut;
    data['value'] = value;
    data['id'] = id;
    data['type'] = type;
    data['libelle'] = libelle;
    return data;
  }
}

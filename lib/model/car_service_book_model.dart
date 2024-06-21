class CarServiceHistoryModel {
  String? success;
  String? error;
  String? message;
  List<ServiceData>? data;

  CarServiceHistoryModel({this.success, this.error, this.message, this.data});

  CarServiceHistoryModel.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString();
    error = json['error'].toString();
    message = json['message'].toString();
    if (json['data'] != null) {
      data = <ServiceData>[];
      json['data'].forEach((v) {
        data!.add(ServiceData.fromJson(v));
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

class ServiceData {
  String? id;
  String? idConducteur;
  String? km;
  String? photoCarServiceBook;
  String? photoCarServiceBookPath;
  String? fileName;
  String? creer;
  String? modifier;

  ServiceData({this.id, this.idConducteur, this.km, this.photoCarServiceBook, this.photoCarServiceBookPath, this.fileName, this.creer, this.modifier});

  ServiceData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    idConducteur = json['id_conducteur'].toString();
    km = json['km'].toString();
    photoCarServiceBook = json['photo_car_service_book'].toString();
    photoCarServiceBookPath = json['photo_car_service_book_path'].toString();
    fileName = json['file_name'].toString();
    creer = json['creer'].toString();
    modifier = json['modifier'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['id_conducteur'] = idConducteur;
    data['km'] = km;
    data['photo_car_service_book'] = photoCarServiceBook;
    data['photo_car_service_book_path'] = photoCarServiceBookPath;
    data['file_name'] = fileName;
    data['creer'] = creer;
    data['modifier'] = modifier;
    return data;
  }
}

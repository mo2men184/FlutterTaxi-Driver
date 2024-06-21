class Model {
  String? success;
  String? error;
  String? message;
  List<ModelData>? data;

  Model({this.success, this.error, this.message, this.data});

  Model.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString();
    error = json['error'].toString();
    message = json['message'].toString();
    if (json['data'] != null) {
      data = <ModelData>[];
      json['data'].forEach((v) {
        data!.add(ModelData.fromJson(v));
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

class ModelData {
  String? name;
  String? id;

  ModelData({this.name, this.id});

  ModelData.fromJson(Map<String, dynamic> json) {
    name = json['name'].toString();
    id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['id'] = id;
    return data;
  }
}

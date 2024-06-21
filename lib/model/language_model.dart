class LanguageModel {
  String? success;
  dynamic error;
  String? message;
  List<LanguageData>? data;

  LanguageModel({this.success, this.error, this.message, this.data});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString();
    error = json['error'].toString();
    message = json['message'].toString();
    if (json['data'] != null) {
      data = <LanguageData>[];
      json['data'].forEach((v) {
        data!.add(LanguageData.fromJson(v));
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

class LanguageData {
  String? id;
  String? language;
  String? code;
  String? flag;
  String? status;
  String? isRtl;
  String? creer;
  String? modifier;
  String? updatedAt;

  LanguageData({this.id, this.language, this.code, this.flag, this.status, this.isRtl, this.creer, this.modifier, this.updatedAt});

  LanguageData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    language = json['language'].toString();
    code = json['code'].toString();
    flag = json['flag'].toString();
    status = json['status'].toString();
    isRtl = json['is_rtl'].toString();
    creer = json['creer'].toString();
    modifier = json['modifier'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['language'] = language;
    data['code'] = code;
    data['flag'] = flag;
    data['status'] = status;
    data['is_rtl'] = isRtl;
    data['creer'] = creer;
    data['modifier'] = modifier;
    data['updated_at'] = updatedAt;
    return data;
  }
}

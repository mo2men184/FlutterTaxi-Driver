class WithdrawalsModel {
  String? success;
  String? error;
  String? message;
  List<WithdrawalsData>? data;

  WithdrawalsModel({this.success, this.error, this.message, this.data});

  WithdrawalsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString();
    error = json['error'].toString();
    message = json['message'].toString();
    if (json['data'] != null) {
      data = <WithdrawalsData>[];
      json['data'].forEach((v) {
        data!.add(WithdrawalsData.fromJson(v));
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

class WithdrawalsData {
  String? id;
  String? idConducteur;
  String? amount;
  String? note;
  String? statut;
  String? creer;
  String? createdAt;
  String? modifier;
  String? updatedAt;
  String? bankName;
  String? branchName;
  String? accountNo;
  String? otherInfo;
  String? ifscCode;

  WithdrawalsData(
      {this.id,
      this.idConducteur,
      this.amount,
      this.note,
      this.statut,
      this.creer,
      this.createdAt,
      this.modifier,
      this.updatedAt,
      this.bankName,
      this.branchName,
      this.accountNo,
      this.otherInfo,
      this.ifscCode});

  WithdrawalsData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    idConducteur = json['id_conducteur'].toString();
    amount = json['amount'].toString();
    note = json['note'].toString();
    statut = json['statut'].toString();
    creer = json['creer'].toString();
    createdAt = json['created_at'].toString();
    modifier = json['modifier'].toString();
    updatedAt = json['updated_at'].toString();
    bankName = json['bank_name'].toString();
    branchName = json['branch_name'].toString();
    accountNo = json['account_no'].toString();
    otherInfo = json['other_info'].toString();
    ifscCode = json['ifsc_code'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['id_conducteur'] = idConducteur;
    data['amount'] = amount;
    data['note'] = note;
    data['statut'] = statut;
    data['creer'] = creer;
    data['created_at'] = createdAt;
    data['modifier'] = modifier;
    data['updated_at'] = updatedAt;
    data['bank_name'] = bankName;
    data['branch_name'] = branchName;
    data['account_no'] = accountNo;
    data['other_info'] = otherInfo;
    data['ifsc_code'] = ifscCode;
    return data;
  }
}

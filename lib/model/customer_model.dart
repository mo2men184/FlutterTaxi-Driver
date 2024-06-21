class CustomerData {
  String? id;
  String? nom;
  String? prenom;
  String? email;
  String? phone;
  String? mdp;
  String? loginType;
  String? photo;
  String? photoPath;
  String? photoNic;
  String? photoNicPath;
  String? statut;
  String? statutNic;
  String? tonotify;
  String? deviceId;
  String? fcmId;
  String? creer;
  String? updatedAt;
  String? modifier;
  String? amount;
  String? resetPasswordOtp;
  String? resetPasswordOtpModifier;
  String? age;
  String? gender;
  String? otp;
  dynamic otpCreated;
  dynamic deletedAt;
  dynamic createdAt;

  CustomerData(
      {this.id,
      this.nom,
      this.prenom,
      this.email,
      this.phone,
      this.mdp,
      this.loginType,
      this.photo,
      this.photoPath,
      this.photoNic,
      this.photoNicPath,
      this.statut,
      this.statutNic,
      this.tonotify,
      this.deviceId,
      this.fcmId,
      this.creer,
      this.updatedAt,
      this.modifier,
      this.amount,
      this.resetPasswordOtp,
      this.resetPasswordOtpModifier,
      this.age,
      this.gender,
      this.otp,
      this.otpCreated,
      this.deletedAt,
      this.createdAt});

  String fullName() {
    if (prenom != null && nom != null) {
      return '$prenom $nom';
    } else if (prenom != null && nom == null) {
      return '$prenom';
    } else if (prenom == null && nom != null) {
      return '$nom';
    } else {
      return "";
    }
  }

  CustomerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nom = json['nom'];
    prenom = json['prenom'];
    email = json['email'];
    phone = json['phone'];
    mdp = json['mdp'];
    loginType = json['login_type'];
    photo = json['photo'];
    photoPath = json['photo_path'];
    photoNic = json['photo_nic'];
    photoNicPath = json['photo_nic_path'];
    statut = json['statut'];
    statutNic = json['statut_nic'];
    tonotify = json['tonotify'];
    deviceId = json['device_id'];
    fcmId = json['fcm_id'];
    creer = json['creer'];
    updatedAt = json['updated_at'];
    modifier = json['modifier'];
    amount = json['amount'];
    resetPasswordOtp = json['reset_password_otp'];
    resetPasswordOtpModifier = json['reset_password_otp_modifier'];
    age = json['age'];
    gender = json['gender'];
    otp = json['otp'];
    otpCreated = json['otp_created'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nom'] = nom;
    data['prenom'] = prenom;
    data['email'] = email;
    data['phone'] = phone;
    data['mdp'] = mdp;
    data['login_type'] = loginType;
    data['photo'] = photo;
    data['photo_path'] = photoPath;
    data['photo_nic'] = photoNic;
    data['photo_nic_path'] = photoNicPath;
    data['statut'] = statut;
    data['statut_nic'] = statutNic;
    data['tonotify'] = tonotify;
    data['device_id'] = deviceId;
    data['fcm_id'] = fcmId;
    data['creer'] = creer;
    data['updated_at'] = updatedAt;
    data['modifier'] = modifier;
    data['amount'] = amount;
    data['reset_password_otp'] = resetPasswordOtp;
    data['reset_password_otp_modifier'] = resetPasswordOtpModifier;
    data['age'] = age;
    data['gender'] = gender;
    data['otp'] = otp;
    data['otp_created'] = otpCreated;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    return data;
  }

  String userAsString() {
    if (prenom != null && nom != null) {
      return '$prenom $nom';
    } else if (prenom != null && nom == null) {
      return '$prenom';
    } else if (prenom == null && nom != null) {
      return '$nom';
    } else {
      return "";
    }
  }
}

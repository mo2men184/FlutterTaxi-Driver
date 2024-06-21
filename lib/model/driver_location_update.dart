class DriverLocationUpdate {
  String? driverLatitude;
  String? driverLongitude;
  String? rotation;
  String? driverId;
  bool? active;

  DriverLocationUpdate(
      {this.driverLatitude,
        this.driverLongitude,
        this.rotation,
        this.driverId,
        this.active});

  DriverLocationUpdate.fromJson(Map<String, dynamic> json) {
    driverLatitude = json['driver_latitude'];
    driverLongitude = json['driver_longitude'];
    rotation = json['rotation'];
    driverId = json['driver_id'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driver_latitude'] = driverLatitude;
    data['driver_longitude'] = driverLongitude;
    data['rotation'] = rotation;
    data['driver_id'] = driverId;
    data['active'] = active;
    return data;
  }
}

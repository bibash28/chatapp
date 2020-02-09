class UserModel {
  final String id;
  final String email;
  final String lat;
  final String lng;
  final String photoUrl;
  final String userName;

  UserModel({
    this.id,
    this.email,
    this.lat,
    this.lng,
    this.photoUrl,
    this.userName,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      lat: json['lat'],
      lng: json['lng'],
      photoUrl: json['photoUrl'],
      userName: json['userName'],
    );
  }
}

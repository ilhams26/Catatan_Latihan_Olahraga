class UserModel {
  final String id;
  final String username;
  final int weight;
  final int height;

  UserModel({
    required this.id,
    required this.username,
    required this.weight,
    required this.height,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      weight: int.tryParse(json['weight'].toString()) ?? 0,
      height: int.tryParse(json['height'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'username': username, 'weight': weight, 'height': height};
  }
}

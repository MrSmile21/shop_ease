import 'stats_model.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profilePicture;
  final StatsModel stats;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
    required this.stats,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profilePicture: map['profilePicture'],
      stats: StatsModel.fromMap(map['stats'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePicture': profilePicture,
      'stats': stats.toMap(),
    };
  }
}

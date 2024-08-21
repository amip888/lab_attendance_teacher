import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String? id;
  String? email;
  String? role;
  dynamic refreshToken;

  User({this.id, this.email, this.role, this.refreshToken});

  @override
  String toString() {
    return 'User(id: $id, email: $email, role: $role, refreshToken: $refreshToken)';
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? email,
    String? role,
    dynamic refreshToken,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

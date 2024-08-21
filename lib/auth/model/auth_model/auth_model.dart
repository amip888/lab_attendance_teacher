import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'auth_model.g.dart';

@JsonSerializable()
class AuthModel {
  User? user;
  String? token;

  AuthModel({this.user, this.token});

  @override
  String toString() => 'AuthModel(user: $user, token: $token)';

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return _$AuthModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AuthModelToJson(this);

  AuthModel copyWith({
    User? user,
    String? token,
  }) {
    return AuthModel(
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }
}

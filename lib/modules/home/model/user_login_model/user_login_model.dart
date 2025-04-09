import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'user_login_model.g.dart';

@JsonSerializable()
class UserLoginModel {
  User? user;

  UserLoginModel({this.user});

  @override
  String toString() => 'UserLoginModel(user: $user)';

  factory UserLoginModel.fromJson(Map<String, dynamic> json) {
    return _$UserLoginModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserLoginModelToJson(this);

  UserLoginModel copyWith({
    User? user,
  }) {
    return UserLoginModel(
      user: user ?? this.user,
    );
  }
}

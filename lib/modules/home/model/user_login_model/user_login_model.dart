import 'package:json_annotation/json_annotation.dart';

import 'teacher.dart';

part 'user_login_model.g.dart';

@JsonSerializable()
class UserLoginModel {
  String? email;
  String? role;
  Teacher? teacher;

  UserLoginModel({this.email, this.role, this.teacher});

  @override
  String toString() {
    return 'UserLoginModel(email: $email, role: $role, teacher: $teacher)';
  }

  factory UserLoginModel.fromJson(Map<String, dynamic> json) {
    return _$UserLoginModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserLoginModelToJson(this);

  UserLoginModel copyWith({
    String? email,
    String? role,
    Teacher? teacher,
  }) {
    return UserLoginModel(
      email: email ?? this.email,
      role: role ?? this.role,
      teacher: teacher ?? this.teacher,
    );
  }
}

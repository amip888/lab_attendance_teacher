import 'package:json_annotation/json_annotation.dart';

import 'teacher.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String? email;
  String? role;
  Teacher? teacher;

  User({this.email, this.role, this.teacher});

  @override
  String toString() => 'User(email: $email, role: $role, teacher: $teacher)';

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? email,
    String? role,
    Teacher? teacher,
  }) {
    return User(
      email: email ?? this.email,
      role: role ?? this.role,
      teacher: teacher ?? this.teacher,
    );
  }
}

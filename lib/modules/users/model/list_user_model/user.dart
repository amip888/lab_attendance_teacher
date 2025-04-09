import 'package:json_annotation/json_annotation.dart';

import 'operator.dart';
import 'student.dart';
import 'teacher.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String? id;
  String? email;
  String? role;
  Operator? operator;
  Teacher? teacher;
  Student? student;

  User({
    this.id,
    this.email,
    this.role,
    this.operator,
    this.teacher,
    this.student,
  });

  @override
  String toString() {
    return 'User(id: $id, email: $email, role: $role, operator: $operator, teacher: $teacher, student: $student)';
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? email,
    String? role,
    Operator? operator,
    Teacher? teacher,
    Student? student,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
      operator: operator ?? this.operator,
      teacher: teacher ?? this.teacher,
      student: student ?? this.student,
    );
  }
}

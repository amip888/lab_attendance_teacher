import 'package:json_annotation/json_annotation.dart';

import 'schedule.dart';
import 'teacher.dart';
import 'user.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification {
  String? id;
  @JsonKey(name: 'id_teacher')
  String? idTeacher;
  @JsonKey(name: 'id_schedule')
  String? idSchedule;
  String? title;
  String? description;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  Teacher? teacher;
  Schedule? schedule;
  List<User>? users;

  Notification({
    this.id,
    this.idTeacher,
    this.idSchedule,
    this.title,
    this.description,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.teacher,
    this.schedule,
    this.users,
  });

  @override
  String toString() {
    return 'Notification(id: $id, idTeacher: $idTeacher, idSchedule: $idSchedule, title: $title, description: $description, type: $type, createdAt: $createdAt, updatedAt: $updatedAt, teacher: $teacher, schedule: $schedule, users: $users)';
  }

  factory Notification.fromJson(Map<String, dynamic> json) {
    return _$NotificationFromJson(json);
  }

  Map<String, dynamic> toJson() => _$NotificationToJson(this);

  Notification copyWith({
    String? id,
    String? idTeacher,
    String? idSchedule,
    String? title,
    String? description,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
    Teacher? teacher,
    Schedule? schedule,
    List<User>? users,
  }) {
    return Notification(
      id: id ?? this.id,
      idTeacher: idTeacher ?? this.idTeacher,
      idSchedule: idSchedule ?? this.idSchedule,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      teacher: teacher ?? this.teacher,
      schedule: schedule ?? this.schedule,
      users: users ?? this.users,
    );
  }
}

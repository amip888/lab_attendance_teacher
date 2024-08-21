import 'package:json_annotation/json_annotation.dart';

import 'lab_room.dart';
import 'teacher.dart';

part 'schedule.g.dart';

@JsonSerializable()
class Schedule {
  String? id;
  @JsonKey(name: 'id_teacher')
  String? idTeacher;
  @JsonKey(name: 'id_lab_room')
  String? idLabRoom;
  String? subject;
  String? major;
  @JsonKey(name: 'class')
  String? scheduleClass;
  String? date;
  @JsonKey(name: 'begin_time')
  String? beginTime;
  @JsonKey(name: 'end_time')
  String? endTime;
  bool? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  Teacher? teacher;
  @JsonKey(name: 'lab_room')
  LabRoom? labRoom;

  Schedule({
    this.id,
    this.idTeacher,
    this.idLabRoom,
    this.subject,
    this.major,
    this.scheduleClass,
    this.date,
    this.beginTime,
    this.endTime,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.teacher,
    this.labRoom,
  });

  @override
  String toString() {
    return 'Schedule(id: $id, idTeacher: $idTeacher, idLabRoom: $idLabRoom, subject: $subject, major: $major, scheduleClass: $scheduleClass, date: $date, beginTime: $beginTime, endTime: $endTime, status: $status, createdAt: $createdAt, updatedAt: $updatedAt, teacher: $teacher, labRoom: $labRoom)';
  }

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return _$ScheduleFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ScheduleToJson(this);

  Schedule copyWith({
    String? id,
    String? idTeacher,
    String? idLabRoom,
    String? subject,
    String? major,
    String? scheduleClass,
    String? date,
    String? beginTime,
    String? endTime,
    bool? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    Teacher? teacher,
    LabRoom? labRoom,
  }) {
    return Schedule(
      id: id ?? this.id,
      idTeacher: idTeacher ?? this.idTeacher,
      idLabRoom: idLabRoom ?? this.idLabRoom,
      subject: subject ?? this.subject,
      major: major ?? this.major,
      scheduleClass: scheduleClass ?? this.scheduleClass,
      date: date ?? this.date,
      beginTime: beginTime ?? this.beginTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      teacher: teacher ?? this.teacher,
      labRoom: labRoom ?? this.labRoom,
    );
  }
}

import 'package:json_annotation/json_annotation.dart';

part 'schedule_model.g.dart';

@JsonSerializable()
class ScheduleModel {
  String? id;
  @JsonKey(name: 'id_teacher')
  String? idTeacher;
  DateTime? day;
  String? subject;
  String? major;
  @JsonKey(name: 'class')
  String? scheduleModelClass;
  @JsonKey(name: 'lab_room')
  String? roomLab;
  bool? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  ScheduleModel({
    this.id,
    this.idTeacher,
    this.day,
    this.subject,
    this.major,
    this.scheduleModelClass,
    this.roomLab,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'ScheduleModel(id: $id, idTeacher: $idTeacher, day: $day, subject: $subject, major: $major, scheduleModelClass: $scheduleModelClass, roomLab: $roomLab, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return _$ScheduleModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ScheduleModelToJson(this);

  ScheduleModel copyWith({
    String? id,
    String? idTeacher,
    DateTime? day,
    String? subject,
    String? major,
    String? scheduleModelClass,
    String? roomLab,
    bool? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      idTeacher: idTeacher ?? this.idTeacher,
      day: day ?? this.day,
      subject: subject ?? this.subject,
      major: major ?? this.major,
      scheduleModelClass: scheduleModelClass ?? this.scheduleModelClass,
      roomLab: roomLab ?? this.roomLab,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

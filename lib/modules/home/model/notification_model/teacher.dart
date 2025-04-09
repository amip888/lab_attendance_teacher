import 'package:json_annotation/json_annotation.dart';

part 'teacher.g.dart';

@JsonSerializable()
class Teacher {
  String? name;
  @JsonKey(name: 'file_path')
  dynamic filePath;

  Teacher({this.name, this.filePath});

  @override
  String toString() => 'Teacher(name: $name, filePath: $filePath)';

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return _$TeacherFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TeacherToJson(this);

  Teacher copyWith({
    String? name,
    dynamic filePath,
  }) {
    return Teacher(
      name: name ?? this.name,
      filePath: filePath ?? this.filePath,
    );
  }
}

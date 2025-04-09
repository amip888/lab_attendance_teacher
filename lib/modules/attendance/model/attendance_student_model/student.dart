import 'package:json_annotation/json_annotation.dart';

part 'student.g.dart';

@JsonSerializable()
class Student {
  String? name;
  @JsonKey(name: 'class')
  String? studentClass;
  @JsonKey(name: 'file_path')
  dynamic filePath;

  Student({this.name, this.studentClass, this.filePath});

  @override
  String toString() {
    return 'Student(name: $name, studentClass: $studentClass, filePath: $filePath)';
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return _$StudentFromJson(json);
  }

  Map<String, dynamic> toJson() => _$StudentToJson(this);

  Student copyWith({
    String? name,
    String? studentClass,
    dynamic filePath,
  }) {
    return Student(
      name: name ?? this.name,
      studentClass: studentClass ?? this.studentClass,
      filePath: filePath ?? this.filePath,
    );
  }
}

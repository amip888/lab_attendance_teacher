// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
      name: json['name'] as String?,
      studentClass: json['class'] as String?,
      filePath: json['file_path'],
    );

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'name': instance.name,
      'class': instance.studentClass,
      'file_path': instance.filePath,
    };

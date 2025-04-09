// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
      id: json['id'] as String?,
      idUser: json['id_user'] as String?,
      name: json['name'] as String?,
      studentClass: json['class'] as String?,
      major: json['major'] as String?,
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      placeBirth: json['place_birth'] as String?,
      dateBirth: json['date_birth'] as String?,
      address: json['address'] as String?,
      filePath: json['file_path'],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'id': instance.id,
      'id_user': instance.idUser,
      'name': instance.name,
      'class': instance.studentClass,
      'major': instance.major,
      'phone': instance.phone,
      'gender': instance.gender,
      'place_birth': instance.placeBirth,
      'date_birth': instance.dateBirth,
      'address': instance.address,
      'file_path': instance.filePath,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

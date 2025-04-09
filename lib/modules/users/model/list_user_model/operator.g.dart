// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operator.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Operator _$OperatorFromJson(Map<String, dynamic> json) => Operator(
      id: json['id'] as String?,
      idUser: json['id_user'] as String?,
      name: json['name'] as String?,
      phone: json['phone'],
      gender: json['gender'] as String?,
      placeBirth: json['place_birth'],
      dateBirth: json['date_birth'],
      address: json['address'],
      filePath: json['file_path'],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$OperatorToJson(Operator instance) => <String, dynamic>{
      'id': instance.id,
      'id_user': instance.idUser,
      'name': instance.name,
      'phone': instance.phone,
      'gender': instance.gender,
      'place_birth': instance.placeBirth,
      'date_birth': instance.dateBirth,
      'address': instance.address,
      'file_path': instance.filePath,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

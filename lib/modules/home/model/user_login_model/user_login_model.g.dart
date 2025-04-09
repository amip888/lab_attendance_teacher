// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLoginModel _$UserLoginModelFromJson(Map<String, dynamic> json) =>
    UserLoginModel(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserLoginModelToJson(UserLoginModel instance) =>
    <String, dynamic>{
      'user': instance.user,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadFile _$UploadFileFromJson(Map<String, dynamic> json) => UploadFile(
      files: json['files'] == null
          ? null
          : Files.fromJson(json['files'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UploadFileToJson(UploadFile instance) =>
    <String, dynamic>{
      'files': instance.files,
    };

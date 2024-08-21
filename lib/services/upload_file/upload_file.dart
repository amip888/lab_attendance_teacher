import 'package:json_annotation/json_annotation.dart';

import 'files.dart';

part 'upload_file.g.dart';

@JsonSerializable()
class UploadFile {
  Files? files;

  UploadFile({this.files});

  @override
  String toString() => 'UploadFile(files: $files)';

  factory UploadFile.fromJson(Map<String, dynamic> json) {
    return _$UploadFileFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UploadFileToJson(this);

  UploadFile copyWith({
    Files? files,
  }) {
    return UploadFile(
      files: files ?? this.files,
    );
  }
}

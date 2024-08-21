import 'package:json_annotation/json_annotation.dart';

part 'files.g.dart';

@JsonSerializable()
class Files {
  String? filename;
  String? filePath;
  String? url;

  Files({this.filename, this.filePath, this.url});

  @override
  String toString() {
    return 'Files(filename: $filename, filePath: $filePath, url: $url)';
  }

  factory Files.fromJson(Map<String, dynamic> json) => _$FilesFromJson(json);

  Map<String, dynamic> toJson() => _$FilesToJson(this);

  Files copyWith({
    String? filename,
    String? filePath,
    String? url,
  }) {
    return Files(
      filename: filename ?? this.filename,
      filePath: filePath ?? this.filePath,
      url: url ?? this.url,
    );
  }
}

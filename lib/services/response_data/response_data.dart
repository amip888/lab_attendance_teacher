import 'package:json_annotation/json_annotation.dart';

part 'response_data.g.dart';

@JsonSerializable()
class ResponseData {
  String? message;
  dynamic data;

  ResponseData({this.message, this.data});

  @override
  String toString() => 'ResponseData(message: $message, data: $data)';

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return _$ResponseDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ResponseDataToJson(this);
}

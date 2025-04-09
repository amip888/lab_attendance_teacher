import 'package:json_annotation/json_annotation.dart';

part 'read_notification.g.dart';

@JsonSerializable()
class ReadNotification {
  String? id;
  @JsonKey(name: 'is_read')
  bool? isRead;

  ReadNotification({this.id, this.isRead});

  @override
  String toString() => 'ReadNotification(id: $id, isRead: $isRead)';

  factory ReadNotification.fromJson(Map<String, dynamic> json) {
    return _$ReadNotificationFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ReadNotificationToJson(this);

  ReadNotification copyWith({
    String? id,
    bool? isRead,
  }) {
    return ReadNotification(
      id: id ?? this.id,
      isRead: isRead ?? this.isRead,
    );
  }
}

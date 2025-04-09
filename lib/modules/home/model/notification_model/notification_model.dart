import 'package:json_annotation/json_annotation.dart';

import 'notification.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  List<Notification>? notification;

  NotificationModel({this.notification});

  @override
  String toString() => 'NotificationModel(notification: $notification)';

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return _$NotificationModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  NotificationModel copyWith({
    List<Notification>? notification,
  }) {
    return NotificationModel(
      notification: notification ?? this.notification,
    );
  }
}

import 'package:json_annotation/json_annotation.dart';

import 'read_notification.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String? id;
  @JsonKey(name: 'read_notification')
  ReadNotification? readNotification;

  User({this.id, this.readNotification});

  @override
  String toString() => 'User(id: $id, readNotification: $readNotification)';

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    ReadNotification? readNotification,
  }) {
    return User(
      id: id ?? this.id,
      readNotification: readNotification ?? this.readNotification,
    );
  }
}

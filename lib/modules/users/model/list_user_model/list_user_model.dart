import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'list_user_model.g.dart';

@JsonSerializable()
class ListUserModel {
  List<User>? users;

  ListUserModel({this.users});

  @override
  String toString() => 'ListUserModel(users: $users)';

  factory ListUserModel.fromJson(Map<String, dynamic> json) {
    return _$ListUserModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ListUserModelToJson(this);

  ListUserModel copyWith({
    List<User>? users,
  }) {
    return ListUserModel(
      users: users ?? this.users,
    );
  }
}

import 'package:json_annotation/json_annotation.dart';

part 'lab_room.g.dart';

@JsonSerializable()
class LabRoom {
  @JsonKey(name: 'lab_name')
  String? labName;

  LabRoom({this.labName});

  @override
  String toString() => 'LabRoom(labName: $labName)';

  factory LabRoom.fromJson(Map<String, dynamic> json) {
    return _$LabRoomFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LabRoomToJson(this);

  LabRoom copyWith({
    String? labName,
  }) {
    return LabRoom(
      labName: labName ?? this.labName,
    );
  }
}

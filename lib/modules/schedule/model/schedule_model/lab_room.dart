import 'package:json_annotation/json_annotation.dart';

part 'lab_room.g.dart';

@JsonSerializable()
class LabRoom {
  @JsonKey(name: 'lab_name')
  String? labName;
  @JsonKey(name: 'open_time')
  String? openTime;
  @JsonKey(name: 'close_time')
  String? closeTime;

  LabRoom({this.labName, this.openTime, this.closeTime});

  @override
  String toString() {
    return 'LabRoom(labName: $labName, openTime: $openTime, closeTime: $closeTime)';
  }

  factory LabRoom.fromJson(Map<String, dynamic> json) {
    return _$LabRoomFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LabRoomToJson(this);

  LabRoom copyWith({
    String? labName,
    String? openTime,
    String? closeTime,
  }) {
    return LabRoom(
      labName: labName ?? this.labName,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
    );
  }
}

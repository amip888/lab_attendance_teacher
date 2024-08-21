import 'package:json_annotation/json_annotation.dart';

import 'lab_room.dart';

part 'lab_room_model.g.dart';

@JsonSerializable()
class LabRoomModel {
  List<LabRoom>? labRoom;

  LabRoomModel({this.labRoom});

  @override
  String toString() => 'LabRoomModel(labRoom: $labRoom)';

  factory LabRoomModel.fromJson(Map<String, dynamic> json) {
    return _$LabRoomModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LabRoomModelToJson(this);

  LabRoomModel copyWith({
    List<LabRoom>? labRoom,
  }) {
    return LabRoomModel(
      labRoom: labRoom ?? this.labRoom,
    );
  }
}

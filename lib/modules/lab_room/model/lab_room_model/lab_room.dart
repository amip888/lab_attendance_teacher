import 'package:json_annotation/json_annotation.dart';

part 'lab_room.g.dart';

@JsonSerializable()
class LabRoom {
  String? id;
  @JsonKey(name: 'lab_name')
  String? labName;
  @JsonKey(name: 'open_time')
  String? openTime;
  @JsonKey(name: 'close_time')
  String? closeTime;
  @JsonKey(name: 'lab_photo')
  String? labPhoto;
  @JsonKey(name: 'qr_photo')
  String? qrPhoto;
  DateTime? createdAt;
  DateTime? updatedAt;

  LabRoom({
    this.id,
    this.labName,
    this.openTime,
    this.closeTime,
    this.labPhoto,
    this.qrPhoto,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'LabRoom(id: $id, labName: $labName, openTime: $openTime, closeTime: $closeTime, labPhoto: $labPhoto, qrPhoto: $qrPhoto, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory LabRoom.fromJson(Map<String, dynamic> json) {
    return _$LabRoomFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LabRoomToJson(this);

  LabRoom copyWith({
    String? id,
    String? labName,
    String? openTime,
    String? closeTime,
    String? labPhoto,
    String? qrPhoto,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LabRoom(
      id: id ?? this.id,
      labName: labName ?? this.labName,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      labPhoto: labPhoto ?? this.labPhoto,
      qrPhoto: qrPhoto ?? this.qrPhoto,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

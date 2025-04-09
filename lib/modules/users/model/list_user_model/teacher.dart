import 'package:json_annotation/json_annotation.dart';

part 'teacher.g.dart';

@JsonSerializable()
class Teacher {
  String? id;
  @JsonKey(name: 'id_user')
  String? idUser;
  String? name;
  String? major;
  String? phone;
  String? gender;
  @JsonKey(name: 'place_birth')
  String? placeBirth;
  @JsonKey(name: 'date_birth')
  String? dateBirth;
  String? address;
  @JsonKey(name: 'file_path')
  String? filePath;
  DateTime? createdAt;
  DateTime? updatedAt;

  Teacher({
    this.id,
    this.idUser,
    this.name,
    this.major,
    this.phone,
    this.gender,
    this.placeBirth,
    this.dateBirth,
    this.address,
    this.filePath,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'Teacher(id: $id, idUser: $idUser, name: $name, major: $major, phone: $phone, gender: $gender, placeBirth: $placeBirth, dateBirth: $dateBirth, address: $address, filePath: $filePath, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return _$TeacherFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TeacherToJson(this);

  Teacher copyWith({
    String? id,
    String? idUser,
    String? name,
    String? major,
    String? phone,
    String? gender,
    String? placeBirth,
    String? dateBirth,
    String? address,
    String? filePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Teacher(
      id: id ?? this.id,
      idUser: idUser ?? this.idUser,
      name: name ?? this.name,
      major: major ?? this.major,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      placeBirth: placeBirth ?? this.placeBirth,
      dateBirth: dateBirth ?? this.dateBirth,
      address: address ?? this.address,
      filePath: filePath ?? this.filePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

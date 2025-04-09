import 'package:json_annotation/json_annotation.dart';

part 'student.g.dart';

@JsonSerializable()
class Student {
  String? id;
  @JsonKey(name: 'id_user')
  String? idUser;
  String? name;
  @JsonKey(name: 'class')
  String? studentClass;
  String? major;
  String? phone;
  String? gender;
  @JsonKey(name: 'place_birth')
  String? placeBirth;
  @JsonKey(name: 'date_birth')
  String? dateBirth;
  String? address;
  @JsonKey(name: 'file_path')
  dynamic filePath;
  DateTime? createdAt;
  DateTime? updatedAt;

  Student({
    this.id,
    this.idUser,
    this.name,
    this.studentClass,
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
    return 'Student(id: $id, idUser: $idUser, name: $name, studentClass: $studentClass, major: $major, phone: $phone, gender: $gender, placeBirth: $placeBirth, dateBirth: $dateBirth, address: $address, filePath: $filePath, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return _$StudentFromJson(json);
  }

  Map<String, dynamic> toJson() => _$StudentToJson(this);

  Student copyWith({
    String? id,
    String? idUser,
    String? name,
    String? studentClass,
    String? major,
    String? phone,
    String? gender,
    String? placeBirth,
    String? dateBirth,
    String? address,
    dynamic filePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      idUser: idUser ?? this.idUser,
      name: name ?? this.name,
      studentClass: studentClass ?? this.studentClass,
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

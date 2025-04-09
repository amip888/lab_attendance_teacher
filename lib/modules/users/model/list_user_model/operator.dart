import 'package:json_annotation/json_annotation.dart';

part 'operator.g.dart';

@JsonSerializable()
class Operator {
  String? id;
  @JsonKey(name: 'id_user')
  String? idUser;
  String? name;
  dynamic phone;
  String? gender;
  @JsonKey(name: 'place_birth')
  dynamic placeBirth;
  @JsonKey(name: 'date_birth')
  dynamic dateBirth;
  dynamic address;
  @JsonKey(name: 'file_path')
  dynamic filePath;
  DateTime? createdAt;
  DateTime? updatedAt;

  Operator({
    this.id,
    this.idUser,
    this.name,
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
    return 'Operator(id: $id, idUser: $idUser, name: $name, phone: $phone, gender: $gender, placeBirth: $placeBirth, dateBirth: $dateBirth, address: $address, filePath: $filePath, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory Operator.fromJson(Map<String, dynamic> json) {
    return _$OperatorFromJson(json);
  }

  Map<String, dynamic> toJson() => _$OperatorToJson(this);

  Operator copyWith({
    String? id,
    String? idUser,
    String? name,
    dynamic phone,
    String? gender,
    dynamic placeBirth,
    dynamic dateBirth,
    dynamic address,
    dynamic filePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Operator(
      id: id ?? this.id,
      idUser: idUser ?? this.idUser,
      name: name ?? this.name,
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

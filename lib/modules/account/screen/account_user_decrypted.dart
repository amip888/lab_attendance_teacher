class UserAccountEncryptDecrypt {
  String? email;
  String? role;
  String? id;
  String? idUser;
  String? name;
  String? major;
  String? phone;
  String? gender;
  String? placeBirth;
  String? dateBirth;
  String? address;
  String? filePath;

  UserAccountEncryptDecrypt(
      {this.email,
      this.role,
      this.id,
      this.idUser,
      this.name,
      this.major,
      this.phone,
      this.gender,
      this.placeBirth,
      this.dateBirth,
      this.address,
      this.filePath});

  Map<String, dynamic> toJson() => {
        'email': email,
        'role': role,
        'id': id,
        'id_user': idUser,
        'name': name,
        'major': major,
        'phone': phone,
        'gender': gender,
        'place_birth': placeBirth,
        'date_birth': dateBirth,
        'address': address,
        'file_path': filePath
      };

  factory UserAccountEncryptDecrypt.fromJson(Map<String, dynamic> json) {
    return UserAccountEncryptDecrypt(
        email: json['email'],
        role: json['role'],
        id: json['id'],
        idUser: json['id_user'],
        name: json['name'],
        major: json['major'],
        phone: json['phone'],
        gender: json['gender'],
        placeBirth: json['place_birth'],
        dateBirth: json['date_birth'],
        address: json['address'],
        filePath: json['file_path']);
  }
}

class Register {
  String? idUser;
  String nama;
  String email;
  DateTime tanggalLahir;
  String jenisKelamin;
  String noTelepon;
  dynamic alamat;
  String? role;
  dynamic idLayanan;
  dynamic idTanggungan;
  DateTime? createdAt;
  DateTime? updatedAt;

  Register({
    this.idUser,
    required this.nama,
    required this.email,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.noTelepon,
    this.alamat,
    this.role,
    this.idLayanan,
    this.idTanggungan,
    this.createdAt,
    this.updatedAt,
  });

  factory Register.fromJson(Map<String, dynamic> json) => Register(
        idUser: json["id_user"],
        nama: json["nama"],
        email: json["email"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        jenisKelamin: json["jenis_kelamin"],
        noTelepon: json["no_telepon"],
        alamat: json["alamat"],
        role: json["role"],
        idLayanan: json["id_layanan"],
        idTanggungan: json["id_tanggungan"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "nama": nama,
        "email": email,
        "tanggal_lahir": tanggalLahir.toIso8601String(),
        "jenis_kelamin": jenisKelamin,
        "no_telepon": noTelepon,
        "alamat": alamat,
        "role": role,
        "id_layanan": idLayanan,
        "id_tanggungan": idTanggungan,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

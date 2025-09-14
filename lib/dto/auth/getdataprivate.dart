class Getdataprivate {
  String? idUser;
  String? nama;
  String? email;
  String? role;
  DateTime? tanggalLahir;
  String? jenisKelamin;
  String? noTelepon;
  dynamic alamat;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic layanan;
  dynamic tanggungan;

  Getdataprivate({
    this.idUser,
    this.nama,
    this.email,
    this.role,
    this.tanggalLahir,
    this.jenisKelamin,
    this.noTelepon,
    this.alamat,
    this.createdAt,
    this.updatedAt,
    this.layanan,
    this.tanggungan,
  });

  factory Getdataprivate.fromJson(Map<String, dynamic> json) => Getdataprivate(
        idUser: json["id_user"],
        nama: json["nama"],
        email: json["email"],
        role: json["role"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        jenisKelamin: json["jenis_kelamin"],
        noTelepon: json["no_telepon"],
        alamat: json["alamat"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        layanan: json["layanan"],
        tanggungan: json["tanggungan"],
      );

  Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "nama": nama,
        "email": email,
        "role": role,
        "tanggal_lahir": tanggalLahir?.toIso8601String(),
        "jenis_kelamin": jenisKelamin,
        "no_telepon": noTelepon,
        "alamat": alamat,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "layanan": layanan,
        "tanggungan": tanggungan,
      };
}

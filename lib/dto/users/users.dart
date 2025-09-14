class Users {
  String? idUser;
  String nama;
  String email;
  DateTime tanggalLahir;
  String jenisKelamin;
  String noTelepon;
  dynamic alamat;
  dynamic idLayanan;
  dynamic idTanggungan;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic layanan;
  dynamic tanggungan;

  Users({
    this.idUser,
    required this.nama,
    required this.email,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.noTelepon,
    this.alamat,
    this.idLayanan,
    this.idTanggungan,
    this.createdAt,
    this.updatedAt,
    this.layanan,
    this.tanggungan,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        idUser: json["id_user"],
        nama: json["nama"],
        email: json["email"],
        tanggalLahir: _parseToLocal(json["tanggal_lahir"]),
        jenisKelamin: json["jenis_kelamin"],
        noTelepon: json["no_telepon"],
        alamat: json["alamat"],
        idLayanan: json["id_layanan"],
        idTanggungan: json["id_tanggungan"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        layanan: json["layanan"],
        tanggungan: json["tanggungan"],
      );

  static DateTime _parseToLocal(dynamic v) {
    final dt = DateTime.parse(v.toString());
    return dt.isUtc ? dt.toLocal() : dt;
  }

  static DateTime? _parseToLocalNullable(dynamic v) {
    if (v == null) return null;
    final dt = DateTime.parse(v.toString());
    return dt.isUtc ? dt.toLocal() : dt;
  }

  Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "nama": nama,
        "email": email,
        "tanggal_lahir": tanggalLahir.toIso8601String(),
        "jenis_kelamin": jenisKelamin,
        "no_telepon": noTelepon,
        "alamat": alamat,
        "id_layanan": idLayanan,
        "id_tanggungan": idTanggungan,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "layanan": layanan,
        "tanggungan": tanggungan,
      };
}

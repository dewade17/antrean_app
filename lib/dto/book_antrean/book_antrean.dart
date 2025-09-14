class BookAntrean {
  String idAntrean;
  String idUser;
  String idSlot;
  int noAntrean;
  String status;
  DateTime tanggalLahir;
  String namaPasien;
  String jenisKelamin;
  String telepon;
  String alamatUser;
  DateTime createdAt;

  BookAntrean({
    required this.idAntrean,
    required this.idUser,
    required this.idSlot,
    required this.noAntrean,
    required this.status,
    required this.tanggalLahir,
    required this.namaPasien,
    required this.jenisKelamin,
    required this.telepon,
    required this.alamatUser,
    required this.createdAt,
  });

  factory BookAntrean.fromJson(Map<String, dynamic> json) => BookAntrean(
        idAntrean: json["id_antrean"],
        idUser: json["id_user"],
        idSlot: json["id_slot"],
        noAntrean: json["no_antrean"],
        status: json["status"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
        namaPasien: json["nama_pasien"],
        jenisKelamin: json["jenis_kelamin"],
        telepon: json["telepon"],
        alamatUser: json["alamat_user"],
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id_antrean": idAntrean,
        "id_user": idUser,
        "id_slot": idSlot,
        "no_antrean": noAntrean,
        "status": status,
        "tanggal_lahir": tanggalLahir.toIso8601String(),
        "nama_pasien": namaPasien,
        "jenis_kelamin": jenisKelamin,
        "telepon": telepon,
        "alamat_user": alamatUser,
        "createdAt": createdAt.toIso8601String(),
      };
}

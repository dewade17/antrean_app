class GetBooking {
  String idAntrean;
  String status;
  Jadwal jadwal;
  Dokter dokter;
  Antrean antrean;
  Slot slot;
  Pasien pasien;
  DateTime createdAt;

  GetBooking({
    required this.idAntrean,
    required this.status,
    required this.jadwal,
    required this.dokter,
    required this.antrean,
    required this.slot,
    required this.pasien,
    required this.createdAt,
  });

  factory GetBooking.fromJson(Map<String, dynamic> json) => GetBooking(
        idAntrean: json["id_antrean"],
        status: json["status"],
        jadwal: Jadwal.fromJson(json["jadwal"]),
        dokter: Dokter.fromJson(json["dokter"]),
        antrean: Antrean.fromJson(json["antrean"]),
        slot: Slot.fromJson(json["slot"]),
        pasien: Pasien.fromJson(json["pasien"]),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id_antrean": idAntrean,
        "status": status,
        "jadwal": jadwal.toJson(),
        "dokter": dokter.toJson(),
        "antrean": antrean.toJson(),
        "slot": slot.toJson(),
        "pasien": pasien.toJson(),
        "createdAt": createdAt.toIso8601String(),
      };
}

class Antrean {
  int noAntreanAnda;
  int totalAntreanAktif;
  dynamic noAntreanSedangDilayani;

  Antrean({
    required this.noAntreanAnda,
    required this.totalAntreanAktif,
    required this.noAntreanSedangDilayani,
  });

  factory Antrean.fromJson(Map<String, dynamic> json) => Antrean(
        noAntreanAnda: json["no_antrean_anda"],
        totalAntreanAktif: json["total_antrean_aktif"],
        noAntreanSedangDilayani: json["no_antrean_sedang_dilayani"],
      );

  Map<String, dynamic> toJson() => {
        "no_antrean_anda": noAntreanAnda,
        "total_antrean_aktif": totalAntreanAktif,
        "no_antrean_sedang_dilayani": noAntreanSedangDilayani,
      };
}

class Dokter {
  String idDokter;
  String namaDokter;
  String spesialisasi;

  Dokter({
    required this.idDokter,
    required this.namaDokter,
    required this.spesialisasi,
  });

  factory Dokter.fromJson(Map<String, dynamic> json) => Dokter(
        idDokter: json["id_dokter"],
        namaDokter: json["nama_dokter"],
        spesialisasi: json["spesialisasi"],
      );

  Map<String, dynamic> toJson() => {
        "id_dokter": idDokter,
        "nama_dokter": namaDokter,
        "spesialisasi": spesialisasi,
      };
}

class Jadwal {
  DateTime tanggalIso;
  String tanggalLabel;
  String jamLabel;
  String statusWaktu;
  String notif;

  Jadwal({
    required this.tanggalIso,
    required this.tanggalLabel,
    required this.jamLabel,
    required this.statusWaktu,
    required this.notif,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) => Jadwal(
        tanggalIso: DateTime.parse(json["tanggal_iso"]),
        tanggalLabel: json["tanggal_label"],
        jamLabel: json["jam_label"],
        statusWaktu: json["status_waktu"],
        notif: json["notif"],
      );

  Map<String, dynamic> toJson() => {
        "tanggal_iso": tanggalIso.toIso8601String(),
        "tanggal_label": tanggalLabel,
        "jam_label": jamLabel,
        "status_waktu": statusWaktu,
        "notif": notif,
      };
}

class Pasien {
  String namaPasien;
  String jenisKelamin;
  String telepon;
  String alamatUser;
  DateTime tanggalLahir;

  Pasien({
    required this.namaPasien,
    required this.jenisKelamin,
    required this.telepon,
    required this.alamatUser,
    required this.tanggalLahir,
  });

  factory Pasien.fromJson(Map<String, dynamic> json) => Pasien(
        namaPasien: json["nama_pasien"],
        jenisKelamin: json["jenis_kelamin"],
        telepon: json["telepon"],
        alamatUser: json["alamat_user"],
        tanggalLahir: DateTime.parse(json["tanggal_lahir"]),
      );

  Map<String, dynamic> toJson() => {
        "nama_pasien": namaPasien,
        "jenis_kelamin": jenisKelamin,
        "telepon": telepon,
        "alamat_user": alamatUser,
        "tanggal_lahir": tanggalLahir.toIso8601String(),
      };
}

class Slot {
  String idSlot;
  DateTime tanggal;
  DateTime jamMulai;
  DateTime jamSelesai;

  Slot({
    required this.idSlot,
    required this.tanggal,
    required this.jamMulai,
    required this.jamSelesai,
  });

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        idSlot: json["id_slot"],
        tanggal: DateTime.parse(json["tanggal"]),
        jamMulai: DateTime.parse(json["jam_mulai"]),
        jamSelesai: DateTime.parse(json["jam_selesai"]),
      );

  Map<String, dynamic> toJson() => {
        "id_slot": idSlot,
        "tanggal": tanggal.toIso8601String(),
        "jam_mulai": jamMulai.toIso8601String(),
        "jam_selesai": jamSelesai.toIso8601String(),
      };
}

class Meta {
  int count;

  Meta({
    required this.count,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
      };
}

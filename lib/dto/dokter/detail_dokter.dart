class Detaildokter {
  String idDokter;
  String namaDokter;
  String spesialisasi;
  dynamic fotoProfilDokter;
  bool isActive;

  Detaildokter({
    required this.idDokter,
    required this.namaDokter,
    required this.spesialisasi,
    required this.fotoProfilDokter,
    required this.isActive,
  });

  factory Detaildokter.fromJson(Map<String, dynamic> json) => Detaildokter(
        idDokter: json["id_dokter"],
        namaDokter: json["nama_dokter"],
        spesialisasi: json["spesialisasi"],
        fotoProfilDokter: json["foto_profil_dokter"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id_dokter": idDokter,
        "nama_dokter": namaDokter,
        "spesialisasi": spesialisasi,
        "foto_profil_dokter": fotoProfilDokter,
        "is_active": isActive,
      };
}

class FiltersEcho {
  String status;
  bool onlyAvailable;

  FiltersEcho({
    required this.status,
    required this.onlyAvailable,
  });

  factory FiltersEcho.fromJson(Map<String, dynamic> json) => FiltersEcho(
        status: json["status"],
        onlyAvailable: json["onlyAvailable"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "onlyAvailable": onlyAvailable,
      };
}

class Jadwal {
  String idJadwal;
  DateTime tanggal;
  DateTime tanggalStr;
  DateTime jamMulai;
  DateTime jamSelesai;
  String jamMulaiHhmm;
  String jamSelesaiHhmm;
  int jamMulaiSec;
  int jamSelesaiSec;
  int kapasitas;
  int terisi;
  int sisa;
  Slot slot;

  Jadwal({
    required this.idJadwal,
    required this.tanggal,
    required this.tanggalStr,
    required this.jamMulai,
    required this.jamSelesai,
    required this.jamMulaiHhmm,
    required this.jamSelesaiHhmm,
    required this.jamMulaiSec,
    required this.jamSelesaiSec,
    required this.kapasitas,
    required this.terisi,
    required this.sisa,
    required this.slot,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) => Jadwal(
        idJadwal: json["id_jadwal"],
        tanggal: DateTime.parse(json["tanggal"]),
        tanggalStr: DateTime.parse(json["tanggal_str"]),
        jamMulai: DateTime.parse(json["jam_mulai"]),
        jamSelesai: DateTime.parse(json["jam_selesai"]),
        jamMulaiHhmm: json["jam_mulai_hhmm"],
        jamSelesaiHhmm: json["jam_selesai_hhmm"],
        jamMulaiSec: json["jam_mulai_sec"],
        jamSelesaiSec: json["jam_selesai_sec"],
        kapasitas: json["kapasitas"],
        terisi: json["terisi"],
        sisa: json["sisa"],
        slot: Slot.fromJson(json["slot"]),
      );

  Map<String, dynamic> toJson() => {
        "id_jadwal": idJadwal,
        "tanggal": tanggal.toIso8601String(),
        "tanggal_str":
            "${tanggalStr.year.toString().padLeft(4, '0')}-${tanggalStr.month.toString().padLeft(2, '0')}-${tanggalStr.day.toString().padLeft(2, '0')}",
        "jam_mulai": jamMulai.toIso8601String(),
        "jam_selesai": jamSelesai.toIso8601String(),
        "jam_mulai_hhmm": jamMulaiHhmm,
        "jam_selesai_hhmm": jamSelesaiHhmm,
        "jam_mulai_sec": jamMulaiSec,
        "jam_selesai_sec": jamSelesaiSec,
        "kapasitas": kapasitas,
        "terisi": terisi,
        "sisa": sisa,
        "slot": slot.toJson(),
      };
}

class Slot {
  String idSlot;
  int kapasitas;
  int terisi;
  int sisa;
  bool isActive;

  Slot({
    required this.idSlot,
    required this.kapasitas,
    required this.terisi,
    required this.sisa,
    required this.isActive,
  });

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        idSlot: json["id_slot"],
        kapasitas: json["kapasitas"],
        terisi: json["terisi"],
        sisa: json["sisa"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id_slot": idSlot,
        "kapasitas": kapasitas,
        "terisi": terisi,
        "sisa": sisa,
        "is_active": isActive,
      };
}

class Totals {
  int totalJadwal;

  Totals({
    required this.totalJadwal,
  });

  factory Totals.fromJson(Map<String, dynamic> json) => Totals(
        totalJadwal: json["total_jadwal"],
      );

  Map<String, dynamic> toJson() => {
        "total_jadwal": totalJadwal,
      };
}

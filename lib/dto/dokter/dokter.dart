class Dokter {
  String idDokter;
  String namaDokter;
  String spesialisasi;
  String fotoProfilDokter;
  bool isActive;
  int totalSlot;
  int totalKapasitas;
  int totalTerisi;
  int totalSisa;

  Dokter({
    required this.idDokter,
    required this.namaDokter,
    required this.spesialisasi,
    required this.fotoProfilDokter,
    required this.isActive,
    required this.totalSlot,
    required this.totalKapasitas,
    required this.totalTerisi,
    required this.totalSisa,
  });

  factory Dokter.fromJson(Map<String, dynamic> json) => Dokter(
        idDokter: json["id_dokter"],
        namaDokter: json["nama_dokter"],
        spesialisasi: json["spesialisasi"],
        fotoProfilDokter: json["foto_profil_dokter"],
        isActive: json["is_active"],
        totalSlot: json["total_slot"],
        totalKapasitas: json["total_kapasitas"],
        totalTerisi: json["total_terisi"],
        totalSisa: json["total_sisa"],
      );

  Map<String, dynamic> toJson() => {
        "id_dokter": idDokter,
        "nama_dokter": namaDokter,
        "spesialisasi": spesialisasi,
        "foto_profil_dokter": fotoProfilDokter,
        "is_active": isActive,
        "total_slot": totalSlot,
        "total_kapasitas": totalKapasitas,
        "total_terisi": totalTerisi,
        "total_sisa": totalSisa,
      };
}

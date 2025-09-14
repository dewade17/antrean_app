class Layanan {
  String idLayanan;
  String namaLayanan;
  bool isActive;
  dynamic deletedAt;
  dynamic alasanNonaktif;
  DateTime? createdAt;
  DateTime? updatedAt;

  Layanan({
    required this.idLayanan,
    required this.namaLayanan,
    required this.isActive,
    this.deletedAt,
    this.alasanNonaktif,
    this.createdAt,
    this.updatedAt,
    
  });

  factory Layanan.fromJson(Map<String, dynamic> json) => Layanan(
        idLayanan: json["id_layanan"],
        namaLayanan: json["nama_layanan"],
        isActive: json["is_active"],
        deletedAt: json["deletedAt"],
        alasanNonaktif: json["alasan_nonaktif"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id_layanan": idLayanan,
        "nama_layanan": namaLayanan,
        "is_active": isActive,
        "deletedAt": deletedAt,
        "alasan_nonaktif": alasanNonaktif,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

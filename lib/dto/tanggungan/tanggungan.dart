class Tanggungan {
  String idTanggungan;
  String namaTanggungan;
  bool isActive;
  dynamic deletedAt;
  dynamic alasanNonaktif;
  DateTime? createdAt;
  DateTime? updatedAt;

  Tanggungan({
    required this.idTanggungan,
    required this.namaTanggungan,
    required this.isActive,
    this.deletedAt,
    this.alasanNonaktif,
    this.createdAt,
    this.updatedAt,
  });

  factory Tanggungan.fromJson(Map<String, dynamic> json) => Tanggungan(
        idTanggungan: json["id_tanggungan"],
        namaTanggungan: json["nama_tanggungan"],
        isActive: json["is_active"],
        deletedAt: json["deletedAt"],
        alasanNonaktif: json["alasan_nonaktif"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id_tanggungan": idTanggungan,
        "nama_tanggungan": namaTanggungan,
        "is_active": isActive,
        "deletedAt": deletedAt,
        "alasan_nonaktif": alasanNonaktif,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

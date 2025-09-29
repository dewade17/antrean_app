import 'dart:convert';

Beritakesehatan beritakesehatanFromJson(String str) =>
    Beritakesehatan.fromJson(json.decode(str));

String _sanitizeHtml(String input) {
  final lineBreakNormalized =
      input.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
  final withoutTags =
      lineBreakNormalized.replaceAll(RegExp(r'<[^>]*>', dotAll: true), '');
  return withoutTags.trim();
}

String beritakesehatanToJson(Beritakesehatan data) =>
    json.encode(data.toJson());

class Beritakesehatan {
  List<Data> data;
  Meta meta;

  Beritakesehatan({
    required this.data,
    required this.meta,
  });

  factory Beritakesehatan.fromJson(Map<String, dynamic> json) =>
      Beritakesehatan(
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class Data {
  String idBerita;
  String judul;
  String deskripsi;
  DateTime tanggalPenerbitan;
  String fotoUrl;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.idBerita,
    required this.judul,
    required this.deskripsi,
    required this.tanggalPenerbitan,
    required this.fotoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        idBerita: json["id_berita"],
        judul: json["judul"],
        deskripsi: _sanitizeHtml(json["deskripsi"] ?? ''),
        tanggalPenerbitan: DateTime.parse(json["tanggal_penerbitan"]),
        fotoUrl: json["foto_url"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id_berita": idBerita,
        "judul": judul,
        "deskripsi": deskripsi,
        "tanggal_penerbitan": tanggalPenerbitan.toIso8601String(),
        "foto_url": fotoUrl,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class Meta {
  int page;
  int pageSize;
  int total;
  int pages;

  Meta({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.pages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        page: json["page"],
        pageSize: json["pageSize"],
        total: json["total"],
        pages: json["pages"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "pageSize": pageSize,
        "total": total,
        "pages": pages,
      };
}

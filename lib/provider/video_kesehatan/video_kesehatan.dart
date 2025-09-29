import 'dart:convert';

Videokesehatan videokesehatanFromJson(String str) =>
    Videokesehatan.fromJson(json.decode(str));

String videokesehatanToJson(Videokesehatan data) => json.encode(data.toJson());

class Videokesehatan {
  List<Data> data;
  Meta meta;

  Videokesehatan({
    required this.data,
    required this.meta,
  });

  factory Videokesehatan.fromJson(Map<String, dynamic> json) => Videokesehatan(
        data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
        meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
      };
}

class Data {
  String idVideo;
  String judul;
  String deskripsi;
  DateTime tanggalPenerbitan;
  String videoUrl;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.idVideo,
    required this.judul,
    required this.deskripsi,
    required this.tanggalPenerbitan,
    required this.videoUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        idVideo: json["id_video"],
        judul: json["judul"],
        deskripsi: json["deskripsi"],
        tanggalPenerbitan: DateTime.parse(json["tanggal_penerbitan"]),
        videoUrl: json["video_url"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id_video": idVideo,
        "judul": judul,
        "deskripsi": deskripsi,
        "tanggal_penerbitan": tanggalPenerbitan.toIso8601String(),
        "video_url": videoUrl,
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

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

  factory Videokesehatan.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final list = rawData is List
        ? rawData
            .whereType<Map<String, dynamic>>()
            .map((x) => Data.fromJson(x))
            .toList()
        : <Data>[];

    final rawMeta = json['meta'];
    final metaMap =
        rawMeta is Map<String, dynamic> ? rawMeta : <String, dynamic>{};

    return Videokesehatan(
      data: list,
      meta: Meta.fromJson(metaMap),
    );
  }
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

  factory Data.fromJson(Map<String, dynamic> json) {
    DateTime _parseDate(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is DateTime) return value;
      if (value is String && value.isNotEmpty) {
        final parsed = DateTime.tryParse(value);
        if (parsed != null) {
          return parsed.toLocal();
        }
      }
      return DateTime.now();
    }

    return Data(
      idVideo: json['id_video']?.toString() ?? '',
      judul: (json['judul'] as String?)?.trim() ?? '',
      deskripsi: (json['deskripsi'] as String?)?.trim() ?? '',
      tanggalPenerbitan: _parseDate(json['tanggal_penerbitan']),
      videoUrl: (json['video_url'] as String?)?.trim() ?? '',
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

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

  factory Meta.fromJson(Map<String, dynamic> json) {
    int parseInt(String key, int fallback) {
      final value = json[key];
      if (value is int) return value;
      if (value is double) return value.round();
      if (value is String) return int.tryParse(value) ?? fallback;
      return fallback;
    }

    return Meta(
      page: parseInt('page', 1),
      pageSize: parseInt('pageSize', 0),
      total: parseInt('total', 0),
      pages: parseInt('pages', 1),
    );
  }

  Map<String, dynamic> toJson() => {
        "page": page,
        "pageSize": pageSize,
        "total": total,
        "pages": pages,
      };
}

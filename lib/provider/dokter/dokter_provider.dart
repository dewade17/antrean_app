import 'package:flutter/material.dart';
import 'package:antrean_app/dto/dokter/dokter.dart';
import 'package:antrean_app/services/api_service.dart';
import 'package:antrean_app/constraints/endpoints.dart';

class DokterProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<Dokter> _items = [];
  List<Dokter> get items => _items;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  // simpan filter terakhir agar gampang refresh
  DateTime? _lastDate;
  String? _lastIdDokter;
  String _lastStatus = 'active'; // 'active' | 'all'

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  void _setError(String? e) {
    _error = e;
    notifyListeners();
  }

  /// Helper format YYYY-MM-DD dari tanggal lokal (tanpa konversi zona)
  String _formatYMD(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String _search = '';
  void setSearch(String v) {
    _search = v;
    notifyListeners();
  }

  List<Dokter> get filteredItems {
    if (_search.trim().isEmpty) return _items;
    final q = _search.toLowerCase();
    return _items
        .where((d) =>
            d.namaDokter.toLowerCase().contains(q) ||
            d.spesialisasi.toLowerCase().contains(q))
        .toList();
  }

  /// GET /dokter/slot-today?date=YYYY-MM-DD&id_dokter=...&status=active|all
  Future<List<Dokter>> fetch({
    DateTime? date,
    String? idDokter,
    String status = 'active',
  }) async {
    _setError(null);
    _setLoading(true);

    try {
      final params = <String>[];
      if (date != null) params.add('date=${_formatYMD(date)}');
      if ((idDokter ?? '').isNotEmpty)
        params.add('id_dokter=${Uri.encodeComponent(idDokter!)}');
      if ((status).isNotEmpty) params.add('status=${status.toLowerCase()}');

      final endpoint = params.isEmpty
          ? Endpoints.getDokter
          : '${Endpoints.getDokter}?${params.join('&')}';

      // Penting: endpoint ini mengembalikan List
      final list = await _api.fetchListPrivate(endpoint);

      // Map -> Dokter, pastikan foto_profil_dokter tidak null (model kamu String)
      _items = list.whereType<Map<String, dynamic>>().map<Dokter>((e) {
        final m = Map<String, dynamic>.from(e);
        m['foto_profil_dokter'] = m['foto_profil_dokter'] ?? '';
        return Dokter.fromJson(m);
      }).toList();

      // simpan filter terakhir
      _lastDate = date;
      _lastIdDokter = idDokter;
      _lastStatus = status.toLowerCase();

      notifyListeners();
      return _items;
    } catch (e) {
      _items = [];
      _setError(e.toString());
      return _items;
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh dengan filter terakhir yang dipakai
  Future<List<Dokter>> refresh() => fetch(
        date: _lastDate,
        idDokter: _lastIdDokter,
        status: _lastStatus,
      );

  /// Cari dokter di cache saat ini
  Dokter? findById(String id) {
    try {
      return _items.firstWhere((d) => d.idDokter == id);
    } catch (_) {
      return null;
    }
  }

  /// Total sisa slot semua dokter (utility opsional)
  int get totalSisaSemuaDokter =>
      _items.fold<int>(0, (sum, d) => sum + (d.totalSisa));

  /// Bersihkan state
  void clear() {
    _items = [];
    _error = null;
    _lastDate = null;
    _lastIdDokter = null;
    _lastStatus = 'active';
    notifyListeners();
  }
}

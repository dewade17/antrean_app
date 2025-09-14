// lib/provider/dokter/detail_provder.dart
import 'package:flutter/material.dart';
import 'package:antrean_app/services/api_service.dart';
import 'package:antrean_app/constraints/endpoints.dart';
import 'package:antrean_app/dto/dokter/detail_dokter.dart';

/// Provider untuk detail dokter + jadwal periodik.
/// Kini memiliki helper untuk menentukan ketersediaan slot/hari.
class DetailDokterProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  // ===== State data =====
  Detaildokter? _dokter;
  FiltersEcho? _filters;
  List<Jadwal> _jadwal = [];
  Totals? _totals;

  Detaildokter? get dokter => _dokter;
  FiltersEcho? get filters => _filters;
  List<Jadwal> get jadwal => _jadwal;
  Totals? get totals => _totals;

  // ===== UI state =====
  bool _loading = false;
  String? _error;
  bool get loading => _loading;
  String? get error => _error;

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  void _setError(String? e) {
    _error = e;
    notifyListeners();
  }

  // ===== Param terakhir (untuk refresh) =====
  String? _lastId;
  DateTime? _lastStart;
  DateTime? _lastEnd;
  String? _lastTime;
  String? _lastTimeStart;
  String? _lastTimeEnd;
  String _lastStatus = 'all';
  bool _lastOnlyAvailable = false;

  // ===== Helpers tanggal =====
  String _fmtYMD(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '$y-$m-$dd';
  }

  DateTime _dateOnlyLocal(DateTime d) {
    final dl = d.toLocal();
    return DateTime(dl.year, dl.month, dl.day);
  }

  // ======= Availability logic =======
  /// Sebuah slot dianggap tersedia jika:
  /// - slot.isActive == true
  /// - sisa > 0
  bool isSlotAvailable(Jadwal j) {
    try {
      return (j.slot.isActive == true) && (j.sisa > 0);
    } catch (_) {
      return false;
    }
  }

  /// Semua slot pada tanggal tertentu (local date).
  List<Jadwal> slotsOfDate(DateTime date) {
    final key = _dateOnlyLocal(date);
    final list = _jadwal.where((j) => _dateOnlyLocal(j.tanggal) == key).toList()
      ..sort((a, b) => a.jamMulaiSec.compareTo(b.jamMulaiSec));
    return list;
  }

  /// Hanya slot yang tersedia pada tanggal tertentu.
  List<Jadwal> availableSlotsOfDate(DateTime date) {
    final all = slotsOfDate(date);
    return all.where(isSlotAvailable).toList();
  }

  /// Apakah tanggal tersebut memiliki minimal satu slot tersedia?
  bool isDateAvailable(DateTime date) => availableSlotsOfDate(date).isNotEmpty;

  /// Set semua tanggal (local date) yang memiliki JADWAL apapun (available atau tidak).
  Set<DateTime> get daysWithAnyJadwal => {
        for (final j in _jadwal) _dateOnlyLocal(j.tanggal),
      };

  /// Set semua tanggal (local date) yang memiliki minimal satu slot tersedia.
  Set<DateTime> get daysWithAvailable => {
        for (final j in _jadwal)
          if (isSlotAvailable(j)) _dateOnlyLocal(j.tanggal),
      };

  /// Set tanggal yang punya jadwal tapi tidak ada slot tersedia (fully booked/non-active).
  Set<DateTime> get daysWithoutAvailable {
    final any = daysWithAnyJadwal;
    final avail = daysWithAvailable;
    return any.difference(avail);
  }

  /// Total sisa kursi dari semua slot yang tersedia pada tanggal tertentu.
  int totalSisaOfDate(DateTime date) {
    final list = availableSlotsOfDate(date);
    return list.fold<int>(0, (sum, j) => sum + (j.sisa));
  }

  // ======= Fetch =======
  /// Fetch detail dokter + jadwal periodik, dengan dukungan filter waktu.
  /// Endpoint: GET /dokter/{id}/date-periodic
  Future<bool> fetch({
    required String idDokter,
    DateTime? start,
    DateTime? end,
    String? time,
    String? timeStart,
    String? timeEnd,
    String status = 'all',
    bool onlyAvailable = false,
  }) async {
    _setError(null);
    _setLoading(true);

    try {
      final params = <String>[];
      if (start != null) params.add('start=${_fmtYMD(start)}');
      if (end != null) params.add('end=${_fmtYMD(end)}');

      final ts = (time ?? '').trim();
      final t1 = (timeStart ?? '').trim();
      final t2 = (timeEnd ?? '').trim();
      if (ts.isNotEmpty) {
        params.add('time=${Uri.encodeComponent(ts)}');
      } else if (t1.isNotEmpty && t2.isNotEmpty) {
        params.add('time_start=${Uri.encodeComponent(t1)}');
        params.add('time_end=${Uri.encodeComponent(t2)}');
      }

      if (status.isNotEmpty) params.add('status=${status.toLowerCase()}');
      if (onlyAvailable) params.add('onlyAvailable=1');

      final base = Endpoints.getDetailDokter(idDokter);
      final endpoint = params.isEmpty ? base : '$base?${params.join('&')}';

      final res = await _api.fetchDataPrivate(endpoint);
      if (res is! Map<String, dynamic>) {
        throw Exception('Bentuk respons tidak sesuai (expected object).');
      }

      // --- Extract ---
      final dJson = res['dokter'] as Map<String, dynamic>?;
      final fJson = res['filters_echo'] as Map<String, dynamic>?;
      final jList = (res['jadwal'] as List<dynamic>? ?? const []);
      final tJson = res['totals'] as Map<String, dynamic>?;

      if (dJson == null) {
        throw Exception('Data dokter tidak ditemukan pada respons.');
      }

      // --- Map dokter & filters ---
      _dokter = Detaildokter.fromJson(dJson);
      if (fJson != null) {
        _filters = FiltersEcho.fromJson({
          'status': (fJson['status'] ?? 'all').toString(),
          'onlyAvailable': (fJson['onlyAvailable'] ?? false) == true,
        });
      } else {
        _filters = null;
      }

      // --- Map jadwal (normalize jika slot null) ---
      _jadwal = jList.whereType<Map<String, dynamic>>().map((raw) {
        final e = Map<String, dynamic>.from(raw);

        // Pastikan field kapasitas/terisi/sisa ada (default 0)
        e['kapasitas'] = e['kapasitas'] ?? (e['slot']?['kapasitas'] ?? 0);
        e['terisi'] = e['terisi'] ?? (e['slot']?['terisi'] ?? 0);
        e['sisa'] = e['sisa'] ?? ((e['kapasitas'] ?? 0) - (e['terisi'] ?? 0));

        // Jika slot null, buat slot dummy non-aktif
        e['slot'] = e['slot'] ??
            {
              'id_slot': '',
              'kapasitas': e['kapasitas'] ?? 0,
              'terisi': e['terisi'] ?? 0,
              'sisa': e['sisa'] ?? 0,
              'is_active': false,
            };

        return Jadwal.fromJson(e);
      }).toList();

      // --- Totals ---
      _totals = tJson != null ? Totals.fromJson(tJson) : null;

      // Simpan parameter terakhir
      _lastId = idDokter;
      _lastStart = start;
      _lastEnd = end;
      _lastTime = ts.isNotEmpty ? ts : null;
      _lastTimeStart = (ts.isEmpty && t1.isNotEmpty) ? t1 : null;
      _lastTimeEnd = (ts.isEmpty && t2.isNotEmpty) ? t2 : null;
      _lastStatus = status.toLowerCase();
      _lastOnlyAvailable = onlyAvailable;

      notifyListeners();
      return true;
    } catch (e) {
      _dokter = null;
      _filters = null;
      _jadwal = [];
      _totals = null;
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh dengan parameter terakhir.
  Future<bool> refresh() async {
    final id = _lastId;
    if (id == null || id.isEmpty) return false;
    return fetch(
      idDokter: id,
      start: _lastStart,
      end: _lastEnd,
      time: _lastTime,
      timeStart: _lastTimeStart,
      timeEnd: _lastTimeEnd,
      status: _lastStatus,
      onlyAvailable: _lastOnlyAvailable,
    );
  }

  void clear() {
    _dokter = null;
    _filters = null;
    _jadwal = [];
    _totals = null;

    _error = null;
    _loading = false;

    _lastId = null;
    _lastStart = null;
    _lastEnd = null;
    _lastTime = null;
    _lastTimeStart = null;
    _lastTimeEnd = null;
    _lastStatus = 'all';
    _lastOnlyAvailable = false;

    notifyListeners();
  }
}

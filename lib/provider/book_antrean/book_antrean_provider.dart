// lib/provider/antrean/book_antrean_provider.dart
import 'package:antrean_app/dto/book_antrean/book_antrean.dart';
import 'package:flutter/material.dart';
import 'package:antrean_app/services/api_service.dart';
import 'package:antrean_app/constraints/endpoints.dart';

class BookAntreanProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  bool _loading = false;
  bool get loading => _loading;

  bool _saving = false;
  bool get saving => _saving;

  String? _error;
  String? get error => _error;

  BookAntrean? _lastBooking;
  BookAntrean? get lastBooking => _lastBooking;

  Map<String, dynamic>? _lastSummary;
  Map<String, dynamic>? get lastSummary => _lastSummary;

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  void _setSaving(bool v) {
    _saving = v;
    notifyListeners();
  }

  void _setError(String? e) {
    _error = e;
    notifyListeners();
  }

  /// Format YYYY-MM-DD dari tanggal lokal (bukan ISO8601)
  String _fmtYMD(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return '$y-$m-$dd';
  }

  /// POST /book-antrean
  /// - Server ambil id_user dari JWT; JANGAN kirim id_user dari client.
  Future<BookAntrean?> createBooking({
    required DateTime tanggalLahir,
    required String namaPasien,
    required String jenisKelamin,
    required String telepon,
    required String alamatUser,
    required String idDokter,
    required String idLayanan,
    String? idTanggungan,
    required String idSlot,
  }) async {
    _setError(null);
    _setSaving(true);
    try {
      final payload = <String, dynamic>{
        'tanggal_lahir': _fmtYMD(tanggalLahir),
        'nama_pasien': namaPasien.trim(),
        'jenis_kelamin': jenisKelamin.trim(),
        'telepon': telepon.trim(),
        'alamat_user': alamatUser.trim(),
        'id_dokter': idDokter,
        'id_layanan': idLayanan,
        if (idTanggungan != null) 'id_tanggungan': idTanggungan,
        'id_slot': idSlot,
      };

      final res = await _api.postDataPrivate(Endpoints.bookAntrean, payload);
      // Response 201: objek antrean yang dibuat
      final booking = BookAntrean.fromJson(
          Map<String, dynamic>.from(res as Map<String, dynamic>));
      _lastBooking = booking;
      notifyListeners();
      return booking;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setSaving(false);
    }
  }

  /// GET /book-antrean?id_slot=...
  /// Ringkasan antrean untuk slot tertentu (berdasarkan user dari JWT).
  ///
  /// Contoh response:
  /// {
  ///   dokter: {...}, slot: {...},
  ///   no_antrean_sedang_dilayani: number|null,
  ///   total_antrean: number,
  ///   no_antrean_anda: number|null
  /// }
  Future<Map<String, dynamic>?> getSummaryBySlot(String idSlot) async {
    _setError(null);
    _setLoading(true);
    try {
      final endpoint =
          '${Endpoints.bookAntrean}?id_slot=${Uri.encodeComponent(idSlot)}';
      final res = await _api.fetchDataPrivate(endpoint);
      // simpan apa adanya (Map)
      _lastSummary = Map<String, dynamic>.from(res);
      notifyListeners();
      return _lastSummary;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// POST /book-antrean/{id}  → batalkan antrean (status MENUNGGU saja)
  Future<bool> cancelBooking(String idAntrean) async {
    _setError(null);
    _setSaving(true);
    try {
      final res = await _api.postDataPrivate(
        '${Endpoints.bookAntrean}$idAntrean',
        const <String, dynamic>{}, // tanpa body
      );
      // API mengembalikan { ok: true }
      final ok = (res is Map<String, dynamic>) && (res['ok'] == true);
      return ok;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setSaving(false);
    }
  }

  /// Utility
  void clear() {
    _error = null;
    _loading = false;
    _saving = false;
    _lastBooking = null;
    _lastSummary = null;
    notifyListeners();
  }
}

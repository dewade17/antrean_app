// lib/provider/antrean/get_booking_provider.dart
import 'package:flutter/material.dart';
import 'package:antrean_app/services/api_service.dart';
import 'package:antrean_app/constraints/endpoints.dart';
import 'package:antrean_app/dto/book_antrean/get_booking.dart';

/// Provider untuk mengambil daftar booking antrean milik user yang sedang login.
/// Endpoint: GET /book-antrean?status=active|all&limit=20&id_slot=...
class GetBookingProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  // ===== State data =====
  List<GetBooking> _items = [];
  List<GetBooking> get items => _items;

  int _metaCount = 0;
  int get metaCount => _metaCount;

  // ===== UI state =====
  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  // ===== Filter terakhir (untuk refresh) =====
  String _lastStatus = 'active'; // 'active' | 'all'
  int _lastLimit = 20;
  String? _lastIdSlot;

  // ===== Setters (opsional dipakai dari UI) =====
  void setStatus(String v) {
    _lastStatus = (v.isEmpty ? 'active' : v.toLowerCase());
    notifyListeners();
  }

  void setLimit(int v) {
    _lastLimit = (v <= 0) ? 20 : (v > 100 ? 100 : v);
    notifyListeners();
  }

  void setIdSlot(String? v) {
    _lastIdSlot = (v == null || v.trim().isEmpty) ? null : v.trim();
    notifyListeners();
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  void _setError(String? e) {
    _error = e;
    notifyListeners();
  }

  /// Fetch data booking.
  ///
  /// - [status]: 'active' (default) hanya MENUNGGU + DIPROSES, atau 'all'
  /// - [limit]: default 20 (1..100)
  /// - [idSlot]: opsional, filter ke 1 slot
  Future<List<GetBooking>> fetch({
    String? status,
    int? limit,
    String? idSlot,
  }) async {
    _setError(null);
    _setLoading(true);

    final useStatus = (status ?? _lastStatus).toLowerCase();
    final useLimit = (() {
      final l = limit ?? _lastLimit;
      if (l <= 0) return 20;
      if (l > 100) return 100;
      return l;
    })();
    final useIdSlot = (idSlot ?? _lastIdSlot);

    try {
      final params = <String>[
        'status=$useStatus',
        'limit=$useLimit',
      ];
      if (useIdSlot != null && useIdSlot.isNotEmpty) {
        params.add('id_slot=${Uri.encodeComponent(useIdSlot)}');
      }

      final endpoint = params.isEmpty
          ? Endpoints.getAntrean
          : '${Endpoints.getAntrean}?${params.join('&')}';

      // Top-level response adalah OBJECT => gunakan fetchDataPrivate
      final res = await _api.fetchDataPrivate(endpoint);
      if (res is! Map<String, dynamic>) {
        throw Exception('Bentuk respons tidak sesuai (expected object).');
      }

      final list = (res['bookings'] as List<dynamic>? ?? const []);
      _items = list
          .whereType<Map<String, dynamic>>()
          .map((e) => GetBooking.fromJson(e))
          .toList();

      _metaCount = (res['meta'] is Map<String, dynamic>)
          ? (res['meta']['count'] ?? _items.length) as int
          : _items.length;

      // simpan filter terakhir
      _lastStatus = useStatus;
      _lastLimit = useLimit;
      _lastIdSlot = useIdSlot;

      notifyListeners();
      return _items;
    } catch (e) {
      _items = [];
      _metaCount = 0;
      _setError(e.toString());
      return _items;
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh dengan filter terakhir yang dipakai.
  Future<List<GetBooking>> refresh() => fetch(
        status: _lastStatus,
        limit: _lastLimit,
        idSlot: _lastIdSlot,
      );

  /// Cari booking by id (di cache saat ini).
  GetBooking? findById(String id) {
    try {
      return _items.firstWhere((b) => b.idAntrean == id);
    } catch (_) {
      return null;
    }
  }

  /// Bersihkan state.
  void clear() {
    _items = [];
    _metaCount = 0;
    _error = null;
    _loading = false;

    _lastStatus = 'active';
    _lastLimit = 20;
    _lastIdSlot = null;

    notifyListeners();
  }
}

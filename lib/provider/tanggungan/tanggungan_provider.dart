// lib/providers/tanggungan_provider.dart
import 'package:flutter/material.dart';
import 'package:antrean_app/dto/tanggungan/tanggungan.dart';
import 'package:antrean_app/services/api_service.dart';
import 'package:antrean_app/constraints/endpoints.dart';

class TanggunganProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<Tanggungan> _items = [];
  List<Tanggungan> get items => _items;

  // Optional: simpan jumlah relasi users jika withCount=true
  final Map<String, int> _usersCount = {};
  Map<String, int> get usersCount => Map.unmodifiable(_usersCount);

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  // Filter terakhir
  String _query = '';
  String _status = 'active'; // active | inactive | all
  bool _withCount = false;

  String get query => _query;
  String get status => _status;
  bool get withCount => _withCount;

  void setQuery(String q) {
    _query = q;
    notifyListeners();
  }

  void setStatus(String s) {
    _status = s;
    notifyListeners();
  }

  void setWithCount(bool v) {
    _withCount = v;
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

  /// GET /tanggungan?q=...&status=active|inactive|all&withCount=true|false
  Future<List<Tanggungan>> fetch(
      {String? q, String? status, bool? withCount}) async {
    _setError(null);
    _setLoading(true);

    final useQ = (q ?? _query).trim();
    final useStatus = (status ?? _status).trim().toLowerCase();
    final useWithCount = withCount ?? _withCount;

    try {
      final params = <String>[];
      if (useQ.isNotEmpty) params.add('q=${Uri.encodeComponent(useQ)}');
      if (useStatus.isNotEmpty) params.add('status=$useStatus');
      if (useWithCount) params.add('withCount=true');

      final endpoint = params.isEmpty
          ? Endpoints.getTanggungan
          : '${Endpoints.getTanggungan}?${params.join('&')}';

      // ⬇️ Penting: gunakan fetchListPrivate karena respons adalah List
      final list = await _api.fetchListPrivate(endpoint);

      _items = [];
      _usersCount.clear();

      for (final e in list) {
        if (e is! Map<String, dynamic>) continue;
        _items.add(Tanggungan.fromJson(e));

        if (useWithCount) {
          final cnt = (e['_count'] is Map && e['_count']['users'] is int)
              ? e['_count']['users'] as int
              : 0;
          final id = e['id_tanggungan']?.toString();
          if (id != null) _usersCount[id] = cnt;
        }
      }

      // simpan filter terakhir
      _query = useQ;
      _status = useStatus;
      _withCount = useWithCount;

      notifyListeners();
      return _items;
    } catch (e) {
      _items = [];
      _usersCount.clear();
      _setError(e.toString());
      return _items;
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Tanggungan>> refresh() => fetch(
        q: _query,
        status: _status,
        withCount: _withCount,
      );

  Tanggungan? findById(String id) {
    try {
      return _items.firstWhere((e) => e.idTanggungan == id);
    } catch (_) {
      return null;
    }
  }

  void clear() {
    _items = [];
    _usersCount.clear();
    _error = null;
    notifyListeners();
  }
}

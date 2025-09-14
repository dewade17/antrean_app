// lib/providers/layanan_provider.dart
import 'package:flutter/material.dart';
import 'package:antrean_app/dto/layanan/layanan.dart';
import 'package:antrean_app/services/api_service.dart';
import 'package:antrean_app/constraints/endpoints.dart';

class LayananProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<Layanan> _items = [];
  List<Layanan> get items => _items;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  String _query = '';
  String _status = 'active'; // active | inactive | all

  String get query => _query;
  String get status => _status;

  void setQuery(String q) {
    _query = q;
    notifyListeners();
  }

  void setStatus(String s) {
    _status = s;
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

  /// GET /layanan?q=...&status=active|inactive|all
  Future<List<Layanan>> fetch({String? q, String? status}) async {
    _setError(null);
    _setLoading(true);

    final useQ = (q ?? _query).trim();
    final useStatus = (status ?? _status).trim().toLowerCase();

    try {
      final params = <String>[];
      if (useQ.isNotEmpty) params.add('q=${Uri.encodeComponent(useQ)}');
      if (useStatus.isNotEmpty) params.add('status=$useStatus');

      final endpoint = params.isEmpty
          ? Endpoints.getLayanan
          : '${Endpoints.getLayanan}?${params.join('&')}';

      // ⬇️ PENTING: pakai fetchListPrivate, karena respon adalah List
      final list = await _api.fetchListPrivate(endpoint);

      _items = list
          .whereType<Map<String, dynamic>>()
          .map((e) => Layanan.fromJson(e))
          .toList();

      _query = useQ;
      _status = useStatus;

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

  Future<List<Layanan>> refresh() => fetch(q: _query, status: _status);

  Layanan? findById(String id) {
    try {
      return _items.firstWhere((e) => e.idLayanan == id);
    } catch (_) {
      return null;
    }
  }

  void clear() {
    _items = [];
    _error = null;
    notifyListeners();
  }
}

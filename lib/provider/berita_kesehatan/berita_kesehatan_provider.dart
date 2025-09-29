import 'package:flutter/foundation.dart';

import 'package:antrean_app/constraints/endpoints.dart';
import 'package:antrean_app/dto/berita_kesehatan/berita_kesehatan.dart';
import 'package:antrean_app/services/api_service.dart';

class BeritaKesehatanProvider extends ChangeNotifier {
  BeritaKesehatanProvider({ApiService? api}) : _api = api ?? ApiService();

  final ApiService _api;

  List<Data> _items = <Data>[];
  Meta? _meta;
  bool _loading = false;
  String? _error;

  String _query = '';
  DateTime? _from;
  DateTime? _to;
  String _sort = 'recent';
  int _page = 1;
  int _pageSize = 20;

  List<Data> get items => _items;
  Meta? get meta => _meta;
  bool get loading => _loading;
  String? get error => _error;

  String get query => _query;
  DateTime? get from => _from;
  DateTime? get to => _to;
  String get sort => _sort;
  int get page => _page;
  int get pageSize => _pageSize;

  void _setLoading(bool value) {
    if (_loading != value) {
      _loading = value;
      notifyListeners();
    }
  }

  void _setError(String? value) {
    if (_error != value) {
      _error = value;
      notifyListeners();
    }
  }

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setDateRange({DateTime? from, DateTime? to}) {
    _from = from;
    _to = to;
    notifyListeners();
  }

  void setSort(String value) {
    _sort = value;
    notifyListeners();
  }

  void setPagination({int? page, int? pageSize}) {
    if (page != null) _page = page;
    if (pageSize != null) _pageSize = pageSize;
    notifyListeners();
  }

  Future<List<Data>> fetch({
    String? q,
    DateTime? from,
    DateTime? to,
    String? sort,
    int? page,
    int? pageSize,
  }) async {
    _setError(null);
    _setLoading(true);

    final String useQuery = q ?? _query;
    final DateTime? useFrom = from ?? _from;
    final DateTime? useTo = to ?? _to;
    final String useSort = (sort ?? _sort).isEmpty ? 'recent' : (sort ?? _sort);
    final int usePage = (page ?? _page).clamp(1, 1 << 30);
    final int usePageSize = (pageSize ?? _pageSize).clamp(1, 100);

    try {
      final List<String> params = <String>[];
      if (useQuery.trim().isNotEmpty) {
        params.add('q=${Uri.encodeComponent(useQuery.trim())}');
      }
      final String? fromStr = _formatDate(useFrom);
      final String? toStr = _formatDate(useTo);
      if (fromStr != null) params.add('from=$fromStr');
      if (toStr != null) params.add('to=$toStr');
      if (useSort.isNotEmpty)
        params.add('sort=${Uri.encodeComponent(useSort)}');
      params.add('page=$usePage');
      params.add('pageSize=$usePageSize');

      final String endpoint = params.isEmpty
          ? Endpoints.getBeritaKehatan
          : '${Endpoints.getBeritaKehatan}?${params.join('&')}';

      final Map<String, dynamic> response =
          await _api.fetchDataPrivate(endpoint);
      final Beritakesehatan parsed = Beritakesehatan.fromJson(response);

      _items = parsed.data;
      _meta = parsed.meta;
      _query = useQuery;
      _from = useFrom;
      _to = useTo;
      _sort = useSort;
      _page = usePage;
      _pageSize = usePageSize;

      notifyListeners();
      return _items;
    } catch (e) {
      _items = <Data>[];
      _meta = null;
      _setError(e.toString());
      return _items;
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Data>> refresh() => fetch(
        q: _query,
        from: _from,
        to: _to,
        sort: _sort,
        page: _page,
        pageSize: _pageSize,
      );

  Data? findById(String id) {
    try {
      return _items.firstWhere((Data element) => element.idBerita == id);
    } catch (_) {
      return null;
    }
  }

  void clear() {
    _items = <Data>[];
    _meta = null;
    _error = null;
    _loading = false;
    _query = '';
    _from = null;
    _to = null;
    _sort = 'recent';
    _page = 1;
    _pageSize = 20;
    notifyListeners();
  }

  String? _formatDate(DateTime? value) {
    if (value == null) return null;
    final int year = value.year;
    final int month = value.month;
    final int day = value.day;
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${year.toString().padLeft(4, '0')}-${twoDigits(month)}-${twoDigits(day)}';
  }
}

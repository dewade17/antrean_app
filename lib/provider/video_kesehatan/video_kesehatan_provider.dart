import 'package:antrean_app/constraints/endpoints.dart';
import 'package:antrean_app/dto/video_kesehatan/video_kesehatan.dart';

import 'package:antrean_app/services/api_service.dart';
import 'package:flutter/material.dart';

class VideoKesehatanProvider extends ChangeNotifier {
  VideoKesehatanProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  final ApiService _apiService;

  Videokesehatan? _response;
  bool _loading = false;
  String? _error;
  String _sort = 'recent';
  String _query = '';
  final int _pageSize = 5;

  bool get loading => _loading;
  String? get error => _error;
  String get sort => _sort;
  List<Data> get videos => _response?.data ?? <Data>[];
  Meta? get meta => _response?.meta;
  int get currentPage => meta?.page ?? 1;
  int get totalPages => meta?.pages ?? 1;
  bool get canGoPrevious => !loading && currentPage > 1;
  bool get canGoNext => !loading && currentPage < totalPages;

  Future<void> fetchVideos({
    int? page,
    String? sort,
    String? query,
    bool resetResultsOnError = false,
  }) async {
    final targetPage = (page ?? currentPage);
    final safePage = targetPage < 1 ? 1 : targetPage;
    if (sort != null) {
      _sort = sort;
    }
    if (query != null) {
      _query = query.trim();
    }

    _setLoading(true);
    try {
      final params = <String, String>{
        'page': safePage.toString(),
        'pageSize': _pageSize.toString(),
        'sort': _sort,
      };
      final q = _query.trim();
      if (q.isNotEmpty) {
        params['q'] = q;
      }

      final queryString = params.entries
          .map((entry) =>
              '${entry.key}=${Uri.encodeQueryComponent(entry.value)}')
          .join('&');

      final endpoint = '${Endpoints.getVideoKesehatan}?$queryString';
      final result = await _apiService.fetchDataPrivate(endpoint);

      _response = Videokesehatan.fromJson(result);
      _error = null;
    } catch (e) {
      _error = e.toString();
      if (resetResultsOnError) {
        _response = Videokesehatan(
          data: <Data>[],
          meta: Meta(page: safePage, pageSize: _pageSize, total: 0, pages: 1),
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refresh() async {
    await fetchVideos(page: currentPage);
  }

  Future<void> nextPage() async {
    if (!canGoNext) return;
    await fetchVideos(page: currentPage + 1);
  }

  Future<void> previousPage() async {
    if (!canGoPrevious) return;
    await fetchVideos(page: currentPage - 1);
  }

  Future<void> changeSort(String newSort) async {
    if (_sort == newSort) return;
    await fetchVideos(page: 1, sort: newSort);
  }

  Future<void> search(String query) async {
    await fetchVideos(page: 1, query: query);
  }

  void clear() {
    _response = null;
    _error = null;
    _sort = 'recent';
    _query = '';
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}

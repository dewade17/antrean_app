// lib/provider/Auth/auth_provider.dart
import 'package:antrean_app/dto/auth/getdataprivate.dart';
import 'package:antrean_app/dto/auth/login.dart';
import 'package:antrean_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:antrean_app/constraints/endpoints.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  bool _loading = false;
  bool get loading => _loading;

  String? _token;
  String? get token => _token;

  Getdataprivate? _currentUser;
  Getdataprivate? get currentUser => _currentUser;

  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  // === Helper: simpan field MINIMAL ke SharedPreferences ===
  Future<void> _persistMinimalUserFields(Map<String, dynamic> userJson) async {
    final prefs = await SharedPreferences.getInstance();

    // Hanya tiga field ini yang disimpan lokal
    final id = userJson['id_user'];
    final nama = userJson['nama'];
    final email = userJson['email'];

    if (id != null) {
      await prefs.setString('id_user', id.toString());
    } else {
      await prefs.remove('id_user');
    }
    if (nama != null) {
      await prefs.setString('nama', nama.toString());
    } else {
      await prefs.remove('nama');
    }
    if (email != null) {
      await prefs.setString('email', email.toString());
    } else {
      await prefs.remove('email');
    }
  }

  /// Login → simpan token → fetchdataprivate → simpan id_user/nama/email → navigate
  Future<void> login(BuildContext context, Login payload) async {
    _setLoading(true);
    try {
      // 1) Login (tanpa Authorization)
      final res = await _api.post(payload.toJson(), Endpoints.login);
      final t = (res['token'] ?? '').toString();
      if (t.isEmpty) throw Exception('Token tidak ditemukan pada respons.');

      // 2) Simpan token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', t);
      _token = t;

      // 3) Verifikasi token lewat getdataprivate
      final me = await _api.fetchDataPrivate(Endpoints.getdataprivate);
      final userJson = (me['user'] ?? me) as Map<String, dynamic>;

      // 4) Simpan ke memori & persist minimal fields
      _currentUser = Getdataprivate.fromJson(userJson);
      await _persistMinimalUserFields(userJson);
      notifyListeners();

      // 5) Pastikan context masih ter-mount sebelum menunjukkan snackbar atau navigasi
      if (!context.mounted) return;
      final messenger = ScaffoldMessenger.of(context);

      messenger.showSnackBar(
        SnackBar(
            content: Text((res['message'] ?? 'Login berhasil').toString())),
      );

      // 6) Navigasi berdasar role (contoh: ADMIN/USER)
      final role = (_currentUser?.role ?? '').toUpperCase();
      String targetRoute = '/login'; // fallback jika bukan USER
      if (role == 'USER') {
        targetRoute = '/home-screen';
      }

      Navigator.of(context).pushNamedAndRemoveUntil(targetRoute, (r) => false);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Login gagal: $e')));
      }
      await _clearSession();
    } finally {
      _setLoading(false);
    }
  }

  /// Pulihkan sesi saat app dibuka (pakai token tersimpan, lalu fetch profil)
  Future<void> tryRestoreSession(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString('token');
    if (t == null || t.isEmpty) return;

    _token = t;
    _setLoading(true);
    try {
      final me = await _api.fetchDataPrivate(Endpoints.getdataprivate);
      final userJson = (me['user'] ?? me) as Map<String, dynamic>;
      _currentUser = Getdataprivate.fromJson(userJson);
      await _persistMinimalUserFields(userJson); // simpan id_user, nama, email
      notifyListeners();
    } catch (_) {
      await _clearSession();
    } finally {
      _setLoading(false);
    }
  }

  /// Ambil ulang profil (mis. setelah update profil)
  Future<void> reloadProfile() async {
    if (_token == null) return;
    final me = await _api.fetchDataPrivate(Endpoints.getdataprivate);
    final userJson = (me['user'] ?? me) as Map<String, dynamic>;
    _currentUser = Getdataprivate.fromJson(userJson);
    await _persistMinimalUserFields(userJson); // simpan id_user, nama, email
    notifyListeners();
  }

  /// Logout: hapus token + field minimal, lalu kembali ke login
  Future<void> logout(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await _clearSession();
    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (r) => false);
    messenger.showSnackBar(const SnackBar(content: Text('Anda telah keluar.')));
  }

  /// Bersihkan semua data lokal terkait auth
  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('id_user');
    await prefs.remove('nama');
    await prefs.remove('email');
    // Hapus kunci lama jika sebelumnya pernah menyimpan blob user
    await prefs.remove('user');

    _token = null;
    _currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }
}

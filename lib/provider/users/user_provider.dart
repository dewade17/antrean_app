import 'package:antrean_app/dto/users/users.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:antrean_app/services/api_service.dart';
import 'package:antrean_app/constraints/endpoints.dart';

class UsersProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  Users? _user;
  Users? get user => _user;

  bool _loading = false;
  bool get loading => _loading;

  bool _saving = false;
  bool get saving => _saving;

  bool _deleting = false;
  bool get deleting => _deleting;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool v) {
    _loading = v;
    notifyListeners();
  }

  void _setSaving(bool v) {
    _saving = v;
    notifyListeners();
  }

  void _setDeleting(bool v) {
    _deleting = v;
    notifyListeners();
  }

  void _setError(String? m) {
    _errorMessage = m;
    notifyListeners();
  }

  /// GET /auth/users/{id}
  Future<Users?> fetchById(String id) async {
    _setError(null);
    _setLoading(true);
    try {
      final res = await _api.fetchDataPrivate('${Endpoints.updateProfile}$id');
      final data = res is Map<String, dynamic>
          ? res
          : (res['user'] as Map<String, dynamic>?);
      if (data == null)
        throw Exception('Data user tidak ditemukan pada respons.');
      _user = Users.fromJson(data);
      notifyListeners();
      return _user;
    } catch (e) {
      _setError(e.toString());
      return null;
    } finally {
      _setLoading(false);
    }
  }

  /// Helper ambil id_user dari SharedPreferences
  Future<String?> _getSelfId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id_user');
  }

  /// Ambil profil diri sendiri berdasarkan id_user tersimpan lokal
  Future<Users?> fetchCurrent() async {
    final id = await _getSelfId();
    if (id == null || id.isEmpty) {
      _setError('id_user tidak tersedia di perangkat.');
      return null;
    }
    return fetchById(id);
  }

  // ====== Helpers tanggal dd/MM/yyyy ======
  DateTime? _parseDdMMyyyy(String input) {
    try {
      final p = input.split('/');
      if (p.length != 3) return null;
      final d = int.parse(p[0]);
      final m = int.parse(p[1]);
      final y = int.parse(p[2]);
      // Kirim/ simpan sebagai UTC midnight untuk stabil lintas zona waktu
      return DateTime.utc(y, m, d);
    } catch (_) {
      return null;
    }
  }

  String _formatDdMMyyyy(DateTime dt) {
    final local = dt.isUtc ? dt.toLocal() : dt;
    final d = local.day.toString().padLeft(2, '0');
    final m = local.month.toString().padLeft(2, '0');
    final y = local.year.toString();
    return '$d/$m/$y';
  }

  void _applyUserToControllers(
    Users u, {
    required TextEditingController emailController,
    required TextEditingController nameController,
    required TextEditingController dateController, // dd/MM/yyyy
    required TextEditingController jenisKelaminController,
    required TextEditingController noTeleponController,
    required TextEditingController alamatController,
    required TextEditingController namaTanggunganController,
    required TextEditingController namaLayananController,
  }) {
    emailController.text = u.email;
    nameController.text = u.nama;
    jenisKelaminController.text = u.jenisKelamin;
    dateController.text = _formatDdMMyyyy(
      u.tanggalLahir.isUtc ? u.tanggalLahir.toLocal() : u.tanggalLahir,
    );
    noTeleponController.text = u.noTelepon;
    alamatController.text = u.alamat;

    // ambil nama relasi jika tersedia
    String layananName = '';
    if (u.layanan is Map) {
      final m = u.layanan as Map;
      if (m['nama_layanan'] != null) layananName = m['nama_layanan'].toString();
    }
    String tanggunganName = '';
    if (u.tanggungan is Map) {
      final m = u.tanggungan as Map;
      if (m['nama_tanggungan'] != null)
        tanggunganName = m['nama_tanggungan'].toString();
    }
    namaLayananController.text = layananName;
    namaTanggunganController.text = tanggunganName;
  }

  /// Isi controller UI dari profil diri sendiri (fetch dulu)
  Future<bool> loadCurrentIntoControllers({
    required TextEditingController emailController,
    required TextEditingController nameController,
    required TextEditingController dateController, // dd/MM/yyyy
    required TextEditingController jenisKelaminController,
    required TextEditingController noTeleponController,
    required TextEditingController alamatController,
    required TextEditingController namaTanggunganController,
    required TextEditingController namaLayananController,
  }) async {
    final me = await fetchCurrent();
    if (me == null) return false;
    _applyUserToControllers(
      me,
      emailController: emailController,
      nameController: nameController,
      dateController: dateController,
      jenisKelaminController: jenisKelaminController,
      noTeleponController: noTeleponController,
      alamatController: alamatController,
      namaTanggunganController: namaTanggunganController,
      namaLayananController: namaLayananController,
    );
    return true;
  }

  /// Bandingkan nilai baru vs lama; kirim hanya yang berubah.
  Map<String, dynamic> _diffPayload({
    required Users old,
    required String? nama,
    required String? email,
    required DateTime? tanggalLahir,
    required String? jenisKelamin,
    required String? noTelepon,
    required String? alamat,
    required dynamic idLayanan,
    required dynamic idTanggungan,
  }) {
    final payload = <String, dynamic>{};

    if (nama != null && nama.trim() != old.nama) {
      payload['nama'] = nama.trim();
    }
    if (email != null &&
        email.trim().toLowerCase() != old.email.toLowerCase()) {
      payload['email'] = email.trim().toLowerCase();
    }
    if (tanggalLahir != null &&
        tanggalLahir.toIso8601String() != old.tanggalLahir.toIso8601String()) {
      payload['tanggal_lahir'] = tanggalLahir.toIso8601String();
    }
    if (jenisKelamin != null && jenisKelamin != old.jenisKelamin) {
      payload['jenis_kelamin'] = jenisKelamin;
    }
    if (noTelepon != null && noTelepon != old.noTelepon) {
      payload['no_telepon'] = noTelepon;
    }
    if (alamat != null) {
      final newAlamat = alamat.isEmpty ? null : alamat;
      if (newAlamat != old.alamat) payload['alamat'] = newAlamat;
    }
    if (idLayanan != null) payload['id_layanan'] = idLayanan;
    if (idTanggungan != null) payload['id_tanggungan'] = idTanggungan;

    return payload;
  }

  /// PUT /auth/users/{id} memakai nilai dari controller
  /// - Parse tanggal dd/MM/yyyy
  /// - Kirim hanya field yang berubah
  /// - Sinkronkan SharedPreferences (nama/email) jika diri sendiri
  /// - **REFRESH**: setelah sukses, fetch ulang & isi ulang controller
  Future<bool> updateCurrentFromControllers({
    required TextEditingController emailController,
    required TextEditingController nameController,
    required TextEditingController dateController, // dd/MM/yyyy
    required TextEditingController jenisKelaminController,
    required TextEditingController noTeleponController,
    required TextEditingController alamatController,
    required TextEditingController namaTanggunganController,
    required TextEditingController namaLayananController,
    String? alamat,
    dynamic idLayanan,
    dynamic idTanggungan,
  }) async {
    _setError(null);
    _setSaving(true);
    try {
      final selfId = await _getSelfId();
      if (selfId == null || selfId.isEmpty) {
        throw Exception('id_user tidak tersedia.');
      }
      if (_user == null || _user?.idUser != selfId) {
        final fetched = await fetchById(selfId);
        if (fetched == null) throw Exception('Gagal memuat profil pengguna.');
      }
      final old = _user!;

      DateTime? tanggalLahir;
      if (dateController.text.trim().isNotEmpty) {
        tanggalLahir = _parseDdMMyyyy(dateController.text.trim());
        if (tanggalLahir == null) {
          throw Exception(
              'Format tanggal lahir tidak valid (gunakan dd/MM/yyyy).');
        }
      }

      final payload = _diffPayload(
        old: old,
        nama: nameController.text,
        email: emailController.text,
        tanggalLahir: tanggalLahir,
        jenisKelamin: jenisKelaminController.text.isEmpty
            ? null
            : jenisKelaminController.text,
        noTelepon: noTeleponController.text,
        alamat: alamatController.text,
        idLayanan: idLayanan,
        idTanggungan: idTanggungan,
      );

      if (payload.isEmpty) {
        // Tidak ada perubahan; tetap lakukan refresh kecil agar UI sinkron
        await loadCurrentIntoControllers(
          emailController: emailController,
          nameController: nameController,
          dateController: dateController,
          jenisKelaminController: jenisKelaminController,
          noTeleponController: noTeleponController,
          alamatController: alamatController,
          namaTanggunganController: namaTanggunganController,
          namaLayananController: namaLayananController,
        );
        return true;
      }

      final res = await _api.updateDataPrivate(
          '${Endpoints.updateProfile}$selfId', payload);
      final data = res as Map<String, dynamic>;
      _user = Users.fromJson(data);
      notifyListeners();

      // Sinkronkan ke SharedPreferences jika ubah nama/email
      final prefs = await SharedPreferences.getInstance();
      if (payload.containsKey('nama'))
        await prefs.setString('nama', _user!.nama);
      if (payload.containsKey('email'))
        await prefs.setString('email', _user!.email);

      // ====== REFRESH ULANG dari server dan isi ulang controller ======
      final refreshed = await fetchById(selfId);
      if (refreshed != null) {
        _applyUserToControllers(
          refreshed,
          emailController: emailController,
          nameController: nameController,
          dateController: dateController,
          jenisKelaminController: jenisKelaminController,
          noTeleponController: noTeleponController,
          alamatController: alamatController,
          namaTanggunganController: namaTanggunganController,
          namaLayananController: namaLayananController,
        );
      }

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setSaving(false);
    }
  }

  /// DELETE /auth/users/{id} — hanya ADMIN
  Future<bool> deleteById(String id) async {
    _setError(null);
    _setDeleting(true);
    try {
      await _api.deleteDataPrivate('${Endpoints.updateProfile}$id');
      if (_user?.idUser == id) {
        _user = null;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setDeleting(false);
    }
  }

  /// Utility: set user secara manual (mis. dari form) tanpa request
  void setUser(Users? u) {
    _user = u;
    notifyListeners();
  }
}

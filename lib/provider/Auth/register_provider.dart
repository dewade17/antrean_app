// ignore_for_file: use_build_context_synchronously

import 'package:antrean_app/screens/auth_screen/login/login_screen.dart';
import 'package:antrean_app/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:antrean_app/constraints/endpoints.dart';

class RegisterProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();

  // Controllers dipusatkan di provider
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final dateController = TextEditingController(); // format: dd/MM/yyyy
  final jeniskelaminController = TextEditingController(); // 'Pria' | 'Wanita'
  final noteleponeController = TextEditingController();
  final passwordController = TextEditingController();
  final konfirmasiPasswordController = TextEditingController();

  bool _loading = false;
  bool get loading => _loading;

  final _api = ApiService();

  DateTime? _parseDdMMyyyy(String input) {
    try {
      final parts = input.split('/');
      if (parts.length != 3) return null;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  Future<void> submit(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    // Validasi form
    final ok = formKey.currentState?.validate() ?? false;
    if (!ok) {
      messenger.showSnackBar(
        const SnackBar(
            content: Text('Periksa kembali input yang belum valid.')),
      );
      return;
    }

    // Validasi konfirmasi password
    if (passwordController.text != konfirmasiPasswordController.text) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Konfirmasi password tidak sama.')),
      );
      return;
    }

    // Parsing tanggal
    final dob = _parseDdMMyyyy(dateController.text);
    if (dob == null) {
      messenger.showSnackBar(
        const SnackBar(
            content: Text('Format tanggal lahir tidak valid (dd/MM/yyyy).')),
      );
      return;
    }

    final payload = {
      "nama": nameController.text.trim(),
      "email": emailController.text.trim(),
      "tanggal_lahir": dob.toIso8601String(),
      "jenis_kelamin": jeniskelaminController.text.trim(),
      "no_telepon": noteleponeController.text.trim(),
      "password": passwordController.text,
      // Banyak backend minta ini:
      "password_confirmation": konfirmasiPasswordController.text,
    };

    _loading = true;
    notifyListeners();
    try {
      final res = await _api.post(payload, Endpoints.register);
      // Opsional: cek struktur respons untuk pesan
      final msg = (res['message'] ?? 'Registrasi berhasil').toString();
      messenger.showSnackBar(SnackBar(content: Text(msg)));

      Navigator.of(context).pop(); // Tutup halaman/popup saat ini
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Registrasi gagal: $e')),
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    dateController.dispose();
    jeniskelaminController.dispose();
    noteleponeController.dispose();
    passwordController.dispose();
    konfirmasiPasswordController.dispose();
    super.dispose();
  }
}

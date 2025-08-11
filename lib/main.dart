import 'package:antrean_app/screens/auth_screen/login/login_screen.dart';
import 'package:antrean_app/screens/auth_screen/register/register_screen.dart';
import 'package:antrean_app/screens/start_screen/opening_screen.dart';
import 'package:antrean_app/screens/user/home/home_screen.dart';
import 'package:antrean_app/screens/user/menu_antrian/antrian_screen.dart';
import 'package:antrean_app/screens/user/menu_informasi_kesehatan/informasi_kesehatan_screen.dart';
import 'package:antrean_app/screens/user/menu_jadwal_dokter/menu_jadwal_dokter.dart';
import 'package:antrean_app/screens/user/menu_profile/profile_user_screen.dart';
import 'package:antrean_app/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null); // Inisialisasi lokal Indonesia
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Antrean',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const OpeningScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home-screen': (context) => const HomeScreen(),
        '/antrian-screen': (context) => const AntrianScreen(),
        '/jadwal-dokter-screen': (context) => const MenuJadwalDokter(),
        '/informasi-kesehatan-screen': (context) =>
            const InformasiKesehatanScreen(),
        '/profile-users': (context) => const ProfileUserScreen(),
      },
    );
  }
}

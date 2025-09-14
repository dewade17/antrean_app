import 'package:antrean_app/provider/book_antrean/book_antrean_provider.dart';
import 'package:antrean_app/provider/book_antrean/get_booking_antrean.dart';
import 'package:antrean_app/provider/dokter/detail_dokter_provider.dart';
import 'package:antrean_app/provider/Auth/auth_provider.dart';
import 'package:antrean_app/provider/Auth/register_provider.dart';
import 'package:antrean_app/provider/dokter/dokter_provider.dart';
import 'package:antrean_app/provider/layanan/layanan_provider.dart';
import 'package:antrean_app/provider/tanggungan/tanggungan_provider.dart';
import 'package:antrean_app/provider/users/user_provider.dart';
import 'package:antrean_app/screens/auth_screen/login/login_screen.dart';
import 'package:antrean_app/screens/auth_screen/register/register_screen.dart';
import 'package:antrean_app/screens/start_screen/opening_screen.dart';
import 'package:antrean_app/screens/user/home/home_screen.dart';
import 'package:antrean_app/screens/user/menu_antrian/antrian_screen.dart';
import 'package:antrean_app/screens/user/menu_informasi_kesehatan/informasi_kesehatan_screen.dart';
import 'package:antrean_app/screens/user/menu_jadwal_dokter/menu_jadwal_dokter.dart';
import 'package:antrean_app/screens/user/menu_profile/profile_user_screen.dart';
import 'package:antrean_app/services/auth_wrapper.dart';
import 'package:antrean_app/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => LayananProvider()),
        ChangeNotifierProvider(create: (_) => TanggunganProvider()),
        ChangeNotifierProvider(create: (_) => DokterProvider()),
        ChangeNotifierProvider(create: (_) => DetailDokterProvider()),
        ChangeNotifierProvider(create: (_) => BookAntreanProvider()),
        ChangeNotifierProvider(create: (_) => GetBookingProvider()),
      ],
      child: MaterialApp(
        title: 'Antrean',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const OpeningScreen(),
        routes: {
          '/home-screen': (context) => const AuthWrapper(
                child: HomeScreen(),
              ),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/antrian-screen': (context) => const AntrianScreen(),
          '/jadwal-dokter-screen': (context) => const MenuJadwalDokter(),
          '/informasi-kesehatan-screen': (context) =>
              const InformasiKesehatanScreen(),
          '/profile-users': (context) => const ProfileUserScreen(),
        },
      ),
    );
  }
}

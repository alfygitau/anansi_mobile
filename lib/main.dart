import 'package:app_anansi_mobile/pages/auth/login.dart';
import 'package:app_anansi_mobile/pages/welcome/welcome.dart';
import 'package:app_anansi_mobile/services/route_service.dart';
import 'package:app_anansi_mobile/state/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anansi Tech',
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: '/',
      routes: {'/login': (context) => const Login()},
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme),
      ),
      home: const SplashScreen(),
    );
  }
}

import 'package:app_anansi_mobile/pages/auth/login.dart';
import 'package:app_anansi_mobile/pages/welcome/welcome.dart';
import 'package:app_anansi_mobile/services/route_service.dart';
import 'package:app_anansi_mobile/state/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://89d0fc12a38d4594aa1aa3c68f578e07@o4508850577604609.ingest.de.sentry.io/4511427142615120';
      options.tracesSampleRate = 1.0;
      options.attachScreenshot = true;
    },
    appRunner: () => runApp(
      DefaultAssetBundle(
        bundle: SentryAssetBundle(),
        child: MultiProvider(
          providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
          child: const MyApp(),
        ),
      ),
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
      navigatorObservers: [SentryNavigatorObserver()],
      initialRoute: '/',
      routes: {'/login': (context) => const Login()},
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF042159)),
        textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme),
      ),
      home: const SplashScreen(),
    );
  }
}

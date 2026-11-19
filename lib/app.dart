import 'package:flutter/material.dart';
import 'pages/status_page.dart';
import 'pages/presentation_page.dart';
import 'theme/palette.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'De ce plasticul nu „moare”?',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Palette.cyan,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        // Fontul de text al slide-urilor, inclus acum în proiect (pubspec.yaml).
        fontFamily: 'IBM Plex Sans',
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => const StatusPage(),
        '/presentation': (ctx) => const PresentationPage(),
      },
    );
  }
}

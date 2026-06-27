import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';
import 'screens/sky_map_screen.dart';
import 'services/location_service.dart';
import 'services/astronomy_service.dart';
import 'services/settings_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait mode initially
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const SkyCanvasApp());
}

class SkyCanvasApp extends StatelessWidget {
  const SkyCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsService()),
        ChangeNotifierProvider(create: (_) => LocationService()),
        ChangeNotifierProvider(create: (_) => AstronomyService()),
      ],
      child: Consumer<SettingsService>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'SkyCanvas',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.black,
              primaryColor: const Color(0xFF1E3A8A),
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF1E3A8A),
                secondary: Color(0xFF3B82F6),
                background: Colors.black,
                surface: Color(0xFF0F172A),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                elevation: 0,
              ),
              cardTheme: CardTheme(
                color: const Color(0xFF0F172A),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textTheme: const TextTheme(
                headlineLarge: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                bodyLarge: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                bodyMedium: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
            home: settings.isNightMode
              ? _NightModeWrapper(
                  child: const SplashScreen(),
                )
              : const SplashScreen(),
          );
        },
      ),
    );
  }
}

// Night mode red tint overlay
class _NightModeWrapper extends StatelessWidget {
  final Widget child;

  const _NightModeWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              color: Colors.red.withOpacity(0.3),
            ),
          ),
        ),
      ],
    );
  }
}

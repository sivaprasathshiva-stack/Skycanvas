import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SkyCanvasApp());
}

class SkyCanvasApp extends StatelessWidget {
  const SkyCanvasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkyCanvas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

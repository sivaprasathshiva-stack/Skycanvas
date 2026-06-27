import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const SkyCanvasRemoteApp());
}

class SkyCanvasRemoteApp extends StatelessWidget {
  const SkyCanvasRemoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkyCanvas Remote',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const RemoteHomeScreen(),
    );
  }
}

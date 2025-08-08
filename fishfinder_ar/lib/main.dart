import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/ar_camera_screen.dart';
import 'services/fish_detection_service.dart';
import 'services/permission_service.dart';

void main() {
  runApp(const FishFinderApp());
}

class FishFinderApp extends StatelessWidget {
  const FishFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FishDetectionService>(
          create: (_) => FishDetectionService(),
        ),
        Provider<PermissionService>(
          create: (_) => PermissionService(),
        ),
      ],
      child: MaterialApp(
        title: 'FishFinder AR',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0077BE), // Ocean blue
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0077BE),
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        home: const ARCameraScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
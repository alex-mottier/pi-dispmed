import 'package:flutter/material.dart';
import 'package:ble_scanner/screens/splash_screen.dart';

void main() => runApp(const BleScannerApp());

class BleScannerApp extends StatelessWidget {
  const BleScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

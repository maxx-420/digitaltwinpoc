import 'package:digitaltwinpoc/screens/layout.dart';
import 'package:flutter/material.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const DigitalTwinApp());
}

class DigitalTwinApp extends StatelessWidget {
  const DigitalTwinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Twin Workflow',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: const Layout(),
    );
  }
}
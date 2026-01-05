import 'package:flutter/material.dart';
import 'package:wedding_v1/features/home/screens/home_page.dart';
import 'package:wedding_v1/services/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MingalarOo',
      theme: KTheme.lightTheme,
      home: HomePage(),
    );
  }
}

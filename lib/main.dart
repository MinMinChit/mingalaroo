import 'package:flutter/material.dart';
import 'package:wedding_v1/features/home/screens/home_page.dart';
import 'package:wedding_v1/services/app_theme.dart';
import 'package:wedding_v1/services/supabase_service.dart';
import 'package:wedding_v1/widgets/emoji_cursor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aung & Cho',
      theme: KTheme.lightTheme,
      home: EmojiCursor(
        child: HomePage(),
      ),
    );
  }
}

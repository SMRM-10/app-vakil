import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const VakilOnlineApp());
}

class VakilOnlineApp extends StatelessWidget {
  const VakilOnlineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'وکیلت آنلاین',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0F3577),
        fontFamily: 'sans',
      ),
      home: const HomePage(),
    );
  }
}
import 'package:carley_showroom/pages/main_shop.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'carley_showroom',
        debugShowCheckedModeBanner: false, 
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E3A8A),
            brightness: Brightness.dark, 
          ),
          useMaterial3: true,
        ),
        home: const MainShop());
  }
}
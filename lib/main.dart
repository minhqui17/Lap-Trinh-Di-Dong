import 'package:flutter/material.dart';
import 'package:travel_booking/features/home/screens/home_screen.dart';
import 'package:travel_booking/features/admin/ad_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
      routes: {
        '/admin': (context) => const AdShell(),
      },
    );
  }
}
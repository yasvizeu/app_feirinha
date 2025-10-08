import 'package:app_feirinha/home/drink.dart';
import 'package:app_feirinha/home/home_product.dart';
import 'package:app_feirinha/home/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Feirinha',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: DrinksScreen()// aguardando a classe
    );
  }
}


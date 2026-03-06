import 'package:escuela_valiente_tfg/views/login_view.dart';
import 'package:flutter/material.dart';

void main() { runApp(const MyApp()); }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escuela Valiente',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true, // Te lo recomiendo para un look moderno
      ),
      // AQUÍ es donde llamas a tu vista de login
      home: LoginView(), 
    );
  }
}

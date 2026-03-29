import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.orangeMain,
      scaffoldBackgroundColor: Colors.white,

      // --- CAMBIAMOS ESTA PARTE ---
      inputDecorationTheme: const InputDecorationTheme(
        filled: false,              // 1. Quitamos el relleno para que no haya rectángulos
        fillColor: Colors.transparent, 
        border: InputBorder.none,    // 2. Quitamos bordes por defecto
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        
        // Estilo de la etiqueta (label) para que sea sutil
        labelStyle: TextStyle(
          color: AppColors.darkBlue,
          fontSize: 16,
        ),
        // Estilo del texto de ayuda o error
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.orangeMain,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }
}
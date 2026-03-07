// lib/widgets/custom_text_field.dart
import 'package:flutter/material.dart';

class CustomAuthInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool isPassword;
  final String? Function(String?)? validator;

  const CustomAuthInput({
    super.key, 
    required this.controller, 
    required this.label, 
    required this.icon, 
    this.isPassword = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Color.fromRGBO(60, 60, 60, 1)),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromRGBO(60, 60, 60, 1), fontWeight: FontWeight.bold),
        prefixIcon: Icon(icon, color: const Color.fromRGBO(60, 60, 60, 1)),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        errorStyle: const TextStyle(height: 0, color: Colors.transparent),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
    );
  }
}
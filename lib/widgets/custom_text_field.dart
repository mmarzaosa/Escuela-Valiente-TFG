import 'package:flutter/material.dart';

class CustomAuthInput extends StatefulWidget {
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
  State<CustomAuthInput> createState() => _CustomAuthInputState();
}

class _CustomAuthInputState extends State<CustomAuthInput> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
Widget build(BuildContext context) {
  return TextFormField(
    controller: widget.controller,
    obscureText: widget.isPassword ? _obscureText : false,
    style: const TextStyle(color: Color.fromRGBO(60, 60, 60, 1)),
    validator: widget.validator,
    decoration: InputDecoration(
      hintText: widget.label, 
      hintStyle: const TextStyle(
        color: Color.fromRGBO(60, 60, 60, 0.5),
        fontWeight: FontWeight.bold,
      ),
      
      floatingLabelBehavior: FloatingLabelBehavior.never, 
      
      prefixIcon: Icon(widget.icon, color: const Color.fromRGBO(60, 60, 60, 1)),
      
      suffixIcon: widget.isPassword 
        ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: const Color.fromRGBO(60, 60, 60, 0.6),
            ),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          )
        : null,
        
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical: 20),
      
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
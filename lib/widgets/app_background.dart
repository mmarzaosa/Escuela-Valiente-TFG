import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final String imagePath;

  // El constructor debe recibir la variable 'imagePath'
  const AppBackground({
    super.key,
    this.imagePath = "assets/images/register_background.png",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
import 'dart:async';
import 'package:flutter/material.dart';

class AvatarHelper extends StatefulWidget {
  final String starImage;
  final double imageSize;

  const AvatarHelper({
    super.key,
    this.starImage = "assets/images/star_image.png",
    this.imageSize = 110, // Ajustado a tu medida
  });

  @override
  State<AvatarHelper> createState() => _AvatarHelperState();
}

class _AvatarHelperState extends State<AvatarHelper> {
  final List<String> messages = [
    "¡BIENVENIDO a Escuela Valiente!",
    "¿Estamos listos para aprender?",
    "Inicia sesión para continuar",
  ];

  int currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Es mejor asignar el timer así para asegurar que se limpie bien
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) { // Verificamos que el widget siga en pantalla
        setState(() {
          currentIndex = (currentIndex + 1) % messages.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Importante para no ocupar toda la pantalla
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 220),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 247, 238, 1).withOpacity(0.7),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 33, 159, 255).withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              // Añadimos una transición suave para que el texto no "salte"
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Text(
                  messages[currentIndex],
                  key: ValueKey<int>(currentIndex), // Necesario para que AnimatedSwitcher detecte el cambio
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color.fromRGBO(1, 96, 191, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 75),
              child: CustomPaint(
                painter: _TrianglePainter(const Color.fromRGBO(255, 247, 238, 1).withOpacity(0.7)),
                child: const SizedBox(width: 20, height: 12),
              ),
            ),
          ],
        ),
        Transform.translate(
          offset: const Offset(0, -30),
          child: Image.asset(
            widget.starImage,
            height: 130,
            width: 130,
            fit: BoxFit.cover, // Cambiado cover a contain para no cortar la estrella
            errorBuilder: (context, error, stackTrace) => 
                const Icon(Icons.star, size: 80, color: Colors.yellow),
          ),
        ),
      ],
    );
  }
}
// Pintor del triángulo
class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = color;
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.7, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
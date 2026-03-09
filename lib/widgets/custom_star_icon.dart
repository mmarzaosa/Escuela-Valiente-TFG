import 'dart:async';
import 'package:flutter/material.dart';

class AvatarHelper extends StatefulWidget {
  final String starImage;
  final double imageSize;
  final String? forcedMessage; // Punto 4: Para mostrar errores

  const AvatarHelper({
    super.key,
    this.starImage = "assets/images/star_image.png",
    this.imageSize = 130,
    this.forcedMessage,
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
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted && widget.forcedMessage == null) { 
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
    // Si hay un mensaje forzado (error), lo mostramos. Si no, el de la lista.
    final String displayMessage = widget.forcedMessage ?? messages[currentIndex];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 220),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 247, 238, 1).withOpacity(0.9), // Más opaco para leer mejor
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  displayMessage,
                  key: ValueKey<String>(displayMessage),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    // Si es error (forcedMessage), lo ponemos un pelín más llamativo
                    color: widget.forcedMessage != null ? Colors.red.shade700 : const Color.fromRGBO(1, 96, 191, 1),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 75),
              child: CustomPaint(
                painter: _TrianglePainter(const Color.fromRGBO(255, 247, 238, 1).withOpacity(0.9)),
                child: const SizedBox(width: 20, height: 12),
              ),
            ),
          ],
        ),
        Transform.translate(
          offset: const Offset(0, -60),
          child: Image.asset(
            widget.starImage,
            height: 180,
            width: widget.imageSize,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => 
                const Icon(Icons.star, size: 80, color: Colors.yellow),
          ),
        ),
      ],
    );
  }
}

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
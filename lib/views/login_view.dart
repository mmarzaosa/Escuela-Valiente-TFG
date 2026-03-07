import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_submit_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          _buildBackground(),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // CONTENEDOR DE ALTURA FIJA PARA EL AVATAR Y BOCADILLO
                    SizedBox(
                      height: 350, // Aumentamos ligeramente la altura para acomodar la estrella más grande
                      child: Stack(
                        clipBehavior: Clip.none, // Permite que sobresalga
                        children: [
                          Positioned(
                            bottom: -15, // Ajuste para que 'pise' ligeramente el formulario
                            right: -20,  // Ajuste lateral
                            child: _buildAvatarHelper("¡Bienvenido! Inicia sesión para continuar"),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10), // Ajuste de separación con el formulario

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildInputGroup(),
                          _buildForgotPassword(),
                          const SizedBox(height: 15),
                          _buildSubmitButton(),
                          const SizedBox(height: 5),
                          _buildSignUpLink(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- MÉTODOS DE CONSTRUCCIÓN ---

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/login_background.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildInputGroup() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 247, 238, 1).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromRGBO(205, 205, 205, 1)),
      ),
      child: Column(
        children: [
          CustomAuthInput(
            controller: _emailController,
            label: 'Correo electrónico',
            icon: Icons.email_outlined,
            validator: (value) => (value == null || !value.contains('@')) ? 'Email no válido' : null,
          ),
          const Divider(
            color: Color.fromRGBO(60, 60, 60, 1),
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
          CustomAuthInput(
            controller: _passController,
            label: 'Contraseña',
            icon: Icons.lock_outline,
            isPassword: true,
            validator: (value) => (value != null && value.length < 6) ? 'Mínimo 6 caracteres' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => print("Recuperar pass"),
        child: const Text(
          "¿Has olvidado la contraseña?",
          style: TextStyle(fontSize: 16, color: Color.fromRGBO(1, 96, 191, 1)),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return CustomSubmitButton(
      text: "Iniciar Sesión",
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          print("Iniciar sesión con: ${_emailController.text}");
        }
      },
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("¿Eres nuevo aquí?", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () => print("Navegar a Registro"),
          child: const Text(
            "CREAR CUENTA",
            style: TextStyle(
              fontSize: 15,
              color: Color.fromRGBO(255, 212, 92, 1),
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  // --- AVATAR HELPER ACTUALIZADO: ESTRELLA MÁS GRANDE Y ALINEADA ---

  Widget _buildAvatarHelper(String message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end, // Alinea el bocadillo a la derecha de la columna
      children: [
        // 1. El Bocadillo de diálogo (con el pico apuntando a la estrella)
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 220), // Aumentamos un poco el ancho
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25), // Un poco más redondeado
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Text(
                message,
                textAlign: TextAlign.center, // Centramos el texto dentro del bocadillo
                style: const TextStyle(
                  color: Color.fromRGBO(1, 96, 191, 1),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // El triángulo del bocadillo
            Padding(
              padding: const EdgeInsets.only(right: 70), // Ajuste del pico para que apunte bien
              child: CustomPaint(
                painter: TrianglePainter(Colors.white),
                child: const SizedBox(width: 20, height: 12),
              ),
            ),
          ],
        ),
        

        // 2. La imagen de la estrella (MUCHO MÁS GRANDE)
        Image.asset(
          "assets/images/star_image.png",
          height: 110, // <-- Aumentado a 200 para darle protagonismo
          width: 110,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.star, size: 120, color: Colors.yellow),
        ),
      ],
    );
  }
}

// Clase para dibujar el triángulo del bocadillo
class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = color;
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width * 0.7, size.height); // Ajuste del ángulo del pico
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
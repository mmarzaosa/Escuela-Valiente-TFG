import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Clave global para validación del formulario
  final _formKey = GlobalKey<FormState>();

  // Controladores para capturar el texto
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void dispose() {
    // Es buena práctica limpiar los controladores al destruir el widget
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
          // 1. Imagen de Fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login_background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 3. Contenido
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 375),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // RECUADRO AGRUPADO (Email + Password)
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(255, 247, 238, 1).withOpacity(0.5),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: const Color.fromRGBO(205, 205, 205, 1)),
                            ),
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: _emailController,
                                  style: const TextStyle(color: Color.fromRGBO(60, 60, 60, 1)),
                                  decoration: const InputDecoration(
                                    labelText: 'Correo electrónico',
                                    labelStyle: TextStyle(
                                      color: Color.fromRGBO(60, 60, 60, 1),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: Color.fromRGBO(60, 60, 60, 1),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                  ),
                                  validator: (value) =>
                                      (value == null || !value.contains('@'))
                                      ? 'Email no válido'
                                      : null,
                                ),
                                const Divider(
                                  color: Color.fromRGBO(60, 60, 60, 1),
                                  height: 1,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                                TextFormField(
                                  controller: _passController,
                                  obscureText: true,
                                  style: const TextStyle(color: Color.fromRGBO(60, 60, 60, 1)),
                                  decoration: const InputDecoration(
                                    labelText: 'Contraseña',
                                    labelStyle: TextStyle(
                                      color: Color.fromRGBO(60, 60, 60, 1),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: Color.fromRGBO(60, 60, 60, 1),
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 18,
                                    ),
                                  ),
                                  validator: (value) =>
                                      (value != null && value.length < 6)
                                      ? 'Mínimo 6 caracteres'
                                      : null,
                                ),
                              ],
                            ),
                          ),

                          // Olvidé mi contraseña
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => print("Recuperar pass"),
                              child: const Text(
                                "¿Has olvidado la contraseña?",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(1, 96, 191, 1),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // BOTÓN CON DEGRADADO REHECHO
                          Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color.fromRGBO(255, 97, 0, 1),
                                  const Color.fromRGBO(255, 122, 0, 20),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.shade900.withOpacity(0.5),
                                  offset: const Offset(0, 4),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  print(
                                    "Iniciando sesión: ${_emailController.text}",
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .transparent, // Transparente para ver el degradado
                                shadowColor: Colors
                                    .transparent, // Quitamos sombra por defecto
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                "Iniciar Sesión",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 5),

                          // CREAR CUENTA
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "¿Eres nuevo aquí?",
                                style: TextStyle(color: Colors.white),
                              ),
                              TextButton(
                                onPressed: () => print("Ir a registro"),
                                child: const Text(
                                  "CREAR CUENTA",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromRGBO(
                                      255,
                                      212,
                                      92,
                                      1,
                                    ), // Corregido el valor alpha a 1
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
}

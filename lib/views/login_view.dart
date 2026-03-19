import 'package:escuela_valiente_tfg/views/home_view.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_submit_button.dart';
import '../widgets/custom_star_icon.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _loginController = LoginController();
  bool _isLoading = false;
  // Para controlar el mensaje de la estrella
  String? _starMessage;
  Color _starTextColor = const Color.fromRGBO(1, 96, 191, 1);

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Llamamos al controlador
      final errorMessage = await _loginController.performLogin(
        _userController.text,
        _passController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (errorMessage == null) {
            _starTextColor = Colors.green.shade700;
            _starMessage = "¡Genial! Entrando...";
            // TODO: Navigator.push a tu pantalla de inicio
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeView()),
                  (Route<dynamic> route) => false,
                );
              }
            });
          } else {
            // La estrella dice el error real (ej: "La contraseña es incorrecta")
            _starTextColor = Colors.red.shade700;
            _starMessage = errorMessage;

            // Limpiar mensaje tras unos segundos
            Future.delayed(const Duration(seconds: 4), () {
              if (mounted) {
                setState(() {
                  _starMessage = null;
                  _starTextColor = const Color.fromRGBO(1, 96, 191, 1);
                });
              }
            });
          }
        });
      }
    } else {
      setState(() {
        _starTextColor = Colors.red.shade700;
        _starMessage = "¡Up! Revisa que los datos sean correctos.";
      });
    }
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
                    SizedBox(
                      height: 300,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            bottom: -100,
                            right: -20,
                            child: AvatarHelper(
                              forcedMessage: _starMessage,
                              textColor: _starTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Form(key: _formKey, child: _buildMainContainer()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/register_background.png"),
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildMainContainer() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 247, 238, 1).withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color.fromRGBO(205, 205, 205, 1),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Punto 1: Menos divisores, solo el central para separar inputs
          CustomAuthInput(
            controller: _userController,
            label: 'Nombre de usuario',
            icon: Icons.person_outline,
            validator: (value) => (value == null) ? 'Usuario no válido' : null,
          ),
          const Divider(color: Color.fromRGBO(205, 205, 205, 1), height: 1),
          CustomAuthInput(
            controller: _passController,
            label: 'Contraseña',
            icon: Icons.lock_outline,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Contraseña no válida';
              }
              return null;
            },
          ),

          // Punto 2: Orden lógico. Ayuda de contraseña justo tras el input
          _buildForgotPassword(),

          const SizedBox(height: 30),

          CustomSubmitButton(
            text: _isLoading ? "Cargando..." : "Iniciar Sesión",
            onPressed: _isLoading ? () {} : _handleLogin,
          ),

          const SizedBox(height: 25),

          _buildSignUpLink(),
        ],
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => print("Recuperar pass"),
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(50, 30),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          "¿Has olvidado la contraseña?",
          style: TextStyle(
            fontSize: 13,
            color: Color.fromRGBO(1, 96, 191, 1),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Column(
      children: [
        const Text(
          "¿Eres nuevo aquí?",
          style: TextStyle(
            color: Color.fromRGBO(60, 60, 60, 1),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: () => print("Navegar a Registro"),
          child: const Text(
            "CREAR CUENTA",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              // 1. Ponemos el color del texto base transparente
              color: Colors.transparent,
              // 2. Usamos una sombra para dibujar el texto real del color que quieras
              shadows: [
                Shadow(
                  color: Color.fromRGBO(1, 96, 191, 1),
                  offset: Offset(0, -2), // Elevamos el texto 2px
                ),
              ],
              // 3. El subrayado ahora puede tener su propio color
              decoration: TextDecoration.underline,
              decorationColor: Color.fromRGBO(
                1,
                96,
                191,
                1,
              ), // Naranja para que resalte, o el que prefieras
              decorationThickness: 2, // Grosor de la línea
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_submit_button.dart';
import '../widgets/custom_star_icon.dart';

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
                      height: 290, // Aumentamos ligeramente la altura para acomodar la estrella más grande
                      child: Stack(
                        clipBehavior: Clip.none, // Permite que sobresalga
                        children: [
                          Positioned(
                            bottom: -60,
                            right: -20,  // Ajuste lateral
                            child:const AvatarHelper(),
                          ),
                        ],
                      ),
                    ),


                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildInputGroup(),
                          _buildForgotPassword(),
                          const SizedBox(height: 50),
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
          image: AssetImage("assets/images/register_background.png"),
          fit: BoxFit.cover,
          alignment: Alignment.center
        ),
      ),
    );
  }

  Widget _buildInputGroup() {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 247, 238, 1).withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color.fromRGBO(205, 205, 205, 1), width: 2),
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
          style: TextStyle(fontSize: 16, color: Color.fromRGBO(1, 96, 191, 1), fontWeight: FontWeight.bold),
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
              color: Color.fromRGBO(1, 96, 191, 1),
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: Color.fromRGBO(1, 96, 191, 1)
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_ui_constants.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_submit_button.dart';
import '../widgets/app_background.dart';
import '../theme/app_texts.dart';
import '../controllers/register_controller.dart';
import 'home_view.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _registerController = RegisterController();

  String _selectedGender = "";
  bool _isLoading = false;

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    // Validaciones básicas
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGender.isEmpty) {
      _showErrorSnackBar(AppTexts.getText('error_no_gender'));
      return;
    }
    if (_passController.text != _confirmPassController.text) {
      _showErrorSnackBar(AppTexts.getText('error_pass_match'));
      return;
    }

    setState(() => _isLoading = true);

    // Generar email único para evitar errores de duplicado durante pruebas
    String safeName = _userController.text.trim().toLowerCase().replaceAll(' ', '');
    String fakeEmail = "$safeName@escuelavaliente.com";

    final result = await _registerController.performRegister(
      name: _userController.text.trim(),
      email: fakeEmail,
      password: _passController.text.trim(),
      gender: _selectedGender,
    );

    if (mounted) {
      // IMPORTANTE: Siempre apagamos el cargando al recibir respuesta
      setState(() => _isLoading = false);

      if (result == null) {
        // Navegar a Home
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeView(isGuest: false)),
          (route) => false,
        );
      } else {
        // Mostrar el error real que viene del controlador
        _showErrorSnackBar(result);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 80),
                    _buildTitle(),
                    const SizedBox(height: 20),
                    _buildGenderSelector(),
                    const SizedBox(height: 10),
                    _buildMainForm(),
                    _buildLoginLink(),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: CustomSubmitButton(
                        text: _isLoading 
                            ? AppTexts.getText('loading') 
                            : AppTexts.getText('start_adventure'),
                        onPressed: _isLoading ? () {} : _handleRegister,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE APOYO (Mantener tus estilos visuales) ---

  Widget _buildTitle() {
    return Text(
      AppTexts.getText('create_your_account'),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w800,
        color: AppColors.darkBlue,
      ),
    );
  }

  Widget _buildMainForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        children: [
          CustomAuthInput(
            controller: _userController,
            label: AppTexts.getText('your_name'),
            icon: Icons.face_rounded,
            validator: (value) => (value == null || value.isEmpty) ? "Dinos tu nombre" : null,
          ),
          const Divider(height: 1),
          CustomAuthInput(
            controller: _passController,
            label: AppTexts.getText('you_secret_key'),
            icon: Icons.vpn_key_rounded,
            isPassword: true,
            validator: (value) => (value != null && value.length < 6) ? "Mínimo 6 letras" : null,
          ),
          const Divider(height: 1),
          CustomAuthInput(
            controller: _confirmPassController, 
            label: AppTexts.getText('repite_pass'),
            icon: Icons.vpn_key_rounded,
            isPassword: true,
            validator: (value) => (value == null || value.isEmpty) ? "Repite la llave" : null,
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      children: [
        Text(
          AppTexts.getText('who_you_are'),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkBlue),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAvatarOption(AppTexts.getText('boy'), "assets/icon/icon_profile_boy.png"),
            _buildAvatarOption(AppTexts.getText('girl'), "assets/icon/icon_profile_home_view.png"),
          ],
        ),
      ],
    );
  }

  Widget _buildAvatarOption(String gender, String imagePath) {
    bool isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = gender),
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 110,
            height: 130,
            padding: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.orangeMain.withOpacity(0.2) : Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: isSelected ? AppColors.orangeMain : Colors.white, width: isSelected ? 4 : 2),
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(gender.toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSelected ? AppColors.orangeMain : AppColors.darkBlue)),
            ),
          ),
          Positioned(
            top: -30,
            child: Image.asset(imagePath, height: 140, fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLink() {
    return TextButton(
      onPressed: () {
        if (Navigator.canPop(context)) Navigator.pop(context);
        else Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginView()));
      },
      child: Text(
        "${AppTexts.getText('have_account')} ${AppTexts.getText('session')}",
        style: const TextStyle(decoration: TextDecoration.underline, color: AppColors.darkBlue),
      ),
    );
  }
}
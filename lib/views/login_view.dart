import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_submit_button.dart';
import '../widgets/custom_star_icon.dart';
import '../controllers/login_controller.dart';
import 'register_view.dart';
import 'home_view.dart';
import '../widgets/app_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import '../theme/app_texts.dart';

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
  String? _starMessage;
  Color _starTextColor = AppColors.darkBlue; 

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final errorMessage = await _loginController.performLogin(
        _userController.text,
        _passController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;

          if (errorMessage == null) {
            _starTextColor = AppColors.successGreen;
            _starMessage = AppTexts.getText('perfect_enter');
            _navigateToHome(isGuest: false);
          } else if (errorMessage.contains("network-request-failed") ||
              errorMessage.contains("offline")) {
            // --- CASO 2: SIN INTERNET ---
            _starTextColor = AppColors.orangeMain;
            _starMessage =
                AppTexts.getText('login_offline_star');

            // Mostramos un pequeño aviso o diálogo para entrar offline
            _showOfflineOption();
          } else {
            // --- CASO 3: ERROR DE DATOS (User/Pass mal) ---
            _starTextColor = AppColors.errorRed;
            _starMessage = errorMessage;
            _resetStarMessage(4);
          }
        });
      }
    } else {
      setState(() {
        _starTextColor = AppColors.errorRed;
        _starMessage = AppTexts.getText('login_error');
      });
    }
  }

  // Función auxiliar para limpiar el mensaje de la estrella
  void _resetStarMessage(int seconds) {
    Future.delayed(Duration(seconds: seconds), () {
      if (mounted) {
        setState(() {
          _starMessage = null;
          _starTextColor = AppColors.darkBlue;
        });
      }
    });
  }

  // Función para navegar (centralizada)
  void _navigateToHome({required bool isGuest}) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeView(isGuest: isGuest)),
          (route) => false,
        );
      }
    });
  }

  void _showOfflineOption() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(AppTexts.getText('mode_offline'), textAlign: TextAlign.center),
        content: Text(
          AppTexts.getText('no_conection_to_school'),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppTexts.getText('btn_retry'),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orangeMain,
            ),
            onPressed: () {
              Navigator.pop(context); // Cerramos diálogo
              _navigateToHome(isGuest: true); // Entramos como invitado
            },
            child: Text(AppTexts.getText('btn_guest')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          AppBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildStarHeader(),
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

  Widget _buildStarHeader() {
    return SizedBox(
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
    );
  }

  Widget _buildMainContainer() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.backgroundCreme.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color.fromRGBO(
            205,
            205,
            205,
            1,
          ),
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
          CustomAuthInput(
            controller: _userController,
            label: AppTexts.getText('username'),
            icon: Icons.person_outline,
            validator: (value) =>
                (value == null || value.isEmpty) ? AppTexts.getText('no_valid_user') : null,
          ),
          const Divider(color: Color.fromRGBO(205, 205, 205, 1), height: 1),
          CustomAuthInput(
            controller: _passController,
            label: AppTexts.getText('password'),
            icon: Icons.lock_outline,
            isPassword: true,
            validator: (value) => (value == null || value.isEmpty)
                ? AppTexts.getText('no_valid_pass')
                : null,
          ),

          _buildForgotPassword(),

          const SizedBox(height: 30),

          CustomSubmitButton(
            text: _isLoading ? AppTexts.getText('loading') : AppTexts.getText('session'),
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
        child:  Text(
          AppTexts.getText('forgot_password'),
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.darkBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Column(
      children: [
        Text(
          AppTexts.getText('new_user'),
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RegisterView()),
            );
          },
          child: Text(
            AppTexts.getText('create_account'),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.transparent,
              shadows: [
                Shadow(color: AppColors.darkBlue, offset: Offset(0, -2)),
              ],
              decoration: TextDecoration.underline,
              decorationColor: AppColors.darkBlue,
              decorationThickness: 2,
            ),
          ),
        ),
      ],
    );
  }

  void _checkConnectivity() async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) {
        throw const SocketException("No hay red");
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeView(isGuest: false),
            ),
          );
        }
      } else {
        setState(() {
          _starMessage = AppTexts.getText('login_welcome');
        });
      }
    } on SocketException catch (_) {
      if (mounted) {
        setState(() {
          _starMessage = AppTexts.getText('offline_title');
          _starTextColor = AppColors.orangeMain;
        });
        _showOfflineOption(); 
      }
    }
  }
}

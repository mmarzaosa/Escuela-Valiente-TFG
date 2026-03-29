import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_ui_constants.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_submit_button.dart';
import '../widgets/app_background.dart';
import '../theme/app_texts.dart';
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  String _selectedGender = "";

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_selectedGender.isEmpty) {
      print("¡Falta elegir si eres niño o niña!");
      return;
    }
    if (_passController.text != _confirmPassController.text) {
      print("¡Las contraseñas no coinciden!");
      return;
    }
    print("Registrando a ${_userController.text} como $_selectedGender...");
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
              child: Column(
                children: [
                  const SizedBox(height: 130),
                  _buildTitle(),
                  const SizedBox(height: 0),
                  _buildGenderSelector(),
                  const SizedBox(height: 10),
                  _buildMainForm(),
                  _buildLoginLink(),
                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: CustomSubmitButton(
                      text: AppTexts.getText('start_adventure'),
                      onPressed: _handleRegister,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          AppTexts.getText('create_your_account'),
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: AppColors.darkBlue,
            shadows: const [Shadow(color: Colors.white, blurRadius: 10)],
          ),
        ),
      ],
    );
  }

  Widget _buildMainForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppUI.borderRadiusLarge),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        children: [
          CustomAuthInput(
            controller: _userController,
            label: AppTexts.getText('your_name'),
            icon: Icons.face_rounded,
          ),
          const Divider(height: 1),
          CustomAuthInput(
            controller: _passController,
            label: AppTexts.getText('you_secret_key'),
            icon: Icons.vpn_key_rounded,
            isPassword: true,
          ),
          const Divider(height: 1),
          CustomAuthInput(
            controller:
                _confirmPassController, 
            label: AppTexts.getText('repite_pass'),
            icon: Icons.vpn_key_rounded,
            isPassword: true,
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
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildAvatarOption(AppTexts.getText('boy'), "assets/icon/icon_profile_boy.png"),
            _buildAvatarOption(
              AppTexts.getText('girl'),
              "assets/icon/icon_profile_home_view.png",
            ),
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
            width: 120,
            height: 140,
            padding: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.orangeMain.withOpacity(0.15)
                  : Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected ? AppColors.orangeMain : Colors.white,
                width: isSelected ? 4 : 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.orangeMain.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : [],
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                gender.toUpperCase(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: isSelected ? AppColors.orangeMain : AppColors.darkBlue,
                ),
              ),
            ),
          ),
          Positioned(
            top: -35,
            child: AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Image.asset(imagePath, height: 180, fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginLink() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppTexts.getText('have_account'),
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            child: Text(
              AppTexts.getText('session'),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

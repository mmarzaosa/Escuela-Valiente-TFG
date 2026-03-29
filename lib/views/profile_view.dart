import 'package:flutter/material.dart';
import 'login_view.dart';
import '../theme/app_colors.dart';
import '../theme/app_ui_constants.dart';
import '../controllers/profile_controller.dart';
import '../theme/app_texts.dart';
class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppUI.borderRadiusLarge),
          ),
          backgroundColor: Colors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                padding: const EdgeInsets.fromLTRB(
                  AppUI.dialogPadding,
                  50,
                  AppUI.dialogPadding,
                  AppUI.dialogPadding,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCreme,
                  borderRadius: BorderRadius.circular(AppUI.borderRadiusLarge),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppTexts.getText("are_you_leaving"),
                      style: const TextStyle(
                        color: AppColors.darkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      AppTexts.getText("your_adventure_waits"),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textDark, fontSize: 16),
                    ),
                    const SizedBox(height: 25),
                    _buildDialogActions(context),
                  ],
                ),
              ),

              // 2. LA ESTRELLA
              Positioned(
                top: AppUI.starOffsetPopup,
                child: SizedBox(
                  height: AppUI.starSizePopup,
                  width: AppUI.starSizePopup,
                  child: Image.asset(
                    "assets/images/star_image.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDialogActions(BuildContext context) {
    final ProfileController _controller = ProfileController();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            AppTexts.getText("stay"),
            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorRed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppUI.borderRadiusMedium),
            ),
            elevation: 0,
          ),
          onPressed: () async {
            await _controller.handleLogout();

            if (context.mounted) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
                (route) => false,
              );
            }
          },
          child: Text(
            AppTexts.getText("exit"),
            style: const TextStyle(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 15),

                  Text(
                    AppTexts.getText("my_achievements"),
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkBlue,
                      shadows: [
                        Shadow(
                          color: Colors.white.withValues(),
                          offset: const Offset(3, 3),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 5),

                  _buildAvatarWidget(),

                  const SizedBox(height: 5),

                  _buildHeaderName(),

                  const SizedBox(height: 5),

                  _buildPackContainer(child: _buildProgressContent()),

                  const SizedBox(height: 20),

                  _buildPackContainer(child: _buildMenuContent(context)),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderName() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Marc",
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w400,
            color: AppColors.darkBlue,
            letterSpacing: 1.2,
            shadows: [
              Shadow(color: Colors.white, blurRadius: 10, offset: Offset(0, 2)),
            ],
          ),
        ),
        const SizedBox(width: 4),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.orangeMain, AppColors.orangeGradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds),
          child: const Icon(
            Icons.emoji_events_rounded,
            color: Colors.white,
            size: 34,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarWidget() {
    return Container(
      height: 130,
      width: 130,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color.fromARGB(255, 255, 178, 62),
          width: 6,
        ),
      ),
      child: ClipOval(
        child: Transform.translate(
          offset: const Offset(0, 14),
          child: Transform.scale(
            scale: 1.8,
            child: Image.asset(
              "assets/icon/icon_profile_boy.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/profile_background.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildPackContainer({required Widget child}) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(AppUI.dialogPadding),
      decoration: BoxDecoration(
        color: AppColors.whiteTranslucent,
        borderRadius: BorderRadius.circular(AppUI.borderRadiusLarge),
        border: Border.all(color: Colors.white.withValues(), width: 2),
      ),
      child: child,
    );
  }

  Widget _buildProgressContent() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.stars_rounded, color: Color(0xFFD48A14), size: 30),
            SizedBox(width: 8),
            Text(
              "Nivel 3",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        _buildProgressBar(0.7), 
      ],
    );
  }

  Widget _buildProgressBar(double progress) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(),
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: 14,
              width: constraints.maxWidth * progress,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.orangeMain, Color(0xFFFFD93B)],
                ),
                borderRadius: BorderRadius.circular(7),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildMenuItem(
          Icons.person_rounded,
          AppTexts.getText("profile"),
          AppColors.darkBlue,
          AppColors.orangeMain,
          () {
            print("Perfil");
          },
        ),
        _buildMenuItem(
          Icons.bar_chart_rounded,
          AppTexts.getText("progress"),
          AppColors.darkBlue,
          AppColors.orangeMain,
          () {
            print("Progreso");
          },
        ),
        _buildMenuItem(
          Icons.notifications_active_rounded,
          AppTexts.getText("warning"),
          AppColors.darkBlue,
          AppColors.orangeMain,
          () {
            print("Avisos");
          },
        ),
        _buildMenuItem(
          Icons.help_center_rounded,
          AppTexts.getText("help"),
          AppColors.darkBlue,
          AppColors.orangeMain,
          () {
            print("Ayuda");
          },
        ),
        const Divider(color: Colors.black12, indent: 20, endIndent: 20),
        _buildMenuItem(
          Icons.logout_rounded,
          AppTexts.getText("exit"),
          AppColors.errorRed, // Usamos la constante de error
          AppColors.errorRed,
          () => _showLogoutDialog(context),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String label,
    Color textColor,
    Color iconColor,
    VoidCallback onTap, 
  ) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: Icon(icon, color: iconColor, size: 24),
      title: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: textColor.withValues(),
      ),
      onTap: onTap,
    );
  }
}

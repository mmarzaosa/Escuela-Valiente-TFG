import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_ui_constants.dart';
import '../widgets/custom_star_icon.dart';
import 'profile_view.dart';
import '../theme/app_texts.dart';

class HomeView extends StatefulWidget {
  final bool isGuest; 
  const HomeView({super.key, this.isGuest=false});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 1;
  bool _showStar = false;

  final Map<int, String> _navIcons = {
    0: "assets/icon/icon_book_profile_view.png",
    2: "assets/icon/icon_profile_home_view.png",
  };

  @override
  void initState() {
    super.initState();
    print("¿Es invitado? ${widget.isGuest}");
    Timer(const Duration(seconds: 1), () {
      if (mounted) setState(() => _showStar = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      const Center(
        child: Text(
          "Pantalla Temario",
          style: TextStyle(color: AppColors.textLight, fontSize: 20),
        ),
      ),
      _buildHomeContent(),
      const ProfileView(),
    ];

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _buildBackground(),

          IndexedStack(index: _selectedIndex, children: _screens),

          if (_selectedIndex == 1) _buildFloatingHelper(),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBarraNavegacionPremium(),
          ),
        ],
      ),
    );
  }


  Widget _buildHomeContent() {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 140),
            _buildContinueCard(),
            const SizedBox(height: 15),
            _buildExploreSection(),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingHelper() {
    return Positioned(
      bottom: -15,
      right: 18,
      child: AnimatedOpacity(
        opacity: _showStar ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 800),
        child: AvatarHelper(
          imageSize: 140,
          customMessages: [
            AppTexts.getText('ready_discover_something_new'),
            AppTexts.getText('explore_syllabus_continue'),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    String imagePath;
    switch (_selectedIndex) {
      case 0:
        imagePath = "assets/images/register_background.png";
        break;
      case 2:
        imagePath = "assets/images/profile_background.png";
        break;
      case 1:
      default:
        imagePath = "assets/images/register_background.png";
        break;
    }
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      ),
    );
  }


  Widget _buildContinueCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.backgroundCreme.withOpacity(0.9),
          borderRadius: BorderRadius.circular(AppUI.borderRadiusLarge),
          border: Border.all(color: AppColors.textLight, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              AppTexts.getText('hello_what_want_learn'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
            ),
            const SizedBox(height: 15),
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [AppColors.orangeGradientEnd, AppColors.orangeMain],
        ),
      ),
      child: ElevatedButton(
        onPressed: () => print("Continuando..."),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          AppTexts.getText('continue_learning'),
          style: const TextStyle(
            color: AppColors.textLight,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildExploreSection() {
    return Column(
      children: [
        Text(
          AppTexts.getText('explore_syllabus'),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.darkBlue,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildThemeCard(AppTexts.getText('science'), "assets/images/ciencias_image.png"),
              _buildThemeCard(AppTexts.getText('lenguage'), "assets/images/lengua_image.png"),
              _buildThemeCard(AppTexts.getText('math'), "assets/images/matematicas_image.png"),
              _buildThemeCard(AppTexts.getText('english'), "assets/images/ingles_image.png"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeCard(String title, String imagePath) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 15, bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.textLight,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15), 
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppColors.orangeMain,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
        ],
      ),
    );
  }

  // --- NAVEGACIÓN ---

  Widget _buildBarraNavegacionPremium() {
    return SizedBox(
      height: 150,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // Fondo de la barra
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(45),
                topRight: Radius.circular(45),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBotonLateral(label: AppTexts.getText('syllabus'), index: 0),
                const SizedBox(width: 80),
                _buildBotonLateral(label: AppTexts.getText('profile'), index: 2),
              ],
            ),
          ),
          // Botón central flotante
          Positioned(top: 0, child: _buildBotonInicioGigante()),
        ],
      ),
    );
  }

  Widget _buildBotonInicioGigante() {
    bool isSelected = _selectedIndex == 1;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = 1),
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.orangeMain : AppColors.textLight,
            width: 6,
          ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.orangeMain, AppColors.orangeGradientEnd],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.orangeMain.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home_rounded, color: AppColors.textLight, size: 50),
            Text(
              AppTexts.getText('home'),
              style: const TextStyle(
                color: AppColors.textLight,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotonLateral({required String label, required int index}) {
    bool isSelected = _selectedIndex == index;
    String? imagePath = _navIcons[index];

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.orangeMain : Colors.transparent,
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.textLight,
              child: ClipOval(
                child: Transform.scale(
                  scale: 1.8,
                  child: Transform.translate(
                    offset: const Offset(0, 3),
                    child: Image.asset(
                      imagePath ?? "",
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.orangeMain : AppColors.darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
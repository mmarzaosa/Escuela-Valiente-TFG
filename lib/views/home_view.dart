import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/custom_star_icon.dart';
import 'profile_view.dart'; 

class HomeView extends StatefulWidget {
  const HomeView({super.key});

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
          style: TextStyle(color: Colors.white, fontSize: 20),
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

          if (_selectedIndex == 1)
            Positioned(
              bottom: -15,
              right: 18,
              child: AnimatedOpacity(
                opacity: _showStar ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 800),
                child: const AvatarHelper(
                  imageSize: 140,
                  customMessages: [
                    "¿Listo para descubrir algo nuevo hoy?",
                    "¡Explora los temas y sigue aprendiendo!",
                  ],
                ),
              ),
            ),

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



  Widget _buildBackground() {
    String imagePath;
    switch (_selectedIndex) {
      case 0:
        imagePath =
            "assets/images/register_background.png"; 
        break;
      case 2:
        imagePath = "assets/images/profile_background.png"; 
        break;
      case 1:
      default:
        imagePath =
            "assets/images/register_background.png"; 
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
          color: const Color.fromRGBO(255, 247, 238, 0.9),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white, width: 2),
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
            const Text(
              "¡Hola! ¿Qué quieres aprender hoy?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A4D8F),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6100), Color(0xFFFF9430)],
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
                child: const Text(
                  "Continuar Aprendiendo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreSection() {
    return Column(
      children: [
        const Text(
          "Explorar Temas",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A4D8F),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildThemeCard(
                "Ciencias",
                "assets/images/ciencias_image.png",
                Colors.cyan.shade500,
              ),
              _buildThemeCard(
                "Lengua",
                "assets/images/lengua_image.png",
                Colors.orange.shade50,
              ),
              _buildThemeCard(
                "Mates",
                "assets/images/matematicas_image.png",
                Colors.green.shade50,
              ),
              _buildThemeCard(
                "Inglés",
                "assets/images/ingles_image.png",
                Colors.blue.shade50,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeCard(String title, String imagePath, Color bgColor) {
    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 15, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
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
              color: Color(0xFFFF9430),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarraNavegacionPremium() {
    return SizedBox(
      height: 150,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
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
                _buildBotonLateral(label: "Temario", index: 0),
                const SizedBox(
                  width: 80,
                ), 
                _buildBotonLateral(label: "Perfil", index: 2),
              ],
            ),
          ),
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
            color: isSelected ? const Color(0xFFFF9430) : Colors.white,
            width: 6,
          ),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF9430), Color(0xFFFF6100)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF9430).withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_rounded, color: Colors.white, size: 50),
            Text(
              "Inicio",
              style: TextStyle(
                color: Colors.white,
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
              color: isSelected ? const Color(0xFFFF9430) : Colors.transparent,
            ),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
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
              color: isSelected
                  ? const Color(0xFFFF9430)
                  : const Color(0xFF1A4D8F),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

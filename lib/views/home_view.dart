import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Índice para controlar qué pestaña está seleccionada (aunque de momento solo estemos en Home)
  int _selectedIndex = 1; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody permite que el fondo se vea por debajo de la barra inferior
      extendBody: true, 
      body: Stack(
        children: [
          // 1. FONDO
          _buildBackground(),

          // 2. CONTENIDO SCROLLABLE
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 150),

                  // TARJETA: CONTINUAR APRENDIENDO
                  _buildContinueCard(),

                  const SizedBox(height: 30),

                  // SECCIÓN: EXPLORAR TEMAS
                  _buildExploreSection(),

                  // Espacio extra al final para que la barra no tape el contenido
                  const SizedBox(height: 150),
                ],
              ),
            ),
          ),
        ],
      ),

      // 3. BOTÓN CENTRAL (INICIO)
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildCentralButton(),

      // 4. BARRA DE NAVEGACIÓN INFERIOR
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  // --- COMPONENTES DE LA INTERFAZ ---

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/register_background.png"), // Tu fondo de campo/nubes
          fit: BoxFit.cover,
        ),
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
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
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
                boxShadow: [
                  BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => print("Continuando última lección..."),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text(
                  "Continuar Aprendiendo",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            )
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
            shadows: [Shadow(color: Colors.white, blurRadius: 10)],
          ),
        ),
        const SizedBox(height: 20),
        // SCROLL HORIZONTAL
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _buildThemeCard("Ciencias", "assets/images/ciencias_image.png", Colors.cyan.shade500),
              _buildThemeCard("Lengua", "assets/images/lengua_image.png", Colors.orange.shade50),
              _buildThemeCard("Mates", "assets/images/matematicas_image.png", Colors.green.shade50),
              _buildThemeCard("Inglés", "assets/images/ingles_image.png", Colors.blue.shade50),
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
          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFFF9430)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(imagePath, fit: BoxFit.cover,width: double.infinity),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCentralButton() {
    return Container(
      height: 85,
      width: 85,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 5),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 5)),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => setState(() => _selectedIndex = 1),
        backgroundColor: const Color(0xFFFF9430),
        elevation: 0,
        shape: const CircleBorder(),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home, color: Colors.white, size: 35),
            Text("Inicio", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      height: 80,
      color: Colors.white.withOpacity(0.95),
      shape: const CircularNotchedRectangle(), // El hueco para el botón central
      notchMargin: 10.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // BOTÓN IZQUIERDA: TEMARIO
          _buildNavItem(Icons.menu_book_rounded, "Temario", 0),
          
          // ESPACIO PARA EL BOTÓN CENTRAL
          const SizedBox(width: 60),

          // BOTÓN DERECHA: PERFIL
          _buildNavItem(Icons.person_rounded, "Perfil", 2),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFFFF9430) : const Color(0xFF1A4D8F),
            size: 30,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFFF9430) : const Color(0xFF1A4D8F),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}